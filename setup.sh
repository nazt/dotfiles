export DEBIAN_FRONTEND=noninteractive
export INSTALL_ZSH=true
export USERNAME=`whoami`

## update and install required packages
sudo apt-get update
sudo apt-get -y install --no-install-recommends apt-utils dialog 2>&1
sudo apt-get install -y \
  curl \
  git \
  gnupg2 \
  jq \
  sudo \
  openssh-client \
  less \
  iproute2 \
  procps \
  wget \
  unzip \
  apt-transport-https \
  lsb-release \
  tmux \
  nodejs \
  npm 

# Install Azure CLI
# echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/azure-cli.list
# curl -sL https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - 2>/dev/null
# sudo apt-get update
# sudo apt-get install -y azure-cli;

# Install Jetbrains Mono font
wget https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip
sudo unzip JetBrainsMono-2.001.zip -d /usr/share/fonts
sudo fc-cache -f -v
sudo apt-get install -y fonts-cascadia-code

# Install Claude Code and Codex CLI
echo "Installing AI coding assistants..."
npm install -g @anthropic-ai/claude-code
npm install -g @openai/codex
echo "✓ Claude Code and Codex CLI installed"
# Install & Configure Zsh
if [ "$INSTALL_ZSH" = "true" ]
then
    sudo apt-get install -y \
    fonts-powerline \
    zsh

    cp -f ~/dotfiles/.zshrc ~/.zshrc
    chsh -s /usr/bin/zsh $USERNAME
    wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
    echo "source $PWD/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc
fi

# Cleanup
sudo apt-get autoremove -y
sudo apt-get autoremove -y
sudo rm -rf /var/lib/apt/lists/*

# Verify installations
echo ""
echo "=== Installation Summary ==="
echo "✓ tmux $(tmux -V 2>/dev/null || echo 'not installed')"
echo "✓ Claude Code $(claude --version 2>/dev/null || echo 'not installed')"
echo "✓ Codex CLI $(codex --version 2>/dev/null || echo 'not installed')"
echo "✓ Node.js $(node --version 2>/dev/null || echo 'not installed')"
echo "============================"
echo ""
echo "Setup complete! Run 'source ~/.bashrc' to reload your shell configuration."
