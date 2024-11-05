#!/bin/sh

# Ensure required variables are set
if [ -z "$COMPANY_NAME" ]; then
  echo "Error: COMPANY_NAME is not set. Please provide the company name to be replaced."
  exit 1
fi

if [ -z "$REPO_URL" ]; then
  echo "Error: REPO_URL is not set. Please provide the repository URL for Gitea."
  exit 1
fi

# Use specified SSH key
export GIT_SSH_COMMAND="ssh -i ${SSH_KEY_PATH}"

# Set up directories with defaults
SRC_DIR="${SRC_DIR:-/src}"
DEST_DIR="${DEST_DIR:-/dest}"
GIT_USER="${GIT_USER:-username}"
GIT_EMAIL="${GIT_EMAIL:-email@example.com}"

# Configure Git
git config --global user.name "$GIT_USER"
git config --global user.email "$GIT_EMAIL"

# Sync from source to destination
cd "$SRC_DIR" || { echo "Error: Could not access source directory"; exit 1; }
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Ensure we're on main branch and pull latest changes
git checkout main || { echo "Error: Cannot switch to main branch"; exit 1; }
git pull || { echo "Error: Git pull failed"; exit 1; }

# Perform rsync, excluding unnecessary files
rsync -av --exclude='.github/' --exclude='.git/' --exclude='**/.terraform/' --exclude='**/.terragrunt-cache/' "$SRC_DIR/" "$DEST_DIR/"

# Replace company name text in destination files
find "$DEST_DIR" -type f -exec sed -i "s/${COMPANY_NAME}/company/gi" {} +

# Commit and push changes
cd "$DEST_DIR" || { echo "Error: Could not access destination directory"; exit 1; }
git add .
git commit -m "Automated sync and push" || echo "No changes to commit"
git push "$REPO_URL" || { echo "Error: Git push failed"; exit 1; }

echo "Sync and push completed successfully."
