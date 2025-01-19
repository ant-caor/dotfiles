#!/bin/bash

# This script sets up iTerm2 on macOS using Homebrew, copies custom iTerm2 settings,
# and forces iTerm2 to recognize the new preferences. It does NOT kill or restart iTerm2.

# -------------------------------------
# 1. Ensure Homebrew is Installed
# -------------------------------------
if ! command -v brew &>/dev/null; then
    echo "Homebrew not installed. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is installed."
fi

# -------------------------------------
# 2. Install iTerm2 if Necessary
# -------------------------------------
if ! brew list --cask | grep -q iterm2; then
    echo "iTerm2 not installed. Installing now..."
    brew install --cask iterm2
else
    echo "iTerm2 is already installed."
fi

# -------------------------------------
# 3. Define Variables
# -------------------------------------
dotfiles_dir="$HOME/Documents/Github/dotfiles/macos/iterm2"
preferences_file="$dotfiles_dir/com.googlecode.iterm2.plist"
target_file="$HOME/Library/Preferences/com.googlecode.iterm2.plist"

# -------------------------------------
# 4. Copy Preferences if They Exist
# -------------------------------------
if [ -f "$preferences_file" ]; then
    echo "Copying iTerm2 preferences from $preferences_file..."
    
    # Remove existing preferences to avoid caching issues
    if [ -f "$target_file" ]; then
        echo "Removing existing iTerm2 preferences..."
        rm "$target_file"
    fi

    # Copy new preferences file
    cp "$preferences_file" "$target_file"
    echo "Copied new preferences to $target_file"

    # Set correct permissions
    echo "Setting file permissions to 644..."
    chmod 644 "$target_file"

    # -------------------------------------
    # 5. Register the Preferences with macOS
    # -------------------------------------
    echo "Importing preferences into defaults system..."
    defaults import com.googlecode.iterm2 "$target_file"

    # -------------------------------------
    # 6. Kill Preferences Daemon (cfprefsd)
    # -------------------------------------
    echo "Killing cfprefsd to force reload of preferences..."
    killall cfprefsd 2>/dev/null

    echo "iTerm2 setup and preferences import complete!"
    echo "Please quit iTerm2 manually (if open) and relaunch it to see the changes."
else
    echo "iTerm2 preferences file not found at $preferences_file. Please check your file and try again."
fi
