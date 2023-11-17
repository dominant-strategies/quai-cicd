#!/bin/bash

LANG_DIRS=("js" "go" "ts" "elixir")
TRACKING_FILE=".last_dir"
EXCLUDE_ITEMS=("select.sh" ".git" ".github" ".idea")

move_directory_contents() {
    local src="$1"
    local dest="$2"

    # Create the destination directory if it doesn't exist
    mkdir -p "$dest"

    # Move all contents
    find "$src" -maxdepth 1 -mindepth 1 | while IFS= read -r item; do
        mv "$item" "$dest/"
    done
}

# Function to move files from top-level back to their directory
move_files_back() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        echo "Invalid directory: $dir"
        exit 1
    fi

    for item in $(ls "$dir"); do
        # If it's a directory and it exists at the top level, use the helper function
        if [[ -d "$item" && -d "$dir/$item" ]]; then
            move_directory_contents "$item" "$dir/$item"
            rmdir "$item"  # remove the now empty directory at the top level
        elif [[ -e "$item" && ! " ${EXCLUDE_ITEMS[@]} " =~ " $item " ]]; then
            mv -v "$item" "$dir/"
        fi
    done
}

# Function to copy files from the chosen directory to the top level
copy_to_top_level() {
    local dir="$1"
    cp -r "$dir/"* .
}

# Main logic
if [[ ! " ${LANG_DIRS[@]} " =~ " $1 " ]]; then
    echo "Invalid language. Please choose from: ${LANG_DIRS[@]}"
    exit 1
fi

# If the tracking file exists, move files from the previous directory back to it
if [[ -e "$TRACKING_FILE" ]]; then
    prev_dir=$(cat "$TRACKING_FILE")
    move_files_back "$prev_dir"
fi

# Copy files from the chosen directory to the top level
copy_to_top_level "$1"

# Update the tracking file
echo "$1" > "$TRACKING_FILE"

echo "Top level now contains files from the $1 directory."
