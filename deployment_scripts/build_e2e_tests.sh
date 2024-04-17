#!/bin/bash

# Initialize variables
e2eTestsStaging=""
staticWebStaging=""
outputFolder=""

# Usage message
usage() {
    echo "Usage: $0 [OPTION]..."
    echo "Required Arguments:"
    echo "  -t, --tests-staging       <e2e_tests_staging_path>  Path to E2E tests staging folder"
    echo "  -w, --static-web-staging  <static_web_staging_path> Path to static web staging folder"
    echo "  -o, --output-folder       <outputfolder>            Path to output directory"
    echo
    echo "Example:"
    echo "  $0 --tests-staging /path/to/tests --static-web-staging /path/to/staticWeb --output-folder /path/to/output"
    exit 1
}

# Define the options
SHORT=t:w:o:
LONG=tests-staging:,static-web-staging:,output-folder:

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
        -t | --tests-staging)
            e2eTestsStaging="$2"
            shift 2
            ;;
        -w | --static-web-staging)
            staticWebStaging="$2"
            shift 2
            ;;
        -o | --output-folder)
            outputFolder="$2"
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
if [[ -z "$e2eTestsStaging" || -z "$staticWebStaging" || -z "$outputFolder" ]]; then
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

# Ensure the output and its subdirectories exist
ensure_directory_exists "$outputFolder"
ensure_directory_exists "${outputFolder}/e2e_tests_build"
ensure_directory_exists "${outputFolder}/e2e_tests_build/static_web_test"

echo "E2E Tests Staging Path: $e2eTestsStaging"
echo "Static Web Staging Path: $staticWebStaging"
echo "Output Folder: $outputFolder"

rsync -av --exclude-from="$e2eTestsStaging/.gitignore" "$e2eTestsStaging/" "${outputFolder}/e2e_tests_build/"
rsync -av --exclude-from="$staticWebStaging/.gitignore" "$staticWebStaging/" "${outputFolder}/e2e_tests_build/static_web_test/"

# Make an instance of the index file for each test case 
cp "${outputFolder}/e2e_tests_build/static_web_test/index.html" "${outputFolder}/e2e_tests_build/static_web_test/invalid_sig_for_init_index.html"
cp "${outputFolder}/e2e_tests_build/static_web_test/index.html" "${outputFolder}/e2e_tests_build/static_web_test/invalid_sig_for_list_index.html"
cp "${outputFolder}/e2e_tests_build/static_web_test/index.html" "${outputFolder}/e2e_tests_build/static_web_test/server_error_for_list_index.html"
cp "${outputFolder}/e2e_tests_build/static_web_test/index.html" "${outputFolder}/e2e_tests_build/static_web_test/success_index.html"

# Inject test case specific variables into test case index files
sed -i "s/SERVER_URL_PLACEHOLDER/http:\/\/localhost:8201/" "${outputFolder}/e2e_tests_build/static_web_test/success_index.html"
sed -i "s/SERVER_URL_PLACEHOLDER/http:\/\/localhost:8301/" "${outputFolder}/e2e_tests_build/static_web_test/server_error_for_list_index.html"
sed -i "s/SERVER_URL_PLACEHOLDER/http:\/\/localhost:8401/" "${outputFolder}/e2e_tests_build/static_web_test/invalid_sig_for_list_index.html"
sed -i "s/SERVER_URL_PLACEHOLDER/http:\/\/localhost:8501/" "${outputFolder}/e2e_tests_build/static_web_test/invalid_sig_for_init_index.html"
