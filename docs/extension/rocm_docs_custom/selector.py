from sphinx.util.docutils import SphinxDirective, directives, nodes
from pathlib import Path
from .utils import kv_to_data_attr, normalize_key
import random
import string


class SelectorGroup(nodes.General, nodes.Element):
    """
    A row within a selector container.

    rST usage:

    .. selector-group:: Heading
       :key:
       :show-when: os=ubuntu (list of key=value pairs separated by spaces)
       :heading-width: 4 (defaults to 6)
    """

    @staticmethod
    def visit_html(translator, node):
        label = node["label"]
        key = node["key"]
        show_when_attr = kv_to_data_attr("show-when", node["show-when"])
        heading_width = node["heading-width"]
        icon = node["icon"]

        icon_html = ""
        if icon:
            icon_html = f'<i class="rocm-docs-selector-icon {icon}"></i>'

        translator.body.append(
            "<!-- start selector-group row -->"
            f"""
            <div id="{nodes.make_id(label)}" class="rocm-docs-selector-group row gx-0 pt-2"
                data-selector-key="{key}"
                {show_when_attr}
                role="radiogroup"
                aria-label="{label}"
            >
                <div class="col-{heading_width} me-1 px-2 rocm-docs-selector-group-heading">
                    <span class="rocm-docs-selector-group-heading-text">{label}{icon_html}</span>
                </div>
                <div class="row col-{12 - heading_width} pe-0">
            """.strip()
        )

    @staticmethod
    def depart_html(translator, _):
        translator.body.append(
            """
                </div>
            </div>
            """
            "<!-- end selector-group row -->"
        )


class SelectorGroupDirective(SphinxDirective):
    required_arguments = 1  # tile text
    final_argument_whitespace = True
    has_content = True
    option_spec = {
        "key": directives.unchanged,
        "show-when": directives.unchanged,
        "heading-width": directives.nonnegative_int,
        "icon": directives.unchanged,
    }

    def run(self):
        label = self.arguments[0]
        node = SelectorGroup()
        node["label"] = label
        node["key"] = normalize_key(self.options.get("key", label))
        node["show-when"] = self.options.get("show-when", "")
        node["heading-width"] = self.options.get("heading-width", 3)
        node["icon"] = self.options.get("icon")

        # Parse nested content
        self.state.nested_parse(self.content, self.content_offset, node)

        # Find all SelectorOption descendants
        option_nodes = list(node.findall(SelectorOption))

        if option_nodes:
            # Set the group key on all options
            for opt in option_nodes:
                opt["group_key"] = node["key"]

            # Find all options marked as default
            default_options = [opt for opt in option_nodes if opt["default"]]

            if default_options:
                # Multiple options marked :default: - only keep first as default
                for i, opt in enumerate(default_options):
                    if i > 0:
                        opt["default"] = False
            else:
                # No explicit default - make first option default
                option_nodes[0]["default"] = True

        return [node]


class SelectorOption(nodes.General, nodes.Element):
    """
    A selectable tile within a selector group.

    rST usage:

    .. selector-option::
    """

    @staticmethod
    def visit_html(translator, node):
        label = node["label"]
        value = node["value"]
        disable_when_attr = kv_to_data_attr("disable-when", node["disable-when"])
        default = node["default"]
        width = node["width"]
        group_key = node.get("group_key", "")

        default_class = "rocm-docs-selector-option-default" if default else ""

        translator.body.append(
            "<!-- start selector-option tile -->"
            f"""
            <div class="rocm-docs-selector-option {default_class} col-{width} px-2"
                data-selector-key="{group_key}"
                data-selector-value="{value}"
                {disable_when_attr}
                tabindex="0"
                role="radio"
                aria-checked="false"
            >
                <span>{label}</span>
            """.strip()
        )

    @staticmethod
    def depart_html(translator, node):
        icon = node["icon"]
        if icon:
            translator.body.append(f'<i class="rocm-docs-selector-icon {icon}"></i>')
        translator.body.append("</div>" "<!-- end selector-option tile -->")


class SelectorOptionDirective(SphinxDirective):
    required_arguments = 1  # text of tile
    final_argument_whitespace = True
    option_spec = {
        "value": directives.unchanged,
        "disable-when": directives.unchanged,
        "default": directives.flag,
        "width": directives.nonnegative_int,
        "icon": directives.unchanged,
    }
    has_content = True

    def run(self):
        label = self.arguments[0]
        node = SelectorOption()
        node["label"] = label
        node["value"] = normalize_key(self.options.get("value", label))
        # node["show-when"] = self.options.get("show-when", "")
        node["disable-when"] = self.options.get("disable-when", "")
        node["default"] = self.options.get("default", False) is not False
        node["width"] = self.options.get("width", 6)
        node["icon"] = self.options.get("icon")

        # Content replaces label if provided
        # if self.content:
        #     self.state.nested_parse(self.content, self.content_offset, node)
        # else:
        #     node += nodes.Text(label)
        return [node]

class SelectedContent(nodes.General, nodes.Element):
    """
    A container to hold conditional content.

    rST usage::

        .. selected-content:: os=ubuntu
           :heading: Ubuntu Notes
    """

    @staticmethod
    def visit_html(translator, node):
        show_when_attr = kv_to_data_attr("show-when", node["show-when"])
        classes = " ".join(node.get("class", []))
        heading = node.get("heading", "")
        heading_level = node.get("heading-level") or (SelectedContent._get_depth(node) + 1)
        heading_level = min(heading_level, 6)

        heading_elem = ""
        if heading:
            # HACK to fix secondary sidebar observer
            suffix = "".join(random.choices(string.ascii_lowercase + string.digits, k=3))
            id_attr = nodes.make_id(f"{heading}-{suffix}")

            heading_elem = (
                f'<h{heading_level} id="{id_attr}" class="rocm-docs-custom-heading">'
                f'{heading}<a class="headerlink" href="#{id_attr}" title="Link to this heading">#</a>'
                f'</h{heading_level}>'
            )

        translator.body.append(
            f"""
            <!-- start selected-content -->
            <div class="rocm-docs-selected-content {classes}" {show_when_attr} aria-hidden="true">
                {heading_elem}
            """.strip()
        )

    @staticmethod
    def depart_html(translator, _):
        translator.body.append("</div><!-- end selected-content -->")

    @staticmethod
    def _get_depth(node):
        depth = 1
        parent = node.parent
        while parent is not None:
            if isinstance(parent, SelectedContent) and parent.get("heading"):
                depth += 1
            parent = getattr(parent, "parent", None)
        return depth


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
        node["heading"] = self.options.get("heading", "")  # empty string if none
        node["heading-level"] = self.options.get("heading-level", None)

        # Parse nested content
        self.state.nested_parse(self.content, self.content_offset, node)
        return [node]


def setup(app):
    app.add_node(
        SelectorGroup,
        html=(SelectorGroup.visit_html, SelectorGroup.depart_html),
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
    app.add_directive("selector-option", SelectorOptionDirective)
    app.add_directive("selected-content", SelectedContentDirective)
    app.add_directive("selected", SelectedContentDirective)

    static_assets_dir = Path(__file__).parent / "static"
    app.config.html_static_path.append(str(static_assets_dir))
    app.add_css_file("selector.css")
    app.add_js_file("selector.js", type="module", defer="defer")

    return {"version": "1.0", "parallel_read_safe": True}
