# macOS Setup Scripts

This folder contains scripts and configuration files for **automating** the setup and configuration of macOS environments. These scripts ensure that essential software is installed and key system settings are configured for a smooth developer experience.

## Usage

1. **Prepare Your Environment**

   - **Administrative Access**: Make sure you have sudo privileges (or an admin account) to install software system-wide.
   - **Prerequisites**: Some scripts assume you have [Homebrew](https://brew.sh/) installed. If not, the scripts may attempt to install it automatically.

2. **Run Setup Scripts**

   To run a script, open your terminal, navigate to this directory, make the script executable (if it isn’t already), and then execute it. For example:

   ```bash
   chmod +x script-name.sh
   ./script-name.sh
   ```

   Each script will typically install applications, fonts, libraries, or plugins as defined in its instructions or inline comments.

## What Gets Installed?

Depending on the script you run, you can expect some or all of the following:

- **iTerm2**  
  A powerful, customizable terminal emulator for macOS.

- **Nerd Fonts**  
  - **FiraMono Nerd Font** (for normal ASCII text)
  - **Symbols Nerd Font** (for extended glyphs and icons)
  - **Powerline Symbols** (legacy powerline characters)

  These fonts ensure you can see all powerline icons, branch glyphs, and emoji in your shell prompt without missing characters.

- **Shell Plugins**  
  - **zsh-syntax-highlighting**: Highlights commands as you type, based on the correctness or existence of the command.  
  - **zsh-autosuggestions**: Suggests commands as you type, based on your history and completions.

- **Starship Prompt**  
  A minimal, blazing-fast shell prompt that displays useful information (e.g., Git status, directory path, language versions). Our included `starship.toml` configuration can show Git emoji statuses, among other customizations.

## Additional Notes

- **Fonts and Glyphs**  
  If you see squares or missing icons in your terminal, ensure iTerm2 is configured to use the correct fonts (under **Preferences → Profiles → Text**, pick **FiraMono Nerd Font** for ASCII text and **Symbols Nerd Font** for non-ASCII).

- **Shell Configuration**  
  The scripts may modify your `~/.zshrc` or `~/.bashrc` (or `~/.bash_profile`) to load Starship, syntax-highlighting, and autosuggestions. You can open a new shell or run `source ~/.zshrc` (or the relevant file) to apply changes immediately.

---

For more details about each script’s functionality, please refer to the script’s inline comments or usage instructions. Happy macOS configuring!

