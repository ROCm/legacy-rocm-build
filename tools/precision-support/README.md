# Autotag

## Pre-requisites

* Python 3.10
* Create a GitHub Personal Access Token.
  * Tested with all the read-only permissions, but public_repo, read:project read:user, and repo:status should be enough.
  * Copy the token somewhere safe.
* Configure SSO for this token by authorizing it for the following organizations:
  * ROCm-Developer-Tools
  * RadeonOpenCompute
  * ROCmSoftwarePlatform

## Updating the changelog and release notes

> IMPORTANT: It is key to update the template Markdown files in `tools/autotag/templates/<name of change type>` (eg: `5.6.0.md`) and not the `CHANGELOG.md` or `RELEASE.md` itself to ensure that updates are not overwritten by the autotag script. The template should only have content from changelogs that are not included by the script to avoid duplicating data.

* Add or update the release specific notes in `tools/autotag/templates/<name of change type>`
* Ensure the all the repositories have their release specific branch with the updated changelogs
* Run this for 5.6.0 (change for whatever version you require)
* `GITHUB_ACCESS_TOKEN=my_token_here`

To generate the changelog from 5.0.0 up to and including 6.4.0:

```sh
python3 tag_script.py -t $GITHUB_ACCESS_TOKEN --no-release --no-pulls --starting-version=5.0.0 --compile_file ../../CHANGELOG.md --branch release/rocm-rel-6.4 6.4.0
```

To generate the release notes only for 6.4.0:

```sh
python3 tag_script.py -t $GITHUB_ACCESS_TOKEN --no-release --no-pulls --compile_file ../../RELEASE.md --branch release/rocm-rel-6.4 6.4.0
```

### Notes

> If branch cannot be found, edit default.xml at root.
> Sometimes the script doesn't know whether to include or exclude an entry for a specific release. Continue this part by accepting (Y) or rejecting (N) entries.
> The end result should be a newly generated changelog in the project root.
> If the `--starting-version` flag is not set, the script will not get changelogs from previous versions.
> Trying to run without a token is possible but GitHub enforces stricter rate limits and is therefore not advised.

* Copy over the first part of the changelog and replace the old release notes in RELEASE.md.

## Precision support audit (`/precision-check`, `/precision-check-delta`)

Audits data-type support across ROCm libraries between two releases. Uses a hybrid
approach: `precision_fetch.py` fetches raw source files and YAML snapshots from
GitHub to `/tmp/`, then Claude reads and compares them semantically via a slash
command — no regex parsers.

### Commands

| Command | When to use |
|---------|-------------|
| `/precision-check PREV CURR` | Full audit — checks all libraries that changed in the manifest |
| `/precision-check-delta PREV CURR` | SHA-filtered — only checks libraries whose source file itself changed |

Use `/precision-check-delta` for routine release-to-release audits. Use
`/precision-check` for a full sweep regardless of source file changes.

### Prerequisites

* [Claude Code](https://claude.ai/claude-code) installed and running in this repo.
* `$GITHUB_TOKEN` set to a GitHub Personal Access Token with read access to the ROCm org. Add it to your shell profile or pass it inline:

  ```sh
  export GITHUB_TOKEN=your_token_here
  ```

### Running an audit

Open Claude Code in this repo and run:

```sh
/precision-check 7.1.1 7.2.0
# or
/precision-check-delta 7.1.1 7.2.0
```

Claude will:

1. Run `precision_fetch.py` to download source files and YAML snapshots to `/tmp/`.
2. Read and compare each library's source against `precision-support.yaml`.
3. Auto-update the YAML for clear missing entries.
4. Flag ambiguous findings (macro expansion, combination tables, support level mismatches) for human review.
5. Write a timestamped log to `tools/autotag/precision-update-log/` (gitignored — local only).

Commit any YAML changes. The YAML being audited lives at `docs/data/reference/precision-support/precision-support.yaml`.

### Adding new libraries to precision support

* Add an entry to `MANIFEST_TO_TAG` in `precision_fetch.py` mapping the manifest component name to the YAML tag.
* Add an entry to `SOURCE_CONFIG` in `precision_fetch.py` with the org, repo, and path to the source file. Add a `note` field if the library should be permanently skipped.
* Update `MONOREPO_LIBS` in `precision_fetch.py` if the library lives inside a monorepo (e.g. `rocm-libraries`).

## Adding new libraries/repositories

* Add the name or group of the repository (retrieved in default.xml in the ROCm project root) to: included_names or included_groups to auto_tag.py.
* At the moment of writing, this is only in the 5.6 branch and not the develop branch.
* Re-run the command specified in the steps above.
* Some libraries do not have the changelog for every point release. The tool will give out warnings, but it is okay to ignore them.
