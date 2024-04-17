#!/bin/bash

# Initialize variables
staticWebStaging=""
outputFolder=""
serverUrl=""

# Usage message
usage() {
    echo "Usage: $0 [OPTION]..."
    echo "Required Arguments:"
    echo "  -w, --static-web-staging  <static_web_staging_path> Path to static web staging folder"
    echo "  -o, --output-folder       <outputfolder>            Path to output directory"
    echo "  -u, --server-url          <serverUrl>               Full server URL"
    echo
    echo "Example:"
    echo "  $0 --static-web-staging /path/to/staticWeb --output-folder /path/to/output --server-url http://example.com"
    exit 1
}

# Define the options
SHORT=w:o:u:
LONG=static-web-staging:,output-folder:,server-url:

# Parse the options
OPTIONS=$(getopt -a -n "$0" --options $SHORT --longoptions $LONG -- "$@")
VALID_ARGS=$?
if [ "$VALID_ARGS" != "0" ]; then
    usage
    exit 1
fi

eval set -- "$OPTIONS"
while :
do
    case "$1" in
        -w | --static-web-staging)
            staticWebStaging="$2"
            shift 2
            ;;
        -o | --output-folder)
            outputFolder="$2"
            shift 2
            ;;
        -u | --server-url)
            serverUrl="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

# Check for required arguments
if [[ -z "$staticWebStaging" || -z "$outputFolder" || -z "$serverUrl" ]]; then
    echo "Error: Missing required arguments."
    usage
fi

# Function to check and create directories
ensure_directory_exists() {
    local dir=$(echo "$1" | tr -s '/')
    if [[ ! -d "$dir" ]]; then
        echo "Directory does not exist: $dir. Creating it now..."
        mkdir -p "$dir"
        if [[ $? -eq 0 ]]; then
            echo "Directory created: $dir"
        else
            echo "Failed to create directory: $dir"
            exit 1
        fi
    else
        echo "Directory already exists: $dir"
    fi
}

# Ensure the output directory exists
ensure_directory_exists "$outputFolder/static_web_build"

echo "Static Web Staging Path: $staticWebStaging"
echo "Output Folder: $outputFolder"
echo "Server URL: $serverUrl"

rsync -av --exclude-from="$staticWebStaging/.gitignore" "$staticWebStaging/" "${outputFolder}/static_web_build/"

# Replace the SERVER_URL_PLACEHOLDER with the actual server URL
sed -i "s/SERVER_URL_PLACEHOLDER/$serverUrl/" "${outputFolder}/static_web_build/index.html"
