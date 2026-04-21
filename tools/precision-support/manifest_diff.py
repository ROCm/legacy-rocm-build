#!/usr/bin/env python3
"""Compare two ROCm default.xml manifests to detect component additions,
removals, and version changes between releases or RCs.

Usage:
    python3 manifest_diff.py previous.xml current.xml
    python3 manifest_diff.py 7.1.1 7.2.0          # fetch from GitHub by tag
    python3 manifest_diff.py 7.2.0 7.2.1           # e.g. RC comparison

The script accepts either local file paths or ROCm version strings.
When given version strings, it fetches default.xml from the ROCm/ROCm
GitHub repo at the corresponding tag (rocm-X.Y.Z).

Output:
    A report of added, removed, and version-changed components, plus
    a summary count.
"""

import argparse
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from urllib.request import urlopen, Request
from urllib.error import URLError


_GITHUB_RAW = (
    "https://raw.githubusercontent.com/ROCm/ROCm/release/rocm-rel-{branch}/default.xml"
)


# ---------------------------------------------------------------------------
# Manifest parsing
# ---------------------------------------------------------------------------

@dataclass
class Project:
    name: str
    revision: str   # effective revision (project-level override or default)
    path: str       # repo checkout path (may differ from name)
    groups: str     # groups attribute if present


def _extract_version(revision: str) -> str:
    """Extract a human-readable version from a revision string.

    refs/tags/rocm-7.2.0  →  7.2.0
    refs/tags/v1.2.3      →  v1.2.3
    refs/heads/develop    →  develop (branch)
    abc1234               →  abc1234 (commit SHA)
    """
    # Named ROCm release tag
    m = re.search(r"refs/tags/rocm-(.+)", revision)
    if m:
        return m.group(1)
    # Generic tag
    m = re.search(r"refs/tags/(.+)", revision)
    if m:
        return m.group(1)
    # Branch
    m = re.search(r"refs/heads/(.+)", revision)
    if m:
        return f"[branch: {m.group(1)}]"
    # Bare SHA or anything else
    return revision


def parse_manifest(path_or_content: str, from_string: bool = False) -> dict[str, Project]:
    """Parse a manifest XML file (or string) and return {name: Project}."""
    if from_string:
        root = ET.fromstring(path_or_content)
    else:
        root = ET.parse(path_or_content).getroot()

    default_el = root.find("default")
    default_revision = default_el.get("revision", "") if default_el is not None else ""

    projects: dict[str, Project] = {}
    for el in root.iterfind("project"):
        name = el.get("name", "")
        if not name:
            continue
        revision = el.get("revision") or default_revision
        path = el.get("path", name)
        groups = el.get("groups", "")
        projects[name] = Project(name=name, revision=revision, path=path, groups=groups)

    return projects


# ---------------------------------------------------------------------------
# Fetching from GitHub
# ---------------------------------------------------------------------------

def _looks_like_version(s: str) -> bool:
    return bool(re.match(r"^\d+\.\d+", s))


_GITHUB_RAW_TAG = (
    "https://raw.githubusercontent.com/ROCm/ROCm/refs/tags/rocm-{version}/default.xml"
)


def fetch_manifest(source: str) -> dict[str, Project]:
    """Load a manifest from a local file path or a ROCm version string.

    When given a version string, tries the release branch first (release/rocm-rel-X.Y),
    then falls back to the release tag (rocm-X.Y.Z) for older releases.
    """
    if _looks_like_version(source):
        branch = ".".join(source.split(".")[:2])
        branch_url = _GITHUB_RAW.format(branch=branch)
        tag_url = _GITHUB_RAW_TAG.format(version=source)
        for url in (branch_url, tag_url):
            print(f"  Fetching {url}", file=sys.stderr)
            try:
                req = Request(url, headers={"User-Agent": "rocm-manifest-diff/1.0"})
                with urlopen(req, timeout=30) as resp:
                    return parse_manifest(resp.read().decode(), from_string=True)
            except URLError as e:
                if hasattr(e, "code") and e.code == 404:
                    continue
                raise SystemExit(f"Cannot fetch manifest for ROCm {source}:\n  {e}")
        raise SystemExit(f"Cannot fetch manifest for ROCm {source}: not found at branch or tag.")
    else:
        return parse_manifest(source)


# ---------------------------------------------------------------------------
# Diff logic
# ---------------------------------------------------------------------------

@dataclass
class Change:
    name: str
    prev_version: str = ""
    curr_version: str = ""


def diff_manifests(
    prev: dict[str, Project],
    curr: dict[str, Project],
) -> tuple[list[str], list[str], list[Change], list[str]]:
    """Return (added, removed, version_changed, unchanged) component lists."""
    prev_names = set(prev)
    curr_names = set(curr)

    added   = sorted(curr_names - prev_names)
    removed = sorted(prev_names - curr_names)

    version_changed: list[Change] = []
    unchanged: list[str] = []

    for name in sorted(prev_names & curr_names):
        pv = _extract_version(prev[name].revision)
        cv = _extract_version(curr[name].revision)
        if pv != cv:
            version_changed.append(Change(name, pv, cv))
        else:
            unchanged.append(name)

    return added, removed, version_changed, unchanged


# ---------------------------------------------------------------------------
# Report
# ---------------------------------------------------------------------------

def print_report(
    prev_label: str,
    curr_label: str,
    added: list[str],
    removed: list[str],
    version_changed: list[Change],
    unchanged: list[str],
    show_unchanged: bool = False,
) -> None:
    print(f"\nManifest diff:  {prev_label}  →  {curr_label}\n")

    if added:
        print(f"ADDED ({len(added)}):")
        for name in added:
            print(f"  + {name}")
        print()

    if removed:
        print(f"REMOVED ({len(removed)}):")
        for name in removed:
            print(f"  - {name}")
        print(
            "  Note: removals may reflect migration into rocm-libraries or\n"
            "  rocm-systems rather than a component drop. Verify before\n"
            "  updating release notes."
        )
        print()

    if version_changed:
        col = max(len(c.name) for c in version_changed)
        print(f"VERSION CHANGED ({len(version_changed)}):")
        for c in version_changed:
            print(f"  {c.name:<{col}}  {c.prev_version}  →  {c.curr_version}")
        print()

    if show_unchanged and unchanged:
        print(f"UNCHANGED ({len(unchanged)}):")
        for name in unchanged:
            print(f"  {name}")
        print()

    total = len(added) + len(removed) + len(version_changed) + len(unchanged)
    print(
        f"Summary: {len(added)} added, {len(removed)} removed, "
        f"{len(version_changed)} version changed, {len(unchanged)} unchanged  "
        f"({total} total)"
    )

    if not added and not removed and not version_changed:
        print("\nNo component changes detected.")


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

def main() -> None:
    parser = argparse.ArgumentParser(
        description="Diff two ROCm manifest files to detect component changes."
    )
    parser.add_argument(
        "previous",
        help="Previous manifest — local file path or ROCm version (e.g. 7.1.1)",
    )
    parser.add_argument(
        "current",
        help="Current manifest — local file path or ROCm version (e.g. 7.2.0)",
    )
    parser.add_argument(
        "--unchanged", action="store_true",
        help="Also list components with no version change",
    )
    args = parser.parse_args()

    prev = fetch_manifest(args.previous)
    curr = fetch_manifest(args.current)

    added, removed, version_changed, unchanged = diff_manifests(prev, curr)

    print_report(
        prev_label=args.previous,
        curr_label=args.current,
        added=added,
        removed=removed,
        version_changed=version_changed,
        unchanged=unchanged,
        show_unchanged=args.unchanged,
    )


if __name__ == "__main__":
    main()
