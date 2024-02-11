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

###################
# NOTICE:
# NOTICE:
# NOTICE:
#    Following lines of text are written in the following context:
#       This is a solo practice project
#       This is not a collaborative project, no one (but me) will be subject to develop this code further
#       This is not a project bound by financial interests
#    SO:
#      I can write a ugly comment to:
#         Create a very solid memory marker for something i just learnt about and i want to remember (subshell commands).
#         Warn people not to read this in depth
#         Set anyone who reads this indepth up for an exercise in the concept of campfire rules.
#    
#    And ultimately.. let loose a bit and play.. do something more than just boilerplate.
#
#
#
#       But im not doing this kind of stuff by my own initiative in a professional context. 
#            Well.. at least not without consent from everyone it effects. Sometimes its good to break the mold. If it's done in the right way, and with permission!
#
#
#    Ps. If you are wondering.. it started out as a small comment.. then I just got more and more ideas and I kept adding. Usually I sanitize that kind of work.. but... every once in a while.. why not. ¯\_(ツ)_/¯.
# ^^^^NOTICE^^^^^^ 
# ^^^^NOTICE^^^^^^
# ^^^^NOTICE^^^^^^
###################

#####
# I run all the chained commands that change the current working directory inside a subshell (inside parentheses: "()"). 
# - This shouuuld.. according to chatgpt isolate the effects of the commands being run (like.. changing the current working directory.)
#   - This is not strictly nessecary here. Since nothing happens after those commands. 
#         - But it seems like a good practice, as it (should, (i havent tested if this actually does what chatgpt says it does), perserve state of the current script working env context.
#          - Since im writing tihs comment: Here is a snippet from my chat logs with the bot.. where i suggested it was like "campfire rules": (Their response to me making the connection to "campfire rules:")
#
#
#
#
# =================================================================================================
#     Exactly, you've got the right idea! The principle you're referring to is often called the
#
#                              "Leave No Trace"
#
#     principle in outdoor ethics, which can indeed be likened to the 
#
#                               "Campfire Rule" 
#
#     in software development and scripting contexts. This rule suggests 
#     that you should leave the environment (in this case, the execution environment of a 
#     script) as you found it, or in a better state if possible. This ensures that your code
#     doesn't have unintended side effects that could affect later parts of the script or other
#     scripts and processes that might be dependent on the same environment.
# =================================================================================================
#
#
#
#   -        So
#      - I decided to add this comment BECAUSE:
#
#             =============================
#             =                           =
#             = PLEASE             PLEASE =
#             =    READ FINAL SECTION     =
#             =============================#
#     --------NO NEED TO READ NEXT SECTION-------
#     --------NO NEED TO READ NEXT SECTION-------
#     --------NO NEED TO READ NEXT SECTION-------
#
#           ---- Reason (selfish):-
#             ---Im Writing long comment to create a 
#              --  memmory marker --
#           -- for something I just learnt that could be useful --
#
#    - I learnt about subshells (though.. i dont fully understand their functionality yes.. but I think it's putthing statements inside brackets? and it effects the current script env less?)
#             - Its cool. I think if i figure out what this does exactly.. then it might be useful. And I can code better.
#         - I mean, if the chatgpt service thing being/whatever is right... its better convention to subshell than not when changing directories and running stuff without the intention to change current working dir permanently....
#
#
#
#       PLEASE READ:
#
#          --- FINAL SECTION---
#
#
#     Campfire rules.
#
#  Evaluate the environment.
#           Is this a horrible comment?
#
#    If you edit this code. Or edit any environment.
#         Leave it the way you found it.
#      Or leave it in a BETTER state.
#
#
#  Feel free to remove/edit this comment if you work on this code and feel the code would be better without it or with changes.
#
#     
#
#
#
#


# Python Mock
python $DOG_DISPLAY_FOR_PYTHON_PATH/main.py & echo $! >> "$script_dir/tmp_test_server_pids.txt"

# Python Prod
export FLASK_ENV='production'
python $DOG_DISPLAY_FOR_PYTHON_PATH/main_dev.py & echo $! >> "$script_dir/tmp_test_server_pids.txt"
export FLASK_ENV=''

# C++ Mock
(cd $DOG_DISPLAY_FOR_CPP_MOCK_PATH && ./DogDisplayForCpp.exe & echo $! >> "$script_dir/tmp_test_server_pids.txt")

# C++ Prod
(cd $DOG_DISPLAY_FOR_CPP_PROD_PATH  && ./DogDisplayForCpp.exe & echo $! >> "$script_dir/tmp_test_server_pids.txt")

# PHP Mock
(cd $DOG_DISPLAY_FOR_PHP_MOCK_PATH && php artisan serve & echo $! >> "$script_dir/tmp_test_server_pids.txt")

# PHP Prod
(cd $DOG_DISPLAY_FOR_PHP_PROD_PATH && php artisan serve --port=8001 & echo $! >> "$script_dir/tmp_test_server_pids.txt")

wait