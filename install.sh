#!/bin/bash

# Define color codes
GREEN='\033[0;32m\]'
RED='\033[0;31m\]'
NC='\033[0m\]' # No Color

# Ask user of it's intentions
while true; do
    read -p "This script will install zsh, ohmyzsh, and tmux alongside with config/plugins. Do you wish to continue ${GREEN}Y${NC}/${RED}N${NC}? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo -e "Please answer ${GREEN}Y${NC} or ${RED}N${NC}.";;
    esac
done


# Install Zsh
sudo apt-get update && sudo apt-get install -y zsh git curl wget sudo

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc --skip-chsh

# Install Zsh plugins
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)" >> ~/.zshrc

# Install Tmux
sudo apt-get install -y tmux

# Install Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Configure Tmux
cat > ~/.tmux.conf << EOF
set -g prefix ^a
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'dracula/tmux'
set -g @dracula-plugins "cpu-usage ram-usage weather time"
set -g @dracula-show-fahrenheit false
set -g @dracula-cpu-usage true
set -g @dracula-ram-usage true
set -g @dracula-show-timezone false
set -g @dracula-fixed-location "Moscow"
set -g @dracula-tmux-ram-usage-label "MEM"
set -g @dracula-cpu-display-load true
set -g @dracula-refresh-rate 1
set -g @dracula-show-battery false
set -g @dracula-military-time true
set -g mouse on
set -g @plugin 'nhdaly/tmux-better-mouse-mode'
set -s default-terminal 'tmux-256color'
set -sg escape-time 50
run '~/.tmux/plugins/tpm/tpm'
EOF

# Install Tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins


# Append Tmux command to ~/.zshrc to launch tmux on logon
echo 'if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then tmux a -t default || exec tmux new -s default && exit; fi' >> ~/.zshrc


# Change default shell to Zsh
chsh -s $(which zsh)

# reload zsh,ohmyzsh,tmux
source ~/.zshrc

#We are done
echo "Installation complete! Press Crtl+b+I to reload Tmux"
