
import subprocess
import sys
import os

def create_third_party_licenses(module_name, path_to_license_data_dir):
    with open("THIRD_PARTY_LICENSES_{}.latest".format(module_name), 'w', encoding="utf-8") as outfile:
        with open("{}/js_licenses.txt".format(path_to_license_data_dir), 'r', encoding="utf-8") as js_licenses:
            outfile.write('JavaScript Licenses:')
            outfile.write(js_licenses.read())
            outfile.write('')

        with open("{}/python_licenses.txt".format(path_to_license_data_dir), 'r', encoding="utf-8") as py_licenses:
            outfile.write('Python Licenses:')
            outfile.write(py_licenses.read())

    print("THIRD_PARTY_LICENSES.latest file created.")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: generate_third_party_licenses.py module_name path/to/rawlicensedata/dir/)")
    
    module_name = sys.argv[1]
    path_to_license_data_dir = sys.argv[2]

    create_third_party_licenses(module_name, path_to_license_data_dir)


