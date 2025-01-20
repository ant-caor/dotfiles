## What This Script Installs

This script installs and configures the following tools and enhancements to improve your terminal experience:

- **iTerm2**: A feature-rich terminal emulator for macOS.
- **Oh My Zsh**: A framework for managing Zsh configuration with themes and plugins.
- **Powerlevel10k theme**: A fast and highly customizable Zsh theme.
- **Meslo Nerd Font**: A patched font recommended for use with Powerlevel10k.
- **zsh-syntax-highlighting**: Provides syntax highlighting for Zsh commands.
- **zsh-autosuggestions**: Offers suggestions based on command history.
- **fzf**: A command-line fuzzy finder.
- **autojump**: A utility to navigate directories faster based on usage frequency.
- **colorls**: A Ruby gem to add color and icons to the `ls` command output.

## How to Use the Script

1. Save the script as `install_terminal.sh`.
2. Make it executable:
   ```bash
   chmod +x install_terminal.sh
   ```
3. Run the script:
   ```bash
   ./install_terminal.sh
   ```

After the installation is complete, restart iTerm2 and source the `.zshrc` file to enjoy the enhanced terminal setup.

---

For any issues, verify the installations by running commands like `brew list` or `echo $ZSH_THEME`. Ensure that the Meslo Nerd Font is applied in iTerm2 preferences manually if needed.

