const TOC_QUERY = ".bd-docs-nav";
const TOC2_QUERY = ".bd-sidebar-secondary";
// /install/rocm.html
const INSTALL_PAGE_DIR = "install";
const INSTALL_PAGE_FILE = "rocm.html";
const TOC_ENTRIES_TO_MODIFY = [
  { tocQuery: "a[href$='redirect/_prerequisites.html']", toc2Query: "a[href='#prerequisites']" },
  { tocQuery: "a[href$='redirect/_install.html']", toc2Query: "a[href='#installation']" },
  { tocQuery: "a[href$='redirect/_post-install.html']", toc2Query: "a[href='#post-installation']" },
  { tocQuery: "a[href$='redirect/_uninstall.html']", toc2Query: "a[href='#uninstalling']" },
];

function domReady(callback) {
  if (document.readyState !== "loading") callback();
  else document.addEventListener("DOMContentLoaded", callback, { once: true });
}

function getDocsRoot() {
  const pathname = window.location.pathname;
  const parts = pathname.split("/").filter(Boolean);

  // If ur already inside /install/, preserve the path up to install/
  if (pathname.includes(`/${INSTALL_PAGE_DIR}/`)) {
    const installIdx = parts.indexOf(INSTALL_PAGE_DIR);
    return "/" + parts.slice(0, installIdx + 1).join("/") + "/";
  }

  // HACK:
  // Look for version pattern: at least two dots (e.g., 6.4.3, 7.10.0-preview), or known aliases
  const versionIdx = parts.findIndex(part =>
    (part.match(/\./g) || []).length >= 2 || /^\d+$/.test(part) || part === "latest"
  );

  if (versionIdx !== -1) {
    return "/" + parts.slice(0, versionIdx + 1).join("/") + `/${INSTALL_PAGE_DIR}/`;
  }

  // Fallback to root-level /install/
  return `/${INSTALL_PAGE_DIR}/`;
}

function buildHref(docsRoot, page, hash) {
  // If already on the install page, just use hash anchors
  const pathname = window.location.pathname;
  const isOnInstallPage = pathname.endsWith(`/${INSTALL_PAGE_DIR}/${INSTALL_PAGE_FILE}`) ||
                          pathname.endsWith(`/${INSTALL_PAGE_FILE}`);

  if (isOnInstallPage && hash) {
    return `#${hash}`;
  }

  return `${docsRoot}${page}${hash ? "#" + hash : ""}`;
}

function watchClassChange(elem, cls, onAdd, onRemove) {
  if (!elem) return;
  const obs = new MutationObserver(() => {
    elem.classList.contains(cls) ? onAdd?.() : onRemove?.();
  });
  obs.observe(elem, { attributes: true, attributeFilter: ["class"] });
}

domReady(() => {
  const toc = document.querySelector(TOC_QUERY);
  const toc2 = document.querySelector(TOC2_QUERY);
  if (!toc) return;

  const docsRoot = getDocsRoot();

  TOC_ENTRIES_TO_MODIFY.forEach((item) => {
    const tocElem = toc.querySelector(item.tocQuery);
    if (!tocElem) {
      console.warn(`[ROCmDocsToc]: No ${item.tocQuery} found on page`);
      return;
    }

    const anchorId = item.toc2Query.match(/#([^'"\]]+)/)?.[1];
    if (!anchorId) return;

    tocElem.href = buildHref(docsRoot, INSTALL_PAGE_FILE, anchorId);

    const toc2Elem = toc2?.querySelector(item.toc2Query);
    if (!toc2Elem) return;

    watchClassChange(
      toc2Elem,
      "active",
      () => tocElem.parentElement.classList.add("current"),
      () => tocElem.parentElement.classList.remove("current"),
    );
  });
});
