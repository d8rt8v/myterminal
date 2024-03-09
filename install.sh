#!/bin/bash

# Ask user of it's intentions
while true; do
    read -p "This script will install zsh, ohmyzsh, and tmux alongside with config/plugins. Do you wish to continue $(tput setaf 2)Y$(tput sgr0)/$(tput setaf 1)N$(tput sgr0)? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo -e "Please answer $(tput setaf 2)Y$(tput sgr0) or $(tput setaf 1)N$(tput sgr0).";;
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
sed -i '/^plugins=/d' ~/.zshrc
echo "plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use)" >> ~/.zshrc

#Correct symbols/emoji display in Tmux
echo "export LC_ALL=C.UTF-8" >> ~/.zshrc
echo "export LANG=C.UTF-8" >> ~/.zshrc

# Install Tmux
sudo apt-get install -y tmux

# Install Tmux Plugin Manager (TPM)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Configure Tmux
cat > ~/.tmux.conf << EOF

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'
set -g @plugin 'dracula/tmux'
set -g @dracula-plugins "cpu-usage ram-usage weather time"

# Config Dracula Theme
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

#Mouse
set -g mouse off

#Config Mouse if it will be used
set -g @plugin 'nhdaly/tmux-better-mouse-mode'

# Set 256 colors
set -s default-terminal 'tmux-256color'

#Fix strange characters
set -sg escape-time 50

# Initialize TMUX plugin manager (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
EOF

# Install Tmux plugins
~/.tmux/plugins/tpm/bin/install_plugins

# Append Tmux command to ~/.zshrc to launch tmux on logon
echo 'if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then tmux a -t default || exec tmux new -s default && exit; fi' >> ~/.zshrc

# Change default shell to Zsh
chsh -s $(which zsh)

# reload and open zsh,ohmyzsh
source ~/.zshrc
zsh
tmux

#We are done
echo "Installation complete! Please relogin ❤️"
