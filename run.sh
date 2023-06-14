#!/bin/bash

src="$1"
target="$2"

if [ "$#" -eq 2 ]; then
    find "$src" -mindepth 1 -type d | awk -v src="$src" '{gsub(src"/?", "", $0); print}' | while read -r dir; do
        # Create directory structure in the target directory
        mkdir -p "$target/$dir"
    done

    find "$src" -type f | awk -v src="$src" '{gsub(src"/?", "", $0); print}' | while read -r file; do
        # Create symbolic links in the corresponding directory
        ln -s "$src/$file" "$target/$file"
    done
else
    echo "You must pass a source_dir and target_dir to this script"
fi
