import json
import requests


print("Enter the GPU target (gfx942, gfx90a)")
gpu_target = input()

print("Enter the manifest file (URL or local path)")
manifest = input()
if 'http' in manifest:
    data = requests.get(manifest).json()
else:
    with open(manifest, 'r') as f:
        data = json.load(f)

already_downloaded = {}


def get_builds(entry):
    print()
    print(f"{entry['buildNumber']} - {entry['buildId']} - {entry['repoName']}")

    if already_downloaded.get(entry['buildId']):
        print('Skipping, already downloaded from build ' + entry['buildId'])
        return

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
        with open(f"{artifact['name']}.zip", 'wb') as f:
            f.write(download.content)
        already_downloaded[entry['buildId']] = True


for entry in data['current']:
    get_builds(entry)
for entry in data['dependencies']:
    get_builds(entry)
