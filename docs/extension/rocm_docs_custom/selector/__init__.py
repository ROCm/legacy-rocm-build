import json
import html as html_mod
from sphinx.util.docutils import SphinxDirective, directives, nodes
from pathlib import Path
from ..utils import kv_to_data_attr, normalize_key, logger


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


class SelectedContentDirective(SphinxDirective):
    required_arguments = 1  # condition (e.g., os=ubuntu)
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "id": directives.unchanged,
        "class": directives.unchanged,
        "heading": directives.unchanged,
        "heading-level": directives.nonnegative_int,
    }

    def run(self):
        node = SelectedContent()
        node["show-cond"] = self.arguments[0]
        node["id"] = self.options.get("id", "")
        node["class"] = self.options.get("class", "")
        node["heading"] = self.options.get("heading", "")
        node["heading-level"] = self.options.get("heading-level", None)

        parent_show_conds = [
            ancestor["show-cond"]
            for ancestor in self.state.parent.traverse(include_self=True)
            if isinstance(ancestor, SelectedContent) and "show-cond" in ancestor
        ]
        node["combined-show-cond"] = "+".join(parent_show_conds + [node["show-cond"]])

        self.state.nested_parse(self.content, self.content_offset, node)
        return [node]


def setup(app):
    app.add_node(
        SelectorGroup,
        html=(SelectorGroup.visit_html, SelectorGroup.depart_html),
    )
    app.add_node(
        SelectorInfo,
        html=(SelectorInfo.visit_html, SelectorInfo.depart_html),
    )
    app.add_node(
        SelectorOption,
        html=(SelectorOption.visit_html, SelectorOption.depart_html),
    )
    app.add_node(
        SelectedContent,
        html=(SelectedContent.visit_html, SelectedContent.depart_html),
    )

    app.add_directive("selector", SelectorGroupDirective)
    app.add_directive("selector-dropdown", SelectorDropdownDirective)
    app.add_directive("selector-info", SelectorInfoDirective)
    app.add_directive("selector-option", SelectorOptionDirective)
    app.add_directive("selected-content", SelectedContentDirective)
    app.add_directive("selected", SelectedContentDirective)

    app.connect("env-purge-doc", _purge_selector_pages)
    app.connect("env-merge-info", _merge_selector_pages)
    app.connect("env-updated", _inject_selector_sidebar)
    app.connect("html-page-context", _inject_selector_toc2_context)

    return {"version": "1.3", "parallel_read_safe": True}
