#!/bin/bash

# Usage function to guide the user on how to run the script correctly
usage() {
    echo "Usage: $0 <port>"
    echo "  <port>: Port number for the local test server"
    exit 1
}

# Check if exactly one argument (the port number) is provided
if [ "$#" -ne 1 ]; then
    usage
fi

PORT="$1"
SCRIPT_DIR="$(dirname "$0")"

# Change to the script's directory to ensure relative paths work as expected
cd "$SCRIPT_DIR" || { echo "Failed to change directory to $SCRIPT_DIR"; exit 1; }

# Export the port number so it's accessible to the middleware servers
export TEST_WEB_SERVER_PORT=$PORT

# Function to start a middleware server process in the background
start_process() {
    node "$1" &  # Start the server as a background process
    echo $! >> "./tmp_running_middleware_pids.txt"  # Record its PID for later cleanup
}

# Flag to prevent multiple cleanup invocations
cleanup_done=false

# Cleanup function to terminate all started middleware servers
cleanup() {
    local flag_file="./tmp_my_cleanup_flag"
    
    # Prevent concurrent cleanup invocations
    if [[ -f "$flag_file" ]]; then
        return
    fi
    touch "$flag_file"  # Create a flag file indicating cleanup is in progress

    if ! $cleanup_done; then
        echo "Cleaning up..."
        while read -r pid; do
            kill -TERM "$pid" 2>/dev/null  # Gracefully terminate each server process
        done < "./tmp_running_middleware_pids.txt"
        rm "./tmp_running_middleware_pids.txt"  # Remove the PID file
        cleanup_done=true
    fi

    rm -f "$flag_file"  # Cleanup complete, remove the flag file
}

# Setup traps to ensure cleanup happens on script exit or interrupt signals
trap cleanup SIGINT SIGTERM
trap "cleanup; exit" EXIT

# Start each middleware server using the start_process function
start_process dog_network_delay_proxy.js
start_process dog_error_proxy.js
start_process dog_invalid_sig_list_proxy.js
start_process dog_invalid_sig_init_proxy.js

# Wait for all background processes to finish (i.e., until they are manually terminated)
wait

# Code powered by OpenAI, ChatGPT-4.