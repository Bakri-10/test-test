#!/bin/bash

# Path to the Dockerfile
dockerfile_path="/home/bakri/Desktop/bode/Dockerfile" # Update this path to your Dockerfile location

# Base URL with a COMPONENT placeholder
base_url="https://bitnami.com/stack/COMPONENT/containers"

# Ensure OS_ARCH is set, default to amd64 if not
OS_ARCH="${OS_ARCH:-amd64}"

# Temporary file to store the new COMPONENTS block
temp_components_file=$(mktemp)

# Function to curl and process a URL to find the latest version
process_url() {
    local url=$1
    # Curl the website and process the output to find the latest version
    curl -sL "$url" | \
    sed -n '/Available versions/,/<\/ul>/p' | \
    grep -oP '\d+\.\d+\.\d+-\d+' | \
    sort -V | \
    tail -n1
}

# Start the COMPONENTS block
echo "COMPONENTS=( \\" > "$temp_components_file"

# Read the Dockerfile and process each component
awk '/COMPONENTS=\(/,/\)/{if($1 ~ /"/) print $1}' "$dockerfile_path" | \
sed 's/"//g' | \
sed 's/\\//g' | \
while IFS= read -r original_component; do
    component=$(echo "$original_component" | cut -d'-' -f1)
    # Construct the URL for the current component
    url="${base_url/COMPONENT/$component}"
    echo "Processing $url"
    # Fetch the latest version of the component
    latest_version=$(process_url "$url")
    if [ -n "$latest_version" ]; then
        # Construct the new component version string
        new_component_version="${component}-${latest_version}-linux-${OS_ARCH}-debian-11"
        echo "Latest version for $component: $new_component_version"
    else
        # Fallback to the original component version
        new_component_version=$original_component
        echo "Fallback to original version for $component: $new_component_version due to URL fetch failure."
    fi
    # Append the component version to the temp file
    echo "  \"$new_component_version\" \\" >> "$temp_components_file"
done

# Close the COMPONENTS block
echo ")" >> "$temp_components_file"

# Replace the old COMPONENTS block in the Dockerfile with the new one
sed -i "/COMPONENTS=(/,/)/c\\$(cat "$temp_components_file")" "$dockerfile_path"

# Clean up the temporary file
rm "$temp_components_file"

echo "Dockerfile has been updated."
