#!/usr/bin/env python3

import json
import requests
import argparse
from pathlib import Path

def get_builds(entries, gpu_target, output):
    already_downloaded = {}
    for entry in entries:
        already_downloaded = _get_builds(entry, gpu_target, already_downloaded, output)

def _get_builds(entry, gpu_target, already_downloaded, output):
    print()
    print(f"{entry['buildNumber']} - {entry['buildId']} - {entry['repoName']}")
    if already_downloaded.get(entry['buildId']):
        print('Skipping, already downloaded from build ' + entry['buildId'])
        return already_downloaded

    artifacts_url = f"https://dev.azure.com/ROCm-CI/ROCm-CI/_apis/build/builds/{entry['buildId']}/artifacts?api-version=7.1"
    artifacts = requests.get(artifacts_url).json()
    for artifact in artifacts['value']:
        if 'gfx' in artifact['name'] and gpu_target not in artifact['name']:
            continue

        print('Artifact name: ' + artifact['name'])
        print('File size: ~' +
              str(round(int(artifact['resource']['properties']['artifactsize'])/1000000, 2)) + ' MB')
        download_url = f"{artifact['resource']['downloadUrl']}"
        download = requests.get(download_url)

        zip_file = Path(output) / f"{artifact['name']}.zip"
        with open(zip_file, 'wb') as f:
            f.write(download.content)
        already_downloaded[entry['buildId']] = True

    return already_downloaded

def main():
    parser = argparse.ArgumentParser(description="Command line tool for downloading external ci artifacts")
    parser.add_argument('--target', type=str, dest="target", choices=["gfx90a", "gfx942"], help="Target gfx")
    parser.add_argument('--manifest', type=str, dest="manifest", help='JSON manifest url or path to local manifest')
    parser.add_argument('--output_dir', type=str, dest="output", help='Path to download directory')
    args = parser.parse_args()

    manifest = args.manifest
    gpu_target = args.target

    if not gpu_target:
        print("Enter the GPU target (gfx942, gfx90a)")
        gpu_target = input()

    if not manifest:
        print("Enter the manifest file (URL or local path)")
        manifest = input()

    if 'http' in manifest:
        data = requests.get(manifest).json()
    else:
        with open(manifest, 'r') as f:
            data = json.load(f)

    entries = [e for e in data['current']]
    entries.extend([e for e in data['dependencies']])
    get_builds(entries, gpu_target, args.output)

if __name__ == "__main__":
    main()
