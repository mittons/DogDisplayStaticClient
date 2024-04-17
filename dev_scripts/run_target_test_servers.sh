#!/bin/bash

cleanup_done=false  # Initialize the cleanup_done flag

script_dir=$(readlink -f $(dirname "$0")) # Determine script directory so we can store temp files here, like the one that tracks the PIDs of the processes we spawn.

# Load the dev_script_dependency_paths.env file
if [ -f "$script_dir/dev_script_dependency_paths.env" ]; then
    source "$script_dir/dev_script_dependency_paths.env"
else
    echo "Error: dev_script_dependency_paths.env file not found."
    exit 1
fi

# Validate required environment variables
variables=("DOG_DISPLAY_FOR_PYTHON_PATH" "DOG_DISPLAY_FOR_CPP_MOCK_PATH" "DOG_DISPLAY_FOR_CPP_PROD_PATH" "DOG_DISPLAY_FOR_PHP_MOCK_PATH" "DOG_DISPLAY_FOR_PHP_PROD_PATH")
for var in "${variables[@]}"; do
    if [[ -z "${!var}" ]]; then  # Indirect reference to check if variable is set
        echo "Error: $var is not set or is empty. Exiting the script."
        read -s -n 1 # Pause for user to see the message
        exit 1
    fi
done

cleanup() {
    local flag_file="$script_dir/tmp_my_cleanup_flag_test_servers"
    
    # Prevent concurrent cleanup invocations
    if [[ -f "$flag_file" ]]; then
        return
    fi
    touch "$flag_file"  # Create a flag file indicating cleanup is in progress

    if ! $cleanup_done; then
        echo "Cleaning up..."

        if [[ -f "$script_dir/tmp_test_server_pids.txt" ]]; then
            while read -r pid; do
                kill -TERM "$pid" 2>/dev/null  # Gracefully terminate each server process
            done < "$script_dir/tmp_test_server_pids.txt"
            rm -f "$script_dir/tmp_test_server_pids.txt"  # Remove the PID file safely
        fi
        cleanup_done=true
    fi

    rm -f "$flag_file"  # Cleanup complete, remove the flag file
}

start_process() {
    "$1" &  # Start the server as a background process
    echo $! >> "$script_dir/tmp_test_server_pids.txt"  # Record its PID for later cleanup
}

# Set trap commands to handle cleanup on signals and exit
trap cleanup SIGINT SIGTERM
trap "cleanup; exit" EXIT


# Determine the platform (Windows/WSL/Linux)
if [ "$OS" = "Windows_NT" ] || grep -qi microsoft /proc/version; then
    DOG_DISPLAY_FOR_CPP_EXE_PATH="/build/src/Release"
    DOG_DISPLAY_FOR_CPP_EXE_FILE="./DogDisplayForCpp.exe"
else
    DOG_DISPLAY_FOR_CPP_EXE_PATH="/build/src"
    DOG_DISPLAY_FOR_CPP_EXE_FILE="./DogDisplayForCpp"
fi


# Python Mock
python $DOG_DISPLAY_FOR_PYTHON_PATH/main.py & echo $! >> "$script_dir/tmp_test_server_pids.txt"

# Python Prod
export FLASK_ENV='production'
python $DOG_DISPLAY_FOR_PYTHON_PATH/main.py & echo $! >> "$script_dir/tmp_test_server_pids.txt"
export FLASK_ENV=''


# Determine the platform (Windows/WSL/Linux)
if [ "$OS" = "Windows_NT" ] || grep -qi microsoft /proc/version; then
    DOG_DISPLAY_FOR_CPP_EXE_PATH="/build/src/Release"
    # C++ Mock
    (cd "$DOG_DISPLAY_FOR_CPP_MOCK_PATH$DOG_DISPLAY_FOR_CPP_EXE_PATH" && ./DogDisplayForCpp.exe & echo $! >> "$script_dir/tmp_test_server_pids.txt")

    # C++ Prod
    (cd "$DOG_DISPLAY_FOR_CPP_PROD_PATH$DOG_DISPLAY_FOR_CPP_EXE_PATH" && ./DogDisplayForCpp.exe & echo $! >> "$script_dir/tmp_test_server_pids.txt")
else
    DOG_DISPLAY_FOR_CPP_EXE_PATH="/build/src"
    # C++ Mock
    (cd "$DOG_DISPLAY_FOR_CPP_MOCK_PATH$DOG_DISPLAY_FOR_CPP_EXE_PATH" && chmod +x ./DogDisplayForCpp && ./DogDisplayForCpp & echo $! >> "$script_dir/tmp_test_server_pids.txt")

    # C++ Prod
    (cd "$DOG_DISPLAY_FOR_CPP_PROD_PATH$DOG_DISPLAY_FOR_CPP_EXE_PATH" && chmod +x ./DogDisplayForCpp && ./DogDisplayForCpp & echo $! >> "$script_dir/tmp_test_server_pids.txt")
fi

# PHP Mock
(cd $DOG_DISPLAY_FOR_PHP_MOCK_PATH && php artisan serve & echo $! >> "$script_dir/tmp_test_server_pids.txt")

# PHP Prod
(cd $DOG_DISPLAY_FOR_PHP_PROD_PATH && php artisan serve --port=8001 & echo $! >> "$script_dir/tmp_test_server_pids.txt")

wait