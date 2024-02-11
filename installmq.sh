#!/bin/bash

# Path to the bash script you want to distribute
script_path="/path/to/your/update-components.sh"

# Starting directory for the search, change this to the root directory of your project
search_root="/path/to/search/root"

# Find directories containing Dockerfile and copy the bash script to each
find "$search_root" -type f -name "Dockerfile" -exec dirname {} \; | while read -r dir; do
    echo "Copying $script_path to $dir"
    cp "$script_path" "$dir"
done

echo "Finished distributing the script to all directories containing a Dockerfile."
