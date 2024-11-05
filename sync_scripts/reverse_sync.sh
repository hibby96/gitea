#!/bin/bash

# Usage message
if [ -z "$1" ]; then
    echo "Usage: $0 <branch_name>"
    echo "Environment variables:"
    echo "  SRC_DIR - Source directory (default: /src)"
    echo "  DEST_DIR - Destination directory (default: /dest)"
    exit 1
fi

# Define source and destination directories with defaults
SRC_DIR="${SRC_DIR:-/src}"
DEST_DIR="${DEST_DIR:-/dest}"
BRANCH_NAME="$1"

# Ensure destination directory exists and switch to it
cd "$DEST_DIR" || { echo "Error: Could not access destination directory"; exit 1; }

# Check out and pull the specified branch
git checkout "$BRANCH_NAME" && git pull origin "$BRANCH_NAME" || { echo "Error: Could not switch branches or pull updates"; exit 1; }

# Sync from destination to source, excluding certain directories
rsync -av --exclude='.git/' --exclude='**/.terraform/' --exclude='**/.terragrunt-cache/' "$SRC_DIR/" "$DEST_DIR/"

# Completion message
echo "Reverse sync completed successfully."
