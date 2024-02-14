#!/bin/bash

# Path to the Dockerfile
dockerfile_path="/home/bakri/Desktop/bode/Dockerfile" # Update this path to your Dockerfile location

# Base URL with a COMPONENT placeholder
base_url="https://bitnami.com/stack/COMPONENT/containers"

# Ensure OS_ARCH is set, default to amd64 if not
OS_ARCH="${OS_ARCH:-amd64}"

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

# Read the Dockerfile and process each component
awk '/COMPONENTS=\(/,/\)/{if($1 ~ /"/) print $1}' "$dockerfile_path" | \
sed 's/"//g' | \
sed 's/\\//g' | \
cut -d'-' -f1 | \
while IFS= read -r component; do
    # Construct the URL for the current component
    url="${base_url/COMPONENT/$component}"
    echo "Processing $url"
    # Fetch the latest version of the component
    latest_version=$(process_url "$url")
    if [ -n "$latest_version" ]; then
        # Construct the new component version string
        new_component_version="${component}-${latest_version}-linux-${OS_ARCH}-debian-11"
        echo "Latest version for $component: $new_component_version"
        # Replace the old component version in the Dockerfile with the new one
        # This sed command is designed to match the component string and replace its version while keeping the component name intact
        sed -i "s|${component}-[0-9]*\.[0-9]*\.[0-9]*-[0-9]*-linux-${OS_ARCH}-debian-11|${new_component_version}|g" "$dockerfile_path"
    else
        echo "Could not determine the latest version for $component."
    fi
done

echo "Dockerfile has been updated with the latest component versions."
