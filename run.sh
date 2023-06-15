#!/bin/bash

src="$1"
target="$2"
dryRun="$3"

exclude_dirs=(".git")

if [ "$#" -ge 2 ]; then
    exclude=()

    # Build the exclude options for find command
    for dir in "${exclude_dirs[@]}"; do
        exclude+=(-not -path "$src/$dir/*" -not -path "$src/$dir")
    done

    echo "Exclude options: ${exclude[@]}"

    find "$src" -mindepth 1 -type d "${exclude[@]}" | awk -v src="$src" '{gsub(src"/?", "", $0); print}' | while read -r dir; do
        if [ -n "$dryRun" ]; then
            echo "DryRun: mkdir -p \"$target/$dir\""
        else
            # Create directory structure in the target directory
            mkdir -p "$target/$dir"
        fi
    done

    find "$src" -type f "${exclude[@]}" | awk -v src="$src" '{gsub(src"/?", "", $0); print}' | while read -r file; do
        if [ -n "$dryRun" ]; then
            echo "DryRun: ln -sf \"$src/$file\" \"$target/$file\""
        else
            # Create symbolic links in the corresponding directory
            ln -sf "$src/$file" "$target/$file"
        fi
    done
else
    echo "You must pass a source_dir and target_dir to this script"
fi
