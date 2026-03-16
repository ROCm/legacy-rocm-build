from sphinx.util.docutils import SphinxDirective, directives, nodes
from pathlib import Path
from ..utils import kv_to_data_attr, normalize_key, logger

class SelectorGroup(nodes.General, nodes.Element):
    """
    A row or dropdown within a selector container.
    """

    @staticmethod
    def visit_html(translator, node):
        label = node["label"]
        key = node["key"]
        show_when_attr = kv_to_data_attr("show-when", node["show-when"])
        heading_width = node["heading-width"]
        dropdown_list_mode = node.get("dropdown-input", False)

        # Standard tile mode
        info_nodes = list(node.findall(SelectorInfo))
        info_link = info_nodes[0]["link"] if info_nodes else None
        info_icon = info_nodes[0]["icon"] if info_nodes else None

        info_icon_html = ""
        if info_link:
            info_icon_html = f"""
            <a href="{info_link}" target="_blank">
                <i class="rocm-docs-selector-icon {info_icon}"></i>
            </a>
            """

        translator.body.append(
            f"""
            <div id="{nodes.make_id(label)}"
                class="rocm-docs-selector-group row gx-0 pt-2"
                data-selector-key="{key}"
                {show_when_attr}
                {'role="radiogroup"' if dropdown_list_mode else ""}
                aria-label="{label}"
            >
                <div class="col-{heading_width} me-1 px-2 rocm-docs-selector-group-heading">
                    <span class="rocm-docs-selector-group-heading-text">{label}{info_icon_html}</span>
                </div>
                <div class="row col-{12 - heading_width} pe-0">
                {f'<select class="form-select rocm-docs-selector-dropdown-input" aria-label="{label}">' if dropdown_list_mode else ""}
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        dropdown_input_mode = node.get("dropdown-input", False)

        translator.body.append(
            f"""
                {"</select>" if dropdown_input_mode else ""}
                </div>
            </div>
            """
        )


class SelectorGroupDirective(SphinxDirective):
    required_arguments = 1  # title text
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "key": directives.unchanged,
        "show-when": directives.unchanged,
        "heading-width": directives.nonnegative_int,
        "dropdown-input": directives.flag,
    }

    def run(self):
        env = self.state.document.settings.env
        app = env.app

        # Add required JS and CSS if selector exists
        if not hasattr(env, '_selector_js_added'):
            static_assets_dir = Path(__file__).parent / "static"
            app.config.html_static_path.append(str(static_assets_dir))

            # https://tom-select.js.org/
            app.add_js_file("vendor/tom-select/tom-select.popular.min.js")
            app.add_css_file("vendor/tom-select/tom-select.bootstrap5.min.css")

            app.add_js_file("selector.js", type="module", defer="defer")
            app.add_css_file("selector.css")
            env._selector_js_added = True

        label = self.arguments[0]
        node = SelectorGroup()
        node["label"] = label
        node["key"] = normalize_key(self.options.get("key", label))
        node["show-when"] = self.options.get("show-when", "")
        node["heading-width"] = self.options.get("heading-width", 3)
        node["dropdown-input"] = "dropdown-input" in self.options

        # Parse nested content (selector-info + selector-option)
        self.state.nested_parse(self.content, self.content_offset, node)

        option_nodes = list(node.findall(SelectorOption))
        if option_nodes:
            for opt in option_nodes:
                opt["group_key"] = node["key"]
                opt["dropdown-input"] = node["dropdown-input"]

            # Default marking
            default_options = [opt for opt in option_nodes if opt["default"]]
            if not default_options:
                option_nodes[0]["default"] = True

        return [node]

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
        # Do nothing — rendering handled by SelectorGroup
        pass

    @staticmethod
    def depart_html(translator, node):
        # Do nothing — prevent NotImplementedError
        pass


class SelectorInfoDirective(SphinxDirective):
    required_arguments = 1  # link URL
    final_argument_whitespace = True
    has_content = False
    option_spec = {"icon": directives.unchanged}

    def run(self):
        node = SelectorInfo()
        node["link"] = self.arguments[0]
        node["icon"] = self.options.get("icon", "fa-solid fa-circle-info fa-lg")

        parent = getattr(self.state, "parent", None)
        if not parent or not any(isinstance(p, SelectorGroup) for p in parent.traverse(include_self=True)):
            logger.warning(
                f"'.. selector-info::' at line {self.lineno} should be nested under a '.. selector::' directive",
                location=(self.env.docname, self.lineno),
            )

        return [node]


class SelectorOption(nodes.General, nodes.Element):
    """
    A selectable tile or list-item option within a selector group.
    """

    @staticmethod
    def visit_html(translator, node):
        label = node["label"]
        value = node["value"]
        show_when_attr = kv_to_data_attr("show-when", node["show-when"])
        disable_when_attr = kv_to_data_attr("disable-when", node["disable-when"])
        default = node["default"]
        width = node["width"]
        dropdown_input_mode = node.get("dropdown-input", False)
        alt_name = node.get("alt-name", "")
        toc_label = node.get("toc-label", "")

        if dropdown_input_mode:
            label = alt_name
            selected_attr = " selected" if default else ""
            display_text = alt_name if alt_name else label
            translator.body.append(
                f'<option value="{value}"{selected_attr} {show_when_attr} {disable_when_attr}>{display_text}</option>'
            )
            return

        default_class = "rocm-docs-selector-option-default" if default else ""

        # Handle width: either bootstrap col-N or percentage
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
                {show_when_attr}
                {disable_when_attr}
                tabindex="0"
                role="radio"
                aria-checked="false"
                {toc_label_attr}
                {width_style}
            >
                <span>{label}</span>
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        dropdown_input_mode = node.get("dropdown-input", False)
        if dropdown_input_mode:
            return  # no closing tag needed for <option>
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
        "show-when": directives.unchanged,
        "disable-when": directives.unchanged,
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
        node["value"] = normalize_key(self.options.get("value", label))
        node["show-when"] = self.options.get("show-when", "")
        node["disable-when"] = self.options.get("disable-when", "")
        node["default"] = self.options.get("default", False) is not False

        # Parse width - supports bootstrap (1-12) or percentage (like "25%")
        width_value = self.options.get("width", "6")
        if isinstance(width_value, str) and width_value.endswith("%"):
            try:
                pct = float(width_value[:-1])
                if pct <= 0 or pct > 100:
                    raise ValueError("must be between 0 and 100")
                node["width"] = width_value
            except ValueError as e:
                logger.warning(
                    f"Invalid percentage width '{width_value}' ({e}), using default",
                    location=(self.env.docname, self.lineno),
                )
                node["width"] = 6
        else:
            try:
                col_num = int(width_value)
                if col_num < 1 or col_num > 12:
                    raise ValueError("must be between 1 and 12")
                node["width"] = col_num
            except ValueError as e:
                logger.warning(
                    f"Invalid width '{width_value}' ({e}), using default",
                    location=(self.env.docname, self.lineno),
                )
                node["width"] = 6

        node["alt-name"] = self.options.get("alt-name", "")
        node["icon"] = self.options.get("icon")
        node["toc-label"] = self.options.get("toc-label", "")

        parent = getattr(self.state, "parent", None)
        if not parent or not any(isinstance(p, SelectorGroup) for p in parent.traverse(include_self=True)):
            logger.warning(
                f"'.. selector-option::' at line {self.lineno} should be nested under a '.. selector::' directive",
                location=(self.env.docname, self.lineno),
            )

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
        show_when = node.get("show-when", "")
        show_when_attr = kv_to_data_attr("show-when", show_when)
        classes = " ".join(node.get("class", []))
        heading = node.get("heading", "")
        # default to <h2>
        heading_level = min(node.get("heading-level") or 2, 6) # maximum depth is <h6>

        id_attr = ""
        heading_elem = ""
        combined_show_when = node.get("combined-show-when", show_when)
        if heading:
            id_attr = nodes.make_id(f"{heading}-{show_when}")

            heading_elem = (
                f'<h{heading_level} class="rocm-docs-custom-heading">'
                f'{heading}<a class="headerlink" href="#{id_attr}" title="Link to this heading">#</a>'
                f'</h{heading_level}>'
            )

        translator.body.append(
            f"""
            <{"section" if heading else "div"}
                id="{id_attr}"
                class="rocm-docs-selected-content {classes}"
                {show_when_attr}
                aria-hidden="true">
                {heading_elem}
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        heading = node.get("heading", "")

        translator.body.append(f"""
            </{"section" if heading else "div"}>
            """)


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
        node["show-when"] = self.arguments[0]
        node["id"] = self.options.get("id", "")
        node["class"] = self.options.get("class", "")
        node["heading"] = self.options.get("heading", "")
        node["heading-level"] = self.options.get("heading-level", None)

        # Collect parent show-whens (if nested)
        # to create a completely unique id
        parent_show_whens = []
        for ancestor in self.state.parent.traverse(include_self=True):
            if isinstance(ancestor, SelectedContent) and "show-when" in ancestor:
                parent_show_whens.append(ancestor["show-when"])

        # Compose combined show-when chain
        combined_show_when = "+".join(parent_show_whens + [node["show-when"]])
        node["combined-show-when"] = combined_show_when

        # Parse nested content
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
    app.add_directive("selector-info", SelectorInfoDirective)
    app.add_directive("selector-option", SelectorOptionDirective)
    app.add_directive("selected-content", SelectedContentDirective)
    app.add_directive("selected", SelectedContentDirective)

    return {"version": "1.2", "parallel_read_safe": True}
