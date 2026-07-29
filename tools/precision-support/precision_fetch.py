#!/usr/bin/env python3
"""Fetch precision support source files and YAML for Claude to compare.

Writes raw content to an isolated output directory for the Claude
precision-check command. Claude reads the files and does the comparison — no
regex parsers used.

Usage (manifest-scoped — full audit):
    python3 precision_fetch.py -t $GITHUB_TOKEN --previous 7.1.1 --current 7.2.0

Usage (SHA-filtered — only libraries whose source file changed):
    python3 precision_fetch.py -t $GITHUB_TOKEN --previous 7.1.1 --current 7.2.0 --sha-filter

Usage (explicit library list):
    python3 precision_fetch.py -t $GITHUB_TOKEN --version 7.2.0 --libs hipblas,hipsparselt
"""

import argparse
import base64
import json
import re
import sys
import tempfile
from pathlib import Path
from urllib.error import HTTPError, URLError
from urllib.request import Request, urlopen

try:
    import yaml
except ImportError:
    sys.exit("pyyaml is required: pip install pyyaml")

from manifest_diff import fetch_manifest, diff_manifests


# ---------------------------------------------------------------------------
# Output files
# ---------------------------------------------------------------------------

_ARTIFACT_COMPONENT = re.compile(r"^[A-Za-z0-9][A-Za-z0-9_.-]*$")


def prepare_output_dir(requested: Path | None) -> Path:
    """Create and return the directory used for this run's artifacts."""
    if requested is None:
        return Path(tempfile.mkdtemp(prefix="rocm-precision-"))

    output_dir = requested.expanduser().resolve()
    try:
        output_dir.mkdir(mode=0o700, parents=True, exist_ok=True)
    except OSError as error:
        raise SystemExit(f"Cannot create output directory {output_dir}: {error}") from error

    if not output_dir.is_dir():
        raise SystemExit(f"Output path is not a directory: {output_dir}")
    return output_dir


def artifact_path(output_dir: Path, library: str, kind: str) -> Path:
    """Return a confined artifact path for a library and artifact kind."""
    for label, value in (("library", library), ("artifact kind", kind)):
        if not _ARTIFACT_COMPONENT.fullmatch(value):
            raise ValueError(f"Invalid {label}: {value!r}")
    return output_dir / f"precision_{library}_{kind}.txt"


# ---------------------------------------------------------------------------
# Monorepo expansion
# ---------------------------------------------------------------------------
# Some manifest entries are monorepos covering multiple precision-tracked
# libraries. When one of these appears in the manifest diff, expand it to
# all tracked sub-libraries rather than treating it as a single component.

MONOREPO_LIBS: dict[str, list[str]] = {
    "rocm-libraries": [
        "hipBLAS", "hipBLASLt", "hipFFT", "hipRAND",
        "hipSOLVER", "hipSPARSE", "hipSPARSELt", "hipTensor", "hipCUB",
        "rocBLAS", "rocFFT", "rocRAND", "rocSOLVER", "rocSPARSE",
        "rocWMMA", "rocPRIM", "rocThrust", "Tensile",
    ],
}


# ---------------------------------------------------------------------------
# Mapping: manifest component name → YAML library tag
# ---------------------------------------------------------------------------

MANIFEST_TO_TAG: dict[str, str] = {
    "hipBLAS":          "hipblas",
    "hipBLASLt":        "hipblaslt",
    "hipFFT":           "hipfft",
    "hipRAND":          "hiprand",
    "hipSOLVER":        "hipsolver",
    "hipSPARSE":        "hipsparse",
    "hipSPARSELt":      "hipsparselt",
    "hipTensor":        "hiptensor",
    "hipCUB":           "hipcub",
    "rocBLAS":          "rocblas",
    "rocFFT":           "rocfft",
    "rocRAND":          "rocrand",
    "rocSOLVER":        "rocsolver",
    "rocSPARSE":        "rocsparse",
    "rocWMMA":          "rocwmma",
    "rocPRIM":          "rocprim",
    "rocThrust":        "rocthrust",
    "composable_kernel": "composable-kernel",
    "MIOpen":           "miopen",
    "AMDMIGraphX":      "migraphx",
    "rccl":             "rccl",
    "Tensile":          "tensile",
}


# ---------------------------------------------------------------------------
# Source config: YAML tag → GitHub fetch details
# ---------------------------------------------------------------------------
# Each entry defines where to fetch the authoritative source file for a library.
#   org:    GitHub org (default "ROCm")
#   repo:   GitHub repo name
#   path:   Path to the source file within the repo
#   note:   Set if the library is skipped or has no parseable source

SOURCE_CONFIG: dict[str, dict] = {
    "hipblas": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipblas/docs/reference/data-type-support.rst",
    },
    "hipblaslt": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipblaslt/docs/reference/data-type-support.rst",
    },
    "hipfft": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipfft/docs/reference/hipfft-api-usage.rst",
    },
    "hiprand": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hiprand/docs/api-reference/data-type-support.rst",
    },
    "hipsolver": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipsolver/docs/reference/precision.rst",
    },
    "hipsparse": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipsparse/docs/reference/precision.rst",
    },
    "hipsparselt": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipsparselt/docs/reference/data-type-support.rst",
    },
    "hiptensor": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hiptensor/docs/api-reference/api-reference.rst",
    },
    "hipcub": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipcub/docs/api-reference/data-type-support.rst",
        "note": "No data-type-support page exists — hipCUB is header-only and type-agnostic",
    },
    "rocblas": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocblas/docs/reference/data-type-support.rst",
    },
    "rocfft": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocfft/library/include/rocfft/rocfft.h",
    },
    "rocrand": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocrand/docs/api-reference/data-type-support.rst",
    },
    "rocsolver": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocsolver/docs/reference/precision.rst",
    },
    "rocsparse": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocsparse/docs/reference/precision.rst",
    },
    "rocwmma": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocwmma/docs/api-reference/api-reference-guide.rst",
    },
    "rocprim": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocprim/docs/reference/data-type-support.rst",
    },
    "rocthrust": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/rocthrust/docs/data-type-support.rst",
        "note": "No data-type-support page exists — rocThrust is a template library and type-agnostic",
    },
    "composable-kernel": {
        "org":  "ROCm",
        "repo": "composable_kernel",
        "path": "docs/reference/Composable_Kernel_supported_scalar_types.rst",
    },
    "miopen": {
        "org":  "ROCm",
        "repo": "MIOpen",
        "path": "docs/reference/datatypes.rst",
    },
    "migraphx": {
        "org":  "ROCm",
        "repo": "AMDMIGraphX",
        "path": "src/api/include/migraphx/migraphx.h",
    },
    "rccl": {
        "org":  "ROCm",
        "repo": "rccl",
        "path": "src/nccl.h.in",
    },
    "tensile": {
        "org":  "ROCm",
        "repo": "rocm-libraries",
        "path": "projects/hipblaslt/tensilelite/Tensile/docs/src/reference/precision-support.rst",
        "note": "Tensile has no docs folder — it is an internal kernel generator, not a user-facing library",
    },
}


# ---------------------------------------------------------------------------
# GitHub helpers
# ---------------------------------------------------------------------------

_GH_API = "https://api.github.com"


def _gh_request(token: str, url: str) -> dict:
    req = Request(url, headers={
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "X-GitHub-Api-Version": "2022-11-28",
    })
    with urlopen(req, timeout=30) as resp:
        return json.loads(resp.read())


def _version_to_ref(version: str) -> str:
    """Convert a ROCm version string to a release branch ref.

    e.g. '7.2.0' → 'release/rocm-rel-7.2'
    """
    major_minor = ".".join(version.split(".")[:2])
    return f"release/rocm-rel-{major_minor}"


def fetch_yaml(token: str, version: str) -> dict:
    """Fetch precision-support.yaml from the ROCm/ROCm repo.

    Tries the release branch first, falls back to the release tag.
    """
    path = "docs/data/reference/precision-support/precision-support.yaml"
    for ref in _refs_for_version(version):
        url = f"{_GH_API}/repos/ROCm/ROCm/contents/{path}?ref={ref}"
        try:
            data = _gh_request(token, url)
            return yaml.safe_load(base64.b64decode(data["content"]).decode())
        except HTTPError as e:
            if e.code in (401, 403):
                sys.exit(f"GitHub authentication failed (HTTP {e.code}) — check your token.")
            continue
        except URLError as e:
            sys.exit(f"Network error: {e}")
    sys.exit(f"Cannot fetch precision-support.yaml for ROCm {version}: not found at branch or tag.")


def _refs_for_version(version: str) -> list[str]:
    """Return refs to try in order: release branch first, tag as fallback."""
    return [_version_to_ref(version), f"rocm-{version}"]


def fetch_file_sha(token: str, org: str, repo_name: str, path: str, version: str) -> str | None:
    """Return the blob SHA of a file at the given ROCm version, or None if not found.

    Tries the release branch first, falls back to the release tag.
    """
    for ref in _refs_for_version(version):
        url = f"{_GH_API}/repos/{org}/{repo_name}/contents/{path}?ref={ref}"
        try:
            data = _gh_request(token, url)
            return data.get("sha")
        except HTTPError as e:
            if e.code in (401, 403):
                sys.exit(f"GitHub authentication failed (HTTP {e.code}) — check your token.")
            continue
        except URLError as e:
            sys.exit(f"Network error fetching SHA for {path}: {e}")
    return None


def fetch_source_file(token: str, org: str, repo_name: str, path: str, version: str) -> str | None:
    """Fetch a source file from GitHub at the given ROCm version.

    Tries the release branch first, falls back to the release tag.
    Returns the file content as a string, or None if not found at either ref.
    """
    for ref in _refs_for_version(version):
        url = f"{_GH_API}/repos/{org}/{repo_name}/contents/{path}?ref={ref}"
        try:
            data = _gh_request(token, url)
            return base64.b64decode(data["content"]).decode()
        except HTTPError as e:
            if e.code in (401, 403):
                sys.exit(f"GitHub authentication failed (HTTP {e.code}) — check your token.")
            continue
        except URLError as e:
            sys.exit(f"Network error fetching {path}: {e}")
    return None


def load_yaml_types(yaml_data: dict) -> dict[str, dict[str, str]]:
    """Return {tag: {type: support}} from precision-support.yaml."""
    result: dict[str, dict[str, str]] = {}
    for group in yaml_data.get("library_groups", []):
        for lib in group.get("libraries", []):
            tag = lib["tag"]
            result[tag] = {dt["type"]: dt["support"] for dt in lib.get("data_types", [])}
    return result


# ---------------------------------------------------------------------------
# Scoping
# ---------------------------------------------------------------------------

def sha_filter_scope(
    token: str,
    previous: str,
    current: str,
    output_dir: Path,
) -> list[str]:
    """Return sorted list of library tags where the source file changed between two ROCm versions.

    Checks all tracked libraries — no manifest diff. Skips libraries where the
    source file SHA is identical at both tags, writing a skip file so Claude knows why.
    """
    print(f"SHA-filtering all tracked libraries {previous} → {current}...", file=sys.stderr)
    changed = []
    for lib, config in SOURCE_CONFIG.items():
        if config.get("note"):
            continue  # permanently skipped libraries (type-agnostic, internal, etc.)
        org, repo, path = config["org"], config["repo"], config["path"]
        sha_prev = fetch_file_sha(token, org, repo, path, previous)
        sha_curr = fetch_file_sha(token, org, repo, path, current)
        if sha_prev is None and sha_curr is None:
            artifact_path(output_dir, lib, "skip").write_text(
                f"Source file not found at either {previous} or {current}",
                encoding="utf-8",
            )
            print(f"  {lib}: not found at either version — skip", file=sys.stderr)
        elif sha_prev == sha_curr:
            artifact_path(output_dir, lib, "skip").write_text(
                f"Source file unchanged between {previous} and {current} (SHA match)",
                encoding="utf-8",
            )
            print(f"  {lib}: unchanged — skip", file=sys.stderr)
        else:
            changed.append(lib)
            print(f"  {lib}: changed — include", file=sys.stderr)
    print(f"  {len(changed)} libraries with changed source files", file=sys.stderr)
    return sorted(changed)


def scope_from_manifest(token: str, previous: str, current: str) -> list[str]:
    """Return sorted list of library tags that changed between two ROCm versions."""
    print(f"Diffing manifests {previous} → {current}...", file=sys.stderr)
    prev_manifest = fetch_manifest(previous)
    curr_manifest = fetch_manifest(current)
    added, removed, version_changed, _ = diff_manifests(prev_manifest, curr_manifest)

    changed_components = (
        set(added)
        | set(removed)
        | {c.name for c in version_changed}
    )

    # Expand monorepo entries
    for monorepo, sub_libs in MONOREPO_LIBS.items():
        if monorepo in changed_components:
            changed_components |= set(sub_libs)

    tags = sorted(
        MANIFEST_TO_TAG[name]
        for name in changed_components
        if name in MANIFEST_TO_TAG
    )
    print(f"  {len(changed_components)} components changed → {len(tags)} tracked libraries", file=sys.stderr)
    return tags


# ---------------------------------------------------------------------------
# Fetching
# ---------------------------------------------------------------------------

def fetch_library(token: str, lib: str, version: str, output_dir: Path) -> None:
    """Fetch source file and YAML entry for one library."""
    config = SOURCE_CONFIG.get(lib)
    if not config:
        print(f"  {lib}: no SOURCE_CONFIG entry — skipping", file=sys.stderr)
        return

    note = config.get("note")
    if note:
        artifact_path(output_dir, lib, "skip").write_text(note, encoding="utf-8")
        print(f"  {lib}: skipped — {note}", file=sys.stderr)
        return

    content = fetch_source_file(
        token,
        config["org"],
        config["repo"],
        config["path"],
        version,
    )

    if content is None:
        artifact_path(output_dir, lib, "skip").write_text(
            f"Source file not found: {config['path']}", encoding="utf-8"
        )
        print(f"  {lib}: source file not found", file=sys.stderr)
        return

    artifact_path(output_dir, lib, "source").write_text(content, encoding="utf-8")

    ref = _version_to_ref(version)
    gh_url = f"https://github.com/{config['org']}/{config['repo']}/blob/{ref}/{config['path']}"
    artifact_path(output_dir, lib, "url").write_text(gh_url, encoding="utf-8")

    print(f"  {lib}: source written ({len(content):,} chars)", file=sys.stderr)


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Fetch precision support source files for Claude to compare."
    )
    parser.add_argument("-t", "--token", required=True, help="GitHub personal access token")

    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--previous", help="Previous ROCm version (use with --current)")
    mode.add_argument("--version", help="ROCm version for explicit --libs mode")

    parser.add_argument("--current", help="Current ROCm version (use with --previous)")
    parser.add_argument("--libs", help="Comma-separated library tags (use with --version)")
    parser.add_argument(
        "--sha-filter",
        action="store_true",
        help="Check all tracked libraries; skip those whose source file SHA is unchanged. "
             "Use with --previous/--current. No manifest diff is performed.",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        help="Directory for generated artifacts. "
             "Defaults to a new private directory under the system temporary directory.",
    )
    args = parser.parse_args()
    output_dir = prepare_output_dir(args.output_dir)

    # Resolve version and library list
    if args.previous:
        if not args.current:
            sys.exit("--current is required when using --previous")
        current_version = args.current
        if args.sha_filter:
            libs = sha_filter_scope(
                args.token,
                args.previous,
                args.current,
                output_dir,
            )
        else:
            libs = scope_from_manifest(args.token, args.previous, args.current)
    else:
        if args.sha_filter:
            sys.exit("--sha-filter requires --previous and --current")
        if not args.libs:
            sys.exit("--libs is required when using --version")
        current_version = args.version
        libs = [lib.strip() for lib in args.libs.split(",")]

    # Fetch YAML once
    print(f"\nFetching precision-support.yaml for ROCm {current_version}...", file=sys.stderr)
    yaml_data = fetch_yaml(args.token, current_version)
    yaml_types = load_yaml_types(yaml_data)

    # Write YAML entries for all tracked libraries (not just changed ones —
    # Claude needs the full context for comparison)
    for lib, types in yaml_types.items():
        artifact_path(output_dir, lib, "yaml").write_text(
            yaml.dump({lib: types}, allow_unicode=True, default_flow_style=False),
            encoding="utf-8",
        )

    # Write manifest-scoped library list so Claude knows what to check
    libs_file = output_dir / "precision_libs.txt"
    libs_file.write_text("\n".join(libs), encoding="utf-8")
    print(f"\nLibraries to check: {', '.join(libs)}", file=sys.stderr)

    # Fetch source files
    print("\nFetching source files...", file=sys.stderr)
    for lib in libs:
        fetch_library(args.token, lib, current_version, output_dir)

    print(f"\nOutput directory: {output_dir}", file=sys.stderr)
    print(f"Library list: {libs_file}", file=sys.stderr)


if __name__ == "__main__":
    main()
