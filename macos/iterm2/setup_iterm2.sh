#!/bin/bash

# This script attempts a clean reinstall of:
#   - iTerm2
#   - Oh My Zsh
#   - Powerlevel10k theme
#   - Meslo Nerd Font patched for Powerlevel10k
#   - zsh-syntax-highlighting, zsh-autosuggestions
#   - fzf, autojump, colorls

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
# 3. Install Meslo Nerd Font patched for Powerlevel10k
# ----------------------------------------------------
if brew list --cask | grep -q font-meslo-lg-nerd-font; then
    echo "Removing Meslo Nerd Font for a clean reinstall..."
    brew uninstall --cask font-meslo-lg-nerd-font
fi
echo "Installing Meslo Nerd Font..."
brew install --cask font-meslo-lg-nerd-font

# ----------------------------------------------------
# 4. Install Oh My Zsh
# ----------------------------------------------------
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "Removing existing Oh My Zsh for a clean reinstall..."
    rm -rf "$HOME/.oh-my-zsh"
fi
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# ----------------------------------------------------
# 5. Install Powerlevel10k
# ----------------------------------------------------
if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
    echo "Removing existing Powerlevel10k for a clean reinstall..."
    rm -rf "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
fi
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"

# ----------------------------------------------------
# 6. Install zsh-syntax-highlighting, zsh-autosuggestions, fzf, autojump, colorls
# ----------------------------------------------------
brew install fzf autojump colorls

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"

# ----------------------------------------------------
# 7. Configure iTerm2 working directory and font settings
# ----------------------------------------------------
if [ -d "$HOME/Documents/Github" ]; then
    defaults write com.googlecode.iterm2 "New Bookmarks" -array-add '{ "Custom Directory" = "Yes"; "Working Directory" = "'$HOME/Documents/Github'"; "Normal Font" = "MesloLGS NF Regular 14"; "Non Ascii Font" = "MesloLGS NF Regular 14"; }'
fi

# ----------------------------------------------------
# 8. Final Message
# ----------------------------------------------------
echo "------------------------------------------------------"
echo "Installation and setup completed!"
echo "------------------------------------------------------"
echo "Installed/Reinstalled:"
echo "  - iTerm2 with Powerlevel10k"
echo "  - Meslo Nerd Font patched for Powerlevel10k"
echo "  - Oh My Zsh"
echo "  - zsh-syntax-highlighting, zsh-autosuggestions"
echo "  - fzf, autojump, colorls"
echo "------------------------------------------------------"
echo "Next Steps:"
echo "  1) Restart iTerm2."
echo "  2) Run 'source ~/.zshrc' or restart the shell."
echo "------------------------------------------------------"
