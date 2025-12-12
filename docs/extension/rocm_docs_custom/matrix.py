from pathlib import Path

from docutils import nodes
from docutils.parsers.rst import directives
from sphinx.util.docutils import SphinxDirective

from .utils import kv_to_data_attr, logger


class CustomTable(nodes.General, nodes.Element):
    """Bootstrap-flavoured table container."""

    @staticmethod
    def visit_html(translator, node):
        show_when_attr = kv_to_data_attr("show-when", node.get("show-when", ""))

        classes = ["rocm-docs-table", "table"]
        classes.extend(node.get("classes", []))
        class_attr = " ".join(classes)
        table_id = node.get("id") or ""

        attrs = []
        if table_id:
            attrs.append(f'id="{table_id}"')
        attrs.append(f'class="{class_attr}"')
        if show_when_attr:
            attrs.append(show_when_attr)

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


class CustomTableDirective(SphinxDirective):
    """.. matrix:: Optional caption"""

    required_arguments = 0
    optional_arguments = 1
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "id": directives.unchanged,
        "class": directives.class_option,
        "show-when": directives.unchanged,
    }

    def run(self):
        node = CustomTable()
        node["caption"] = self.arguments[0] if self.arguments else ""
        node["id"] = self.options.get("id", "")
        node["classes"] = self.options.get("class", [])
        node["show-when"] = self.options.get("show-when", "")
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

        show_when_attr = kv_to_data_attr("show-when", node.get("show-when", ""))
        disable_when_attr = kv_to_data_attr(
            "disable-when", node.get("disable-when", "")
        )

        classes = " ".join(node.get("classes", []))
        attrs = []
        if classes:
            attrs.append(f'class="{classes}"')
        if show_when_attr:
            attrs.append(show_when_attr)
        if disable_when_attr:
            attrs.append(disable_when_attr)

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
        "show-when": directives.unchanged,
        "disable-when": directives.unchanged,
        "header": directives.flag,
    }

    def run(self):
        node = CustomTableRow()
        node["classes"] = self.options.get("class", [])
        node["show-when"] = self.options.get("show-when", "")
        node["disable-when"] = self.options.get("disable-when", "")
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
        show_when_attr = kv_to_data_attr("show-when", node.get("show-when", ""))

        attrs = []
        if classes:
            attrs.append(f'class="{classes}"')
        if colspan and colspan > 1:
            attrs.append(f'colspan="{colspan}"')
        if rowspan and rowspan > 1:
            attrs.append(f'rowspan="{rowspan}"')
        if show_when_attr:
            attrs.append(show_when_attr)

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
        "show-when": directives.unchanged,
    }

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
        node["colspan"] = self.options.get("colspan", 1)
        node["rowspan"] = self.options.get("rowspan", 1)
        node["show-when"] = self.options.get("show-when", "")

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


def setup(app):
    app.add_node(CustomTable, html=(CustomTable.visit_html, CustomTable.depart_html))
    app.add_node(CustomTableHead, html=(CustomTableHead.visit_html, CustomTableHead.depart_html))
    app.add_node(CustomTableRow, html=(CustomTableRow.visit_html, CustomTableRow.depart_html))
    app.add_node(CustomTableCell, html=(CustomTableCell.visit_html, CustomTableCell.depart_html))

    app.add_directive("matrix", CustomTableDirective)
    app.add_directive("matrix-head", CustomTableHeadDirective)
    app.add_directive("matrix-row", CustomTableRowDirective)
    app.add_directive("matrix-cell", CustomTableCellDirective)

    static_assets_dir = Path(__file__).parent / "static"
    app.config.html_static_path.append(str(static_assets_dir))
    app.add_css_file("table.css")

    return {
        "version": "1.1",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
