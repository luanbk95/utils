#!/bin/bash

COLOR_TITLE="\033[1;94m"
COLOR_msg="\033[34m"
COLOR_MSG="\033[1;34m"
COLOR_info="\033[36m"
COLOR_INFO="\033[1;36m"
COLOR_DUMP="\033[2;37m"
COLOR_ERROR="\033[1;31m"
COLOR_warn="\033[93m"
COLOR_WARN="\033[1;93m"
COLOR_section="\033[95m"
COLOR_SECTION="\033[1;95m"
COLOR_pass="\033[32m"
COLOR_PASS="\033[1;32m"
COLOR_RESET="\033[0m"

# message $COLOR $MSG
message() {
    echo -e "${1}${2}${COLOR_RESET}"
}

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  message $COLOR_ERROR "Usage: $0 {soc-dev|soc-prod|soc-stag|us-prod|us-prod-ceph}"
  exit 1
fi

# Define the source files
CONFIG_DIR=~/.kube
TARGET_FILE="$CONFIG_DIR/config"
SOURCE_FILE="config-$1"

# Validate the argument
if [ "$1" != "soc-prod" ] && [ "$1" != "soc-stag" ] && [ "$1" != "soc-dev" ] && [ "$1" != "us-prod" ] && [ "$1" != "us-prod-ceph" ]; then
  message $COLOR_ERROR "Error: Argument must be 'soc-prod' or 'soc-stag' or 'soc-dev' or 'us-prod' or 'us-prod-ceph'."
  exit 1
fi

# Perform the file overwrite
if [ -f "$CONFIG_DIR/$SOURCE_FILE" ]; then
  cp "$CONFIG_DIR/$SOURCE_FILE" "$TARGET_FILE"
  message $COLOR_PASS "Successfully overwritten \"$TARGET_FILE\" with \"$CONFIG_DIR/$SOURCE_FILE\""
else
  message $COLOR_ERROR "Error: Source file \"$CONFIG_DIR/$SOURCE_FILE\" does not exist."
  exit 1
fi
kubectl get node -o wide
