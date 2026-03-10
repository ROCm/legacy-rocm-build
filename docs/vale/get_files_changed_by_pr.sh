#!/bin/bash

# A script to produce the list of files altered by a given PR, and optionally download them.
#     Should work on bash 3.2 and up.
#
# Accepts the following arguments:
#     -o String. The owner of the repository which the target PR is for.
#     -r String. The name of the repository which the target PR is for.
#     -p Integer. The PR number of the target PR.
#     -l Optional string. The full path to a local directory where the altered files should be downloaded. This
#                         directory, and parents, will be created if missing.
#                         If not present, no files will be downloaded; only the paths printed.
#     -d Optional string. Regex for the relative paths, such that only files whose relative paths match this regex
#                         will be downloaded. Only relevant if -l is set. Default: '^.*$'.
#     -t Optional string. The full path to a file that contains (only) the GitHub token that should
#                         be used to access GitHub. Either this or -T should be provided; if both are, -t will be
#                         prioritized.
#     -T Optional string. The GitHub token that should be used to access GitHub. Either this or -t should be provided;
#                         if both are, -t will be prioritized.
#
# Outputs to STDOUT a list of file paths altered by the PR, in alphabetical order (according to current locale),
#     paths relative to repository root. For example:
#         projects/rocblas/library/src/blas/rocblas_tsrv_kernels.cpp
#         projects/rocblas/library/src/blaslt/rocblas_tsrq_kernels.cpp
# Outputs logs/debug messages to STDERR.
# Downloads the files changed in the PR into the -l directory, overwriting files if there is a name collision.
#     Only occurs if -l was provided.
#
# Returns code 0 on successfully concluding (after printing the paths and optionally downloading the files).
# Returns code 3 if the number of files altered in this PR exceeds 2500. This is done because the query to retrieve
#                the list of files altered is limited to 3000, and we give ourselves a margin of error.
#                The file paths that were acquired will not be printed in this case.
# Returns any other code in any other case.

set -e

declare -r GITHUB_API_ROOT="https://api.github.com"  # Should not end in a /
declare -r MAX_ALLOWABLE_ALTERED_FILES=2500  # If a PR has more files altered than this, code 3.


# transfer_array_x and transfer_array_size_x are used for storing function parameters and return values.
# The function that sets them should clear them. When receiving data via these arrays, the receiver should immediately
#     transfer them to local ones to prevent accidental overwrites.
# Each transfer_array_x is an array of strings, while transfer_array_size_x is the index of the first unallocated
#    element of the array (logically unallocated; bash might consider it allocated from prior use, due to it being
#    reused).
declare -a transfer_array_0
declare -i transfer_array_0_size=0
declare -a transfer_array_1
declare -i transfer_array_1_size=0


echo_log () {
    # @brief Accepts a single string argument, which is immediately echo'd out to STDERR along with the curent time
    #        in ISO format.
    #
    # @param $1 The log output to print.
    #
    # @returns 0

    local current_datetime;
    current_datetime="$(date +"%Y-%m-%dT%H:%M:%S%z")"
    echo "${current_datetime} - ${1}" 1>&2

    return 0
}


help_message () {
    # @brief Prints out the help message.
    #
    # @param (None)
    #
    # @returns 0

    echo "A script to produce the list of files altered by a given PR, and optionally download them."
    echo ""
    echo "Accepts the following arguments:"
    echo "    -o String. The owner of the repository which the target PR is for."
    echo "    -r String. The name of the repository which the target PR is for."
    echo "    -p Integer. The PR number of the target PR."
    echo "    -l Optional string. The full path to a local directory where the altered files should be downloaded."
    echo "                        This directory, and parents, will be created if missing."
    echo "                        If not present, no files will be downloaded (only the paths will be printed)."
    echo "    -d Optional string. Regex for the relative paths, such that only files whose relative paths match this"
    echo "                        regex will be downloaded. Only relevant if -l is set. Default: '^.*$'."
    echo "    -t Optional string. The full path to a file that contains (only) the GitHub token that should"
    echo "                        be used to access GitHub. Either this or -T should be provided; if both are,"
    echo "                        -t will be prioritized."
    echo "    -T Optional string. The GitHub token that should be used to access GitHub. Either this or -t"
    echo "                        should be provided; if both are, -t will be prioritized."
    echo ""
    echo "Outputs to STDOUT a list of file paths altered by the PR, in alphabetical order (according to"
    echo "    current locale), paths relative to repository root. For example:"
    echo "        projects/rocblas/library/src/blas/rocblas_tsrv_kernels.cpp"
    echo "        projects/rocblas/library/src/blaslt/rocblas_tsrq_kernels.cpp"
    echo "Outputs logs/debug messages to STDERR."
    echo "Downloads the files changed in the PR into the -l directory, overwriting files if there is a name collision."
    echo "    Only occurs if -l was provided."
    echo ""
    echo "Returns code 0 on successfully concluding (after printing the paths and optionally downloading the files)."
    echo "Returns code 3 if the number of files altered in this PR exceeds 2500. This is done because the query to "
    echo "               retrieve the list of files altered is limited to 3000, and we give ourselves a"
    echo "               margin of error. The file paths that were acquired will not be printed in this case."
    echo "Returns any other code in any other case."

    return 0
}


parallel_insertion_sort_strings () {
    # @brief Given two arrays of strings, sorts them both according to the first one's keys (alphabetically
    #        according to current locale). For instance, if the first array's element 1 moves to index 2, then
    #        the second array's element 1 will be moved to its index 2 as well.
    #        Does not check its arguments except for array length.
    #
    # @param (via transfer_array_0) Array of strings. The first array to sort.
    # @param (via transfer_array_1) Array of strings. The array whose elements should be moved in the same way that
    #           the transfer_array_0 array's elements are moved.
    #
    # @sideeffect Returns (via transfer_array_0 and transfer_array_0_size) the sorted first array. 
    #             Will not occur if transfer_array_0 and transfer_array_1 are not the same length.
    # @sideeffect Returns (via transfer_array_1 and transfer_array_1_size) the sorted second array.
    #             Will not occur if transfer_array_0 and transfer_array_1 are not the same length.
    #
    # @returns Code 0 if the two arrays were sorted and returned via the transfer arrays; code 1 if the provided
    #          arrays are not the same length.

    echo_log "parallel_insertion_sort_strings starting operations."

    # Ensure that the arrays are the same length.
    if [[ ${transfer_array_0_size} -ne ${transfer_array_1_size} ]]; then
        echo_log "parallel_insertion_sort_strings provided unequal-sized arrays."
        return 1
    fi

    # Reassign the transfer arrays to local variables.
    local -a parent_array
    local -i working_index=0
    while [[ ${working_index} -lt ${transfer_array_0_size} ]]; do
        parent_array[${working_index}]=${transfer_array_0[${working_index}]}
        working_index=$((${working_index} + 1))
    done

    local -a child_array
    working_index=0
    while [[ ${working_index} -lt ${transfer_array_1_size} ]]; do
        child_array[${working_index}]=${transfer_array_1[${working_index}]}
        working_index=$((${working_index} + 1))
    done

    local -a parent_array_sorted
    local -a child_array_sorted
    
    working_index=0  # Represents the index from the parameter arrays we wish to insert next.
    local current_element_parent  # The element at working_index in the parent
    local current_element_child  # The element at working_index in the child

    local -i sorted_section_index=0  # Iterates backwards through the sorted section.
    local current_sorted_element_parent  # The element at sorted_section_index in the parent
    local current_sorted_element_child  # The element at sorted_section_index in the child 
    local -i new_sorted_element_index=0  # The new index a sorted element will be moved to.
    while [[ ${working_index} -lt ${#parent_array_sorted[@]} ]]; do
        current_element_parent="${parent_array[${working_index}]}"
        current_element_child="${child_array[${working_index}]}"

        if [[ ${working_index} -eq 0 ]]; then
            # This is the first element; we consider arrays of length 1 as already sorted, so it can go in as-is.
            #     It can go in the first place in the array.
            parent_array_sorted[0]="${current_element_parent}"
            child_array_sorted[0]="${current_element_child}"
        else 
            # This is not the first element. We will rearrange the other elements to make room for it, then insert it.

            # Sorted section ends one before the current element's place.
            sorted_section_index=$((${working_index} - 1))

            # Move elements of the sorted section forward so long as they are greater than the current element.
            # Double brackets will compare to current locale.
            while [[ ${sorted_section_index} -ge 0 ]] && [[ "${parent_array_sorted[${sorted_section_index}]}" -gt "${current_element_parent}" ]]; do
                current_sorted_element_parent="${parent_array_sorted[${sorted_section_index}]}"
                current_sorted_element_child="${child_array_sorted[${sorted_section_index}]}"

                new_sorted_element_index=$((${sorted_section_index} + 1))

                parent_array_sorted[${new_sorted_element_index}]="${current_sorted_element_parent}"
                child_array_sorted[${new_sorted_element_index}]="${current_sorted_element_child}"

                sorted_section_index=$((${sorted_section_index} - 1))
            done

            # sorted_section_index now points to the first properly sorted element of the array - or, one before the
            #     start of the array. In either case, the current element (at working_index) should go one ahead
            #     of this.
            parent_array_sorted[$((${sorted_section_index} + 1))]="${current_element_parent}"
            child_array_sorted[$((${sorted_section_index} + 1))]="${current_element_child}"
        fi

        working_index=$((${working_index} + 1))
    done

    # Our arrays should now be sorted. Load them into the return arrays and conclude.
    transfer_array_0_size=0
    for element in "${parent_array_sorted[@]}"; do
        transfer_array_0[${transfer_array_0_size}]="${element}"
        transfer_array_0_size=$((transfer_array_0_size + 1))
    done
    transfer_array_1_size=0
    for element in "${child_array_sorted[@]}"; do
        transfer_array_1[${transfer_array_1_size}]="${element}"
        transfer_array_1_size=$((transfer_array_1_size + 1))
    done

    echo_log "parallel_insertion_sort_strings has finished operations and is returning the sorted arrays."
}


get_files_altered_by_pr () {
    # @brief Given a PR, returns the list of files altered by that PR in alphabetical order (according to current
    #        locale), along with the URLs to where the files can be found.
    #        If the PR has more than MAX_ALLOWABLE_ALTERED_FILES altered files, returns a code 3 instead without
    #        altering any return_array_x and return_array_size_x.
    #        Does not check its arguments.
    #
    # @param $1 String. The owner of the repository which the target PR is for.
    # @param $2 String. The name of the repository which the target PR is for.
    # @param $3 Integer. The PR number of the target PR.
    # @param $4 String. The GitHub token which should be used for accessing GitHub.
    #
    # @sideeffect Returns (via transfer_array_0 and transfer_array_0_size) the list of paths of files that were changed
    #             by the target PR (ordered alphabetically to current locale).
    #             If there are too many files (see @brief), then this will not happen and transfer_array_0 and
    #             transfer_array_0_size will not be altered.
    # @sideeffect Returns (via transfer_array_1 and transfer_array_1_size) the list of URLs to the contents of the files
    #             that were changed in the target PR, ordered the same way as in transfer_array_0 (that is, the file
    #             with path at transfer_array_0[X] has URL transfer_array_1[X] for all X < transfer_array_1_size.
    #             If there are too many files (see @brief), then this will not happen and transfer_array_1 and
    #             transfer_array_1_size will not be altered.
    #
    # @returns 0 if there were not too many files, and the changed file paths/URLs were placed
    #            in the transfer arrays.
    #          3 if there were too many files.
    #          1 if any other error occurred.

    local repository_owner="${1}"
    local repository_name="${2}"
    local pr_number="${3}"
    local github_token="${4}"

    # Some common variables that are reused throughout the function
    local curl_response
    local grep_result
    local ifs_backup  # Backup for IFS to allow us to change it back
    local -i working_index  # Array index

    echo_log "get_files_altered_by_pr starting retrieval of altered files from PR #|${pr_number}| from\
 |${repository_owner}/${repository_name}|."

    # Each request we make will produce a JSON output, containing (among other things) the file paths and URLs
    #    we are looking for.
    # The file paths are found in lines like this:
    #         "filename": "projects/hipblaslt/library/src/amd_detail/rocblaslt/src/rocroller/solution_selection.cpp",
    # The URL for a given file path will follow a given file path with a line like this:
    #         "raw_url": "https://github.com/ROCm/rocm-libraries/raw/eae075f86ab8d39225d6c65e89f97e07c9518616/projects%2Fhipblaslt%2Flibrary%2Fsrc%2Famd_detail%2Frocblaslt%2Fsrc%2Frocroller%2Fsolution_selection.cpp",
    # A URL line will always follow its parent filename line. In the case that we see a filename line without an
    #     associated raw_url line, then that filename is not something we are interested in (for instance, it is
    #     a submodule).
    #
    # Our algorithm for processing this will be as follows:
    #     1. Create an array containing only the file paths, and then another containing only the URLs (in the same
    #        order, i.e. element X in one array corresponds to element X in the other).
    #     2. Sort the two arrays using parallel_insertion_sort_strings according to the file paths.
    #        We use insertion sort since it's likely the filenames are already sorted, at least partially.

    # Note that by using these regexes with --only-matching we will eliminate the leading and tailing whitespace,
    #     as well as the tailing comma.
    local filename_line_regex='"filename": ".+"'
    local raw_url_line_regex='"raw_url": ".+"'

    local -a filename_lines_list  # The interesting filename lines, already processed by filename_line_regex
    local -a raw_url_lines_list  # The interesting raw_url lines, already processed by raw_url_line_regex
    working_index=0  # The index within the above two lists we are inserting into

    # Scan mode:
    #     0: We are awaiting the next filename line
    #     1: We have just seen a filename line and are awaiting a raw_url line
    local -i scan_mode=0
    local last_filename_line_seen

    # The response may be paginated; we can tell if this is happening and where to request the next block of data by
    #     looking at the header of the response of our request.
    #     If the header contains a line like this:
    #             link: <https://api.github.com/repositories/971570345/pulls/2718/files?page=2>; rel="next", <https://api.github.com/repositories/971570345/pulls/2718/files?page=4>; rel="last"
    #         or like this:
    #             link: <https://api.github.com/repositories/971570345/pulls/2718/files?page=1>; rel="prev", <https://api.github.com/repositories/971570345/pulls/2718/files?page=3>; rel="next", <https://api.github.com/repositories/971570345/pulls/2718/files?page=4>; rel="last", <https://api.github.com/repositories/971570345/pulls/2718/files?page=1>; rel="first"
    #     then the reply is paginated. This header also tells us where we should look for the next page.
    #     If the header does not contain such a line, then the reply is not paginated.
    local request_url_base="${GITHUB_API_ROOT}/repos/${repository_owner}/${repository_name}/pulls/${pr_number}/files"
    local link_header_regex='link:.+'
    local next_page_link_section_regex='<\S+>; rel="next"'  # Extracting the next link from the links line

    local request_url="${request_url_base}"
    local link_header
    local next_page_link_section
    local -i next_page_link_section_string_length  # Length of next_page_link_section

    while true; do  # Pagination loop
        # Collect the files from the next URL.
        if ! curl_response="$(curl --fail --silent --retry 2 --location --header "Accept: application/vnd.github+json" --header "Authorization: Bearer ${github_token}" --header "X-Github-Api-Version: 2022-11-28" "${request_url}")"; then
            echo_log "Failed to get good return code from |${request_url}|.\
 Re-executing curl call to provide error message and returning 1."
            curl --retry 2 --location --header "Accept: application/vnd.github+json" --header "Authorization: Bearer ${github_token}" --header "X-Github-Api-Version: 2022-11-28" "${request_url}"
            return 1
        fi

        # Process the curl response to extract the interesting lines.
        while IFS='' read -r raw_line; do
            if grep_result="$(grep --only-matching --extended-regexp "${filename_line_regex}" <<< "${raw_line}")"; then
                # Whatever scan mode we are in, we simply load the new filename
                last_filename_line_seen="${grep_result}"
                scan_mode=1
                continue
            fi
            
            if grep_result="$(grep --only-matching --extended-regexp "${raw_url_line_regex}" <<< "${raw_line}")"; then
                if [[ ${scan_mode} -eq 0 ]]; then
                    # We have just seen a raw_url line, and now see another one. This is unexpected.
                    error_log "curl response from |${request_url}| had unexpected format: |${curl_response}|."
                    return 1
                elif [[ ${scan_mode} -eq 1 ]]; then
                    # We have previously seen a filename, and now see a raw_url line. We should record both.
                    filename_lines_list[${working_index}]="${last_filename_line_seen}"
                    raw_url_lines_list[${working_index}]="${grep_result}"
                    working_index=$((${working_index} + 1))
                    scan_mode=0
                    continue
                else
                    error_log "Fell off of if-stack on scan mode |${scan_mode}| while scanning response from |${request_url}|.
 This should not be possible!"
                    return 1
                fi
            fi

            # This is an uninteresting line.
        done <<< "${curl_response}"

        # Get the link header.
        if ! curl_response="$(curl --fail --silent --retry 2 --location --head --header "Accept: application/vnd.github+json" --header "Authorization: Bearer ${github_token}" --header "X-Github-Api-Version: 2022-11-28" "${request_url}")"; then
            echo_log "Failed to get good return code from |${request_url}|, when collecting headers.\
 Re-executing curl call (without header-only argument) to provide error message and returning 1."
            curl --retry 2 --location --header "Accept: application/vnd.github+json" --header "Authorization: Bearer ${github_token}" --header "X-Github-Api-Version: 2022-11-28" "${request_url}"
            return 1
        fi

        if ! link_header="$(grep --only-matching --extended-regexp "${link_header_regex}" <<< "${curl_response}")"; then
            # This reply is not paginated. We can break.
            break
        fi

        # Extract the section with the next link, if there is one. This will give us a string like
        #     <https://api.github.com/repositories/971570345/pulls/2718/files?page=2>; rel="next"
        if ! next_page_link_section="$(grep --only-matching --extended-regexp "${next_page_link_section_regex}" <<< "${link_header}")"; then
            # We have processed the last page. We can break.
            break
        fi

        # Extract just the next page link itself by trimming the unnecessary sections of next_page_link_section.
        #     We will go there next loop.
        # This will give us a string like:
        #     https://api.github.com/repositories/971570345/pulls/2718/files?page=2
        next_page_link_section_string_length=${#next_page_link_section}
        request_url="${next_page_link_section:1:$((next_page_link_section_string_length - 14))}"
    done

    # Sort filename_lines_list and raw_url_lines_list. We use insertion sort since it's likely the list is partially
    #    sorted already.
    transfer_array_0_size=0
    while [[ ${transfer_array_0_size} -lt ${#filename_lines_list[@]} ]]; do
        transfer_array_0[${transfer_array_0_size}]="${filename_lines_list[${transfer_array_0_size}]}"
        transfer_array_0_size=$((${transfer_array_0_size} + 1))
    done
    transfer_array_1_size=0
    while [[ ${transfer_array_1_size} -lt ${#raw_url_lines_list[@]} ]]; do
        transfer_array_1[${transfer_array_1_size}]="${raw_url_lines_list[${transfer_array_1_size}]}"
        transfer_array_1_size=$((${transfer_array_1_size} + 1))
    done

    parallel_insertion_sort_strings 

    # Retrieve the sorted arrays into filename_lines_list and raw_url_lines_list.
    local -i working_index=0
    while [[ ${working_index} -lt ${transfer_array_0_size} ]]; do
        filename_lines_list[${working_index}]="${transfer_array_0[${working_index}]}"
        working_index=$((${working_index} + 1))
    done
    working_index=0
    while [[ ${working_index} -lt ${transfer_array_1_size} ]]; do
        raw_url_lines_list[${working_index}]="${transfer_array_1[${working_index}]}"
        working_index=$((${working_index} + 1))
    done

    # Trim all elements of filename_lines_list to leave just one file path per line.
    # The lines start like:
    #     "filename": "shared/origami/src/origami/origami.cpp"
    # And will finish like:
    #     shared/origami/src/origami/origami.cpp
    # There is no leading/tailing whitespace or commas to worry about, since when collecting these lines with
    #     grep we collected --only-matching data.
    local -a file_paths_list
    working_index=0
    local file_path_trimmed
    local -i file_path_raw_length
    for file_path_line in "${filename_lines_list[@]}"; do
        file_path_raw_length=${#file_path_line}
        file_path_trimmed="${file_path_line:13:$((${file_path_raw_length} - 14))}"

        file_paths_list[${working_index}]="${file_path_trimmed}"
        working_index=$((${working_index} + 1))
    done

    # Trim all elements of raw_url_lines_list to leave just one URL path per line.
    # The lines start like:
    #     "raw_url": "https://github.com/ROCm/rocm-libraries/raw/eae075f86ab8d39225d6c65e89f97e07c9518616/shared%2Forigami%2Fsrc%2Forigami%2Forigami.cpp"
    # And will finish like:
    #     https://github.com/ROCm/rocm-libraries/raw/eae075f86ab8d39225d6c65e89f97e07c9518616/shared%2Forigami%2Fsrc%2Forigami%2Forigami.cpp
    # There is no leading/tailing whitespace or commas to worry about, since when collecting these lines with
    #     grep we collected --only-matching data.
    local -a file_urls_list
    working_index=0
    local file_url_line_trimmed
    local -i file_url_line_raw_length
    for file_url_line in "${raw_url_lines_list[@]}"; do
        file_url_line_raw_length=${#file_url_line}
        file_url_line_trimmed="${file_url_line:12:$((${file_url_line_raw_length} - 13))}"

        file_urls_list[${working_index}]="${file_url_line_trimmed}"
        working_index=$((${working_index} + 1))
    done

    # If we have too many files, code 3.
    if [[ ${#file_paths_list} -gt ${MAX_ALLOWABLE_ALTERED_FILES} ]]; then
        echo_log "PR #|${pr_number}| in repository |${repository_owner}/${repository_name}| had more files altered\
 than |${MAX_ALLOWABLE_ALTERED_FILES}|; returning code 3."
        return 3
    fi

    # The output can now be stored into the transfer arrays.
    transfer_array_0_size=0
    for file_path in "${file_paths_list[@]}"; do
        transfer_array_0[${transfer_array_0_size}]="${file_path}"
        transfer_array_0_size=$((${transfer_array_0_size} + 1))
    done
    transfer_array_1_size=0
    for file_url in "${file_urls_list[@]}"; do
        transfer_array_1[${transfer_array_1_size}]="${file_url}"
        transfer_array_1_size=$((${transfer_array_1_size} + 1))
    done

    echo_log "get_files_altered_by_pr has finished retrieving file paths and URLs altered by PR #|${pr_number}| from\
 |${repository_owner}/${repository_name}|, and is returning them with code 0."
    return 0
}


download_files () {
    # @brief Given a list of relative file paths, a list of associated URLs, and a target local path, wgets each URL
    #        into its associated file name (and path) within the target local path, overwriting if necessary.
    #        The directory at the target local path, and parents, will be created if necessary.
    #        For instance if the parameters are:
    #            relative_paths: ["my_project/my_file.txt"]
    #            URLs: ["https://example.org"]
    #            target_local_path: ["/Users/me/my_directory"]
    #        Then https://example.org will be downloaded into /Users/me/my_directory/my_project/my_file.txt.
    #
    #        Is not guaranteed to properly check its parameters, except for ensuring that all the relative paths
    #            do not contain '..' (to prevent escapes outside the local target path).
    #
    # @param $1 String. The full path to a local directory (which may not exist yet), within which all files will be
    #                   downloaded. Should NOT end in a slash.
    # @param $2 String. A regex for the relative paths. Any file whose relative path does not match this regex
    #                   will not be downloaded.
    # @param (via transfer_array_0) The relative paths of the files being downloaded.
    # @param (via transfer_array_1) The URLs from which the files should be downloaded. Any URL at index X should have
    #                               its file path at transfer_array_0 index X.
    #
    # @returns Code 0 upon successfully downloading the files (or not downloading them if no paths match the regex in
    #                 $2.
    #          Code 1 if:
    #              - transfer_array_0_size and transfer_array_1_size are not equal
    #              - Any path in transfer_array_0 contains '..'
    #              - Any other error

    local download_base_directory="${1}"
    local allowed_relative_paths_regex="${2}"

    echo_log "download_files starting operations; told to download files to |${download_base_directory}|,\
regex |${allowed_relative_paths_regex}|."

    if [[ ${transfer_array_0_size} -ne ${transfer_array_1_size} ]]; then
        echo_log "download_files passed mismatched URL and relative paths arrays:\
 |${transfer_array_0_size}| vs |${transfer_array_1_size}|."
        return 1
    fi

    local -a relative_paths_list
    local -i working_index=0
    while [[ ${working_index} -lt ${transfer_array_0_size} ]]; do
        relative_paths_list[${working_index}]="${transfer_array_0[${working_index}]}"
        working_index=$((${working_index} + 1))
    done

    local -a urls_list
    working_index=0
    while [[ ${working_index} -lt ${transfer_array_1_size} ]]; do
        urls_list[${working_index}]="${transfer_array_1[${working_index}]}"
        working_index=$((${working_index} + 1))
    done

    # Ensure that there are no paths in relative_paths_list containing '..'
    bad_path_regex='^.*\.\..*$'
    for relative_path in "${relative_paths_list[@]}"; do
        if grep --quiet --extended-regexp "${bad_path_regex}" <<< "${relative_path}"; then
            echo_log "download_files passed path containing '..', which is not allowed: |${relative_path}|."
            return 1
        fi
    done

    echo_log "Creating |${download_base_directory}| and parents if necessary."
    mkdir -p "${download_base_directory}"  # This will fail if a file (not directory) exists there already.
    local download_base_directory_absolute="$(realpath "${download_base_directory}")"

    # Convert the relative paths to full paths
    safe_path_regex="^${download_base_directory}/.+$"

    local -a absolute_paths_list
    local absolute_path
    working_index=0
    for relative_path in "${relative_paths_list[@]}"; do
        absolute_path="${download_base_directory_absolute}/${relative_path}"
        absolute_paths_list[${working_index}]="${absolute_path}"
        working_index=$((${working_index} + 1))
    done

    # Download the files matching the regex.
    echo_log "Downloading the requested files into |${download_base_directory}|..."
    working_index=0
    # The file path might contain directories, which we have to create. For instance,
    #     if the path is
    #         '/Users/me/downloaded_files' - base directory
    #         'my_project/my_subproject/my_file.txt' - relative path
    #     Then we must first create /Users/me/downloaded_files/my_project/my_subproject before downloading
    #         the file.
    local file_directory
    for file_url in "${urls_list[@]}"; do
        if grep --quiet --extended-regexp "${allowed_relative_paths_regex}" <<< "${relative_paths_list[${working_index}]}"; then
            # Create the file's directory
            file_directory="$(dirname "${absolute_paths_list[${working_index}]}")"
            mkdir -p "${file_directory}"

            # wget will return a bad error code on a bad HTTP response, exactly as we would like it.
            wget -O "${absolute_paths_list[${working_index}]}" "${file_url}"
        fi
        working_index=$((${working_index} + 1))
    done

    echo_log "download_files has finished downloading to |${download_base_directory}| and is concluding."
}


# ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== ===== =====
# ----- ----- -----
# Check/process commandline arguments.
# ----- ----- -----

# If we got no arguments, or the argument seems to be asking for help, print the help message and exit successfully.
if [[ -z ${1+x} ]]; then
    help_message
    exit 0
fi

if [[ "${1}" == "help" ]] || [[ "${1}" == "--help" ]]; then
    help_message
    exit 0
fi

# All integer arguments are initially collected as strings, and converted later.
declare repository_owner  # -o
declare repository_name  # -r
declare pr_number_text  # -p
declare local_download_path  # -l
declare download_paths_regex_argument  # -d
declare github_token_file_path  # -t
declare github_token_argument  # -T


# Store arguments into variables. We'll deal with them later.
while getopts 'o:r:p:l:d:t:T:' letter_option; do
    case "${letter_option}" in
        "o" )
            repository_owner="${OPTARG}"
        ;;

        "r" )
            repository_name="${OPTARG}"
        ;;

        "p" )
            pr_number_text="${OPTARG}"
        ;;

        "l" )
            local_download_path="${OPTARG}"
        ;;

        "d" )
            download_paths_regex_argument="${OPTARG}"
        ;;

        "t" )
            github_token_file_path="${OPTARG}"
        ;;

        "T" )
            github_token_argument="${OPTARG}"
        ;;
    esac
done

# repository_owner -o
if [[ -z "${repository_owner}" ]]; then
    echo_log "No repository owner (-o) provided."
    exit 1
fi
# A valid GitHub repository owner (username) can only contain alphanumeric characters, and dashes.
if ! grep --quiet --extended-regexp '^[A-Za-z0-9-]+$' <<< "${repository_owner}"; then
    echo_log "Repository owner (-o) does not match expected format."
    exit 1
fi

# repository_name -r
if [[ -z "${repository_name}" ]]; then
    echo_log "No repository name (-r) provided."
    exit 1
fi
# A valid GitHub repository name can contain alphanumeric characters, -, _, and .
if ! grep --quiet --extended-regexp '^(-|_|\w|\.)+$' <<< "${repository_name}"; then
    echo_log "Repository name (-r) does not match expected format."
    exit 1
fi

# pr_number -p
if [[ -z "${pr_number_text}" ]]; then
    echo_log "No PR number (-p) provided."
    exit 1
fi
# A valid PR number is a positive integer.
if ! grep --quiet --extended-regexp '^[0-9]+$' <<< "${pr_number_text}"; then
    echo_log "PR number (-p) does not match expected format."
    exit 1
fi
# Convert pr_number_text to an integer variable
declare -i pr_number=${pr_number_text}

# download_paths_regex -d
declare download_paths_regex="^.*$"  # Unless told otherwise, match anything.
if [[ ! -z "${download_paths_regex_argument}" ]]; then
    download_paths_regex="${download_paths_regex_argument}"
fi

# github_token_file_path -t and github_token_argument
declare github_token
if [[ ! -z "${github_token_file_path}" ]]; then
    # Reading token from file.
    if [[ ! -f "${github_token_file_path}" ]]; then
        echo_log "Provided GitHub token path (-t) does not point to an extant file."
        exit 1
    fi

    github_token="$(cat "${github_token_file_path}")"
    if [[ -z "${github_token}" ]]; then
        echo_log "Provided GitHub token file path (-t) |${github_token_file_path}| appears to be an empty file!"
        exit 1
    fi
elif [[ ! -z "${github_token_argument}" ]]; then
    github_token="${github_token_argument}"
else
    echo_log "Not provided a GitHub token path (-t) or GitHub token (-T)."
    exit 1
fi


# Execute the operation.

# Get the file paths and URLs.
get_files_altered_by_pr "${repository_owner}" "${repository_name}" ${pr_number} "${github_token}"

# If requested, download the files. The files and URLs are already in the appropriate transfer arrays.
if [[ ! -z "${local_download_path}" ]]; then
    download_files "${local_download_path}" "${download_paths_regex}"
fi

# Print the file paths.
declare -i working_index=0
while [[ ${working_index} -lt ${transfer_array_0_size} ]]; do
    echo "${transfer_array_0[${working_index}]}"
    working_index=$((${working_index} + 1))
done
