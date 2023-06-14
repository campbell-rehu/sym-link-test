#!/bin/bash

source_dir="$PWD/source-folder"
target_dir="$PWD/dest-folder"

create_symlinks() {
    local src="$1"
    local target="$2"

    find "$src" -mindepth 1 -type d | awk -v src="$src" '{gsub(src"/?", "", $0); print}' | while read -r dir; do
        # Create directory structure in the target directory
        mkdir -p "$target/$dir"
    done

    find "$src" -type f | awk -v src="$src" '{gsub(src"/?", "", $0); print}' | while read -r file; do
        # Create symbolic links in the corresponding directory
        ln -s "$src/$file" "$target/$file"
    done
}

# Call the function with source and target directories
create_symlinks "$source_dir" "$target_dir"
