#!/bin/bash

####
# Script that refreshes the dev_test_apps_dir folder
# - A folder containing temporary copies of most/all of the application executables we use for the "automate_full_test_cycle.sh scripts"
# - Script assumes we are inside DogDisplayStaticClient repo dir, specifically rootDir/dev_scripts.
#   - Script assumes the dev_test_apps_dir folder should be located at rootDir/dev_test_apps_dir.
# Also creates/updates the local env file with paths for any programs inside the dev_test_apps_dir. 
##

# Define the dev scripts directory and move into it
DEV_SCRIPTS_DIR=$(readlink -f $(dirname "$0"))
cd "$DEV_SCRIPTS_DIR"

# Move to parent folder
cd ..

# Create/recreate dev_test_apps_dir (rm -rf if it already exists for 'refresh')
DEV_TEST_APPS_DIR="dev_test_apps_dir"
rm -rf "$DEV_TEST_APPS_DIR"
mkdir "$DEV_TEST_APPS_DIR"
cd "$DEV_TEST_APPS_DIR"

# Fetch chromedriver (place exe into dev_test_apps_dir root)
# TODO: Add commands to download chromedriver and place it in the current directory.

# Clone projects into dev_test_apps_dir
git clone "https://github.com/mittons/DogDisplayForCpp.git"
git clone "https://github.com/mittons/DogDisplayForPhp.git"
git clone "https://github.com/mittons/DogDisplayForPython.git"
git clone "https://github.com/mittons/MockDogApiDec19.git"

# Build docker image for mockapi
cd "MockDogApiDec19"
# TODO: Replace with actual Docker build command, assuming Dockerfile is present
docker build -t mockdogapidec19 .
cd ..

# Placeholder for building projects. Replace with actual build commands for each project.
# Build projects (including making copies of cloned repos if needed)
# - CppMock
# - CppProd
# - PhpMock
# - PhpProd
# - Python?

cd "$DEV_SCRIPTS_DIR"

# Build env file with paths
ENV_FILE="./dev_script_dependency_paths.env"
TEMPLATE_ENV_FILE="./dev_script_dependency_paths.env-example"
if [ ! -f "$ENV_FILE" ]; then
    cp "$TEMPLATE_ENV_FILE" "$ENV_FILE"
fi

# Sed relevant paths into env file
CHROMEDRIVER_PATH="$PWD/../$DEV_TEST_APPS_DIR/chromedriver" # Adjust this path as necessary
sed -i "s|CHROMEDRIVER_PATH=.*|CHROMEDRIVER_PATH=\"$CHROMEDRIVER_PATH\"|" "$ENV_FILE"

# TODO: Add other `sed` commands for paths required by the env file that are created as a result of this script.

# Return to initial directory just in case
cd "$DEV_SCRIPTS_DIR"
