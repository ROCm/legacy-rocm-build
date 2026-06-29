import json
import html as html_mod
from sphinx.transforms.post_transforms import SphinxPostTransform
from sphinx.util.docutils import SphinxDirective, directives, nodes
from pathlib import Path
from ..utils import kv_to_data_attr, normalize_key, logger, make_unique_id, noop, skip_node, register_output_flags

# ---------------------------------------------------------------------------
# No static option data: all valid (fam, os, os-ver, install-method)
# combinations are derived dynamically from the SelectorGroup / SelectorOption
# nodes present in the document at transform time.
# See _collect_selector_options() and _build_combos() below.
# ---------------------------------------------------------------------------


def _purge_selector_pages(app, env, docname):
    if hasattr(env, '_selector_pages'):
        env._selector_pages.discard(docname)


def _merge_selector_pages(app, env, docnames, other):
    if not hasattr(env, '_selector_pages'):
        env._selector_pages = set()
    env._selector_pages.update(getattr(other, '_selector_pages', set()))


def _has_toc2_metadata(env, docname):
    metadata = env.metadata.get(docname, {})
    return "selector-toc2" in metadata or "selector-toc2-icon" in metadata


def _inject_selector_sidebar(app, env):
    selector_pages = getattr(env, '_selector_pages', set())
    if not selector_pages:
        return
    sidebar = app.config.html_theme_options.setdefault("secondary_sidebar_items", {})
    if not isinstance(sidebar, dict):
        return
    sidebar.setdefault("**", ["page-toc"])
    for docname in selector_pages:
        if _has_toc2_metadata(env, docname) and docname not in sidebar:
            sidebar[docname] = ["selector-toc2"]


def _inject_selector_toc2_context(app, pagename, templatename, context, doctree):
    if pagename not in getattr(app.env, '_selector_pages', set()):
        return
    if not _has_toc2_metadata(app.env, pagename):
        return
    metadata = app.env.metadata.get(pagename, {})
    context["selector_toc2"] = metadata.get("selector-toc2", "")
    context["selector_toc2_icon"] = metadata.get("selector-toc2-icon", "fa-solid fa-computer")


def _register_selector_assets(env):
    if hasattr(env, '_selector_js_added'):
        return
    static_assets_dir = Path(__file__).parent / "static"
    env.app.config.html_static_path.append(str(static_assets_dir))
    # https://tom-select.js.org/
    env.app.add_js_file("vendor/tom-select.popular.min.js")
    env.app.add_css_file("vendor/tom-select.bootstrap5.min.css")
    env.app.add_js_file("selector.js", type="module", defer="defer")
    env.app.add_css_file("selector.css")
    env._selector_js_added = True


def _warn_must_be_nested(state, lineno, docname, directive_name, parent_name):
    parent = getattr(state, "parent", None)
    if not parent or not any(isinstance(p, SelectorGroup) for p in parent.traverse(include_self=True)):
        logger.warning(
            f"'.. {directive_name}::' at line {lineno} should be nested under a '.. {parent_name}::' directive",
            location=(docname, lineno),
        )


def _parse_width(value, lineno, docname):
    if isinstance(value, str) and value.endswith("%"):
        try:
            pct = float(value[:-1])
            if pct <= 0 or pct > 100:
                raise ValueError("must be between 0 and 100")
            return value
        except ValueError as e:
            logger.warning(
                f"Invalid percentage width '{value}' ({e}), using default",
                location=(docname, lineno),
            )
            return 6
    else:
        try:
            col_num = int(value)
            if col_num < 1 or col_num > 12:
                raise ValueError("must be between 1 and 12")
            return col_num
        except ValueError as e:
            logger.warning(
                f"Invalid width '{value}' ({e}), using default",
                location=(docname, lineno),
            )
            return 6


class SelectorGroup(nodes.General, nodes.Element):
    """
    A row or dropdown within a selector container.
    """

    @staticmethod
    def visit_html(translator, node):
        label = node["label"]
        key = node["key"]
        show_cond_attr = kv_to_data_attr("show-cond", node["show-cond"])
        heading_width = node["heading-width"]
        is_dropdown = node.get("dropdown-input", False)

        info_node = next(node.findall(SelectorInfo), None)
        info_link = info_node["link"] if info_node else None
        info_icon = info_node["icon"] if info_node else None

        info_icon_html = (
            f'<a href="{info_link}" target="_blank">'
            f'<i class="rocm-docs-selector-icon {info_icon}"></i>'
            f'</a>'
            if info_link else ""
        )

        role_attr = '' if is_dropdown else 'role="radiogroup"'
        select_open = (
            f'<select class="form-select rocm-docs-selector-dropdown-input"'
            f' data-selector-key="{key}" aria-label="{label}">'
            if is_dropdown else ""
        )

        translator.body.append(
            f"""
            <div id="{nodes.make_id(label)}"
                class="rocm-docs-selector-group row pt-2"
                data-selector-key="{key}"
                {show_cond_attr}
                {role_attr}
                aria-label="{label}"
            >
                <div class="col-{heading_width} me-1 px-2 rocm-docs-selector-group-heading">
                    <span class="rocm-docs-selector-group-heading-text">{label}{info_icon_html}</span>
                </div>
                <div class="row col-{12 - heading_width} pe-0">
                {select_open}
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        is_dropdown = node.get("dropdown-input", False)
        translator.body.append(
            f"""
                {"</select>" if is_dropdown else ""}
                </div>
            </div>
            """
        )


class _SelectorGroupBase(SphinxDirective):
    required_arguments = 1  # title text
    final_argument_whitespace = True
    has_content = True
    _is_dropdown = False  # overridden in subclass

    def run(self):
        _register_selector_assets(self.env)

        if not hasattr(self.env, '_selector_pages'):
            self.env._selector_pages = set()
        self.env._selector_pages.add(self.env.docname)

        label = self.arguments[0]
        node = SelectorGroup()
        node["label"] = label
        node["key"] = normalize_key(self.options.get("key", label))
        node["show-cond"] = self.options.get("show-cond", "")
        node["heading-width"] = self.options.get("heading-width", 3)
        node["dropdown-input"] = self._is_dropdown

        self.state.nested_parse(self.content, self.content_offset, node)

        option_nodes = list(node.findall(SelectorOption))
        if option_nodes:
            for opt in option_nodes:
                opt["group_key"] = node["key"]
                opt["dropdown-input"] = self._is_dropdown

            if not any(opt["default"] for opt in option_nodes):
                option_nodes[0]["default"] = True

        return [node]


class SelectorGroupDirective(_SelectorGroupBase):
    option_spec = {
        "key": directives.unchanged,
        "show-cond": directives.unchanged,
        "heading-width": directives.nonnegative_int,
    }
    _is_dropdown = False


class SelectorDropdownDirective(_SelectorGroupBase):
    option_spec = {
        "key": directives.unchanged,
        "show-cond": directives.unchanged,
        "heading-width": directives.nonnegative_int,
    }
    _is_dropdown = True


class SelectorInfo(nodes.General, nodes.Element):
    """
    Represents an informational icon/link associated with a selector group.
    Appears as a clickable icon in the selector group heading.

    rST usage:

    .. selector:: AMD EPYC Server CPU
       :key: cpu

       .. selector-info:: https://www.amd.com/en/products/processors/server/epyc.html
          :icon: fa-solid fa-circle-info fa-lg

       .. selector-option:: EPYC 9005 (5th gen.)
          :value: 9005
    """

    @staticmethod
    def visit_html(translator, node):
        pass  # rendering handled by SelectorGroup

    @staticmethod
    def depart_html(translator, node):
        pass  # prevent NotImplementedError


class SelectorInfoDirective(SphinxDirective):
    required_arguments = 1  # link URL
    final_argument_whitespace = True
    has_content = False
    option_spec = {"icon": directives.unchanged}

    def run(self):
        node = SelectorInfo()
        node["link"] = self.arguments[0]
        node["icon"] = self.options.get("icon", "fa-solid fa-circle-info fa-lg")

        _warn_must_be_nested(self.state, self.lineno, self.env.docname, "selector-info", "selector")

        return [node]


class SelectorOption(nodes.General, nodes.Element):
    """
    A selectable tile or list-item option within a selector group.
    """

    @staticmethod
    def visit_html(translator, node):
        label = node["label"]
        value = node["value"]
        show_cond_attr = kv_to_data_attr("show-cond", node["show-cond"])
        disable_cond_attr = kv_to_data_attr("disable-cond", node["disable-cond"])
        default = node["default"]
        width = node["width"]
        is_dropdown = node.get("dropdown-input", False)
        alt_name = node.get("alt-name", "")
        toc_label = node.get("toc-label", "")

        extra_bindings = node.get("extra-bindings", {})
        extra_bindings_attr = (
            f'data-selector-extra-bindings="{html_mod.escape(json.dumps(extra_bindings))}"'
            if extra_bindings else ""
        )

        if is_dropdown:
            display_text = alt_name if alt_name else label
            translator.body.append(
                f'<option class="rocm-docs-selector-option"'
                f' value="{value}"'
                f' data-selector-key="{node.get("group_key", "")}"'
                f' data-selector-value="{value}"'
                f'{" selected" if default else ""} {show_cond_attr} {disable_cond_attr} {extra_bindings_attr}>{display_text}</option>'
            )
            return

        default_class = "rocm-docs-selector-option-default" if default else ""

        if isinstance(width, str) and width.endswith("%"):
            width_class = ""
            width_style = f' style="width: {width}"'
        else:
            width_class = f"col-{width}"
            width_style = ""

        toc_label_attr = f'data-toc-label="{toc_label}"' if toc_label else ""

        translator.body.append(
            f"""
            <div class="rocm-docs-selector-option {default_class} {width_class} px-2"
                data-selector-key="{node.get('group_key', '')}"
                data-selector-value="{value}"
                {show_cond_attr}
                {disable_cond_attr}
                tabindex="0"
                role="radio"
                aria-checked="false"
                {toc_label_attr}
                {extra_bindings_attr}
                {width_style}
            >
                <span>{label}</span>
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        if node.get("dropdown-input", False):
            return
        icon = node["icon"]
        if icon:
            translator.body.append(f'<i class="rocm-docs-selector-icon {icon}"></i>')
        translator.body.append("</div>")


class SelectorOptionDirective(SphinxDirective):
    required_arguments = 1  # text of tile
    final_argument_whitespace = True
    option_spec = {
        "value": directives.unchanged,
        "alt-name": directives.unchanged,
        "show-cond": directives.unchanged,
        "disable-cond": directives.unchanged,
        "default": directives.flag,
        "width": directives.unchanged,
        "icon": directives.unchanged,
        "toc-label": directives.unchanged,
    }
    has_content = True

    def run(self):
        label = self.arguments[0]
        node = SelectorOption()
        node["label"] = label

        # :value: accepts an optional bare value followed by extra key=value
        # bindings, e.g. ":value: mi355x gfx=gfx950 arch=cdna3".
        # The first token without '=' is the option's own value; the rest set
        # additional selector keys when this option is chosen.
        value_raw = self.options.get("value", label)
        tokens = value_raw.split()
        bare_tokens = [t for t in tokens if "=" not in t]
        kv_tokens = [t for t in tokens if "=" in t]

        node["value"] = normalize_key(bare_tokens[0] if bare_tokens else label)

        extra_bindings = {}
        for token in kv_tokens:
            k, _, v = token.partition("=")
            if k and v:
                extra_bindings[normalize_key(k)] = normalize_key(v)
        node["extra-bindings"] = extra_bindings

        node["show-cond"] = self.options.get("show-cond", "")
        node["disable-cond"] = self.options.get("disable-cond", "")
        node["default"] = "default" in self.options
        node["width"] = _parse_width(self.options.get("width", "6"), self.lineno, self.env.docname)
        node["alt-name"] = self.options.get("alt-name", "")
        node["icon"] = self.options.get("icon")
        node["toc-label"] = self.options.get("toc-label", "")

        _warn_must_be_nested(self.state, self.lineno, self.env.docname, "selector-option", "selector")

        return [node]


class SelectedContent(nodes.General, nodes.Element):
    """
    A container to hold documentation content to be shown conditionally.

    rST usage::

        .. selected-content:: os=ubuntu
           :heading: Ubuntu Notes
    """

    @staticmethod
    def visit_html(translator, node):
        show_cond = node.get("show-cond", "")
        show_cond_attr = kv_to_data_attr("show-cond", show_cond)
        classes = " ".join(node.get("class", []))
        heading = node.get("heading", "")
        heading_level = min(node.get("heading-level") or 2, 6)

        id_attr = ""
        heading_elem = ""
        if heading:
            combined_show_cond = node.get("combined-show-cond", show_cond)
            id_attr = nodes.make_id(f"{heading}-{combined_show_cond}")
            heading_elem = (
                f'<h{heading_level} class="rocm-docs-custom-heading">'
                f'{heading}<a class="headerlink" href="#{id_attr}" title="Link to this heading">#</a>'
                f'</h{heading_level}>'
            )

        tag = "section" if heading else "div"
        translator.body.append(
            f"""
            <{tag}
                id="{id_attr}"
                class="rocm-docs-selected-content {classes}"
                {show_cond_attr}
                aria-hidden="true">
                {heading_elem}
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        tag = "section" if node.get("heading", "") else "div"
        translator.body.append(f"</{tag}>")

    @staticmethod
    def visit_markdown(translator, node):
        # The Markdown translator (used to generate llms-full.txt) has no
        # visitor for selector nodes. Render the conditional content inline so
        # it is not dropped, prefixed with a bold label of its condition (and
        # heading, when present) so mutually-exclusive variants — e.g.
        # os=linux vs os=windows — are not conflated into one another.
        # When Markdown generation is disabled, drop the block entirely.
        if not translator.config.rocm_selector_markdown_generation:
            raise nodes.SkipNode
        heading = node.get("heading", "")
        # Use this node's own condition (not combined-show-cond): the Markdown
        # walker descends into nested SelectedContent nodes, each of which emits
        # its own label, so nesting context is already represented. The combined
        # value also picks up sibling conditions for top-level blocks.
        show_cond = node.get("show-cond", "")
        label_parts = []
        if show_cond:
            label_parts.append(show_cond)
        if heading:
            label_parts.append(heading)
        label = " — ".join(label_parts)
        if label:
            para = nodes.paragraph()
            para += nodes.strong(text=label)
            para.walkabout(translator)
        for child in node.children:
            child.walkabout(translator)
        raise nodes.SkipNode


class SelectedContentDirective(SphinxDirective):
    required_arguments = 1  # condition (e.g., os=ubuntu)
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "id": directives.unchanged,
        "class": directives.unchanged,
        "heading": directives.unchanged,
        "heading-level": directives.nonnegative_int,
        "no-pdf": directives.flag,
    }

    def run(self):
        node = SelectedContent()
        node["show-cond"] = self.arguments[0]
        node["id"] = self.options.get("id", "")
        node["class"] = self.options.get("class", "")
        node["heading"] = self.options.get("heading", "")
        node["heading-level"] = self.options.get("heading-level", None)
        node["no-pdf"] = "no-pdf" in self.options

        parent_show_conds = [
            ancestor["show-cond"]
            for ancestor in self.state.parent.traverse(include_self=True)
            if isinstance(ancestor, SelectedContent) and "show-cond" in ancestor
        ]
        node["combined-show-cond"] = "+".join(parent_show_conds + [node["show-cond"]])

        self.state.nested_parse(self.content, self.content_offset, node)
        return [node]


# ---------------------------------------------------------------------------
# Constants and helpers for SelectorPDFReorganizeTransform.
# These must appear after all node classes they reference.
# ---------------------------------------------------------------------------

# Node types that are selector UI chrome — always skipped when gathering content
_SELECTOR_UI = (SelectorGroup, SelectorOption, SelectorInfo)

# Condition keys that are too granular to use for filtering (treat as always-match)
_IGNORE_KEYS = {"gpu", "gfx", "arch"}

# Docname prefixes for pages that are HTML-only redirect stubs.
# These get inlined into the mega-doctree by the LaTeX builder but carry no
# readable content, so they are stripped from the source pool before gathering.
_REDIRECT_DOCNAME_PREFIXES = ("install/redirect/",)


def _is_redirect_stub(node) -> bool:
    """Return True for HTML-only redirect stub pages inlined by the LaTeX builder.

    Sphinx's ``inline_all_toctrees`` wraps each inlined document in a
    ``sphinx.addnodes.start_of_file`` container rather than exposing the
    inner section directly, so detection must work for any node type.

    Three strategies in order:
    1. ``docname`` attribute — set on ``start_of_file`` nodes by Sphinx.
    2. ``node.source`` file path — set by the RST parser on every node.
    3. Content heuristic — the first inner section contains a sub-section
       whose title starts with "Redirecting".
    """
    # 1. docname attribute (most reliable when set)
    docname = node.get("docname", "") if hasattr(node, "get") else ""
    if docname and any(docname.startswith(p) for p in _REDIRECT_DOCNAME_PREFIXES):
        return True

    # 2. source file path
    source = (getattr(node, "source", None) or "").replace("\\", "/")
    if any(f"/{p}" in source for p in _REDIRECT_DOCNAME_PREFIXES):
        return True

    # 3. content heuristic: find the first section inside the node and check
    #    whether it contains a sub-section titled "Redirecting…"
    first_section = next(node.findall(nodes.section), None)
    if first_section is not None:
        for child in first_section.children:
            if isinstance(child, nodes.section):
                title = next(
                    (c for c in child.children if isinstance(c, nodes.title)), None
                )
                if title and title.astext().lower().startswith("redirect"):
                    return True

    return False


def _parse_cond(show_cond: str) -> dict:
    """Parse a ``show-cond`` string into {key: [values]}.

    Same-key entries are OR'd; different keys are AND'd.
    Keys in ``_IGNORE_KEYS`` are dropped so they never block a match.
    """
    result: dict = {}
    for token in show_cond.split():
        if "=" not in token:
            continue
        k, _, v = token.partition("=")
        k = normalize_key(k)
        v = normalize_key(v)
        if k in _IGNORE_KEYS:
            continue
        result.setdefault(k, []).append(v)
    return result


def _matches(show_cond: str, combo: dict) -> bool:
    """Return True if *combo* satisfies all conditions in *show_cond*.

    *combo* is a dict of {key: value} for the current (fam, os, ver, i).

    - Empty show-cond → always True (unconditional content).
    - Keys in ``_IGNORE_KEYS`` are stripped before matching (too granular).
    - Any remaining key that is absent from *combo* means the content
      belongs to a dimension that does not exist in the PDF (e.g. ``w``
      for the graphics/compute workload toggle) → returns False so those
      blocks are excluded rather than duplicated across every combo.
    """
    if not show_cond:
        return True
    cond = _parse_cond(show_cond)
    for key, allowed in cond.items():
        if key not in combo:
            return False  # dimension absent from PDF combos — exclude
        if combo[key] not in allowed:
            return False
    return True


def _make_pdf_id(*parts: str) -> str:
    """Build a unique, valid HTML/LaTeX ID from an arbitrary list of strings."""
    raw = "-".join(str(p) for p in parts if p)
    id_ = nodes.make_id(raw)
    # make_id returns "" for strings that start with digits (e.g. version "26.04");
    # fall back to a prefixed slug.
    return id_ or "pdf-" + raw.replace(".", "-").replace(" ", "-").lower()


def _gather_content(children, combo: dict, into: list, id_prefix: str = ""):
    """Recursively collect content nodes that match *combo*.

    - ``SelectedContent`` nodes whose ``show-cond`` does not match *combo* are
      skipped entirely.
    - ``SelectedContent`` nodes that match are unwrapped: their children are
      processed recursively, with a heading section prepended if they carry one.
    - Regular ``section`` nodes (Prerequisites, Installation, etc.) are recursed
      into and rebuilt with only the filtered content; empty sections are dropped.
    - Selector UI nodes (``SelectorGroup`` etc.) are always skipped.
    - Any other container node (dropdowns, admonitions, etc.) that contains
      ``SelectedContent`` descendants is recursed into and rebuilt so that
      filtering propagates through it.  Containers with no ``SelectedContent``
      descendants are deep-copied as-is.
    - ``nodes.transition`` and ``nodes.target`` are skipped — they are structural
      markup (horizontal rules and RST label anchors) that carry no readable
      content and would otherwise be duplicated across every combo section.
    """
    for child in children:
        if _is_redirect_stub(child):
            continue
        if isinstance(child, _SELECTOR_UI):
            continue
        if isinstance(child, (nodes.transition, nodes.target)):
            continue
        if isinstance(child, SelectedContent):
            if child.get("no-pdf"):
                continue
            show_cond = child.get("show-cond", "")
            if show_cond and not _matches(show_cond, combo):
                continue
            heading = child.get("heading", "")
            if heading:
                inner: list = []
                _gather_content(child.children, combo, inner, id_prefix)
                if inner:
                    sec_id = _make_pdf_id(id_prefix, heading)
                    section = nodes.section(ids=[sec_id], names=[sec_id])
                    section += nodes.title(text=heading)
                    for item in inner:
                        section += item
                    into.append(section)
            else:
                _gather_content(child.children, combo, into, id_prefix)
        elif isinstance(child, nodes.section):
            # Step section (e.g. Prerequisites, Installation): recurse and rebuild
            # with only the filtered content so unmatched variants are dropped.
            title_node = next(
                (c for c in child.children if isinstance(c, nodes.title)), None
            )
            non_title = [c for c in child.children if not isinstance(c, nodes.title)]
            inner = []
            _gather_content(non_title, combo, inner, id_prefix)
            if inner:
                step_title = title_node.astext() if title_node else ""
                sec_id = _make_pdf_id(id_prefix, step_title)
                new_section = nodes.section(ids=[sec_id], names=[sec_id])
                if title_node:
                    new_section += title_node.deepcopy()
                for item in inner:
                    new_section += item
                into.append(new_section)
        elif list(child.findall(SelectedContent)):
            # Container (e.g. dropdown/admonition) wrapping SelectedContent nodes.
            # Deep-copy the container then replace its children with the filtered set
            # so that conditional content inside it is properly pruned.
            new_node = child.deepcopy()
            filtered: list = []
            _gather_content(child.children, combo, filtered, id_prefix)
            new_node.children = []
            for c in filtered:
                c.parent = new_node
                new_node.children.append(c)
            if new_node.children:
                into.append(new_node)
        else:
            into.append(child.deepcopy())


def _collect_selector_options(chapter) -> dict:
    """Scan the chapter for SelectorGroup/SelectorOption nodes and return
    ``{key: [(value, label, group_show_cond)]}`` with values deduplicated in
    document order.  ``group_show_cond`` is the parent SelectorGroup's
    ``show-cond`` so callers can filter options by the active combo.
    """
    opts: dict = {}
    seen: dict = {}  # key → set of values already added
    for sg in chapter.findall(SelectorGroup):
        key = sg.get("key", "")
        if not key:
            continue
        if key not in opts:
            opts[key] = []
            seen[key] = set()
        group_show_cond = sg.get("show-cond", "")
        for opt in sg.findall(SelectorOption):
            val = opt.get("value", "")
            label = opt.get("label", val)
            if val and val not in seen[key]:
                opts[key].append((val, label, group_show_cond))
                seen[key].add(val)
    return opts


def _build_combos(sel_opts: dict) -> list:
    """Build the ordered list of (combo_dict, labels_dict) from selector options.

    Iterates fam → os → os-version → install-method.  For the install-method
    level, each SelectorGroup in the RST targets a specific OS via its
    ``show-cond``, so the label for ``pkgman`` varies by OS (apt/dnf/zypper).
    If multiple entries exist for the same value, the one whose group show-cond
    matches the current OS is preferred.

    Version selector keys follow the ``{os}-ver`` naming convention.
    """
    combos = []

    fam_opts = sel_opts.get("fam", [("all", "All", "")])
    os_opts  = sel_opts.get("os",  [])
    i_entries = sel_opts.get("i",   [])  # (value, label, group_show_cond)

    # Build a mapping: i_val → [(label, group_show_cond)] for label selection
    i_labels_by_val: dict = {}
    for i_val, i_label, i_group_cond in i_entries:
        i_labels_by_val.setdefault(i_val, []).append((i_label, i_group_cond))

    # Ordered unique install-method values (preserving first-seen order)
    i_vals_ordered: list = []
    seen_i: set = set()
    for i_val, _, _ in i_entries:
        if i_val not in seen_i:
            i_vals_ordered.append(i_val)
            seen_i.add(i_val)

    for fam_val, fam_label, _ in fam_opts:
        for os_val, os_label, _ in os_opts:
            ver_key = f"{os_val}-ver"
            ver_entries = sel_opts.get(ver_key, [])
            ver_iter = [(v, lbl) for v, lbl, _ in ver_entries] if ver_entries else [(None, None)]

            for ver_val, ver_label in ver_iter:
                for i_val in i_vals_ordered:
                    # Pick the install-method label whose group show-cond
                    # matches the current OS (fall back to first label).
                    i_label = i_labels_by_val[i_val][0][0]
                    for lbl, group_cond in i_labels_by_val[i_val]:
                        if _matches(group_cond, {"os": os_val}):
                            i_label = lbl
                            break

                    combo: dict = {"fam": fam_val, "os": os_val, "i": i_val}
                    if ver_val is not None:
                        combo[ver_key] = ver_val

                    labels = {
                        "fam": fam_label,
                        "os":  os_label,
                        "ver": ver_label,
                        "i":   i_label,
                    }
                    combos.append((combo, labels))

    return combos


class SelectorPDFReorganizeTransform(SphinxPostTransform):
    """Reorganize the install page for PDF/LaTeX output.

    In HTML the selector widgets let users pick (device family → OS →
    OS version → install method) and see only the relevant content.  In a PDF
    that interactivity is lost, so we restructure the document: for every
    valid combination we produce a dedicated section hierarchy

        <fam> → <os> → <os version> → <install method> → full guide

    so a reader can find the complete instructions for their setup in one
    place rather than scanning through all possible variants mixed together.

    The transform only runs for the LaTeX builder and only when the page
    contains enough ``SelectedContent`` nodes to be worth reorganising
    (threshold: ≥ 10 nodes).
    """

    default_priority = 488  # before SelectorToSectionTransform (490)

    def apply(self):
        if self.app.builder.format != "latex":
            return

        # PDF generation disabled: skip the per-combo install-page reorganization.
        if not self.config.rocm_selector_pdf_generation:
            return

        all_selected = list(self.document.findall(SelectedContent))
        if len(all_selected) < 10:
            return

        # In the LaTeX builder, post-transforms run on the assembled mega-doctree
        # (all pages inlined).  Each sub-document's sections are tagged with
        # docname='install/rocm' by inline_all_toctrees, so locate the right one.
        chapter = None
        for sec in self.document.findall(nodes.section):
            if sec.get("docname") == "install/rocm":
                chapter = sec
                break

        if chapter is None:
            # Fallback for single-document builds where docname tags may be absent.
            chapter = next(
                (n for n in self.document.children if isinstance(n, nodes.section)),
                None,
            )

        if chapter is None:
            return

        # ------------------------------------------------------------------
        # Preserve the preamble: the chapter title and any non-selector,
        # non-section nodes before the first SelectedContent.
        # ------------------------------------------------------------------
        preamble = []
        first_selected_idx = None
        for i, child in enumerate(chapter.children):
            if isinstance(child, SelectedContent):
                first_selected_idx = i
                break
            if isinstance(child, _SELECTOR_UI):
                continue
            preamble.append(child.deepcopy())

        if first_selected_idx is None:
            return

        # Source pool: chapter children from the first SelectedContent onwards.
        # Everything before that index is already captured in the preamble and
        # must not be repeated inside every per-combo section.
        source_children = chapter.children[first_selected_idx:]

        # Strip HTML-only redirect stub pages that the LaTeX builder inlines as
        # sub-sections of this chapter.  They have no content value in PDF.
        source_children = [c for c in source_children if not _is_redirect_stub(c)]

        # ------------------------------------------------------------------
        # Discover selector options from the doctree (no hardcoded arrays).
        # ------------------------------------------------------------------
        sel_opts = _collect_selector_options(chapter)
        all_combos = _build_combos(sel_opts)

        # ------------------------------------------------------------------
        # Build the new chapter contents: preamble + per-combo sections.
        # Group by fam → os → ver → i.
        # ------------------------------------------------------------------
        new_children = list(preamble)

        # Track which (fam, os, ver) section objects are already created so
        # we can append install-method sections to the right parent.
        fam_sections: dict = {}   # fam_val → (section_node, has_content)
        os_sections: dict = {}    # (fam_val, os_val) → (section_node, has_content)
        ver_sections: dict = {}   # (fam_val, os_val, ver_val) → (section_node, has_content)

        for combo, labels in all_combos:
            fam_val  = combo["fam"]
            os_val   = combo["os"]
            i_val    = combo["i"]
            ver_key  = f"{os_val}-ver"
            ver_val  = combo.get(ver_key)  # None if no version for this OS

            fam_label = labels["fam"]
            os_label  = labels["os"]
            ver_label = labels["ver"]
            i_label   = labels["i"]

            # Create fam section on first encounter.
            if fam_val not in fam_sections:
                fam_id = _make_pdf_id("pdf", fam_val)
                fam_sec = nodes.section(ids=[fam_id], names=[fam_id])
                fam_sec += nodes.title(text=fam_label)
                fam_sections[fam_val] = [fam_sec, False]

            os_key = (fam_val, os_val)
            if os_key not in os_sections:
                os_id = _make_pdf_id("pdf", fam_val, os_val)
                os_sec = nodes.section(ids=[os_id], names=[os_id])
                os_sec += nodes.title(text=os_label)
                os_sections[os_key] = [os_sec, False]

            ver_key_tuple = (fam_val, os_val, ver_val)
            if ver_key_tuple not in ver_sections:
                if ver_val is not None:
                    ver_id = _make_pdf_id("pdf", fam_val, os_val, ver_val)
                    ver_sec = nodes.section(ids=[ver_id], names=[ver_id])
                    ver_sec += nodes.title(text=ver_label or ver_val)
                    ver_sections[ver_key_tuple] = [ver_sec, False]
                else:
                    ver_sections[ver_key_tuple] = [None, False]  # no ver level

            id_prefix = _make_pdf_id(
                fam_val, os_val,
                ver_val if ver_val else "",
                i_val,
            )
            content_nodes: list = []
            _gather_content(source_children, combo, content_nodes, id_prefix)

            if not content_nodes:
                continue

            i_id = _make_pdf_id("pdf", fam_val, os_val,
                                ver_val if ver_val else "", i_val)
            i_sec = nodes.section(ids=[i_id], names=[i_id])
            i_sec += nodes.title(text=i_label)
            for n in content_nodes:
                i_sec += n

            ver_sec, _ = ver_sections[ver_key_tuple]
            target = ver_sec if ver_sec is not None else os_sections[os_key][0]
            target += i_sec
            ver_sections[ver_key_tuple][1] = True

        # Assemble the hierarchy bottom-up.
        for (fam_val, os_val, ver_val), (ver_sec, ver_has) in ver_sections.items():
            if not ver_has:
                continue
            os_sec, _ = os_sections[(fam_val, os_val)]
            if ver_sec is not None:
                os_sec += ver_sec
            os_sections[(fam_val, os_val)][1] = True

        for (fam_val, os_val), (os_sec, os_has) in os_sections.items():
            if not os_has:
                continue
            fam_sections[fam_val][0] += os_sec
            fam_sections[fam_val][1] = True

        for fam_val, (fam_sec, fam_has) in fam_sections.items():
            if fam_has:
                new_children.append(fam_sec)

        # ------------------------------------------------------------------
        # Replace the chapter's children with the reorganised content.
        # ------------------------------------------------------------------
        chapter.children = []
        for child in new_children:
            child.parent = chapter
            chapter += child

        # IDs built by _make_pdf_id are combo-derived and never registered with
        # the document, so a heading repeated across combos (e.g. a shared
        # "Prerequisites" step) yields duplicate section IDs. Reassign every new
        # section a document-unique ID so PDF/HTML cross-references resolve to
        # the correct target.
        for section in chapter.findall(nodes.section):
            old_ids = section["ids"]
            base = old_ids[0] if old_ids else (section.get("names") or ["sec"])[0]
            unique = make_unique_id(self.document, base)
            section["ids"] = [unique]
            section["names"] = [unique]


class SelectorToSectionTransform(SphinxPostTransform):
    """Convert SelectedContent nodes to proper docutils structures for non-HTML builders.

    In HTML, SelectedContent nodes render as conditional show/hide sections driven
    by JavaScript. In static formats (LaTeX/PDF, text, man) there is no interactivity,
    so all content must be visible. This transform runs before the LaTeX translator:

    - Nodes with a ``:heading:`` option become proper docutils ``section`` nodes so
      that headings appear correctly in the PDF table of contents and body text.
    - Nodes without a heading are unwrapped in place — their children are spliced
      directly into the parent so all condition variants render sequentially, which
      is correct behaviour for a static format.

    The HTML path is untouched: the transform exits immediately for HTML builds.
    The Markdown path (llms-full.txt) is also left untouched — it runs under the
    HTML builder and renders SelectedContent via the dedicated Markdown node
    handler instead.
    """

    default_priority = 490  # run before MatrixToTableTransform (500)

    def apply(self):
        if self.app.builder.format == "html":
            return

        # PDF generation disabled: skip converting SelectedContent for LaTeX.
        # The nodes' latex visitors are no-ops, so the conditional content is
        # simply omitted from the PDF. Other non-HTML builders still convert.
        if (
            self.app.builder.format == "latex"
            and not self.config.rocm_selector_pdf_generation
        ):
            return

        # Collect upfront so that replacing nodes mid-traversal is safe.
        for node in list(self.document.findall(SelectedContent)):
            if node.parent is None:
                continue  # already detached by a parent replacement

            heading = node.get("heading", "")

            if heading:
                # Replace with a proper section so the heading appears in the PDF.
                # Headings repeat across conditional blocks (e.g. "Prerequisites"
                # under each OS), so the ID must be deduplicated against the
                # document or cross-references collapse onto the first match.
                sec_id = make_unique_id(self.document, heading)
                section = nodes.section(ids=[sec_id], names=[sec_id])
                section += nodes.title(text=heading)
                for child in node.children[:]:
                    section += child
                node.replace_self(section)
            else:
                # No heading — splice children directly into the parent so the
                # SelectedContent wrapper disappears without dropping any content.
                # replace_self routes through Element.replace, which reparents
                # each spliced child (sets .parent/.document); a raw children
                # slice assignment would leave them pointing at the detached
                # wrapper and corrupt later transforms/translators.
                node.replace_self(node.children[:])


def setup(app):
    app.add_node(
        SelectorGroup,
        html=(SelectorGroup.visit_html, SelectorGroup.depart_html),
        markdown=(skip_node, noop),
        latex=(skip_node, noop),
        text=(skip_node, noop),
        man=(skip_node, noop),
        texinfo=(skip_node, noop),
    )
    app.add_node(
        SelectorInfo,
        html=(SelectorInfo.visit_html, SelectorInfo.depart_html),
        markdown=(skip_node, noop),
        latex=(skip_node, noop),
        text=(skip_node, noop),
        man=(skip_node, noop),
        texinfo=(skip_node, noop),
    )
    app.add_node(
        SelectorOption,
        html=(SelectorOption.visit_html, SelectorOption.depart_html),
        markdown=(skip_node, noop),
        latex=(skip_node, noop),
        text=(skip_node, noop),
        man=(skip_node, noop),
        texinfo=(skip_node, noop),
    )
    app.add_node(
        SelectedContent,
        html=(SelectedContent.visit_html, SelectedContent.depart_html),
        markdown=(SelectedContent.visit_markdown, noop),
        latex=(noop, noop),
        text=(noop, noop),
        man=(noop, noop),
        texinfo=(noop, noop),
    )

    app.add_directive("selector", SelectorGroupDirective)
    app.add_directive("selector-dropdown", SelectorDropdownDirective)
    app.add_directive("selector-info", SelectorInfoDirective)
    app.add_directive("selector-option", SelectorOptionDirective)
    app.add_directive("selected-content", SelectedContentDirective)
    app.add_directive("selected", SelectedContentDirective)

    app.add_post_transform(SelectorPDFReorganizeTransform)
    app.add_post_transform(SelectorToSectionTransform)

    register_output_flags(app)

    app.connect("env-purge-doc", _purge_selector_pages)
    app.connect("env-merge-info", _merge_selector_pages)
    app.connect("env-updated", _inject_selector_sidebar)
    app.connect("html-page-context", _inject_selector_toc2_context)

    # The post-transforms mutate each document's own doctree independently and
    # hold no cross-document state, so parallel writing is safe.
    return {
        "version": "1.5",
        "parallel_read_safe": True,
        "parallel_write_safe": True,
    }
