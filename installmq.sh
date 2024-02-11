#!/bin/bash

# Define the path to search in. Replace /path/to/directory with your actual directory path.
SEARCH_PATH="/path/to/directory"

# Search for Dockerfile in the specified path and echo each path found
find "$SEARCH_PATH" -type f -name "Dockerfile" -exec echo {} \;
