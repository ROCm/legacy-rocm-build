from docutils import nodes
from docutils.parsers.rst import Directive
from docutils.statemachine import ViewList
from sphinx.util import logging
from sphinx.util.nodes import nested_parse_with_titles
import requests
import re
import os
from pathlib import Path
from urllib.parse import urljoin

logger = logging.getLogger(__name__)

class BranchAwareRemoteContent(Directive):
    """
    Directive that downloads and includes content from other repositories,
    matching the branch/tag of the current documentation build.

    Usage:
    .. remote-content::
       :repo: owner/repository
       :path: path/to/file.rst
       :default_branch: docs/develop  # Branch to use when not on a release
       :tag_prefix: Docs/  # Optional
       :replace: old_text1|new_text1;; old_text2|new_text2;; old_text3|new_text3
       :project_name: ProjectName  # Optional override for URL construction
       :docs_base_url: https://rocm.docs.amd.com/projects  # Optional override
       :doc_ignore: path/to/ignore;; another/path  # Doc links to leave unconverted
       :doc_remap: remote/path|local/path;; remote/path2|New Text|local/path2

    The :replace: option uses | to separate old and new text, and ;; to separate multiple replacements.
    The :doc_ignore: option uses ;; to separate multiple paths to ignore.
    The :doc_remap: option remaps :doc: links to local paths instead of converting them to external URLs.
        Format: "old_path|new_path" (keeps original display text) or
                "old_path|new_display_text|new_path" (replaces display text)
        Use ;; to separate multiple remappings.
        
        Examples:
        - :doc_remap: install/guide|how-to/getting_started
          Remaps `:doc:`install/guide`` to `:doc:`how-to/getting_started``
          Remaps `:doc:`Install <install/guide>`` to `:doc:`Install <how-to/getting_started>``
        
        - :doc_remap: install/guide|Getting Started|how-to/getting_started
          Remaps `:doc:`install/guide`` to `:doc:`Getting Started <how-to/getting_started>``
          Remaps `:doc:`Install <install/guide>`` to `:doc:`Getting Started <how-to/getting_started>``
    """

    required_arguments = 0
    optional_arguments = 0
    final_argument_whitespace = True
    has_content = False
    option_spec = {
        'repo': str,
        'path': str,
        'default_branch': str,  # Branch to use when not on a release tag
        'start_line': int,      # Include the file from a specific line
        'tag_prefix': str,      # Prefix for release tags (e.g., 'Docs/')
        'replace': str,         # Text replacement in format "old|new" (use ;; to separate multiple replacements)
        'project_name': str,    # Override project name for URL construction
        'docs_base_url': str,   # Override base URL for documentation
        'doc_ignore': str,      # Doc links to ignore (not convert to external URLs), separated by ;;
        'doc_remap': str,       # Remap doc links to local paths (format: "old_path|new_path" or "old_path|new_text|new_path"), separated by ;;
        'csv_widths': str,      # Add widths to CSV tables (e.g., "33 67")
        'fix_latex_math': str,  # Enable automatic LaTeX math fixes (true/false)
    }

    def get_current_version(self):
        """Get current version/branch being built"""
        env = self.state.document.settings.env
        html_context = env.config.html_context

        # Check if building from a tag
        if "official_branch" in html_context:
            if html_context["official_branch"] == 0:
                if "version" in html_context:
                    # Remove any 'v' prefix
                    version = html_context["version"]
                    if re.match(r'^\d+\.\d+\.\d+$', version):
                        return version

        # Not a version tag, so we'll use the default branch
        return None

    def get_target_ref(self):
        """Get target reference for the remote repository"""
        current_version = self.get_current_version()

        # If it's a version number, use tag prefix and version
        if current_version:
            tag_prefix = self.options.get('tag_prefix', '')
            return f'{tag_prefix}{current_version}'

        # For any other case, use the specified default branch
        if 'default_branch' not in self.options:
            logger.warning('No default_branch specified and not building from a version tag')
            return None

        return self.options['default_branch']

    def get_project_name(self):
        """Extract project name from repo option or use override"""
        # Check if there's an explicit override
        if 'project_name' in self.options:
            return self.options['project_name']

        # Parse from repo: "ROCm/HIP" -> "HIP"
        repo = self.options.get('repo', '')
        if '/' in repo:
            return repo.split('/')[-1]

        return repo

    def get_ignored_doc_paths(self):
        """Get list of doc paths that should not be converted"""
        if 'doc_ignore' not in self.options:
            return []

        # Split by ;; to get multiple paths
        ignored_paths = self.options['doc_ignore'].split(';;')

        # Strip whitespace and filter empty entries
        return [path.strip() for path in ignored_paths if path.strip()]

    def get_doc_remaps(self):
        """Get list of doc path remappings
        
        Returns a list of tuples: (old_path, new_display_text_or_None, new_path)
        Format: "old_path|new_path" or "old_path|new_display_text|new_path"
        """
        if 'doc_remap' not in self.options:
            return []

        # Split by ;; to get multiple remappings
        remap_specs = self.options['doc_remap'].split(';;')
        
        remaps = []
        for remap_spec in remap_specs:
            remap_spec = remap_spec.strip()
            
            # Skip empty entries
            if not remap_spec:
                continue
            
            # Split by pipe character
            if '|' not in remap_spec:
                logger.warning(f'doc_remap option must be in format "old_path|new_path" or "old_path|new_text|new_path", got: "{remap_spec}"')
                continue
            
            parts = remap_spec.split('|')
            
            if len(parts) == 2:
                # Format: old_path|new_path (keep original display text)
                old_path = parts[0].strip()
                new_path = parts[1].strip()
                remaps.append((old_path, None, new_path))
                logger.debug(f'Added doc remap: {old_path} -> {new_path}')
            elif len(parts) == 3:
                # Format: old_path|new_display_text|new_path
                old_path = parts[0].strip()
                new_display_text = parts[1].strip()
                new_path = parts[2].strip()
                remaps.append((old_path, new_display_text, new_path))
                logger.debug(f'Added doc remap: {old_path} -> {new_display_text} <{new_path}>')
            else:
                logger.warning(f'doc_remap option has too many parts (expected 2 or 3, got {len(parts)}): "{remap_spec}"')
        
        return remaps

    def get_docs_base_url(self):
        """Get the base URL for documentation"""
        # Check for explicit override in directive
        if 'docs_base_url' in self.options:
            return self.options['docs_base_url']

        # Check for global config
        env = self.state.document.settings.env
        if hasattr(env.config, 'remote_content_docs_base'):
            return env.config.remote_content_docs_base

        # Default to ROCm docs
        return 'https://rocm.docs.amd.com/projects'

    def construct_raw_url(self, repo, path, ref):
        """Construct the raw.githubusercontent.com URL"""
        return f'https://raw.githubusercontent.com/{repo}/{ref}/{path}'

    def construct_doc_url(self, doc_path, ref):
        """Construct external documentation URL for a :doc: reference"""
        base_url = self.get_docs_base_url()
        project_name = self.get_project_name()

        # Clean up the doc_path: remove .rst extension if present
        if doc_path.endswith('.rst'):
            doc_path = doc_path[:-4]

        # Remove leading slash to avoid double slashes in URL
        doc_path = doc_path.lstrip('/')

        # Special case: main ROCm docs don't use /projects/ structure
        if self.options.get('repo') == 'ROCm/ROCm':
            url = f'https://rocm.docs.amd.com/en/{ref}/{doc_path}.html'
        else:
            # Standard project pattern: domain/projects/name/en/ref/path
            url = f'{base_url}/{project_name}/en/{ref}/{doc_path}.html'

        return url

    def resolve_relative_doc_path(self, doc_path, source_file_path):
        """Resolve relative document paths based on source file location"""
        # If it's not a relative path, return as-is
        if not doc_path.startswith('./') and not doc_path.startswith('../'):
            return doc_path

        # Get the directory of the source file
        source_dir = Path(source_file_path).parent

        # Resolve the relative path
        resolved_path = (source_dir / doc_path).as_posix()

        # Normalize (remove . and ..)
        resolved_path = str(Path(resolved_path))

        return resolved_path

    def process_doc_roles(self, content, ref):
        """Process :doc: roles and convert them to external links or remap to local paths"""
        # Get list of paths to ignore
        ignored_paths = self.get_ignored_doc_paths()
        
        # Get list of path remappings
        doc_remaps = self.get_doc_remaps()

        # Pattern to match :doc: roles
        # Matches both :doc:`target` and :doc:`text <target>`
        # But NOT namespaced references like :doc:`project:target`
        doc_pattern = r':doc:`([^`]+)`'

        def replace_doc_role(match):
            full_content = match.group(1)

            # First, parse the display text and target
            # Check if it's the format "text <target>" or just "target"
            if '<' in full_content and '>' in full_content:
                # Extract text and target
                text_match = re.match(r'(.+?)\s*<(.+?)>', full_content)
                if text_match:
                    display_text = text_match.group(1).strip()
                    target = text_match.group(2).strip()
                else:
                    # Fallback if regex doesn't match
                    display_text = full_content
                    target = full_content
            else:
                # Just a target, use it as display text too
                target = full_content.strip()
                display_text = target

            # Check if this is a namespaced reference (e.g., "project:path")
            is_namespaced = ':' in target

            # Check if this target should be ignored
            if target in ignored_paths:
                logger.info(f'Ignoring doc link as requested: {target}')
                return match.group(0)

            # Also check if the target matches after stripping leading slash
            target_stripped = target.lstrip('/')
            if target_stripped in ignored_paths:
                logger.info(f'Ignoring doc link as requested: {target}')
                return match.group(0)

            # Check if this target should be remapped to a local path
            for old_path, new_display_text, new_path in doc_remaps:
                # Check both with and without leading slash
                if target == old_path or target_stripped == old_path:
                    # Determine the display text for the remapped link
                    if new_display_text is not None:
                        # Use the specified new display text
                        final_display_text = new_display_text
                    else:
                        # Keep the original display text
                        final_display_text = display_text
                    
                    # Return as a local :doc: role
                    if final_display_text == new_path:
                        # If display text matches path, use simple format
                        result = f':doc:`{new_path}`'
                    else:
                        # Use explicit display text format
                        result = f':doc:`{final_display_text} <{new_path}>`'
                    
                    logger.info(f'Remapped :doc:`{full_content}` to {result}')
                    return result

            # If it's a namespaced reference and we got here (no ignore/remap match),
            # leave it unchanged for intersphinx to handle
            if is_namespaced:
                logger.debug(f'Skipping namespaced doc reference (no remap match): {full_content}')
                return match.group(0)

            # Resolve relative paths for external link construction
            resolved_target = self.resolve_relative_doc_path(target, self.options['path'])

            # Construct the external URL
            url = self.construct_doc_url(resolved_target, ref)

            # Return as a standard RST external link
            result = f'`{display_text} <{url}>`__'
            logger.info(f'Converted :doc:`{full_content}` to external link: {url}')

            return result

        # Replace all :doc: roles
        processed_content = re.sub(doc_pattern, replace_doc_role, content)

        return processed_content

    def process_csv_tables(self, content):
        """Add widths to CSV tables if csv_widths option is specified"""
        if 'csv_widths' not in self.options:
            return content
        
        csv_widths = self.options['csv_widths'].strip()
        if not csv_widths:
            return content
        
        # Pattern to match CSV table directives with their options
        # This correctly handles RST indentation rules
        csv_pattern = re.compile(
            r'^(\s*)\.\. csv-table::.*?\n'  # Match the directive line with optional indentation
            r'((?:\s+:[^:]+:.*\n)*)',       # Match options (indented, but not relative to directive)
            re.MULTILINE
        )
        
        def add_widths_to_csv(match):
            indent = match.group(1)
            existing_options = match.group(2)
            
            # Check if :widths: already exists in the options
            if ':widths:' in existing_options:
                return match.group(0)
            
            # Find the :header: line to get its indentation
            header_pattern = re.compile(r'^(\s+):header:.*\n', re.MULTILINE)
            header_match = header_pattern.search(existing_options)
            
            if header_match:
                # Use the same indentation as the header line
                option_indent = header_match.group(1)
                widths_line = f'{option_indent}:widths: {csv_widths}\n'
                
                # Insert the widths line after the header
                modified_options = existing_options[:header_match.end()] + widths_line + existing_options[header_match.end():]
                result = f'{indent}.. csv-table::\n{modified_options}'
                
                logger.info(f'Added :widths: {csv_widths} to CSV table')
                return result
            elif existing_options:
                # If there are other options but no header, add widths at the beginning
                # Get indentation from the first option
                first_option_match = re.match(r'^(\s+):', existing_options)
                if first_option_match:
                    option_indent = first_option_match.group(1)
                    widths_line = f'{option_indent}:widths: {csv_widths}\n'
                    result = f'{indent}.. csv-table::\n{widths_line}{existing_options}'
                    logger.info(f'Added :widths: {csv_widths} to CSV table')
                    return result
            else:
                # No existing options, add widths as the first option
                # Standard RST indentation is 3 spaces for options
                option_indent = '   '
                widths_line = f'{option_indent}:widths: {csv_widths}\n'
                result = f'{indent}.. csv-table::\n{widths_line}'
                logger.info(f'Added :widths: {csv_widths} to CSV table')
                return result
            
            return match.group(0)
        
        # Apply the transformation to all CSV tables
        modified_content = csv_pattern.sub(add_widths_to_csv, content)
        
        return modified_content

    def process_latex_math(self, content):
        """Fix common LaTeX math issues in content"""
        # Check if latex math fixing is enabled
        if 'fix_latex_math' not in self.options:
            return content
        
        fix_latex = self.options.get('fix_latex_math', '').strip().lower()
        if fix_latex not in ('true', '1', 'yes'):
            return content
        
        def escape_underscores_in_text(match):
            """Escape underscores within a \text{} command"""
            text_content = match.group(1)
            # Only escape underscores that are not already escaped
            escaped_content = re.sub(r'(?<!\\)_', r'\\_', text_content)
            if escaped_content != text_content:
                logger.info(f'Fixed underscores in \\text{{{text_content}}} -> \\text{{{escaped_content}}}')
            return f'\\text{{{escaped_content}}}'
        
        # Find all \text{} commands and fix underscores within them
        # This pattern handles nested braces by matching balanced braces
        # We use a simpler approach that works for most cases
        text_pattern = r'\\text\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
        
        # Process the content
        modified_content = re.sub(text_pattern, escape_underscores_in_text, content)
        
        if modified_content != content:
            logger.info('Applied LaTeX math fixes')
        
        return modified_content

    def apply_replacements(self, content):
        """Apply text replacements to content"""
        if 'replace' not in self.options:
            return content

        # Get replacement specification
        replace_option = self.options['replace']

        # Split by ;; to get multiple replacements
        replace_specs = replace_option.split(';;')

        # Apply each replacement
        for replace_spec in replace_specs:
            replace_spec = replace_spec.strip()

            # Skip empty entries
            if not replace_spec:
                continue

            # Split by pipe character to get old and new text
            if '|' not in replace_spec:
                logger.warning(f'Replace option must be in format "old_text|new_text", got: "{replace_spec}"')
                continue

            parts = replace_spec.split('|', 1)  # Split only on first pipe
            old_text = parts[0]
            new_text = parts[1]

            # Perform replacement
            modified_content = content.replace(old_text, new_text)

            if modified_content != content:
                logger.info(f'Replaced "{old_text}" with "{new_text}"')
                content = modified_content

        return content

    def get_image_cache_dir(self):
        """Get or create the directory for cached remote images"""
        env = self.state.document.settings.env
        # Store images in docs/_remote_images/ directory
        cache_dir = Path(env.srcdir) / '_remote_images' / self.options['repo'].replace('/', '_')
        cache_dir.mkdir(parents=True, exist_ok=True)
        return cache_dir

    def download_image(self, image_path, ref):
        """Download an image from the remote repository"""
        # The image_path has already been resolved relative to the source file
        # which already includes the necessary repository structure
        # So we can use it directly
        
        # Construct the raw URL for the image
        image_url = self.construct_raw_url(
            self.options['repo'],
            image_path,
            ref
        )

        try:
            logger.info(f'Downloading image from {image_url}')
            response = requests.get(image_url, timeout=30)
            response.raise_for_status()

            # Create cache directory and save the image
            cache_dir = self.get_image_cache_dir()
            
            # Get just the relative path part for saving
            # Remove any 'docs/' prefix as we handle that separately
            save_path = Path(image_path)
            if save_path.parts and save_path.parts[0] == 'docs':
                save_path = Path(*save_path.parts[1:])
            
            local_image_path = cache_dir / save_path
            local_image_path.parent.mkdir(parents=True, exist_ok=True)

            # Write the image content
            local_image_path.write_bytes(response.content)
            logger.info(f'Saved image to {local_image_path}')

            return local_image_path

        except requests.exceptions.RequestException as e:
            logger.warning(f'Failed to download image from {image_url}: {str(e)}')
            return None

    def process_image_nodes(self, node, ref):
        """Process image nodes in the parsed content and download images"""
        from docutils import nodes
        
        # Find all image and figure nodes
        for img_node in node.traverse(nodes.image):
            original_uri = img_node.get('uri', '')
            
            # Skip if it's already an absolute URL
            if original_uri.startswith(('http://', 'https://', '/')):
                continue
            
            # Get the full path of the source file (includes any repo structure)
            source_path = Path(self.options['path'])
            source_dir = source_path.parent
            repo = self.options.get('repo', '')
            
            # Resolve the image path relative to the source file
            if source_dir.as_posix() and source_dir.as_posix() != '.':
                # Build the full path by joining source dir with image path
                # First convert to POSIX path for consistency
                joined_path = (source_dir / original_uri).as_posix()
                
                # Use os.path.normpath to resolve .. components
                image_path = os.path.normpath(joined_path)
                # Convert backslashes to forward slashes for consistency
                image_path = image_path.replace('\\', '/')
                
                # Check repository-specific path adjustments
                # After normpath, we need to check if the path is correct for the repository structure
                
                if repo == 'ROCm/rocm-systems':
                    # For rocm-systems, docs are under projects/hip/docs/
                    # Check various patterns for the normalized path
                    if image_path.startswith('projects/hip/') and not image_path.startswith('projects/hip/docs/'):
                        # The path likely normalized from projects/hip/docs/../../data to projects/hip/data
                        # We need to add docs/ back
                        rest_of_path = image_path[len('projects/hip/'):]
                        image_path = f'projects/hip/docs/{rest_of_path}'
                    elif image_path.startswith('projects/') and not image_path.startswith('projects/hip/'):
                        # Path is projects/data/... instead of projects/hip/docs/data/...
                        # Remove 'projects/' prefix and add full path
                        rest_of_path = image_path[len('projects/'):]
                        image_path = f'projects/hip/docs/{rest_of_path}'
                    elif image_path.startswith('../'):
                        # Path goes outside repo structure with ../
                        # Strip the ../ and add to the correct base path
                        rest_of_path = image_path[3:]  # Remove '../'
                        image_path = f'projects/hip/docs/{rest_of_path}'
                    elif not image_path.startswith('projects/'):
                        # Path completely outside expected structure, prepend full path
                        image_path = f'projects/hip/docs/{image_path}'
                        
                elif repo in ['ROCm/ROCm', 'ROCm/rccl']:
                    # For ROCm and rccl, docs are under docs/
                    if image_path.startswith('../'):
                        # Path goes outside repo structure with ../
                        # Strip the ../ and add to the correct base path
                        rest_of_path = image_path[3:]  # Remove '../'
                        image_path = f'docs/{rest_of_path}'
                    elif not image_path.startswith('docs/'):
                        # Path normalized outside docs/, add it back
                        image_path = f'docs/{image_path}'
            else:
                # If no source directory, use original URI
                image_path = original_uri
                
                # Still need to check repository requirements for paths without source dir
                if repo == 'ROCm/rocm-systems' and not image_path.startswith('projects/'):
                    image_path = f'projects/hip/docs/{image_path}'
                elif repo in ['ROCm/ROCm', 'ROCm/rccl'] and not image_path.startswith('docs/'):
                    image_path = f'docs/{image_path}'
            
            # Final normalization to remove any remaining ../ components
            # This is crucial to prevent ../  in the middle of the final path
            image_path = os.path.normpath(image_path).replace('\\', '/')
            
            # Ensure we don't have leading slashes
            image_path = image_path.lstrip('/')
            
            logger.info(f'Processing image: {original_uri} -> {image_path}')
            
            # Download the image
            local_image_path = self.download_image(image_path, ref)

            if local_image_path:
                # Get the Sphinx source directory
                env = self.state.document.settings.env
                srcdir = Path(env.srcdir)

                # Make the path relative to the source directory
                try:
                    rel_path = local_image_path.relative_to(srcdir)
                    # Use absolute path from source root with leading slash
                    # This ensures Sphinx can always find the image
                    new_path = '/' + str(rel_path.as_posix())
                except ValueError:
                    # If we can't make it relative, use absolute path
                    new_path = str(local_image_path.as_posix())
                
                # Update the image node's URI
                img_node['uri'] = new_path
                logger.info(f'Updated image URI: {original_uri} -> {new_path}')
            else:
                # If download failed, keep the original path
                logger.warning(f'Keeping original image path due to download failure: {original_uri}')

    def fetch_and_parse_content(self, url, source_path, ref):
        """Fetch content and parse it as RST"""
        response = requests.get(url)
        response.raise_for_status()
        content = response.text

        # Normalize tabs after numbered list markers to spaces
        # This fixes formatting issues where numbered lists use tabs instead of spaces
        content = re.sub(r'^(\s*\d+\.)\t+', r'\1 ', content, flags=re.MULTILINE)

        # Apply text replacements before parsing
        content = self.apply_replacements(content)

        # Fix LaTeX math issues if requested
        content = self.process_latex_math(content)

        # Process CSV tables to add widths if specified
        content = self.process_csv_tables(content)

        # Process :doc: roles before parsing
        content = self.process_doc_roles(content, ref)

        start_line = self.options.get('start_line', 0)

        # Create ViewList for parsing
        line_count = 0
        content_list = ViewList()
        for line_no, line in enumerate(content.splitlines()):
            if line_count >= start_line:
                content_list.append(line, source_path, line_no)
            line_count += 1

        # Create a section node and parse content
        node = nodes.section()
        nested_parse_with_titles(self.state, content_list, node)
        
        # Process images after parsing: download them and update node URIs
        self.process_image_nodes(node, ref)

        return node.children

    def run(self):
        if 'repo' not in self.options or 'path' not in self.options:
            logger.warning('Both repo and path options are required')
            return []

        target_ref = self.get_target_ref()
        logger.info(f'Target ref determined: {target_ref} for repo: {self.options["repo"]}')
        
        if not target_ref:
            return []

        raw_url = self.construct_raw_url(
            self.options['repo'],
            self.options['path'],
            target_ref
        )

        try:
            logger.info(f'Attempting to fetch content from {raw_url}')
            return self.fetch_and_parse_content(raw_url, self.options['path'], target_ref)
        except requests.exceptions.RequestException as e:
            logger.warning(f'Failed to fetch content from {raw_url}: {str(e)}')

            # If we failed on a tag, try falling back to default_branch
            current_version = self.get_current_version()
            if current_version:
                if 'default_branch' in self.options:
                    try:
                        fallback_ref = self.options['default_branch']
                        logger.info(f'Attempting fallback to {fallback_ref}...')

                        fallback_url = self.construct_raw_url(
                            self.options['repo'],
                            self.options['path'],
                            fallback_ref
                        )

                        return self.fetch_and_parse_content(fallback_url, self.options['path'], fallback_ref)
                    except requests.exceptions.RequestException as e2:
                        logger.warning(f'Fallback also failed: {str(e2)}')

            return []

def setup(app):
    app.add_directive('remote-content', BranchAwareRemoteContent)

    # Add configuration value for global docs base URL
    app.add_config_value('remote_content_docs_base', 'https://rocm.docs.amd.com/projects', 'html')

    return {
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }