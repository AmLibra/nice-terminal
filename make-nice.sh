#!/bin/bash
# based on Medium article by Code Slicer: https://ivanaugustobd.medium.com/your-terminal-can-be-much-much-more-productive-5256424658e8
# author: Khalil M'hirsi, 2024

printf "\n\nThis script will install and configure the following terminal improvements:\n"
printf "  - Oh My Zsh\n"
printf "  - zsh-syntax-highlighting\n"
printf "  - zsh-autosuggestions\n"
printf "  - fzf\n"
printf "  - Hack font\n"
printf "  - Powerlevel10k\n"
printf "  - colorls\n\n"

printf "This script will also install the following common Linux dev tools:\n"
printf "  - docker\n"
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

sudo apt install build-essential gcc zsh ruby-full git tmux curl ranger -y

for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
# Add Docker's official GPG key:
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

printf "Done.\n\n"

# Install Oh My Zsh
printf "Installing Oh My Zsh..."
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
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
if grep -q "^ZSH_THEME=" ~/.zshrc; then
    sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
else
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
fi
if ! grep -q "POWERLEVEL9K_MODE" ~/.zshrc; then
    echo "POWERLEVEL9K_MODE=\"nerdfont-complete\"" >> ~/.zshrc
    echo "POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(...elements)" >> ~/.zshrc
fi

# Install colorls
echo "alias ls=\"colorls --sd -A\"" >> ~/.zshrc
sudo gem install colorls

# Add gcommit function to ~/.zshrc if it's not already present
if ! grep -q "gcommit()" ~/.zshrc; then
    echo "Adding gcommit function to ~/.zshrc..."
    cat << 'EOF' >> ~/.zshrc

# gcommit function to add, commit, and push changes with a commit message
gcommit() {
    if [ -z "\$1" ]; then
        echo "Error: Please provide a commit message."
        return 1
    fi
    git add .
    git commit -m "\$1"
    git push
}
EOF
else
    echo "gcommit function already exists in ~/.zshrc."
fi

printf "\n\nDon't forget to change the terminal font to Hack Regular Nerd Font and restart the terminal! \n\n"
 
