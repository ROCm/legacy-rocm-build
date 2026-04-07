const GROUP_QUERY = ".rocm-docs-selector-group";
const OPTION_QUERY = ".rocm-docs-selector-option";
const SELECTED_CLASS = "rocm-docs-selected";
const DISABLED_CLASS = "rocm-docs-disabled";
const HIDDEN_CLASS = "rocm-docs-hidden";
const TOC2_OPTIONS_LIST_QUERY = ".rocm-docs-selector-toc2-options";
const TOC2_CONTENTS_LIST_QUERY = ".rocm-docs-selector-toc2-contents";
const HEADING_QUERY = "h2,h3,h4,h5,h6";
const HEADING_TEXT_QUERY = ".rocm-docs-selector-group-heading-text";

const TOC_ITEM_CLASS = "rocm-docs-selector-toc2-item";
const EMPTY_ITEM_CLASS = "empty";

const DROPDOWN_INPUT_CLASS = "rocm-docs-selector-dropdown-input";
const DROPDOWN_INPUT_LABEL_CLASS = "rocm-docs-selector-dropdown-input-label";

const tomSelectInstances = [];
let contentsTocInitialized = false;

function isVisible(el) {
  return !!(el && el.offsetParent !== null);
}

function getGroupHeadingText(group) {
  const span = group.querySelector(HEADING_TEXT_QUERY);
  return span ? span.textContent.trim() : "(Unnamed Selector)";
}

function getUniqueGroups(groups) {
  const seen = new Set();
  return groups.filter((group) => {
    // Use group ID as primary identity; fallback to heading text.
    const identifier = group.id
      ? `id:${group.id}`
      : `heading:${getGroupHeadingText(group)}`;
    if (seen.has(identifier)) return false;
    seen.add(identifier);
    return true;
  });
}

export function updateTOC2OptionsList() {
  const tocOptionsList = document.querySelector(TOC2_OPTIONS_LIST_QUERY);
  if (!tocOptionsList) return;

  let visibleGroups = Array.from(document.querySelectorAll(GROUP_QUERY)).filter(
    isVisible,
  );
  visibleGroups = getUniqueGroups(visibleGroups);

  tomSelectInstances.forEach((ts) => ts.destroy());
  tomSelectInstances.length = 0;
  tocOptionsList.innerHTML = "";

  if (visibleGroups.length === 0) {
    const li = document.createElement("li");
    li.className =
      `nav-item toc-entry toc-h3 ${TOC_ITEM_CLASS} ${EMPTY_ITEM_CLASS}`;
    const span = document.createElement("span");
    span.textContent = "(no visible selectors)";
    li.appendChild(span);
    tocOptionsList.appendChild(li);
    return;
  }

  visibleGroups.forEach((group) => {
    const headingText = getGroupHeadingText(group);

    const liEl = document.createElement("li");
    liEl.className = `nav-item toc-entry toc-h3 ${TOC_ITEM_CLASS}`;
    liEl.dataset.groupId = group.id || "";

    const label = document.createElement("label");
    label.className = DROPDOWN_INPUT_LABEL_CLASS;
    label.textContent = headingText;
    label.htmlFor = headingText;

    const selectEl = document.createElement("select");
    selectEl.className = `form-select ${DROPDOWN_INPUT_CLASS}`;
    selectEl.name = headingText;

    const options = Array.from(group.querySelectorAll(OPTION_QUERY)).filter(
      (opt) =>
        !opt.classList.contains(HIDDEN_CLASS) &&
        !opt.classList.contains(DISABLED_CLASS),
    );

    if (options.length === 0) {
      const opt = document.createElement("option");
      opt.textContent = "(none available)";
      opt.disabled = true;
      opt.selected = true;
      selectEl.appendChild(opt);
    } else {
      options.forEach((optionEl) => {
        const tocLabel = optionEl.getAttribute("data-toc-label");
        let labelText;
        if (tocLabel) {
          labelText = tocLabel;
        } else {
          const clone = optionEl.cloneNode(true);
          clone.querySelectorAll("i, svg").forEach((el) => el.remove());
          labelText = clone.textContent.trim();
        }
        const opt = new Option(
          labelText,
          optionEl.dataset.selectorValue || "",
          false,
          optionEl.classList.contains(SELECTED_CLASS),
        );
        selectEl.appendChild(opt);
      });
    }

    liEl.appendChild(label);
    liEl.appendChild(selectEl);

    const ts = new TomSelect(selectEl, {
      plugins: ["dropdown_input"],
      onChange(value) {
        // For dropdown groups on the main page, drive via TomSelect so its
        // change event fires and selector.js handles the update. Calling
        // .click() on a native <option> element is unreliable across browsers.
        const mainSelect = group.querySelector(`.${DROPDOWN_INPUT_CLASS}`);
        if (mainSelect?.tomselect) {
          mainSelect.tomselect.setValue(value);
          return;
        }
        const target = group.querySelector(
          `${OPTION_QUERY}[data-selector-value="${CSS.escape(value)}"]`,
        );
        if (target) {
          target.click();
        }
      },
    });
    tomSelectInstances.push(ts);

    tocOptionsList.appendChild(liEl);
  });
}

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
      const visible =
        !!targetId &&
        !!(document.getElementById(targetId)?.offsetParent);
      const next = visible ? "" : "none";
      if (li.style.display !== next) li.style.display = next;
    });
}
