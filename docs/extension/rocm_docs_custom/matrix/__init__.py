from pathlib import Path

from docutils import nodes
from docutils.parsers.rst import directives
from sphinx.transforms.post_transforms import SphinxPostTransform
from sphinx.util.docutils import SphinxDirective

from ..utils import kv_to_data_attr, logger, noop as _noop, register_output_flags


class CustomTable(nodes.General, nodes.Element):
    """Bootstrap-flavoured table container."""

    @staticmethod
    def visit_html(translator, node):
        show_cond_attr = kv_to_data_attr("show-cond", node.get("show-cond", ""))

        classes = ["rocm-docs-table", "table"]
        classes.extend(node.get("classes", []))
        class_attr = " ".join(classes)
        table_id = node.get("id") or ""

        attrs = []
        if table_id:
            attrs.append(f'id="{table_id}"')
        attrs.append(f'class="{class_attr}"')
        if show_cond_attr:
            attrs.append(show_cond_attr)

        attrs_str = " ".join(attrs)
        translator.body.append(f"<!-- start custom-table --><table {attrs_str}>")

        caption = node.get("caption", "")
        if caption:
            translator.body.append(f"<caption>{caption}</caption>")

        translator._in_matrix_body = False  # internal state flag

    @staticmethod
    def depart_html(translator, node):
        # Close an open <tbody> if present
        if getattr(translator, "_in_matrix_body", False):
            translator.body.append("</tbody>")
            translator._in_matrix_body = False

        translator.body.append("</table><!-- end custom-table -->")

    @staticmethod
    def visit_markdown(translator, node):
        # The Markdown translator (used to generate llms-full.txt) has no
        # visitor for the custom matrix nodes. Convert this matrix to a standard
        # docutils table and render it with the translator's own table machinery
        # so the output is a real Markdown table rather than dropped content.
        # When Markdown generation is disabled, drop the matrix entirely.
        if not translator.config.rocm_selector_markdown_generation:
            raise nodes.SkipNode
        table = _build_table(node)
        table.walkabout(translator)
        raise nodes.SkipNode


class CustomTableDirective(SphinxDirective):
    """.. matrix:: Optional caption"""

    required_arguments = 0
    optional_arguments = 1
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "id": directives.unchanged,
        "class": directives.class_option,
        "show-cond": directives.unchanged,
    }

    def run(self):
        node = CustomTable()
        node["caption"] = self.arguments[0] if self.arguments else ""
        node["id"] = self.options.get("id", "")
        node["classes"] = self.options.get("class", [])
        node["show-cond"] = self.options.get("show-cond", "")
        self.state.nested_parse(self.content, self.content_offset, node)
        return [node]


class CustomTableHead(nodes.General, nodes.Element):
    """A table header section (renders <thead>).</thead>"""

    @staticmethod
    def visit_html(translator, node):
        translator.body.append("<!-- start table head --><thead>")

    @staticmethod
    def depart_html(translator, node):
        translator.body.append("</thead><!-- end table head -->")


class CustomTableHeadDirective(SphinxDirective):
    """.. matrix-head::"""

    has_content = True

    def run(self):
        node = CustomTableHead()
        self.state.nested_parse(self.content, self.content_offset, node)
        return [node]


class CustomTableRow(nodes.General, nodes.Element):
    """A table row (<tr> inside <thead> or <tbody>)."""

    @staticmethod
    def visit_html(translator, node):
        # handle automatic <tbody> opening for body rows
        if not node.get("header-row", False):
            if not getattr(translator, "_in_matrix_body", False):
                translator.body.append("<!-- start tbody --><tbody>")
                translator._in_matrix_body = True

        show_cond_attr = kv_to_data_attr("show-cond", node.get("show-cond", ""))
        disable_cond_attr = kv_to_data_attr(
            "disable-cond", node.get("disable-cond", "")
        )

        classes = " ".join(node.get("classes", []))
        attrs = []
        if classes:
            attrs.append(f'class="{classes}"')
        if show_cond_attr:
            attrs.append(show_cond_attr)
        if disable_cond_attr:
            attrs.append(disable_cond_attr)

        attrs_str = "" if not attrs else " " + " ".join(attrs)
        translator.body.append(f"<!-- start custom-table row --><tr{attrs_str}>")

    @staticmethod
    def depart_html(translator, node):
        translator.body.append("</tr><!-- end custom-table row -->")


class CustomTableRowDirective(SphinxDirective):
    """.. matrix-row::"""

    required_arguments = 0
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "class": directives.class_option,
        "show-cond": directives.unchanged,
        "disable-cond": directives.unchanged,
        "header": directives.flag,
    }

    def run(self):
        node = CustomTableRow()
        node["classes"] = self.options.get("class", [])
        node["show-cond"] = self.options.get("show-cond", "")
        node["disable-cond"] = self.options.get("disable-cond", "")
        node["header-row"] = self.options.get("header", False) is not False

        # Parse nested cells
        self.state.nested_parse(self.content, self.content_offset, node)

        # Inherit header status if inside matrix-head
        parent_in_head = any(
            isinstance(p, CustomTableHead)
            for p in self.state.parent.traverse(include_self=True)
        )
        if parent_in_head:
            node["header-row"] = True

        # Mark all cells as headers if this is a header row
        if node["header-row"]:
            for cell in node.findall(CustomTableCell):
                if "header" not in cell:
                    cell["header"] = True

        # Sanity check
        parent = getattr(self.state, "parent", None)
        if not parent or not any(
            isinstance(p, (CustomTable, CustomTableHead))
            for p in parent.traverse(include_self=True)
        ):
            logger.warning(
                "'.. matrix-row::' at line %s should be nested under a '.. matrix::'.",
                self.lineno,
                location=(self.env.docname, self.lineno),
            )

        return [node]


class CustomTableCell(nodes.General, nodes.Element):
    """A table cell (<td> or <th>)."""

    @staticmethod
    def visit_html(translator, node):
        is_header = bool(node.get("header", False))
        tag = "th" if is_header else "td"

        classes = " ".join(node.get("classes", []))
        colspan = node.get("colspan", 1)
        rowspan = node.get("rowspan", 1)
        show_cond_attr = kv_to_data_attr("show-cond", node.get("show-cond", ""))

        attrs = []
        if classes:
            attrs.append(f'class="{classes}"')
        if colspan and colspan > 1:
            attrs.append(f'colspan="{colspan}"')
        if rowspan and rowspan > 1:
            attrs.append(f'rowspan="{rowspan}"')
        if show_cond_attr:
            attrs.append(show_cond_attr)

        attrs_str = "" if not attrs else " " + " ".join(attrs)
        translator.body.append(f"<{tag}{attrs_str}>")

    @staticmethod
    def depart_html(translator, node):
        tag = "th" if node.get("header", False) else "td"
        translator.body.append(f"</{tag}>")


class CustomTableCellDirective(SphinxDirective):
    """.. matrix-cell::"""

    required_arguments = 0
    optional_arguments = 1
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "header": directives.flag,
        "class": directives.class_option,
        "colspan": directives.nonnegative_int,
        "rowspan": directives.nonnegative_int,
        "show-cond": directives.unchanged,
    }

    def _span_option(self, name):
        """Return a colspan/rowspan value, warning on (and correcting) 0.

        ``directives.nonnegative_int`` permits 0, which is almost always an
        authoring error; treat it as 1 so the grid stays valid.
        """
        value = self.options.get(name, 1)
        if value is not None and value < 1:
            logger.warning(
                "'.. matrix-cell::' at line %s has :%s: %s; using 1.",
                self.lineno, name, value,
                location=(self.env.docname, self.lineno),
            )
            return 1
        return value

    def run(self):
        label = self.arguments[0] if self.arguments else ""
        node = CustomTableCell()

        # Explicit :header: always wins
        explicit_header = self.options.get("header", False) is not False

        # Detect if the parent row (matrix-row) or one of its ancestors
        # (matrix-head) marks this as a header section.
        parent_header_row = False
        parent_node = getattr(self.state, "parent", None)
        if parent_node:
            for ancestor in parent_node.traverse(include_self=True):
                if isinstance(ancestor, CustomTableRow) and ancestor.get("header-row", False):
                    parent_header_row = True
                    break
                if isinstance(ancestor, CustomTableHead):
                    parent_header_row = True
                    break
        node["header"] = explicit_header or parent_header_row
        node["classes"] = self.options.get("class", [])
        node["colspan"] = self._span_option("colspan")
        node["rowspan"] = self._span_option("rowspan")
        node["show-cond"] = self.options.get("show-cond", "")

        if self.content:
            self.state.nested_parse(self.content, self.content_offset, node)
        elif label:
            node += nodes.Text(label)

        # Sanity check nesting
        if not parent_node or not any(
            isinstance(p, CustomTableRow)
            for p in parent_node.traverse(include_self=True)
        ):
            logger.warning(
                "'.. matrix-cell::' at line %s should be nested under a '.. matrix-row::' directive",
                self.lineno,
                location=(self.env.docname, self.lineno),
            )

        return [node]


def _ancestors(node):
    """Yield *node*'s ancestors from immediate parent up to the document root."""
    parent = node.parent
    while parent is not None:
        yield parent
        parent = parent.parent


def _iter_own(start, node_type):
    """Yield descendant nodes of *node_type* that belong to *start*'s own table.

    Unlike ``node.findall``, this stops descending at a nested ``CustomTable``
    so an inner matrix's rows/cells are not pulled into the outer grid. The
    nested table itself (and its subtree) is skipped; it is converted
    independently by :class:`MatrixToTableTransform`.
    """
    for child in start.children:
        if isinstance(child, CustomTable):
            continue  # boundary: a nested matrix owns its own rows/cells
        if isinstance(child, node_type):
            yield child
        yield from _iter_own(child, node_type)


def _cell_span(cell_node, attr):
    """Return a sane span (>= 1) for a cell's colspan/rowspan attribute."""
    value = cell_node.get(attr, 1) or 1
    return max(1, value)


def _convert_nested_tables(root):
    """Replace any ``CustomTable`` nodes within *root*'s subtree in place.

    Used on cell content that was deep-copied from the source tree: a matrix
    can be nested inside an arbitrary container (admonition, list, etc.) inside
    a cell, and every such nested matrix must become a standard docutils table
    so non-HTML writers — which have no visitor for the custom nodes — can
    render it. Processes innermost matrices first so nesting at any depth is
    fully converted.
    """
    while True:
        nested = list(root.findall(CustomTable))
        if not nested:
            break
        # Convert the deepest matrices first: a CustomTable with no CustomTable
        # descendant of its own is innermost and safe to replace.
        for table in reversed(nested):
            if not any(True for _ in table.findall(CustomTable, include_self=False)):
                table.replace_self(_build_table(table))


def _grid_width(rows):
    """Compute the true column count of a matrix, accounting for spans.

    Walks the grid row by row tracking columns still occupied by a rowspan
    from an earlier row, so that colspan/rowspan cells are placed in the same
    positions docutils' own table parser would use.
    """
    pending: dict = {}  # column index -> rows still covered (incl. current)
    width = 0
    for row_node in rows:
        col = 0
        for cell in _iter_own(row_node, CustomTableCell):
            while pending.get(col, 0) > 0:
                col += 1
            colspan = _cell_span(cell, "colspan")
            rowspan = _cell_span(cell, "rowspan")
            for c in range(col, col + colspan):
                pending[c] = rowspan
            col += colspan
            width = max(width, col)
        for c in list(pending):
            if pending[c] > 0:
                pending[c] -= 1
    return width


def _build_row(row_node, num_cols, pending):
    """Build a docutils row, preserving spans and grid alignment.

    *pending* maps column index -> number of rows still covered by a rowspan
    that began in an earlier row; it is mutated across calls so vertical spans
    are tracked over the whole table. Missing cells are padded only at columns
    not already covered by a span, so ragged rows stay aligned and spanned
    positions are not double-filled.
    """
    row = nodes.row()
    col = 0
    for cell_node in _iter_own(row_node, CustomTableCell):
        while pending.get(col, 0) > 0:
            col += 1
        colspan = _cell_span(cell_node, "colspan")
        rowspan = _cell_span(cell_node, "rowspan")
        entry = nodes.entry()
        if colspan > 1:
            entry["morecols"] = colspan - 1
        if rowspan > 1:
            entry["morerows"] = rowspan - 1
        for child in cell_node.children:
            if isinstance(child, CustomTable):
                # A matrix nested directly in a cell: convert it to a standard
                # table here so the copied subtree contains no custom nodes
                # (which have no non-HTML visitor).
                entry += _build_table(child)
            else:
                copied = child.deepcopy()
                _convert_nested_tables(copied)
                entry += copied
        row += entry
        for c in range(col, col + colspan):
            pending[c] = rowspan
        col += colspan
    # Pad only genuinely-empty trailing columns (skip those held by a rowspan).
    while col < num_cols:
        if pending.get(col, 0) > 0:
            col += 1
            continue
        row += nodes.entry()
        col += 1
    for c in list(pending):
        if pending[c] > 0:
            pending[c] -= 1
    return row


def _build_table(matrix_node):
    """Convert a CustomTable node into a standard docutils table node.

    Shared by :class:`MatrixToTableTransform` (non-HTML builders such as LaTeX
    and text) and the Markdown node handler (llms-full.txt generation), so a
    single representation drives every non-HTML rendering path.
    """
    rows = list(_iter_own(matrix_node, CustomTableRow))
    if not rows:
        return nodes.paragraph()

    max_cols = _grid_width(rows)

    table = nodes.table()
    tgroup = nodes.tgroup(cols=max_cols)
    table += tgroup

    for _ in range(max_cols):
        tgroup += nodes.colspec(colwidth=1)

    header_rows = [r for r in rows if r.get("header-row", False)]
    body_rows = [r for r in rows if not r.get("header-row", False)]

    # Rowspans must be tracked across the whole grid (header into body), so a
    # single pending map is threaded through every row in document order.
    pending: dict = {}

    if header_rows:
        thead = nodes.thead()
        tgroup += thead
        for row in header_rows:
            thead += _build_row(row, max_cols, pending)

    # Always include tbody: Sphinx's LaTeX transform requires it.
    tbody = nodes.tbody()
    tgroup += tbody
    for row in body_rows:
        tbody += _build_row(row, max_cols, pending)

    caption = matrix_node.get("caption", "")
    if caption:
        table.insert(0, nodes.title(text=caption))

    return table


class MatrixToTableTransform(SphinxPostTransform):
    """Convert custom matrix nodes to standard docutils table nodes for non-HTML builders.

    HTML rendering uses the custom Bootstrap-styled nodes unchanged. For all
    other builders (LaTeX, text, man, etc.) each CustomTable is replaced with
    a standard docutils table node so that Sphinx's built-in rendering handles
    it correctly — no per-file workarounds needed.
    """

    default_priority = 500

    def apply(self):
        if self.app.builder.format == "html":
            return

        # PDF generation disabled: skip the LaTeX table conversion. Other
        # non-HTML builders (text, man, etc.) still convert as normal.
        if (
            self.app.builder.format == "latex"
            and not self.config.rocm_selector_pdf_generation
        ):
            return

        # Collect upfront: replacing a node mid-traversal would invalidate the
        # iterator. Only convert outermost matrices — _build_table recursively
        # converts any matrix nested inside a cell, so a nested CustomTable is
        # already handled by the time we would reach it (and would be detached).
        all_tables = list(self.document.findall(CustomTable))
        outermost = [
            t for t in all_tables
            if not any(isinstance(a, CustomTable) for a in _ancestors(t))
        ]
        for matrix_node in outermost:
            matrix_node.replace_self(_build_table(matrix_node))


def setup(app):
    app.add_node(
        CustomTable,
        html=(CustomTable.visit_html, CustomTable.depart_html),
        markdown=(CustomTable.visit_markdown, _noop),
        latex=(_noop, _noop),
        text=(_noop, _noop),
        man=(_noop, _noop),
        texinfo=(_noop, _noop),
    )
    app.add_node(
        CustomTableHead,
        html=(CustomTableHead.visit_html, CustomTableHead.depart_html),
        latex=(_noop, _noop),
        text=(_noop, _noop),
        man=(_noop, _noop),
        texinfo=(_noop, _noop),
    )
    app.add_node(
        CustomTableRow,
        html=(CustomTableRow.visit_html, CustomTableRow.depart_html),
        latex=(_noop, _noop),
        text=(_noop, _noop),
        man=(_noop, _noop),
        texinfo=(_noop, _noop),
    )
    app.add_node(
        CustomTableCell,
        html=(CustomTableCell.visit_html, CustomTableCell.depart_html),
        latex=(_noop, _noop),
        text=(_noop, _noop),
        man=(_noop, _noop),
        texinfo=(_noop, _noop),
    )

    app.add_directive("matrix", CustomTableDirective)
    app.add_directive("matrix-head", CustomTableHeadDirective)
    app.add_directive("matrix-row", CustomTableRowDirective)
    app.add_directive("matrix-cell", CustomTableCellDirective)

    app.add_post_transform(MatrixToTableTransform)

    register_output_flags(app)

    static_assets_dir = Path(__file__).parent / "static"
    app.config.html_static_path.append(str(static_assets_dir))
    app.add_css_file("table.css")

    return {
        "version": "1.3",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
