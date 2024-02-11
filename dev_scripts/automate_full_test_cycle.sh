#!/bin/bash

echo "Starting the full test cycle..."
echo ""

script_dir=$(readlink -f $(dirname "$0"))

# Navigate to the script's directory to ensure relative paths work
cd "$script_dir"

# Load the .env file
if [ -f "$script_dir/dev_script_dependency_paths.env" ]; then
    source "$script_dir/dev_script_dependency_paths.env"
else
    echo "Error: dev_script_dependency_paths.env file not found."
    exit 1
fi

# Check if DOGGO_BASH_PATH is set and not empty
if [[ -z "$DOGGO_BASH_PATH" ]]; then
    echo "Error: DOGGO_BASH_PATH is not set or is empty. Exiting the script."
    read -s -n 1 # Silent, waiting for any key press
    exit 1
fi

# Start test helper services
echo "Starting test helper services..."
"$DOGGO_BASH_PATH" -c "./run_test_helper_services.sh" &
sleep 10
echo "Test helper services started."

# Start target test servers
echo "Starting target test servers..."
"$DOGGO_BASH_PATH" -c "./run_target_test_servers.sh" &
sleep 10
echo "Target test servers started."

# Serve static files for tests
echo "Serving static files for tests..."
"$DOGGO_BASH_PATH" -c "cd .. && ./bcd.sh && node ./lets_go/e2e_tests_build/utils/serve_static_for_tests.js" &
sleep 30
echo "Static files being served."

# Run end-to-end tests on server matrix
echo "Running end-to-end tests on server matrix..."
"$DOGGO_BASH_PATH" -c "cd .. && ./dev_scripts/run_e2e_tests_on_server_matrix.sh ./lets_go/; exec bash" &
echo "End-to-end tests initiated."

echo ""

echo "Full test cycle initiated. Please check individual process logs for progress."
