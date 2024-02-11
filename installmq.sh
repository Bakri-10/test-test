#!/bin/bash

# Define the path to search in. Replace /path/to/directory with your actual directory path.
SEARCH_PATH="/path/to/directory"

# Define the path to the Bash script you want to copy. Replace /path/to/your_script.sh with your actual script path.
SCRIPT_TO_COPY="/path/to/your_script.sh"

# Search for Dockerfile in the specified path, modify the echoed path, and copy the specified Bash script to each directory
find "$SEARCH_PATH" -type f -name "Dockerfile" | sed 's|/Dockerfile$||' | while read directory; do
    echo "Copying $SCRIPT_TO_COPY to $directory/"
    cp "$SCRIPT_TO_COPY" "$directory/"
done
