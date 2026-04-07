import os
import csv
import re
from docutils.parsers.rst import Directive

class CsvToListTable(Directive):
    required_arguments = 0
    optional_arguments = 1
    final_argument_whitespace = True
    option_spec = {
        'file': str,
        'include-header': lambda x: x.lower() == 'true',  # Boolean option
        'rows': str,  # Comma-separated list of row ranges and indices
        'widths': lambda x: [int(i) for i in x.split(',')],
        'columns': lambda x: [int(i) for i in x.split(',')]  # Columns to include (by index)
    }

    def run(self):
        env = self.state.document.settings.env
        src_dir = os.path.abspath(env.srcdir)

        # Get options
        file_path = self.options.get('file')
        if not file_path:
            raise self.error("The :file: option is required.")

        full_file_path = os.path.join(src_dir, file_path)

        # Check if the file exists
        if not os.path.exists(full_file_path):
            raise self.error(f"CSV file {full_file_path} does not exist.")

        include_header = self.options.get('include-header', True)
        rows_option = self.options.get('rows', '')
        widths = self.options.get('widths', [])
        columns = self.options.get('columns', [])

        # Parse the `:rows:` option
        selected_rows = self.parse_rows_option(rows_option)

        # Read CSV and process rows
        with open(full_file_path, newline='', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile)
            data = list(reader)

        if not data:
            raise self.error(f"CSV file {full_file_path} is empty or could not be read.")

        # Include the header if specified
        if include_header:
            headers = data[0]
            table_data = [data[i] for i in selected_rows if 0 <= i < len(data)]
        else:
            headers = []
            table_data = [data[i] for i in selected_rows if 0 <= i < len(data)]

        # If columns are specified, filter the columns
        if columns:
            headers = [headers[i] for i in columns] if headers else []
            table_data = [[row[i] for i in columns] for row in table_data]

        # Generate the list-table RST content
        list_table_rst = self.generate_list_table(headers, table_data, widths)

        # Parse the generated RST content and return the nodes
        self.state_machine.insert_input(list_table_rst.splitlines(), full_file_path)
        return []

    def parse_rows_option(self, rows_option):
        """
        Parse the `:rows:` option and return a list of selected row indices.
        """
        if not rows_option:
            return []

        row_indices = set()
        ranges = rows_option.split(',')

        for r in ranges:
            if '-' in r:
                start, end = map(int, r.split('-'))
                row_indices.update(range(start - 1, end))  # Convert to 0-based indexing
            else:
                row_indices.add(int(r) - 1)  # Convert to 0-based indexing

        return sorted(row_indices)

    def generate_list_table(self, headers, table_data, widths):
        """Generate RST list-table content from CSV data."""
        rows = []
        rows.extend([headers] if headers else [])
        rows.extend(table_data)

        # Start the list-table directive
        list_table_lines = [".. list-table::"]

        # Add widths if specified
        if widths:
            widths_str = ", ".join(str(w) for w in widths)
            list_table_lines.append(f"   :widths: {widths_str}")

        # Add header rows if there's a header
        if headers:
            list_table_lines.append(f"   :header-rows: 1")

        list_table_lines.append("")  # Blank line after options

        # Add the rows
        for row in rows:
            row_line = "   * - | " + self.format_cell(row[0])  # First cell
            for cell in row[1:]:
                row_line += f"\n     - | {self.format_cell(cell)}"
            list_table_lines.append(row_line)

        return "\n".join(list_table_lines)

    def format_cell(self, cell):
        """
        Format a cell's content for multi-line text handling, including automatic line break detection.
        """
        # Replace common line-break markers with actual line breaks
        for marker in ["|br|", "\\n", "|"]:
            cell = cell.replace(marker, "\n")

        # Split the cell content into lines
        lines = cell.splitlines()
        if len(lines) > 1:
            # For multi-line content, indent subsequent lines
            return f"\n       | ".join(lines)
        return cell


def setup(app):
    app.add_directive('csv-to-list-table', CsvToListTable)
    return {
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }
