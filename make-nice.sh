#!/bin/bash

printf "\n\nThis script will install and configure the following terminal improvements:\n"
printf "  - Oh My Zsh\n"
printf "  - zsh-syntax-highlighting\n"
printf "  - zsh-autosuggestions\n"
printf "  - fzf\n"
printf "  - Hack font\n"
printf "  - Powerlevel10k\n"
printf "  - colorls\n\n"

printf "This script will also install the following common Linux dev tools:\n"
printf "  - gcc\n"
printf "  - zsh\n"
printf "  - ruby-full\n"
printf "  - git\n"
printf "  - tmux\n"
printf "  - curl\n"
printf "  - ranger\n\n"

printf "Making sure the system is up to date..."
sudo apt update
sudo apt upgrade -y
printf "Done.\n\n"

printf "Installing common Linux dev tools..."
sudo apt install gcc zsh ruby-full git tmux curl ranger -y
printf "Done.\n\n"

# Install Oh My Zsh
printf "Installing Oh My Zsh..."
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh; zsh
sudo usermod --shell $(which zsh) $(whoami)
printf "Done.\n\n"

# Define Oh My Zsh custom directory
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# Install zsh-syntax-highlighting plugin if not already installed
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
else
    echo "zsh-syntax-highlighting already installed."
fi

# Install zsh-autosuggestions plugin if not already installed
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
else
    echo "zsh-autosuggestions already installed."
fi

# Add plugins to the .zshrc if not already present
if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    echo "Adding zsh-syntax-highlighting and zsh-autosuggestions to .zshrc..."
    sed -i '/^plugins=/ s/)/ zsh-syntax-highlighting zsh-autosuggestions)/' ~/.zshrc
else
    echo "Plugins already configured in .zshrc."
fi

# Install fzf
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    echo "fzf is already installed."
fi

# Download the Hack font
current=$(pwd)
mkdir -p ~/.fonts && cd ~/.fonts
unzip -o "$current/Hack.zip"
printf "\n\nDon't forget to install the font files in order for the terminal to display the Hack font! \n\n"

# Install powerlevel10k for terminal layout and icons
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
else
    echo "Powerlevel10k already installed."
fi

# Configure Powerlevel10k in .zshrc
if ! grep -q "POWERLEVEL9K_MODE" ~/.zshrc; then
    echo "POWERLEVEL9K_MODE=\"nerdfont-complete\"" >> ~/.zshrc
    echo "POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(...elements)" >> ~/.zshrc
fi

# Install colorls
echo "alias ls=\"colorls --sd -A\"" >> ~/.zshrc
sudo gem install colorls

# Reload terminal
source ~/.zshrc

printf "\n\nDon't forget to change the terminal font to Hack Regular Nerd Font and restart the terminal! \n\n"
 