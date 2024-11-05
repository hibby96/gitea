# Repo Sync Tool

This Dockerized tool automatically syncs a local repository to a Gitea server, applying transformations like company name replacements. It runs on a regular schedule, updating the destination repo whenever changes are detected.

### Overview

- **Syncs files** from a local source to a destination directory, with configurable text replacements.
- **Pushes changes** to a Gitea repository using SSH for secure access.
- **Customizable** with environment variables to fit each company's setup.
- **Reverse Sync Option** to pull updates from Gitea back to your local repository.

### Prerequisites

1. **Gitea Account and Repository**:
   - Create a Gitea user account if you don’t already have one.
   - Generate a personal access token in Gitea for authentication and use it in `REPO_URL`.

2. **SSH Key**:
   - Generate an SSH key pair for secure Git access:
     ```bash
     ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
     ```
   - Add the **public key** (`id_ed25519.pub`) to your Gitea account under **SSH Keys**.

3. **Local Directories**:
   - **Source Directory**: Path to the local repository to be synced (`/src`).
   - **Destination Directory**: Path where files are modified and then pushed to Gitea (`/dest`).

### Setup and Usage

1. **Build the Docker Image**:
   ```bash
   docker build -t sync-and-push .
   ```

2. **Run the Container**:
   Customize paths and environment variables as needed:
   ```bash
   docker run -d --rm \
     -v ~/.ssh/id_ed25519:/root/.ssh/id_ed25519:ro \
     -v /path/to/local/source:/src \
     -v /path/to/local/destination:/dest \
     -e REPO_URL="http://user:token@gitea-server/repo-path.git" \
     -e GIT_USER="your-username" \
     -e GIT_EMAIL="your-email@example.com" \
     -e COMPANY_NAME="YourCompanyName" \
     -e SYNC_INTERVAL=300 \
     sync-and-push
   ```

### Reverse Sync Script

The `reverse_sync.sh` script pulls changes from the Gitea repository back into your local source directory, ensuring it stays in sync with the latest updates.

#### Usage
1. **Run Reverse Sync**:
   ```bash
   ./reverse_sync.sh <branch_name>
   ```
   Replace `<branch_name>` with the branch you want to sync.

2. **Environment Variables**:
   - **`SRC_DIR`**: The Gitea-synced directory (default: `/src`).
   - **`DEST_DIR`**: The local repository directory to sync changes to (default: `/dest`).

#### Example Command
```bash
SRC_DIR="/path/to/gitea/infrastructure" DEST_DIR="/path/to/local/infrastructure" ./reverse_sync.sh main
```

This script is useful for keeping local repositories up-to-date with changes from Gitea, especially for collaboration or testing purposes.

### Environment Variables

- **`REPO_URL`**: Full URL for the Gitea repository, including the username and personal access token.
- **`GIT_USER`** / **`GIT_EMAIL`**: Used for Git commit configurations.
- **`COMPANY_NAME`**: Name to be replaced in files (case-insensitive) with `"company"`.
- **`SYNC_INTERVAL`**: Interval (in seconds) between sync operations (default: 300).

### Additional Notes

- **Source (`/src`)**: Contains the original repository files.
- **Destination (`/dest`)**: Where files are modified, with `COMPANY_NAME` replaced by `"company"`, and then pushed to Gitea.

This setup keeps your Gitea repo synchronized with local changes, applying automated transformations for easy rebranding or anonymization.