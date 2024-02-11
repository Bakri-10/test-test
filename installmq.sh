#!/bin/bash

# Define the path to search in. Replace /path/to/directory with your actual directory path.
SEARCH_PATH="/path/to/directory"

# Search for Dockerfile in the specified path and modify the echoed path
find "$SEARCH_PATH" -type f -name "Dockerfile" | sed 's|/Dockerfile$||' | while read line; do
    echo "$line/"
done
