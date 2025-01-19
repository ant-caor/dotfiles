#!/bin/bash

# This script attempts a clean reinstall of:
#   - iTerm2
#   - Several fonts: FiraMono Nerd, Symbols Nerd, Powerline Symbols
#   - Starship
#   - iTerm2 preferences (auto-setting fonts)
#   - starship.toml (with git emojis, no '')
#   - zsh-syntax-highlighting, zsh-autosuggestions
#   - (Optional) Installs gitmoji-cli
#   - (Optional) Imports gruvbox-rainbow for iTerm2 color scheme

# ----------------------------------------------------
# 1. Ensure Homebrew is Installed
# ----------------------------------------------------
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing now..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is installed."
fi

# ----------------------------------------------------
# 2. Clean Reinstall iTerm2
# ----------------------------------------------------
if brew list --cask | grep -q iterm2; then
    echo "Removing iTerm2 for a clean reinstall..."
    brew uninstall --cask iterm2
fi
echo "Installing iTerm2..."
brew install --cask iterm2

# ----------------------------------------------------
# 3. Clean Reinstall Nerd/Powerline Fonts
# ----------------------------------------------------
# 3a) FiraMono Nerd Font
if brew list --cask | grep -q font-fira-mono-nerd-font; then
    echo "Removing FiraMono Nerd Font for a clean reinstall..."
    brew uninstall --cask font-fira-mono-nerd-font
fi
echo "Installing FiraMono Nerd Font..."
brew install --cask font-fira-mono-nerd-font

# 3b) Symbols Only Nerd Font
if brew list --cask | grep -q font-symbols-only-nerd-font; then
    echo "Removing Symbols Only Nerd Font for a clean reinstall..."
    brew uninstall --cask font-symbols-only-nerd-font
fi
echo "Installing Symbols Only Nerd Font..."
brew install --cask font-symbols-only-nerd-font

# 3c) Powerline Symbols
if brew list --cask | grep -q font-powerline-symbols; then
    echo "Removing Powerline Symbols Font for a clean reinstall..."
    brew uninstall --cask font-powerline-symbols
fi
echo "Installing Powerline Symbols Font..."
brew install --cask font-powerline-symbols

# ----------------------------------------------------
# 4. iTerm2 Preferences Setup
# ----------------------------------------------------
dotfiles_dir="$HOME/Documents/Github/dotfiles/macos/iterm2"
preferences_file="$dotfiles_dir/com.googlecode.iterm2.plist"
target_file="$HOME/Library/Preferences/com.googlecode.iterm2.plist"
github_dir="$HOME/Documents/Github"

if [ -f "$target_file" ]; then
    echo "Removing existing iTerm2 preferences from $target_file..."
    rm "$target_file"
fi

if [ -f "$preferences_file" ]; then
    echo "Copying iTerm2 preferences from $preferences_file..."
    cp "$preferences_file" "$target_file"
    chmod 644 "$target_file"

    # Optionally set iTerm2 default working directory to ~/Documents/Github
    if [ -d "$github_dir" ]; then
      echo "Detected $github_dir exists. Setting iTerm2 'Working Directory'..."
      plutil -replace "New Bookmarks.0.Custom Directory" -string "Yes" "$target_file"
      plutil -replace "New Bookmarks.0.Working Directory" -string "$github_dir" "$target_file"
    else
      echo "Directory $github_dir not found. Skipping default working directory config."
    fi

    # Auto-set Normal/Non-ASCII Fonts
    echo "Setting iTerm2 Normal Font to 'FiraMono Nerd Font 12'..."
    plutil -replace "New Bookmarks.0.Normal Font" -string "FiraMono Nerd Font 12" "$target_file"
    echo "Setting iTerm2 Non-ASCII Font to 'Symbols Nerd Font 12'..."
    plutil -replace "New Bookmarks.0.Non Ascii Font" -string "Symbols Nerd Font 12" "$target_file"

    echo "Importing updated preferences..."
    defaults import com.googlecode.iterm2 "$target_file"
    killall cfprefsd 2>/dev/null
    echo "iTerm2 preference setup complete!"
else
    echo "No custom iTerm2 plist found at $preferences_file. Skipping preference setup."
fi

# ----------------------------------------------------
# 5. Reinstall Starship
# ----------------------------------------------------
if brew list | grep -q starship; then
    echo "Removing Starship for a clean reinstall..."
    brew uninstall starship
fi
echo "Installing Starship..."
brew install starship

# ----------------------------------------------------
# 6. Install zsh-syntax-highlighting, zsh-autosuggestions
# ----------------------------------------------------
if ! brew list | grep -q zsh-syntax-highlighting; then
    echo "Installing zsh-syntax-highlighting..."
    brew install zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting already installed."
fi

if ! brew list | grep -q zsh-autosuggestions; then
    echo "Installing zsh-autosuggestions..."
    brew install zsh-autosuggestions
else
    echo "zsh-autosuggestions already installed."
fi

# ----------------------------------------------------
# 7. Clean out old 'starship init' lines, re-add
#    And also add lines for zsh-syntax-highlighting & zsh-autosuggestions
# ----------------------------------------------------
shell_name=$(basename "$SHELL")
case "$shell_name" in
  zsh)
    shell_config="$HOME/.zshrc"
    ;;
  bash)
    if [ -f "$HOME/.bash_profile" ]; then
      shell_config="$HOME/.bash_profile"
    else
      shell_config="$HOME/.bashrc"
    fi
    ;;
  *)
    shell_config="$HOME/.zshrc"
    echo "Unrecognized shell ($shell_name). Defaulting to zshrc for plugin setup."
    ;;
esac

echo "Removing any existing 'starship init' references from $shell_config..."
sed -i.bak '/starship init/d' "$shell_config" 2>/dev/null || true

# Also remove old lines referencing syntax-highlighting, autosuggestions
sed -i.bak '/zsh-syntax-highlighting/d' "$shell_config" 2>/dev/null || true
sed -i.bak '/zsh-autosuggestions/d' "$shell_config" 2>/dev/null || true

echo "Adding Starship init to $shell_config..."
echo "eval \"\$(starship init $shell_name)\" # starship setup" >> "$shell_config"

zsh_syntax_path="$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
zsh_autosug_path="$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

if [ -f "$zsh_syntax_path" ]; then
    echo "# zsh-syntax-highlighting" >> "$shell_config"
    echo "source \"$zsh_syntax_path\"" >> "$shell_config"
fi

if [ -f "$zsh_autosug_path" ]; then
    echo "# zsh-autosuggestions" >> "$shell_config"
    echo "source \"$zsh_autosug_path\"" >> "$shell_config"
fi

# ----------------------------------------------------
# 8. Copy starship.toml from dotfiles (Git Emojis, no '')
# ----------------------------------------------------
starship_src="$dotfiles_dir/starship.toml"
starship_dest="$HOME/.config/starship.toml"

rm -f "$starship_dest"
mkdir -p "$(dirname "$starship_dest")"

if [ -f "$starship_src" ]; then
    echo "Copying Starship config from $starship_src to $starship_dest..."
    cp "$starship_src" "$starship_dest"

    # Optionally remove [go] block if your starship version doesn't support it
    sed -i.bak '/^\[go\]/,/^$/d' "$starship_dest" 2>/dev/null || true
else
    echo "No starship.toml found at $starship_src. Skipping starship config setup."
fi

# ----------------------------------------------------
# 11. Final Message
# ----------------------------------------------------
echo "------------------------------------------------------"
echo "Clean reinstall + plugin install completed!"
echo "------------------------------------------------------"
echo "Installed/Reinstalled:"
echo "  - iTerm2"
echo "  - FiraMono Nerd Font (normal ASCII)"
echo "  - Symbols Nerd Font (extended icons)"
echo "  - Powerline Symbols Font"
echo "  - zsh-syntax-highlighting"
echo "  - zsh-autosuggestions"
echo "  - Starship"
echo "Copied if found:"
echo "  - iTerm2 plist -> $target_file"
echo "  - starship.toml -> $starship_dest"
echo "------------------------------------------------------"
echo "Next Steps:"
echo "  1) Quit iTerm2 (Cmd+Q) if running, then reopen to load new preferences."
echo "  2) 'source $shell_config' or open a new shell to see Starship & zsh plugins."
echo "  3) In iTerm2 Preferences > Profiles > Colors > Color Presets, pick 'gruvbox_rainbow'."
echo "  4) If you installed gitmoji-cli, run 'gitmoji -c' to commit with emojis."
echo "------------------------------------------------------"
