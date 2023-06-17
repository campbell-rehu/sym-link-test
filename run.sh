#!/bin/bash

# Function to create symbolic links or copy specific files while preserving the directory structure
process_files() {
    local src="${1%/}"  # Remove trailing slash if present
    local target="${2%/}"  # Remove trailing slash if present
    shift 2
    local files_to_copy=("$@")
    local exclude=()

    # Hard-coded directories to exclude
    local exclude_dirs=("dir_to_exclude1" "dir_to_exclude2")

    # Build the exclude options for find command
    for dir in "${exclude_dirs[@]}"; do
        exclude+=(-not -path "$src/$dir/*" -not -path "$src/$dir")
    done

    # Process files
    find "$src" -type f "${exclude[@]}" | while read -r file; do
        # Get the relative path of the file with respect to the source directory
        rel_path=${file#$src/}

        # Debug: Print paths being processed
        # echo "Processing file: $file"
        # echo "Relative path: $rel_path"

        # Check if the file is in the list of files to copy
        if printf '%s\n' "${files_to_copy[@]}" | grep -Fxq -- "$file"; then
            # Only copy if the file does not already exist
            if ! [ -e "$target/$rel_path" ]; then
                # Copy the file
                if $dry_run; then
                    echo "Would copy: $file to $target/$rel_path"
                else
                    mkdir -p "$(dirname "$target/$rel_path")"
                    cp "$file" "$target/$rel_path"
                fi
            fi
        else
            # Create a symlink
            if $dry_run; then
                echo "Would create symlink: $file to $target/$rel_path"
            else
                mkdir -p "$(dirname "$target/$rel_path")"
                ln -sf "$file" "$target/$rel_path"
            fi
        fi
    done
}

# Check if the script is in dry-run mode
dry_run=false
if [[ $1 == "--dry-run" ]]; then
    dry_run=true
    shift 1
fi

# Check if at least two arguments are provided (source and target directories)
if [ "$#" -lt 2 ]; then
    echo "Usage: ./script.sh [--dry-run] source_dir target_dir full_path_of_files_to_copy..."
    exit 1
fi

# Get the source and target directories from command line arguments
source_dir="$1"
target_dir="$2"

# Shift the first two arguments (source and target directories)
shift 2

# Call the function with source and target directories and list of files to copy
process_files "$source_dir" "$target_dir" "$@"
