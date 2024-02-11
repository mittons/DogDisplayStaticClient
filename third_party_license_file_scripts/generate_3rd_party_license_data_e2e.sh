#!/bin/bash

# This script is intended to perform the operations required to:
#   Generate an exact list of the licenses of third party creations that e2e_tests module in this code base relies upon.
#   Output the latest generated version of the list into a file within this directory:
#        THIRD_PARTY_LICENSES_e2e_tests.latest
#   And optionally, if supplied with path as its first argument, it copies the newly generated file to the directory
#       Stripping latest from the name: THIRD_PARTY_LICENSES_e2e_tests
#       Overwriting any files already existing at that location with the same name



# Store script dir as variable
script_dir=$(readlink -f $(dirname "$0")) 

# Ensure we are working from the scripts directory
cd $script_dir

# Ensure we have a fresh version of the intermediate data folder
rm -rf intermediate_data_e2e
mkdir intermediate_data_e2e

# Ensure we enter a fresh unaltered venv
rm -rf venv
python -m venv venv
source venv/Scripts/activate

# Go to module dir
cd ../lets_go/e2e_tests_build

# Install dependenices
npm install
pip install -r requirements.txt

# Extract pip license data
pip-licenses.exe --python=$script_dir/venv/Scripts/python.exe \
    --format=plain-vertical -l \
    --output-file $script_dir/intermediate_data_e2e/python_licenses.txt

# Exctract js license data
license-checker \
    --customPath=$script_dir/customLicenceFormat.json \
    --relativeLicensePath | grep -v 'path:' > $script_dir/intermediate_data_e2e/js_licenses.txt


# Navigate back to the scripts directory
cd $script_dir


# Deactivate the isolated python env used to set up the exact dependencies of the project
deactivate

# Synthesize the license file from intermediate data
echo "JavaScript Licenses:" > THIRD_PARTY_LICENSES_e2e_tests.latest
cat intermediate_data_e2e/js_licenses.txt >> THIRD_PARTY_LICENSES_e2e_tests.latest

echo "" >> THIRD_PARTY_LICENSES_e2e_tests.latest

echo "Python Licenses:" >> THIRD_PARTY_LICENSES_e2e_tests.latest
cat intermediate_data_e2e/python_licenses.txt >> THIRD_PARTY_LICENSES_e2e_tests.latest

echo "THIRD_PARTY_LICENSES_e2e_tests.latest file created."


# Check if an argument (path) was provided
if [ ! -z "$1" ]; then
    # Copy the file to the provided path, dropping the '.latest' suffix
    cp THIRD_PARTY_LICENSES_e2e_tests.latest "$1/THIRD_PARTY_LICENSES_e2e_tests"
    echo "Copied THIRD_PARTY_LICENSES_e2e_tests.latest to $1/THIRD_PARTY_LICENSES_e2e_tests"
fi


# Clean up intermediate data
rm -rf intermediate_data_e2e