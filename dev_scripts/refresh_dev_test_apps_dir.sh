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

####
# Create/recreate dev_test_apps_dir (rm -rf if it already exists for 'refresh')
##

DEV_TEST_APPS_DIR="dev_test_apps_dir"
rm -rf "$DEV_TEST_APPS_DIR"
mkdir "$DEV_TEST_APPS_DIR"
cd "$DEV_TEST_APPS_DIR"


####
# Fetch chromedriver (place exe into dev_test_apps_dir root)
##

# Determine the platform (Linux/WSL/Windows)
if [ "$OS" = "Windows_NT" ]; then
    PLATFORM="windows"
elif grep -qi microsoft /proc/version; then
    PLATFORM="wsl"
else
    PLATFORM="linux"
fi


# Set the ChromeDriver version
CHROMEDRIVER_VERSION="123.0.6312.105"

# Download and unzip ChromeDriver
if [ "$PLATFORM" = "windows" ] || [ "$PLATFORM" = "wsl" ]; then
    DOWNLOAD_URL="https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/win64/chromedriver-win64.zip"
    curl -o chromedriver-win64.zip "$DOWNLOAD_URL"

    unzip chromedriver-win64.zip
    chmod +x chromedriver-win64/chromedriver.exe
    # Cleanup
    rm chromedriver-win64.zip

    CHROMEDRIVER_PATH="$PWD/chromedriver-win64/chromedriver.exe"
else
    DOWNLOAD_URL="https://storage.googleapis.com/chrome-for-testing-public/$CHROMEDRIVER_VERSION/linux64/chromedriver-linux64.zip"
    wget -o chromedriver-linux64.zip "$DOWNLOAD_URL"
    unzip chromedriver-linux64.zip
    chmod +x chromedriver-linux64/chromedriver
    # Cleanup
    rm chromedriver-linux64.zip

    CHROMEDRIVER_PATH="$PWD/chromedriver-linux64/chromedriver"
fi

####
# Clone projects into dev_test_apps_dir
##
# Cpp
git clone "https://github.com/mittons/DogDisplayForCpp.git"
cp -r "DogDisplayForCpp" "DogDisplayForCpp_Prod"
mv "DogDisplayForCpp" "DogDisplayForCpp_Mock"

# PHP
git clone "https://github.com/mittons/DogDisplayForPhp.git"
cp -r "DogDisplayForPhp" "DogDisplayForPhp_Prod"
mv "DogDisplayForPhp" "DogDisplayForPhp_Mock"

# Python
git clone "https://github.com/mittons/DogDisplayForPython.git"

# MockDogApi
git clone "https://github.com/mittons/MockDogApiDec19.git"

####
# Build docker image for mockapi
##

cd "MockDogApiDec19"
docker build -t mockdogapidec19 .
cd ..

####
# Build projects (including making copies of cloned repos if needed)
##

# Python
DOG_DISPLAY_FOR_PYTHON_PATH="$PWD/DogDisplayForPython"

# CppMock
cd DogDisplayForCpp_Mock

build_script.sh

DOG_DISPLAY_FOR_CPP_MOCK_PATH="$PWD"
cd ..

# CppProd

cd DogDisplayForCpp_Prod

build_script.sh -p

DOG_DISPLAY_FOR_CPP_PROD_PATH="$PWD"
cd ..

# PhpMock
cd DogDisplayForPhp_Mock
cp .env-example .env
sed -i "s|DOG_SERVICE_BASE_URL=.*|DOG_SERVICE_BASE_URL='http://localhost:3019'|" .env

composer install

DOG_DISPLAY_FOR_PHP_MOCK_PATH="$PWD"
cd ..

# PhpProd
cd DogDisplayForPhp_Prod
cp .env-example .env

composer install

DOG_DISPLAY_FOR_PHP_PROD_PATH="$PWD"
cd ..

cd "$DEV_SCRIPTS_DIR"

####
# Build env file with paths
##

ENV_FILE="./dev_script_dependency_paths.env"
TEMPLATE_ENV_FILE="./dev_script_dependency_paths.env-example"
if [ ! -f "$ENV_FILE" ]; then
    cp "$TEMPLATE_ENV_FILE" "$ENV_FILE"
fi

# Sed relevant paths into env file
sed -i "s|CHROMEDRIVER_PATH=.*|CHROMEDRIVER_PATH=\"$CHROMEDRIVER_PATH\"|" "$ENV_FILE"

sed -i "s|DOG_DISPLAY_FOR_PYTHON_PATH=.*|DOG_DISPLAY_FOR_PYTHON_PATH=\"$DOG_DISPLAY_FOR_PYTHON_PATH\"|" "$ENV_FILE"
sed -i "s|DOG_DISPLAY_FOR_PHP_MOCK_PATH=.*|DOG_DISPLAY_FOR_PHP_MOCK_PATH=\"$DOG_DISPLAY_FOR_PHP_MOCK_PATH\"|" "$ENV_FILE"
sed -i "s|DOG_DISPLAY_FOR_PHP_PROD_PATH=.*|DOG_DISPLAY_FOR_PHP_PROD_PATH=\"$DOG_DISPLAY_FOR_PHP_PROD_PATH\"|" "$ENV_FILE"

sed -i "s|DOG_DISPLAY_FOR_CPP_MOCK_PATH=.*|DOG_DISPLAY_FOR_CPP_MOCK_PATH=\"$DOG_DISPLAY_FOR_CPP_MOCK_PATH\"|" "$ENV_FILE"
sed -i "s|DOG_DISPLAY_FOR_CPP_PROD_PATH=.*|DOG_DISPLAY_FOR_CPP_PROD_PATH=\"$DOG_DISPLAY_FOR_CPP_PROD_PATH\"|" "$ENV_FILE"


# TODO: Add other `sed` commands for paths required by the env file that are created as a result of this script.

# Return to initial directory just in case
cd "$DEV_SCRIPTS_DIR"
