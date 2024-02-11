#!/bin/bash

# This script is intended to perform the operations required to:
#   Generate an exact list of the licenses of third party creations that e2e_tests module in this code base relies upon.
#   Output the latest generated version of the list into a file within this directory:
#        THIRD_PARTY_LICENSES_static_web_client.latest
#   And optionally, if supplied with path as its first argument, it copies the newly generated file to the directory
#       Stripping latest from the name: THIRD_PARTY_LICENSES_static_web_client
#       Overwriting any files already existing at that location with the same name


# Store script dir as variable
script_dir=$(readlink -f $(dirname "$0")) 

# Ensure we are working from the scripts directory
cd $script_dir

# Ensure we have a fresh version of the intermediate data folder
rm -rf intermediate_data_static_web
mkdir intermediate_data_static_web

# Go to module dir
cd ../lets_go/static_web_build

# Install dependenices
npm install

# Exctract js license data
license-checker \
    --customPath=$script_dir/customLicenceFormat.json \
    --relativeLicensePath | grep -v 'path:' > $script_dir/intermediate_data_static_web/js_licenses.txt


# Navigate back to the scripts directory
cd $script_dir

# Create the license file
cp $script_dir/intermediate_data_static_web/js_licenses.txt THIRD_PARTY_LICENSES_static_web_client.latest

echo "THIRD_PARTY_LICENSES_static_web_client.latest file created."



# Check if an argument (path) was provided
if [ ! -z "$1" ]; then
    # Copy the file to the provided path, dropping the '.latest' suffix
    cp THIRD_PARTY_LICENSES_static_web_client.latest "$1/THIRD_PARTY_LICENSES_static_web_client"
    echo "Copied THIRD_PARTY_LICENSES_static_web_client.latest to $1/THIRD_PARTY_LICENSES_static_web_client"
fi


# Clean up intermediate data
rm -rf intermediate_data_static_web