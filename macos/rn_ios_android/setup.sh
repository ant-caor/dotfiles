#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Function to display messages
function echo_info() {
    echo -e "\033[1;34m[INFO]\033[0m $1"
}

function echo_success() {
    echo -e "\033[1;32m[SUCCESS]\033[0m $1"
}

function echo_error() {
    echo -e "\033[1;31m[ERROR]\033[0m $1"
}

# Determine Homebrew prefix (handles both Intel and Apple Silicon)
BREW_PREFIX=$(brew --prefix)

# Determine the shell profile file (supports zsh and bash)
if [ -n "$ZSH_VERSION" ]; then
    PROFILE_FILE="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    PROFILE_FILE="$HOME/.bash_profile"
else
    PROFILE_FILE="$HOME/.profile"
fi

# 1. Install Homebrew if not installed
if ! command -v brew &> /dev/null
then
    echo_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$($BREW_PREFIX/bin/brew shellenv)"' >> "$PROFILE_FILE"
    eval "$($BREW_PREFIX/bin/brew shellenv)"
    echo_success "Homebrew installed successfully."
else
    echo_info "Homebrew is already installed. Updating Homebrew..."
    brew update
    brew upgrade
    echo_success "Homebrew is up to date."
fi

# 2. Install essential packages
echo_info "Installing essential packages: openjdk@17, node, yarn, watchman, git..."
brew install openjdk@17 watchman git

# Fix node and yarn linking issues with permissions check
if ! brew link node &> /dev/null; then
    echo_info "Fixing node symlink permissions..."
    sudo rm -rf /usr/local/include/node /usr/local/share/doc/node /usr/local/lib/node_modules/corepack
    sudo chown -R $(whoami) /usr/local/lib/node_modules && sudo chmod -R u+w /usr/local/lib/node_modules
test -w /usr/local/share/doc || sudo chmod -R u+w /usr/local/share/doc
    brew link --overwrite node || { echo_error "Failed to link node. Check permissions manually."; exit 1; }
fi

if ! brew link yarn &> /dev/null; then
    echo_info "Fixing yarn symlink permissions..."
    sudo rm -rf /usr/local/bin/yarn
    brew link --overwrite yarn || { echo_error "Failed to link yarn. Check permissions manually."; exit 1; }
fi

echo_success "Essential packages installed."

# 3. Install Android Studio and Xcode
echo_info "Installing Android Studio and Xcode..."
brew install --cask android-studio
brew install --cask xcodes

echo_success "Android Studio and Xcode installed successfully."

# 4. Configure npm to use a user directory
echo_info "Configuring npm to use a user directory for global installations..."
NPM_GLOBAL_DIR="$HOME/.npm-global"
mkdir -p "$NPM_GLOBAL_DIR"
npm config set prefix "$NPM_GLOBAL_DIR"

# Add npm global bin to PATH
if ! grep -q "export PATH=\"$HOME/.npm-global/bin:\$PATH\"" "$PROFILE_FILE"; then
    echo_info "Adding npm global bin directory to PATH in $PROFILE_FILE..."
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$PROFILE_FILE"
    export PATH="$HOME/.npm-global/bin:$PATH"
    echo_success "npm global bin directory added to PATH."
fi

# Add react-native to PATH
if ! grep -q "export PATH=\"$HOME/.npm-global/bin:\$PATH\"" "$PROFILE_FILE"; then
    echo_info "Adding react-native CLI to PATH in $PROFILE_FILE..."
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$PROFILE_FILE"
    export PATH="$HOME/.npm-global/bin:$PATH"
    echo_success "React Native CLI added to PATH."
fi

# Reload shell configuration
echo_info "Reloading shell configuration..."
source "$PROFILE_FILE"
echo_success "Shell configuration reloaded."

# 5. Install React Native CLI globally
echo_info "Installing React Native CLI globally..."
npm install -g react-native-cli

echo_success "React Native CLI installed successfully."

# Verify installation
if command -v react-native &> /dev/null
then
    echo_success "React Native CLI is correctly installed and accessible."
else
    echo_error "React Native CLI installation failed. Please check manually."
    exit 1
fi

echo_success "Development environment setup is complete!"
echo_info "Please restart your terminal or run 'source $PROFILE_FILE' to apply the environment variables."
