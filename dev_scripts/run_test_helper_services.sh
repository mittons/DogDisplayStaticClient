#!/bin/bash

script_dir=$(readlink -f $(dirname "$0")) # Determine script directory so we can store temp files here, like the one that tracks the PIDs of the processes we spawn.

# Load the .env file
if [ -f "$script_dir/dev_script_dependency_paths.env" ]; then
    source "$script_dir/dev_script_dependency_paths.env"
else
    echo "Error: dev_script_dependency_paths.env file not found."
    exit 1
fi

# Check if CHROMEDRIVER_PATH is set and not empty
if [[ -z "$CHROMEDRIVER_PATH" ]]; then
    echo "Error: CHROMEDRIVER_PATH is not set or is empty. Exiting the script."
    read -s -n 1 # Silent, waiting for any key press
    exit 1
fi

cleanup_done=false  # Ensure this flag is declared globally if it's used outside this function too

cleanup() {
    local flag_file="$script_dir/tmp_my_cleanup_flag_long_running_servers"
    
    # Prevent concurrent cleanup invocations
    if [[ -f "$flag_file" ]]; then
        return
    fi
    touch "$flag_file"  # Create a flag file indicating cleanup is in progress

    if ! $cleanup_done; then
        echo "Cleaning up..."
        while read -r pid; do
            kill -TERM "$pid" 2>/dev/null  # Gracefully terminate each server process
        done < "$script_dir/tmp_long_running_dog_service_pids.txt"
        rm -f "$script_dir/tmp_long_running_dog_service_pids.txt"  # Remove the PID file safely
        cleanup_done=true
    fi

    rm -f "$flag_file"  # Cleanup complete, remove the flag file
}

start_process() {
    $1 &  # Start the server as a background process
    echo $! >> "$script_dir/tmp_long_running_dog_service_pids.txt"  # Record its PID for later cleanup
}

# Setting traps for cleaning up on script exit or interruption
trap cleanup SIGINT SIGTERM
trap "cleanup; exit" EXIT

# Corrected and simplified start process commands
start_process "docker run -p 3019:8019 mockdogapidec19"
start_process "$CHROMEDRIVER_PATH --port=4444"


wait