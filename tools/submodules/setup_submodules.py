
'''
This script sets up git submodules based on a manifest file. It performs the following tasks:
1. Finds the root directory of the project.
2. Parses command line arguments to get the manifest file and output folder paths.
3. Parses the manifest file to get a list of projects.
4. Gets a list of existing submodules.
5. Removes submodules that are not in the manifest file.
6. Adds new submodules from the manifest file.
7. Updates existing submodules to the specified revision.
'''

import os
import subprocess
import sys
import argparse
import pathlib
import logging

import xml.etree.ElementTree as ET

class Project:
    """
    Project class to store project information.

    Attributes:
        name (str): Name of the project.
        revision (str): Revision of the project.
        path (str): Path to the project.

    Methods:
        __str__: Returns a string representation of the project.
        __repr__: Returns a string representation of the project.
    """
    def __init__(self, **kwargs):
        '''
        Project class to store project information
        :param name: Name of the project
        :param revision: Revision of the project
        :param path: Path to the project
        '''
        self.name = kwargs.get('name')
        self.revision = kwargs.get('revision')
        self.path = kwargs.get('path')


    def __str__(self):
        return f"Project {self.name} at {self.path} with revision {self.revision}"


    def __repr__(self):
        return self.__str__()


# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
DARK_RED='\033[0;31m'
NC='\033[0m' # No Color


def find_root() -> str:
    '''
    Find the root directory of the project
    :return: Root directory of the project
    '''
    current = os.getcwd()
    while current != "/":
        if os.path.exists(os.path.join(current, ".git")):
            return current
        current = os.path.dirname(current)
    print("Could not find root directory", file=sys.stderr)
    sys.exit(1)


def run_command(command) -> list:
    '''
    Run a command in the shell
    :param command: Command to run
    :return: List of errors
    '''
    error_log = []
    print(f"Running command: {command}")
    # subprocess.run(command, shell=True, check=True)
    result = subprocess.run(command, shell=True, check=False,
                            stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    if result.returncode != 0:
        print(f"{RED}Error running command: {result.stderr.decode('utf-8')}{NC}",
              file=sys.stderr)

        logging.error("Error running command: %s", command)
        logging.error("\t%s", result.stderr.decode('utf-8'))

        error_log.append(f"Error running command: {command}")
        error_log.append(f"\t{result.stderr.decode('utf-8')}\n")
    else:
        if result.stdout:
            print(result.stdout.decode('utf-8'))

    return error_log


def parse_arguments(project_root: str) -> argparse.Namespace:
    '''
    Parse command line arguments
    :param project_root: Root directory of the project
    :return: Parsed arguments
    '''

    parser = argparse.ArgumentParser(description="Setup submodules based on a manifest file.")
    parser.add_argument("-m", "--manifest", required=False,
                        default=f'{project_root}/default.xml', help="Path to the manifest file")
    parser.add_argument("-o", "--output", required=False,
                        default='libs', help="Path to the submodule folder")
    return parser.parse_args()


def parse_manifest(manifest_path: str, output_path: str) -> list:
    '''
    Parse the manifest file and return a list of projects
    :param manifest_path: Path to the manifest file
    :param output_path: Path to the output folder
    :return: List of projects
    '''

    tree = ET.parse(manifest_path)
    root = tree.getroot()

    defaults = root.find('default')
    default_revision = None

    if defaults is not None:
        default_revision = defaults.get('revision')
        # print(f"Default revision: {default_revision}")

    projects = []
    for project in root.findall('project'):
        name = project.get('name')
        revision = project.get('revision', default_revision)
        path = os.path.join(output_path, project.get('path', name))

        projects.append(Project(name = name,
                                revision = revision,
                                path = path))

    return projects


def get_existing_submodules(project_root: str) -> list:
    '''
    Get a list of existing submodules
    :param project_root: Root directory of the project
    :return: List of existing submodules
    '''

    gitmodules_path = os.path.join(project_root, ".gitmodules")
    existing_submodules = []

    if os.path.exists(gitmodules_path):
        with open(gitmodules_path, "r", encoding="utf-8") as gitmodules_file:

            for line in gitmodules_file:
                line = line.strip()

                if line.startswith("[submodule"):
                    submodule_name = pathlib.Path(line.split('"')[1]).as_posix()
                    existing_submodules.append(submodule_name)

    return existing_submodules


def remove_submodule(project_root: str, module_path: str) -> list:
    '''
    Remove a submodule
    :param project_root: Root directory of the project
    :param module_path: Path to the submodule
    :return: List of errors
    '''
    error_log = []
    gitmodules_path = os.path.join(project_root, ".gitmodules")

    error_log.extend(run_command(f"git submodule deinit -f {module_path}"))
    error_log.extend(run_command(f"rm -rf {module_path}"))
    error_log.extend(run_command(f"rm -rf .git/modules/{module_path}"))
    # error_log.extend(run_command(f"git rm -r --cached {module_path}"))

    # # Remove the submodule from the .gitmodules file
    with open(gitmodules_path, "r", encoding="utf-8") as gitmodules_file:
        lines = gitmodules_file.readlines()

    with open(gitmodules_path, "w", encoding="utf-8") as gitmodules_file:
        skip = False
        for line in lines:
            if line.strip().startswith(f"[submodule \"{module_path}\"]"):
                skip = True
            elif skip and line.strip().startswith("[submodule"):
                skip = False

            if not skip:
                gitmodules_file.write(line)

    return error_log


def main():
    '''
    Main function
    '''

    # Set up logging
    log_file = os.path.join(os.path.expanduser("~"), "submodule_setup.log")
    logging.basicConfig(level=logging.DEBUG,
                        filename=log_file,
                        filemode='w',
                        format='%(asctime)s - %(levelname)s - %(message)s')

    # Save errors to a list to output at the end
    error_log = []

    project_root = find_root()
    os.chdir(project_root)

    print(f"Found project root at {project_root}")

    args = parse_arguments(project_root)
    print(f"Using manifest file at {args.manifest}")

    # Check if manifest file exists
    if not os.path.exists(args.manifest):
        print(f"Manifest file {args.manifest} does not exist", file=sys.stderr)
        sys.exit(1)

    # Check if output folder exists
    print(f"Using output folder at {args.output}\n")
    if not os.path.exists(args.output):
        print(f"Output folder {args.output} does not exist. Creating it.")
        os.makedirs(args.output)

    # Create a list of existing submodules
    existing_submodules = get_existing_submodules(project_root)

    for module in existing_submodules:
        logging.debug("Existing submodule %s", module)

    logging.debug("=====\n")

    # Create a list of projects from the manifest file
    projects = parse_manifest(args.manifest, args.output)

    for project in projects:
        logging.debug("Manifest Project %s to %s at %s",
                      project.name,
                      project.path,
                      project.revision)

    logging.debug("=====\n")

    print('\n*** Initializing submodules ***\n')
    run_command("git submodule update --init")

    print(f'\n{DARK_RED}*** Removing old projects ***{NC}\n')

    # If project is in existing submodules and not in manifest, remove it
    removed_modules = []

    project_paths = {project.path for project in projects}
    for module in existing_submodules:
        if module not in project_paths:
            print(f"{DARK_RED}Removing submodule {module}{NC}")
            logging.info("Removing submodule %s", module)

            removed_modules.append(module)
            error_log.extend(remove_submodule(project_root, module))

            print()

    # Remove the submodules from the list of existing submodules
    existing_submodules = [module for module in existing_submodules
                           if module not in removed_modules]

    print(f'\n{GREEN}*** Adding new projects ***{NC}\n')

    # Add new submodules
    for project in projects:
        if project.path not in existing_submodules:
            print(f"{GREEN}Adding submodule ../{project.name}{NC}")
            logging.info("Adding submodule ../%s to %s", project.name, project.path)

            error_log.extend(
                run_command(f"git submodule add ../{project.name} {project.path}"))
            error_log.extend(
                run_command(f"cd {project.path} "
                            f"&& git checkout {project.revision} "
                            f"&& cd {project_root}"))
            print()

    print(f'\n{BLUE}*** Updating existing projects ***{NC}\n')

    # Update existing submodules
    for project in projects:
        if project.path in existing_submodules and project.path not in removed_modules:

            print(f"{BLUE}Updating submodule {project.path}{NC}")
            logging.info("Updating submodule %s", project.path)

            error_log.extend(
                run_command(f"cd {project.path} && "
                            "git fetch --tag && "
                            f"git checkout {project.revision} "
                            f"&& cd {project_root}"))
            print()

    # Print errors at the end
    if error_log:
        print(f"\n{RED}Errors occurred. Please check the logs: {log_file}{NC}\n"
              "Error Summary:\n",
              file=sys.stderr)
        logging.error("Errors occurred. Please check the logs: %s", log_file)
        logging.error("Error Summary:")

        for error in error_log:
            print(error, file=sys.stderr)
            logging.error(error)
    else:
        print(f"{GREEN}All submodules updated successfully{NC}")


if __name__ == "__main__":
    main()
