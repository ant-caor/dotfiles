#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# -----------------------------
# Function Definitions
# -----------------------------

# Function to display informational messages
echo_info() {
    echo -e "\033[34m[INFO]\033[0m $1"
}

# Function to display success messages
echo_success() {
    echo -e "\033[32m[SUCCESS]\033[0m $1"
}

# Function to display warning messages
echo_warning() {
    echo -e "\033[33m[WARNING]\033[0m $1"
}

# Function to display error messages and exit
echo_error() {
    echo -e "\033[31m[ERROR]\033[0m $1"
    exit 1
}

# Function to detect the current shell
detect_shell() {
    CURRENT_SHELL=$(basename "$SHELL")
    if [[ "$CURRENT_SHELL" != "zsh" && "$CURRENT_SHELL" != "bash" ]]; then
        echo_error "Unsupported shell: $CURRENT_SHELL. Please use bash or zsh."
    fi
    echo_info "Detected shell: $CURRENT_SHELL"
}

# Function to install Homebrew if it's not already installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo_info "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo_success "Homebrew installed successfully."

        # Add Homebrew to PATH for the current session
        if [ -d "/opt/homebrew/bin" ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -d "/usr/local/bin" ]; then
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        echo_info "Homebrew is already installed."
    fi
}

# Function to install necessary dependencies using Homebrew
install_dependencies() {
    echo_info "Installing necessary dependencies using Homebrew..."

    # Update Homebrew to the latest version
    brew update

    # Install wget if not present
    if ! command -v wget &> /dev/null; then
        brew install wget
        echo_success "Installed wget."
    else
        echo_info "wget is already installed."
    fi

    echo_success "All necessary dependencies are installed."
}

# Function to fix ownership and permissions of GOPATH directories
fix_gopath_permissions() {
    echo_info "Fixing ownership and permissions for GOPATH directories..."

    GOPATH_DIR="$HOME/go"
    MOD_DIR="$GOPATH_DIR/pkg/mod"

    if [ -d "$MOD_DIR" ]; then
        echo_info "Changing ownership of $MOD_DIR to $(whoami)..."
        sudo chown -R "$(whoami)" "$MOD_DIR" || echo_warning "Failed to change ownership of $MOD_DIR. You may need to manually adjust permissions."
        
        echo_info "Changing permissions of $MOD_DIR to read-write for the user..."
        sudo chmod -R u+rw "$MOD_DIR" || echo_warning "Failed to change permissions of $MOD_DIR. You may need to manually adjust permissions."

        # Remove immutable flags on macOS
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo_info "Removing immutable flags from $MOD_DIR..."
            sudo chflags -R nouchg "$MOD_DIR" || echo_warning "Failed to remove immutable flags from $MOD_DIR."
        fi
    fi

    echo_success "Ownership and permissions for GOPATH directories fixed."
}

# Function to remove existing Go installations
remove_existing_go() {
    echo_info "Removing existing Go installations..."

    # Uninstall Go if installed via Homebrew
    if brew list go &> /dev/null; then
        brew uninstall go
        echo_success "Uninstalled Go using Homebrew."
    else
        echo_info "Go is not installed via Homebrew."
    fi

    # Remove manual Go installation directory if it exists
    if [ -d "/usr/local/go" ]; then
        echo_info "Removing /usr/local/go using sudo..."
        sudo rm -rf /usr/local/go
        echo_success "Removed manual Go installation from /usr/local/go."
    else
        echo_info "No manual Go installation found in /usr/local/go."
    fi

    # Fix ownership and permissions of GOPATH directory
    if [ -d "$HOME/go" ]; then
        fix_gopath_permissions

        echo_info "Removing GOPATH directory using sudo..."
        sudo rm -rf "$HOME/go"
        echo_success "Removed GOPATH directory at $HOME/go."
    else
        echo_info "No GOPATH directory found at $HOME/go."
    fi

    # Clean Go-related environment variables from profile files
    clean_env_vars
}

# Function to clean Go-related environment variables from shell profiles
clean_env_vars() {
    echo_info "Cleaning Go-related environment variables from shell profiles..."

    # Define all potential profile files
    PROFILE_FILES=("$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.profile" "$HOME/.zshrc")

    for PROFILE in "${PROFILE_FILES[@]}"; do
        if [ -f "$PROFILE" ]; then
            # Backup the profile before modifying
            cp "$PROFILE" "${PROFILE}.backup"
            echo_info "Created backup for $PROFILE at ${PROFILE}.backup"

            # Remove Go-related lines
            sed -i.bak '/# Go environment variables/d' "$PROFILE"
            sed -i.bak '/export PATH=.*\/go\/bin/d' "$PROFILE"
            sed -i.bak '/export GOPATH=\$HOME\/go/d' "$PROFILE"
            sed -i.bak '/export PATH=.*\$GOPATH\/bin/d' "$PROFILE"

            echo_success "Cleaned Go environment variables from $PROFILE."
        fi
    done

    echo_success "Environment variables cleanup completed."
}

# Function to install the latest stable Go using Homebrew
install_go() {
    echo_info "Installing the latest stable version of Go using Homebrew..."

    brew install go

    echo_success "Go installed successfully via Homebrew."
}

# Function to set up Go environment variables
setup_env_vars() {
    echo_info "Setting up Go environment variables..."

    # Determine which profile file to update based on the current shell
    if [ "$CURRENT_SHELL" == "zsh" ]; then
        PROFILE_FILE="$HOME/.zshrc"
    elif [ "$CURRENT_SHELL" == "bash" ]; then
        PROFILE_FILE="$HOME/.bash_profile"
    fi

    # Backup the profile file before modifying
    cp "$PROFILE_FILE" "${PROFILE_FILE}.backup"
    echo_info "Created backup for $PROFILE_FILE at ${PROFILE_FILE}.backup"

    # Append Go environment variables if they aren't already present
    if ! grep -q "# Go environment variables" "$PROFILE_FILE"; then
        {
            echo ""
            echo "# Go environment variables"
            echo "export PATH=\$PATH:/usr/local/go/bin"
            echo "export GOPATH=\$HOME/go"
            echo "export PATH=\$PATH:\$GOPATH/bin"
        } >> "$PROFILE_FILE"
        echo_success "Appended Go environment variables to $PROFILE_FILE."
    else
        echo_info "Go environment variables already present in $PROFILE_FILE."
    fi

    # Source the profile file to apply changes immediately
    if [ "$CURRENT_SHELL" == "zsh" ]; then
        source "$HOME/.zshrc"
    elif [ "$CURRENT_SHELL" == "bash" ]; then
        source "$HOME/.bash_profile"
    fi
    echo_success "Environment variables set up and sourced."
}

# Function to install essential Go tools
install_go_tools() {
    echo_info "Installing essential Go tools (gopls and Delve)..."

    # Ensure Go binaries are in PATH
    export PATH=$PATH:$HOME/go/bin

    # Install gopls (Go language server)
    go install golang.org/x/tools/gopls@latest
    echo_success "Installed gopls."

    # Install Delve (Go debugger)
    go install github.com/go-delve/delve/cmd/dlv@latest
    echo_success "Installed Delve."

    echo_success "All essential Go tools installed successfully."
}

# Function to verify Go and tool installations
verify_installations() {
    echo_info "Verifying Go installation..."
    if command -v go &> /dev/null; then
        go version
        echo_success "Go installation verified."
    else
        echo_error "Go installation failed."
    fi

    echo_info "Verifying gopls installation..."
    if command -v gopls &> /dev/null; then
        gopls version
        echo_success "gopls installation verified."
    else
        echo_error "gopls installation failed."
    fi

    echo_info "Verifying Delve installation..."
    if command -v dlv &> /dev/null; then
        dlv version
        echo_success "Delve installation verified."
    else
        echo_error "Delve installation failed."
    fi
}

# -----------------------------
# Main Execution Flow
# -----------------------------

main() {
    detect_shell
    install_homebrew
    install_dependencies
    remove_existing_go
    install_go
    setup_env_vars
    install_go_tools
    verify_installations
    echo_success "Go installation and setup completed successfully!"
    echo_info "Please restart your terminal or run 'source ${PROFILE_FILE}' to apply the environment changes."
}

main
