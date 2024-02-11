#!/bin/bash

# Path to the bash script you want to copy
BASH_SCRIPT_PATH="/path/to/update-dockefile.sh"

# Base directory to start searching for Dockerfiles
SEARCH_BASE_DIR="/path/to/search/directory"

# Find directories containing a Dockerfile and copy the bash script into each
find "$SEARCH_BASE_DIR" -type f -name 'Dockerfile' | while read dockerfile; do
  DIR_PATH=$(dirname "$dockerfile")
  echo "Copying $BASH_SCRIPT_PATH to $DIR_PATH"
  cp "$BASH_SCRIPT_PATH" "$DIR_PATH"
done
