# Define the dev scripts directory and move into it
BUILD_SCRIPTS_DIR=$(readlink -f $(dirname "$0"))
cd "$BUILD_SCRIPTS_DIR"

cd ..
rm -rf build/

./build_scripts/build_e2e_tests.sh -t e2e_tests_staging/ -w static_web_staging/ -o ./build/ -p 7777

cd ./build/e2e_tests_build/
npm install
