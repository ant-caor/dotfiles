# Docker Installation and Uninstallation Script

This script automates the uninstallation and installation of Docker on macOS, specifically for Apple Silicon (M1/M2) systems.

## Prerequisites

Ensure that you have the following before running the script:
- macOS with Apple Silicon (M1/M2)
- Administrator privileges (sudo access)

## Features

- Completely removes existing Docker installations
- Downloads and installs the latest Apple Silicon-compatible Docker version
- Automatically starts Docker after installation
- Avoids multiple password prompts using `sudo` session persistence

## Usage

### 1. Download the script

Save the script as `setup.sh` on your machine.

### 2. Make the script executable

```bash
chmod +x setup.sh
```

### 3. Run the script

Execute the script with administrator privileges:

```bash
./setup.sh
```

## What the Script Does

1. **Uninstalls Docker:**
   - Removes Docker application and related binaries
   - Deletes Docker configuration and cache files
   - Cleans up Docker-related directories

2. **Installs Docker:**
   - Downloads the latest Docker DMG for Apple Silicon
   - Installs Docker to `/Applications`
   - Launches Docker after installation

## Troubleshooting

- If the script fails to locate Docker after installation, ensure Docker is opened manually to add it to the system path.
- If permission errors occur, ensure you have `sudo` privileges and try running the script again.

## Known Issues

- Some directories may have restricted permissions and require manual removal.
- If the script hangs on startup, check for any prompts requiring user input.

## Author

This script was created to simplify Docker management on Apple Silicon Macs.

---

**Disclaimer:** Use this script at your own risk. Ensure you have backups of important data before running.

