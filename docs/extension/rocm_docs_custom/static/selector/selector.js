import { domReady, logDebug } from "./utils.js";
import {
  updateTOC2ContentsList,
  updateTOC2OptionsList,
} from "./selector-toc.js";

const GROUP_QUERY = ".rocm-docs-selector-group";
const OPTION_QUERY = ".rocm-docs-selector-option";
const COND_QUERY = "[data-show-when],[data-disable-when]";

const DEFAULT_OPTION_CLASS = "rocm-docs-selector-option-default";
const DISABLED_CLASS = "rocm-docs-disabled";
const HIDDEN_CLASS = "rocm-docs-hidden";
const SELECTED_CLASS = "rocm-docs-selected";

// Toggle helpers -------------------------------------------------------------

const isDefaultOption = (elem) => elem.classList.contains(DEFAULT_OPTION_CLASS);

const disable = (elem) => {
  elem.classList.add(DISABLED_CLASS);
  elem.setAttribute("aria-disabled", "true");
  elem.setAttribute("tabindex", "-1");
};

const enable = (elem) => {
  elem.classList.remove(DISABLED_CLASS);
  elem.setAttribute("aria-disabled", "false");
  elem.setAttribute("tabindex", "0");
};

const hide = (elem) => {
  elem.classList.add(HIDDEN_CLASS);
  elem.setAttribute("aria-hidden", "true");
};

const show = (elem) => {
  elem.classList.remove(HIDDEN_CLASS);
  elem.setAttribute("aria-hidden", "false");
};

const select = (elem) => {
  elem.classList.add(SELECTED_CLASS);
  elem.setAttribute("aria-checked", "true");
};

const deselect = (elem) => {
  elem.classList.remove(SELECTED_CLASS);
  elem.setAttribute("aria-checked", "false");
};

// Global selector state ------------------------------------------------------

const state = {};

function getState() {
  return { ...state };
}

function setState(updates) {
  Object.assign(state, updates);
  logDebug("State updated:", state);
}

// Condition handling ---------------------------------------------------------

/**
 * Safely parse JSON-encoded conditions from a data-* attribute.
 * Expects a key/value object, where values may be strings or arrays of strings.
 */
function parseConditions(attrName, raw) {
  if (!raw) return null;

  try {
    const conditions = JSON.parse(raw);
    if (typeof conditions !== "object" || Array.isArray(conditions)) {
      console.warn(
        `[ROCmDocsSelector] Invalid '${attrName}' format ` +
          "(must be a key/value object):",
        raw,
      );
      return null;
    }
    return conditions;
  } catch (err) {
    console.error(
      `[ROCmDocsSelector] Couldn't parse '${attrName}' conditions:`,
      err,
    );
    return null;
  }
}

/**
 * Return true iff all conditions match the current state.
 * - Values can be a string or an array of strings.
 * - A condition with an undefined state key is treated as not matching.
 */
function matchesConditions(conditions, currentState) {
  for (const [key, expected] of Object.entries(conditions)) {
    const actual = currentState[key];

    // If no value yet, this condition does not match.
    if (actual === undefined) return false;

    if (Array.isArray(expected)) {
      if (!expected.includes(actual)) return false;
    } else if (actual !== expected) {
      return false;
    }
  }
  return true;
}

function shouldBeDisabled(elem) {
  const raw = elem.dataset.disableWhen;
  if (!raw) return false; // no conditions => never disabled

  const conditions = parseConditions("disable-when", raw);
  if (!conditions) {
    console.warn(
      "[ROCmDocsSelector] Invalid 'show-when' conditions; " +
        "hiding affected element.",
    );
    return false;
  }

  return matchesConditions(conditions, state);
}

function shouldBeShown(elem) {
  const raw = elem.dataset.showWhen;
  if (!raw) return true; // no conditions => always visible

  const conditions = parseConditions("show-when", raw);
  if (!conditions) return true;

  return matchesConditions(conditions, state);
}

// Event handlers -------------------------------------------------------------

function handleOptionSelect(e) {
  const option = e.currentTarget;

  // Ignore interaction with disabled or already selected options
  if (
    option.classList.contains(DISABLED_CLASS) ||
    option.classList.contains(SELECTED_CLASS)
  ) {
    return;
  }

  const { selectorKey: key, selectorValue: value } = option.dataset;
  if (!key || !value) return;

  // Update all selectors sharing the same key
  const allOptions = document.querySelectorAll(
    `${OPTION_QUERY}[data-selector-key="${key}"]`,
  );

  allOptions.forEach((opt) => {
    if (opt.dataset.selectorValue === value) {
      select(opt);
    } else {
      deselect(opt);
    }
  });

  // Update global state
  setState({ [key]: value });

  // Re-run visibility rules and TOC sync
  updateVisibility();
}

function handleOptionKeydown(e) {
  if (e.key === "Enter" || e.key === " ") {
    e.preventDefault();
    handleOptionSelect(e);
  }
}

// Visibility / enablement update --------------------------------------------

// Ensure each selector group always has a valid selected option.
// If the current selection becomes disabled/hidden due to another selector's
// change, automatically pick a replacement.
function reconcileGroupSelections() {
  const currentState = getState();
  const updates = {};

  document.querySelectorAll(GROUP_QUERY).forEach((group) => {
    // Skip groups that are themselves hidden
    if (group.classList.contains(HIDDEN_CLASS)) return;

    const options = Array.from(group.querySelectorAll(OPTION_QUERY));
    if (!options.length) return;

    const groupKey = group.dataset.selectorKey ||
      options[0].dataset.selectorKey;
    if (!groupKey) return;

    // Options that are both enabled and visible
    const enabledVisible = options.filter(
      (opt) =>
        !opt.classList.contains(DISABLED_CLASS) &&
        !opt.classList.contains(HIDDEN_CLASS),
    );

    if (!enabledVisible.length) {
      // No valid options left; just clear visual selection.
      options.forEach(deselect);
      return;
    }

    const currentlySelected = options.find((opt) =>
      opt.classList.contains(SELECTED_CLASS)
    );

    const selectedStillValid = currentlySelected &&
      enabledVisible.includes(currentlySelected);

    if (selectedStillValid) {
      const selectedValue = currentlySelected.dataset.selectorValue;
      if (selectedValue && currentState[groupKey] !== selectedValue) {
        updates[groupKey] = selectedValue;
      }
      return;
    }

    // Need a new selection: prefer a default option, otherwise the first
    // enabled+visible option in DOM order.
    const replacement = enabledVisible.find(isDefaultOption) ||
      enabledVisible[0];
    if (!replacement) return;

    options.forEach(deselect);
    select(replacement);

    const newValue = replacement.dataset.selectorValue;
    if (newValue && currentState[groupKey] !== newValue) {
      updates[groupKey] = newValue;
    }
  });

  const changedKeys = Object.keys(updates);
  if (changedKeys.length > 0) {
    setState(updates);
    return true;
  }
  return false;
}

let isUpdatingVisibility = false;

function updateVisibility() {
  // Prevent re-entrancy if something triggers updateVisibility
  // while it is already running.
  if (isUpdatingVisibility) return;
  isUpdatingVisibility = true;

  try {
    let stateChanged = false;
    let iterations = 0;

    // We may need multiple passes: reconciling selections can change the
    // global state, which in turn affects show/disable conditions.
    do {
      document.querySelectorAll(COND_QUERY).forEach((elem) => {
        // Show/hide only if element has show-when
        if (elem.dataset.showWhen !== undefined) {
          if (shouldBeShown(elem)) {
            show(elem);
          } else {
            hide(elem);
          }
        }

        // Enable/disable only if element has disable-when
        if (elem.dataset.disableWhen !== undefined) {
          if (shouldBeDisabled(elem)) {
            disable(elem);
          } else {
            enable(elem);
          }
        }
      });

      stateChanged = reconcileGroupSelections();
      iterations += 1;
      // Hard stop to avoid infinite loops in case of conflicting rules.
    } while (stateChanged && iterations < 5);

    updateTOC2OptionsList();
    updateTOC2ContentsList();
  } finally {
    isUpdatingVisibility = false;
  }
}

// Initialization -------------------------------------------------------------

domReady(() => {
  const selectorOptions = document.querySelectorAll(OPTION_QUERY);
  const initialState = {};

  // Attach listeners and gather defaults
  selectorOptions.forEach((option) => {
    option.addEventListener("click", handleOptionSelect);
    option.addEventListener("keydown", handleOptionKeydown);

    if (isDefaultOption(option)) {
      select(option);
      const { selectorKey: key, selectorValue: value } = option.dataset;
      if (key && value && initialState[key] === undefined) {
        initialState[key] = value;
      }
    }
  });

  setState(initialState);
  updateVisibility();

  // Mark all selector groups as initialized to make them visible
  document.querySelectorAll(GROUP_QUERY).forEach((group) => {
    group.classList.add("rocm-docs-selector-initialized");
  });
});
