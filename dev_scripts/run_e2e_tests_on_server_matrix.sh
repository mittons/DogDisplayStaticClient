#!/bin/bash

# This script orchestrates end-to-end testing across a matrix of servers, each running
# different language implementations and data service configurations:
#    [(C++,PHP,Python)  x  (prod API, mock API)].
#It ensures a# comprehensive validation of API functionality and reliability across different implementations in various environments.

# Usage message
usage() {
    echo "Usage: $0 <base_path>"
    echo "  <base_path>  The base directory path containing the e2e_tests_build folder"
    exit 1
}

# Check for correct number of arguments
if [ "$#" -ne 1 ]; then
    usage
fi

BASE_PATH="$1"
E2E_TESTS_PATH="$BASE_PATH/e2e_tests_build"

# Array of port numbers to iterate over
PORTS=(5678 5679 7776 7777 8000 8001)

# Iterate over each port
for PORT in "${PORTS[@]}"; do
    echo "Running middleware and tests on port $PORT..."
    
    # Start the middleware in the background
    "$E2E_TESTS_PATH/utils/middleware/run_all_middleware.sh" $PORT &
    MIDDLEWARE_PID=$!

    # Give some time for middleware to initialize
    sleep 5

    # Run selenium tests
    if python "$E2E_TESTS_PATH/sel_run_tests.py"; then
        echo "All tests passed on port $PORT."
    else
        echo "Test failures detected on port $PORT."
        kill $MIDDLEWARE_PID
        exit 1
    fi

    # Kill the middleware process
    kill -TERM $MIDDLEWARE_PID 2>/dev/null

    # Give some time for middleware to die
    sleep 5
    echo "Completed tests for port $PORT. Moving to next port..."
    echo " "
done

echo "All tests completed successfully across all ports."

# Code powered by OpenAI, ChatGPT-4.
