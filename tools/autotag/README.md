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

## Adding new libraries/repositories

* Add the name or group of the repository (retrieved in default.xml in the ROCm project root) to: included_names or included_groups to auto_tag.py.
* At the moment of writing, this is only in the 5.6 branch and not the develop branch.
* Re-run the command specified in the steps above.
* Some libraries do not have the changelog for every point release. The tool will give out warnings, but it is okay to ignore them.
