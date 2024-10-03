import os
import yaml
from graphviz import Digraph

# Set DEBUG to False for normal output, True for debug output
DEBUG = False

def debug_print(message):
    if DEBUG:
        print(message)

import os
import yaml

def extract_dependencies(exclude_nodes=[]):
    dependencies = {}
    debug_print("Extracting dependencies from YAML files...")

    # Define a mapping of specific filenames to component names
    component_name_mapping = {
        'HIP.yml': 'clr',  # Remap HIP.yml to clr in graph
    }

    script_directory = os.path.dirname(os.path.abspath(__file__))
    yaml_directory = os.path.join(script_directory, '..', 'components')

    for filename in os.listdir(yaml_directory):
        if filename.endswith(".yaml") or filename.endswith(".yml"):
            debug_print(f"Processing file: {filename}")
            try:
                with open(os.path.join(yaml_directory, filename), 'r') as file:
                    data = yaml.safe_load(file) or {}
                    parameters = data.get('parameters', [])

                    # Check for both 'rocmDependencies' and 'rocmDependenciesAMD'
                    rocm_dependencies = next((param['default'] for param in parameters if param['name'] == 'rocmDependencies' or param['name'] == 'rocmDependenciesAMD'), [])
                    test_dependencies = next((param['default'] for param in parameters if param['name'] == 'rocmTestDependencies'), [])

                    unique_dependencies = list(set(rocm_dependencies + test_dependencies))
                    unique_dependencies = [dep for dep in unique_dependencies if dep not in exclude_nodes]

                    # Use the mapped component name if it exists
                    component_name = component_name_mapping.get(filename, os.path.splitext(filename)[0])
                    dependencies[component_name] = {
                        'dependencies': unique_dependencies
                    }
                    debug_print(f"Found unique dependencies for {component_name}: {unique_dependencies}")
            except Exception as e:
                print(f"Error processing {filename}: {e}")

    return dependencies

def simplify_dependencies(graph):
    simplified_graph = {}

    for component, deps in graph.items():
        if component not in simplified_graph:
            simplified_graph[component] = set(deps)  # Use a set for uniqueness

        for dep in deps:
            if dep in graph:  # If the dependency has its own dependencies
                for sub_dep in graph[dep]:
                    simplified_graph[component].discard(sub_dep)  # Remove transitive dependencies

    # Convert sets back to lists
    for component in simplified_graph:
        simplified_graph[component] = list(simplified_graph[component])

    return simplified_graph

def build_dependency_graph(dependencies, exclude_nodes=None):
    if exclude_nodes is None:
        exclude_nodes = []

    graph = {}
    debug_print("Building dependency graph...")

    for component, deps in dependencies.items():
        if component in exclude_nodes:
            continue  # Skip excluded components

        # Ensure uniqueness and prevent self-dependency
        all_deps = [dep for dep in set(deps['dependencies']) if dep != component and dep not in exclude_nodes]
        graph[component] = all_deps
        debug_print(f"{component} -> {all_deps}")

    # Simplify the dependencies to remove transitive dependencies
    simplified_graph = simplify_dependencies(graph)

    return simplified_graph

def build_full_dependency_tree(graph):
    tree = {}
    debug_print("Building full dependency tree...")

    def dfs(component, visited):
        if component in visited:
            return
        visited.add(component)
        for dep in graph.get(component, []):
            # Prevent self-dependency in the tree
            if dep != component:
                if dep not in tree:
                    tree[dep] = []
                if component not in tree[dep]:  # Prevent duplicates
                    tree[dep].append(component)
                dfs(dep, visited)

    for component in graph.keys():
        dfs(component, set())

    return tree

def visualize_graph(graph):
    dot = Digraph()

    for component, deps in graph.items():
        for dep in deps:
            dot.edge(component, dep)

    script_directory = os.path.dirname(os.path.abspath(__file__))

    dot.render(os.path.join(script_directory, 'dependency_graph'), format='png', cleanup=True)  # Save as PNG

def main():
    exclude_deps = ['rocm-examples']
    dependencies = extract_dependencies(exclude_nodes=exclude_deps)

    if not dependencies:
        debug_print("No dependencies found.")
        return

    graph = build_dependency_graph(dependencies, exclude_nodes=exclude_deps)
    full_tree = build_full_dependency_tree(graph)

    print("Dependency tree:")
    print(full_tree)

    # Call this function after building the graph
    visualize_graph(full_tree)

if __name__ == "__main__":
    main()
