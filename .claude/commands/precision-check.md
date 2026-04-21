Precision support delta check. Arguments: $ARGUMENTS = "previous_version current_version" (e.g. 7.1.1 7.2.0).

**Output rule:** Do not write any text until all tool calls are complete. When you are ready to respond, write exactly: "X of N libraries need verification." then the summary table, then detail blocks, then the "Changes written:" block. Nothing else. No narration, no transitions, no status updates, no reasoning.

## Step 1 — Fetch source files

```bash
cd ~/projects/ROCm-internal/tools/precision-support && python3 precision_fetch.py -t "$GITHUB_TOKEN" --previous PREVIOUS --current CURRENT
```

Replace PREVIOUS and CURRENT from $ARGUMENTS.

## Step 2 — Read library list

Read `/tmp/precision_libs.txt`.

## Step 3 — Parse each library

For each library in the list:

- Source file exists (`/tmp/precision_{lib}_source.txt`): read it and `/tmp/precision_{lib}_yaml.txt`, then compare.
- URL file exists (`/tmp/precision_{lib}_url.txt`): read it — this is the GitHub link to the source file, used in the detail block Source field.
- Skip file exists (`/tmp/precision_{lib}_skip.txt`): note the reason.

**Do not use GitHub MCP tools, WebFetch, or any network call.** All content is already in `/tmp/`. Use only the Read tool on those files.

You are the parser. Read the source file directly — do not infer from filenames or prior knowledge.

- RST files: look for list-tables, type listings, and support level indicators.
- C headers: look for enums and macros that define supported types.
- AMD/NVIDIA split tables: use the AMD column only.

## Step 4 — Known mismatches (do not flag)

These entries are **specific** — they exempt only the named type for the named library. They do not mark the entire library as clean. Continue checking all other types in every library.

- **hipBLAS float16**: YAML=⚠️ correct — only AXPY and Dot support it.
- **hipBLAS bfloat16**: YAML=⚠️ correct — only Dot supports it.
- **rocBLAS float16**: same partial-support pattern as hipBLAS — do not flag.
- **rocBLAS bfloat16**: same partial-support pattern as hipBLAS — do not flag.
- **MIGraphX int8**: YAML=⚠️ correct — quantization-only via `quantize_int8()`.
- **rocFFT float16**: YAML already includes float16 ✅ — do not flag as missing.

**Do not dismiss any other gaps on your own judgment.** If a type appears in the source but not in the YAML, flag it — even if you think it might be intentional or covered by convention. That call belongs to the human reviewer, not you.

## Step 5 — Classify and update (silent)

For each finding, decide **auto-update** or **flag**:

**Default: auto-update.** If a type is absent from YAML and appears in the source, add it — unless one of the following exceptions applies.

**Flag for human review if ANY are true:**

- Found only via macro expansion (e.g., `MIGRAPHX_SHAPE_VISIT_TYPES`).
- Found only in a combination table (Ti/To/Tc triplets) — not a canonical per-type list.
- Finding is a support level mismatch (✅ vs ⚠️) — the type is already in YAML but at the wrong level.
- Source contains only typedef declarations with no support table or ✅ indicators of any kind.
- Type is explicitly marked AMD ❌ in an AMD/NVIDIA split table.

For auto-update findings, add the missing types to `~/projects/ROCm-internal/docs/data/reference/precision-support/precision-support.yaml`. Match the existing format exactly (type + support fields).

Then write a log to `~/projects/ROCm-internal/tools/precision-support/precision-update-log/PREVIOUS-CURRENT-YYYYMMDD-HHMMSS.md` (replace PREVIOUS/CURRENT from $ARGUMENTS, timestamp from `date +%Y%m%d-%H%M%S`). Always create a new file — never read or overwrite an existing log. Log format:

```markdown
# Precision support audit: ROCm PREVIOUS → CURRENT

**Date:** YYYY-MM-DD

## Auto-updated
(table of types added, or "None")

## Flagged for human review
(table of flags)

## Clean / skipped
(table)
```

## Step 6 — Output

Write your response now. Start with: "X of N libraries need verification."

Then the summary table. **This MUST be a markdown table — no lists, no separators, no other format.** One row per library, all libraries included:

| Library | Finding | Action | Source |
|---------|---------|--------|--------|
| ... | ... | ... | filename.ext |

Use the URL from `/tmp/precision_{lib}_url.txt`. In the Source column, write only the filename (last path segment, plain text — no markdown link). For skipped libraries, leave Source blank.

Then, **for flagged libraries only**, a detail block:

<!-- markdownlint-disable MD036 -->
**{Library}**
<!-- markdownlint-enable MD036 -->

- Finding: ...
- Details: ...
- Source: [filename](url) — full clickable link using the URL from `/tmp/precision_{lib}_url.txt`.
- Recommended action: ...

Clean and skipped libraries appear only in the table — no detail block.

End with:

```text
Changes written:
- {library}: {types added}
(or "None" if no auto-updates)
```
