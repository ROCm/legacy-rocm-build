const GROUP_QUERY = ".rocm-docs-selector-group";
const SELECTED_CLASS = "rocm-docs-selected";
const TOC2_OPTIONS_LIST_QUERY = ".rocm-docs-selector-toc2-options";
const TOC2_CONTENTS_LIST_QUERY = ".rocm-docs-selector-toc2-contents";
const HEADING_QUERY = ".rocm-docs-selected-content h1,h2,h3,h4,h5,h6";

const TOC_ITEM_CLASS = "rocm-docs-selector-toc2-item";
const EMPTY_ITEM_CLASS = "empty";

let optionsTocInitialized = false;

function isVisible(el) {
  return !!(el && el.offsetParent !== null);
}

function getUniqueGroups(groups) {
  const seen = new Set();
  return groups.filter((group) => {
    // Use group ID as primary identity; fallback to heading text
    const headingSpan = group.querySelector(
      ".rocm-docs-selector-group-heading-text"
    );
    const headingText = headingSpan
      ? headingSpan.textContent.trim()
      : "(Unnamed Selector)";
    const identifier = group.id ? `id:${group.id}` : `heading:${headingText}`;

    if (seen.has(identifier)) return false;
    seen.add(identifier);
    return true;
  });
}

function initTOC2OptionsList() {
  const tocOptionsList = document.querySelector(TOC2_OPTIONS_LIST_QUERY);
  if (!tocOptionsList) return;

  tocOptionsList.innerHTML = "";

  let groups = Array.from(document.querySelectorAll(GROUP_QUERY)).filter(isVisible);
  groups = getUniqueGroups(groups);

  if (groups.length === 0) {
    const li = document.createElement("li");
    li.className = `nav-item toc-entry toc-h3 ${TOC_ITEM_CLASS} ${EMPTY_ITEM_CLASS}`;
    const span = document.createElement("span");
    span.textContent = "(no visible selectors)";
    li.appendChild(span);
    tocOptionsList.appendChild(li);
    optionsTocInitialized = true;
    return;
  }

  groups.forEach((group) => {
    const headingSpan = group.querySelector(
      ".rocm-docs-selector-group-heading-text"
    );
    const headingText = headingSpan
      ? headingSpan.textContent.trim()
      : "(Unnamed Selector)";

    const li = document.createElement("li");
    li.className = `nav-item toc-entry toc-h3 ${TOC_ITEM_CLASS}`;
    li.dataset.groupId = group.id || "";

    const link = document.createElement("a");
    link.className = "nav-link";
    link.href = group.id ? `#${group.id}` : "#";
    link.dataset.headingText = headingText;

    const selectedOption = group.querySelector(`.${SELECTED_CLASS}`);
    let optionText = "(none selected)";
    if (selectedOption) {
      const clone = selectedOption.cloneNode(true);
      clone.querySelectorAll("i, svg").forEach((el) => el.remove());
      optionText = clone.innerHTML.trim();
    }

    link.innerHTML = `<strong>${headingText}</strong>: ${optionText}`;
    li.appendChild(link);
    tocOptionsList.appendChild(li);
  });

  optionsTocInitialized = true;
}

export function updateTOC2OptionsList() {
  const tocOptionsList = document.querySelector(TOC2_OPTIONS_LIST_QUERY);
  if (!tocOptionsList) return;

  let visibleGroups = Array.from(document.querySelectorAll(GROUP_QUERY)).filter(
    isVisible
  );
  visibleGroups = getUniqueGroups(visibleGroups);

  // Always rebuild fresh (simpler, avoids state drift)
  tocOptionsList.innerHTML = "";

  if (visibleGroups.length === 0) {
    const li = document.createElement("li");
    li.className = `nav-item toc-entry toc-h3 ${TOC_ITEM_CLASS} ${EMPTY_ITEM_CLASS}`;
    const span = document.createElement("span");
    span.textContent = "(no visible selectors)";
    li.appendChild(span);
    tocOptionsList.appendChild(li);
    return;
  }

  visibleGroups.forEach((group) => {
    const headingSpan = group.querySelector(
      ".rocm-docs-selector-group-heading-text"
    );
    const headingText = headingSpan
      ? headingSpan.textContent.trim()
      : "(Unnamed Selector)";

    const li = document.createElement("li");
    li.className = `nav-item toc-entry toc-h3 ${TOC_ITEM_CLASS}`;
    li.dataset.groupId = group.id || "";

    const link = document.createElement("a");
    link.className = "nav-link";
    link.href = group.id ? `#${group.id}` : "#";
    link.dataset.headingText = headingText;

    const selectedOption = group.querySelector(`.${SELECTED_CLASS}`);
    let optionText = "(none selected)";
    if (selectedOption) {
      const clone = selectedOption.cloneNode(true);
      clone.querySelectorAll("i, svg").forEach((el) => el.remove());
      optionText = clone.innerHTML.trim();
    }

    link.innerHTML = `<strong>${headingText}</strong>: ${optionText}`;
    li.appendChild(link);
    tocOptionsList.appendChild(li);
  });
}

let contentsTocInitialized = false;

function initTOC2ContentsList() {
  const tocContentsList = document.querySelector(TOC2_CONTENTS_LIST_QUERY);
  if (!tocContentsList) return;

  // Remove any previous dynamic items (idempotent init)
  tocContentsList
    .querySelectorAll(`li.toc-entry.${TOC_ITEM_CLASS}`)
    .forEach((node) => node.remove());

  const headings = Array.from(document.querySelectorAll(HEADING_QUERY));
  if (headings.length === 0) {
    contentsTocInitialized = true;
    return;
  }

  const lastLiByLevel = {};

  headings.forEach((h) => {
    const level = parseInt(h.tagName.substring(1), 10);
    if (Number.isNaN(level) || level < 2 || level > 6) return;

    const li = document.createElement("li");
    li.className = `nav-item toc-entry toc-${h.tagName.toLowerCase()} ` +
      TOC_ITEM_CLASS;

    const a = document.createElement("a");
    a.className = "reference internal nav-link";

    const section = h.closest("section");
    const targetId = h.id || (section ? section.id : "");
    a.href = targetId ? `#${targetId}` : "#";

    // Use only the text from the heading (ignore headerlink icon etc.)
    const clone = h.cloneNode(true);
    const firstTextNode = clone.childNodes.length > 0
      ? clone.childNodes[0].textContent
      : "";
    a.textContent = (firstTextNode || "").trim();

    li.dataset.targetId = targetId;
    li.appendChild(a);

    // Nest under closest previous shallower heading
    let parentUl = null;
    for (let parentLevel = level - 1; parentLevel >= 2; parentLevel -= 1) {
      const parentLi = lastLiByLevel[parentLevel];
      if (parentLi) {
        parentUl = parentLi.querySelector("ul");
        if (!parentUl) {
          parentUl = document.createElement("ul");
          parentUl.className = "nav section-nav flex-column";
          parentLi.appendChild(parentUl);
        }
        break;
      }
    }

    if (parentUl) {
      parentUl.appendChild(li);
    } else {
      tocContentsList.appendChild(li);
    }

    lastLiByLevel[level] = li;
    for (let deeper = level + 1; deeper <= 6; deeper += 1) {
      delete lastLiByLevel[deeper];
    }
  });

  contentsTocInitialized = true;
}

export function updateTOC2ContentsList() {
  const tocOptionsList = document.querySelector(TOC2_OPTIONS_LIST_QUERY);
  const tocContentsList = document.querySelector(TOC2_CONTENTS_LIST_QUERY);
  if (!tocContentsList || !tocOptionsList) return;

  if (!contentsTocInitialized) {
    initTOC2ContentsList();
  }

  tocContentsList
    .querySelectorAll(`li.toc-entry.${TOC_ITEM_CLASS}`)
    .forEach((li) => {
      const targetId = li.dataset.targetId;
      if (!targetId) {
        li.style.display = "none";
        return;
      }
      const target = document.getElementById(targetId);
      const visible = target && target.offsetParent !== null;
      li.style.display = visible ? "" : "none";
    });
}
