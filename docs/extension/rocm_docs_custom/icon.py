from docutils import nodes


def icon_role(name, rawtext, text, lineno, inliner, options=None, content=None):
    """
    Inline role for Font Awesome icons. See
    https://fontawesome.com/search?ip=brands&o=r to find available icons.

    Example rST usage:

    :icon:`fa-brands fa-redhat fa-lg`

    Example MyST Markdown usage:

    {icon}`fa-brands fa-redhat fa-lg`
    """
    html = f'<i class="{text}"></i>'
    node = nodes.raw("", html, format="html")
    return [node], []


def setup(app):
    app.add_role("icon", icon_role)

    return {"version": "6.9", "parallel_read_safe": True}
