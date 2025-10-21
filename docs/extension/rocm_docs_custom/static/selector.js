const READY_EVENT = "ROCmDocsSelectorsReady";
const STATE_CHANGE_EVENT = "ROCmDocsSelectorStateChanged";

const GROUP_QUERY = ".rocm-docs-selector-group";
const OPTION_QUERY = ".rocm-docs-selector-option";
const COND_QUERY = "[data-show-when]";
const TOC2_OPTIONS_LIST_QUERY = ".rocm-docs-selector-toc2-options";
const TOC2_CONTENTS_LIST_QUERY = ".rocm-docs-selector-toc2-contents";
const HEADING_QUERY = ".rocm-docs-selected-content h1,h2,h3,h4,h5,h6[id]";

const isDefaultOption = (elem) =>
  elem.classList.contains("rocm-docs-selector-option-default");

const DISABLED_CLASS = "rocm-docs-disabled";
const disable = (elem) => {
  elem.classList.add(DISABLED_CLASS);
  elem.setAttribute("aria-disabled", "true");
  elem.setAttribute("tabindex", "-1");
};
// const enable = (elem) => {
//   elem.classList.remove(DISABLED_CLASS);
//   elem.setAttribute("aria-disabled", "false");
//   elem.setAttribute("tabindex", "0");
// };

const HIDDEN_CLASS = "rocm-docs-hidden";
const hide = (elem) => {
  elem.classList.add(HIDDEN_CLASS);
  elem.setAttribute("aria-hidden", "true");
};
const show = (elem) => {
  elem.classList.remove(HIDDEN_CLASS);
  elem.setAttribute("aria-hidden", "false");
};

const SELECTED_CLASS = "rocm-docs-selected";
const select = (elem) => {
  elem.classList.add(SELECTED_CLASS);
  elem.setAttribute("aria-checked", "true");
};
const deselect = (elem) => {
  elem.classList.remove(SELECTED_CLASS);
  elem.setAttribute("aria-checked", "false");
};

const state = {};

function getState() {
  return { ...state };
}

function setState(updates) {
  const previousState = getState();
  Object.assign(state, updates);

  const event = new CustomEvent(STATE_CHANGE_EVENT, {
    detail: {
      previousState,
      currentState: getState(),
      changes: updates,
    },
  });
  document.dispatchEvent(event);
}

function validateOptionElem(optionElem) {
  const key = optionElem.dataset.selectorKey;
  const value = optionElem.dataset.selectorValue;

  const errors = [];
  if (!key) errors.push("Missing 'data-selector-key'");
  if (!value) errors.push("Missing 'data-selector-value'");

  if (errors.length === 0) return;

  const label = optionElem.textContent.trim() || "<unnamed option>";
  console.error(
    `[ROCmDocsSelector] Invalid selector option '${label}': ${
      errors.join(", ")
    }!`,
  );
  disable(optionElem);
}

function handleOptionSelect(e) {
  const option = e.currentTarget;
  const parentGroup = option.closest(GROUP_QUERY);
  const siblingOptions = parentGroup.querySelectorAll(OPTION_QUERY);

  siblingOptions.forEach((elem) => deselect(elem));
  select(option);

  // Update global state
  const key = option.dataset.selectorKey;
  const value = option.dataset.selectorValue;
  if (key && value) setState({ [key]: value });

  updateVisibility();
}

function shouldBeShown(elem) {
  const conditionsData = elem.dataset.showWhen;
  if (!conditionsData) return true; // Default visible

  try {
    const conditions = JSON.parse(conditionsData);
    // Ensure it's an object
    if (typeof conditions !== "object" || Array.isArray(conditions)) {
      console.warn(
        "[ROCmDocsSelector] Invalid 'show-when' format (must be key/value object):",
        conditionsData,
      );
      return true;
    }

    for (const [key, value] of Object.entries(conditions)) {
      const currentValue = state[key];

      if (currentValue === undefined) return false;

      if (Array.isArray(value)) {
        if (!value.includes(currentValue)) return false;
        continue;
      }

      if (state[key] !== value) {
        return false;
      }
    }

    return true;
  } catch (err) {
    console.error(
      "[ROCmDocsSelector] Couldn't parse 'show-when' conditions:",
      err,
    );
    return true;
  }
}

function updateTOC2OptionsList() {
  const tocOptionsList = document.querySelector(TOC2_OPTIONS_LIST_QUERY);
  if (!tocOptionsList) return;

  // Clear previous entries
  tocOptionsList.innerHTML = "";

  // Get only visible selector groups
  const groups = Array.from(document.querySelectorAll(GROUP_QUERY)).filter(
    (g) => g.offsetParent !== null,
  );

  if (groups.length === 0) {
    const li = document.createElement("li");
    li.className =
      "nav-item toc-entry toc-h3 rocm-docs-selector-toc2-item empty";
    const span = document.createElement("span");
    span.textContent = "(no visible selectors)";
    li.appendChild(span);
    tocOptionsList.appendChild(li);
    return;
  }

  groups.forEach((group) => {
    // ✅ Find group heading span
    const headingSpan = group.querySelector(
      ".rocm-docs-selector-group-heading-text",
    );
    const headingText = headingSpan
      ? headingSpan.textContent.trim()
      : "(Unnamed Selector)";

    // Find currently selected option
    const selectedOption = group.querySelector(`.${SELECTED_CLASS}`);
    let optionText = "(none selected)";
    if (selectedOption) {
      const clone = selectedOption.cloneNode(true);
      // Remove all <i> elements
      clone.querySelectorAll("i, svg").forEach((el) => el.remove());
      optionText = clone.innerHTML.trim();
    }

    // Build list item
    const li = document.createElement("li");
    li.className = "nav-item toc-entry toc-h3 rocm-docs-selector-toc2-item";

    const link = document.createElement("a");
    link.className = "nav-link";
    link.href = `#${group.id}`;
    link.innerHTML = `<strong>${headingText}</strong>: ${optionText}`;

    li.appendChild(link);
    tocOptionsList.appendChild(li);
  });
}

function updateTOC2ContentsList() {
  const tocOptionsList = document.querySelector(TOC2_OPTIONS_LIST_QUERY);
  const tocContentsList = document.querySelector(TOC2_CONTENTS_LIST_QUERY);
  if (!tocContentsList || !tocOptionsList) return;

  const visibleHeaders = [...document.querySelectorAll(HEADING_QUERY)]
    .filter((h) => h.offsetParent !== null); // only visible headings

  tocContentsList
    .querySelectorAll("li.toc-entry.rocm-docs-selector-toc2-item")
    .forEach((node) => node.remove());

  if (visibleHeaders.length === 0) return;

  let lastH2Li = null;

  visibleHeaders.forEach((h) => {
    const level = parseInt(h.tagName.substring(1), 10);
    const li = document.createElement("li");
    li.className =
      `nav-item toc-entry toc-${h.tagName.toLowerCase()} rocm-docs-selector-toc2-item`;

    const a = document.createElement("a");
    a.className = "reference internal nav-link";
    const section = h.closest("section");
    const fallbackId = section ? section.id : "";
    a.href = h.id ? `#${h.id}` : fallbackId ? `#${fallbackId}` : "#";
    a.textContent = h.cloneNode(true).childNodes[0].textContent.trim();
    li.appendChild(a);

    // Nest logic: h3+ belong to last h2's inner list
    if (level === 2) {
      tocContentsList.appendChild(li);
      lastH2Li = li;
    } else if (level === 3 && lastH2Li) {
      // ensure nested UL exists
      let innerUl = lastH2Li.querySelector("ul");
      if (!innerUl) {
        innerUl = document.createElement("ul");
        innerUl.className = "nav section-nav flex-column";
        lastH2Li.appendChild(innerUl);
      }
      innerUl.appendChild(li);
    } else {
      tocContentsList.appendChild(li);
    }
  });
}

function updateVisibility() {
  document.querySelectorAll(COND_QUERY).forEach((elem) => {
    if (shouldBeShown(elem)) {
      show(elem);
    } else {
      hide(elem);
    }
  });

  updateTOC2OptionsList();
  updateTOC2ContentsList();
}

function init() {
  const selectorOptions = document.querySelectorAll(OPTION_QUERY);

  const initialState = {};

  // Attach listeners and gather defaults
  selectorOptions.forEach((option) => {
    validateOptionElem(option);

    option.addEventListener("click", handleOptionSelect);
    option.addEventListener("keydown", (e) => {
      if (e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        handleOptionSelect(e);
      }
    });

    if (isDefaultOption(option)) {
      select(option);
      const { selectorKey: key, selectorValue: value } = option.dataset;
      if (key && value) {
        initialState[key] = value;
      }
    }
  });

  setState(initialState);
  updateVisibility();

  document.dispatchEvent(new CustomEvent(READY_EVENT));
}

function domReady(callback) {
  if (document.readyState !== "loading") {
    callback();
  } else {
    document.addEventListener("DOMContentLoaded", callback, { once: true });
  }
}

// window.rocmDocsSelector = {
//   setState,
//   getState,
// };

// Initialize when DOM is ready
domReady(init);
