#!/usr/bin/env python3
"""Unit tests for precision_fetch output handling."""

import contextlib
import io
import os
import stat
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parent))

import precision_fetch


class OutputDirectoryTests(unittest.TestCase):
    def test_default_output_directories_are_private_and_unique(self) -> None:
        real_mkdtemp = tempfile.mkdtemp
        with tempfile.TemporaryDirectory() as parent:
            with mock.patch.object(
                precision_fetch.tempfile,
                "mkdtemp",
                side_effect=lambda prefix: real_mkdtemp(prefix=prefix, dir=parent),
            ):
                first = precision_fetch.prepare_output_dir(None)
                second = precision_fetch.prepare_output_dir(None)

            self.assertNotEqual(first, second)
            self.assertTrue(first.name.startswith("rocm-precision-"))
            self.assertEqual(stat.S_IMODE(first.stat().st_mode), 0o700)
            self.assertEqual(stat.S_IMODE(second.stat().st_mode), 0o700)

    def test_requested_output_directory_is_created(self) -> None:
        with tempfile.TemporaryDirectory() as parent:
            requested = Path(parent) / "nested" / "artifacts"
            result = precision_fetch.prepare_output_dir(requested)

            self.assertEqual(result, requested.resolve())
            self.assertTrue(result.is_dir())

    def test_artifact_path_rejects_unsafe_components(self) -> None:
        output_dir = Path("/tmp/example")

        with self.assertRaises(ValueError):
            precision_fetch.artifact_path(output_dir, "../../escape", "source")
        with self.assertRaises(ValueError):
            precision_fetch.artifact_path(output_dir, "hipblas", "../source")


class ArtifactWritingTests(unittest.TestCase):
    def test_sha_filter_writes_skip_file_to_output_directory(self) -> None:
        config = {
            "hipblas": {
                "org": "ROCm",
                "repo": "rocm-libraries",
                "path": "precision.rst",
            }
        }
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            with (
                mock.patch.dict(precision_fetch.SOURCE_CONFIG, config, clear=True),
                mock.patch.object(
                    precision_fetch,
                    "fetch_file_sha",
                    side_effect=["same-sha", "same-sha"],
                ),
            ):
                changed = precision_fetch.sha_filter_scope(
                    "token",
                    "7.1.1",
                    "7.2.0",
                    output_dir,
                )

            self.assertEqual(changed, [])
            skip_file = output_dir / "precision_hipblas_skip.txt"
            self.assertIn("unchanged", skip_file.read_text(encoding="utf-8"))

    def test_fetch_library_writes_source_and_url_to_output_directory(self) -> None:
        config = {
            "testlib": {
                "org": "ROCm",
                "repo": "example",
                "path": "docs/precision.rst",
            }
        }
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory)
            with (
                mock.patch.dict(precision_fetch.SOURCE_CONFIG, config, clear=True),
                mock.patch.object(
                    precision_fetch,
                    "fetch_source_file",
                    return_value="source content",
                ),
            ):
                precision_fetch.fetch_library(
                    "token",
                    "testlib",
                    "7.2.0",
                    output_dir,
                )

            self.assertEqual(
                (output_dir / "precision_testlib_source.txt").read_text(
                    encoding="utf-8"
                ),
                "source content",
            )
            self.assertIn(
                "release/rocm-rel-7.2/docs/precision.rst",
                (output_dir / "precision_testlib_url.txt").read_text(encoding="utf-8"),
            )

    def test_main_writes_all_artifacts_to_requested_directory(self) -> None:
        yaml_data = {
            "library_groups": [
                {
                    "libraries": [
                        {
                            "tag": "hipblas",
                            "data_types": [{"type": "float32", "support": "supported"}],
                        }
                    ]
                }
            ]
        }
        with tempfile.TemporaryDirectory() as directory:
            output_dir = Path(directory) / "artifacts"
            argv = [
                "precision_fetch.py",
                "--token",
                "test-token",
                "--version",
                "7.2.0",
                "--libs",
                "hipblas",
                "--output-dir",
                os.fspath(output_dir),
            ]
            stderr = io.StringIO()
            with (
                mock.patch.object(sys, "argv", argv),
                mock.patch.object(
                    precision_fetch, "fetch_yaml", return_value=yaml_data
                ),
                mock.patch.object(
                    precision_fetch,
                    "fetch_source_file",
                    return_value="source content",
                ),
                contextlib.redirect_stderr(stderr),
            ):
                precision_fetch.main()

            self.assertEqual(
                sorted(path.name for path in output_dir.iterdir()),
                [
                    "precision_hipblas_source.txt",
                    "precision_hipblas_url.txt",
                    "precision_hipblas_yaml.txt",
                    "precision_libs.txt",
                ],
            )
            self.assertEqual(
                (output_dir / "precision_libs.txt").read_text(encoding="utf-8"),
                "hipblas",
            )
            self.assertIn(
                f"Output directory: {output_dir.resolve()}",
                stderr.getvalue(),
            )
            self.assertNotIn("test-token", stderr.getvalue())


if __name__ == "__main__":
    unittest.main()
