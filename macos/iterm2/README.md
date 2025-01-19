# Setting Up iTerm2 on Mac

This guide describes how to set up iTerm2 using a bash script that automates the installation and configuration process. The script file `setup_iterm2.sh` is located in the same directory as this Markdown file.

## Prerequisites

Before running the script, ensure you have the following:
- **Homebrew**: The script uses Homebrew to install iTerm2. If Homebrew is not installed, the script will attempt to install it.
- **Administrative access**: Installing Homebrew and iTerm2 requires admin rights on the machine.

## Installation Steps

1. **Make the Script Executable**

   Open Terminal and navigate to the directory containing this Markdown and the script file. Run the following command to make the script executable:

   ```bash
   chmod +x setup_iterm2.sh
   ```

    This command changes the script's permissions, allowing it to be executed.

2. **Run the script**

    Once the script is executable, you can run it to install and configure iTerm2. In the Terminal, still within the directory containing the script, execute it by typing:

    ```bash
    ./setup_iterm2.sh
    ```

    *What the script does*

    - Checks for Homebrew: It checks if Homebrew is installed and installs it if it isn't.
    - Installs iTerm2: It checks if iTerm2 is already installed and installs it if necessary.
    - Applies Preferences: The script tries to find and apply your custom iTerm2 preferences from the specified dotfiles directory.
    - Uses Default Preferences: If the custom preferences file is not found, it applies a default set stored in the same directory.

3. **Verify installation**

    After the script completes, open iTerm2 to check if it reflects the preferences applied. If not, you may need to manually restart iTerm2 or your computer to ensure all settings are refreshed.




