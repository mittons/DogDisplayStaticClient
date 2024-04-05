Hey. Im writing a bash script.

Ive outline the steps in a markdown file. Can you help me write as much of it as you can using the markdown todos i will include in this message, and for anything I dont give enough context for you to write concrete lines of code you could insert commented sections in the script file that act as kind of placeholders for the code sections that arent fully defined by the markdown steps.

Ive written the first bit of the script:

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


Here are the todos:
- [ ] Write env setup script steps:
    - [ ] Move to current folder (called dev_scripts)
    - [ ] Move to parent folder
    - [ ] Create/recreate dev_test_apps_dir (rm rf if it already exists for 'refresh')
    - [ ] Nav into dev_test_apps_dir
    - [ ] Fetch chromdriver (place exe into dev_test_apps_dir root)
    - [ ] Clone projects into dev_test_apps_dir
        - [ ] git clone "https://github.com/mittons/DogDisplayForCpp.git"
        - [ ] git clone "https://github.com/mittons/DogDisplayForPhp.git"
        - [ ] git clone "https://github.com/mittons/DogDisplayForPython.git"
        - [ ] git clone "https://github.com/mittons/MockDogApiDec19.git"
    - [ ] Build docker image for mockapi
        - [ ] Nav into mock api folder
        - [ ] Run docker build statement (image should be called mockdogapidec19)
        - [ ] Nav back out
    - [ ] Build projects (including making copies of cloned repos if needed)
        - [ ] CppMock
        - [ ] CppProd
        - [ ] PhpMock
        - [ ] PhpProd
        - [ ] Python?
    - [ ] Nav back to dev_scripts folder we started in
    - [ ] Build env file with paths 
        - [ ] If env file (./dev_script_dependency_paths.env) doesnt exist in folder, copy the template env file (./dev_script_dependency_paths.env-example) to env file(./dev_script_dependency_paths.env-example).
        - [ ] Sed relevant paths into env file (use absolute system paths, doublequote escaped).
            - [ ] Chromedriver exe path should go into the line that starts with 'CHROMEDRIVER_PATH=' (single quotes are not part of the line) and should end up something like 'CHROMEDRIVER_PATH="/path/to/chromedriver/exe"' (single quotes are not part of the line).
            - [ ] Sed other parts required by the env file that are created as a result of this script. 