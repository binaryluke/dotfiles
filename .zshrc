# Docker aliases
alias d="docker"
alias dc="docker-compose"

# Other aliases
alias n="npm"
alias vime="vim -u $HOME/.vim/essential.vim"
alias vdot="vim $HOME/dotfiles"
alias audacity="open /Applications/Audacity.app/Contents/MacOS/Audacity"

# Add Visual Studio Code (code) to PATH
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Add mysql client to PATH
export PATH="$PATH:/usr/local/opt/mysql-client/bin"

# Add scripts folder to path
export PATH="$PATH:/$HOME/scripts"

# Add brew lib to path
export PATH="$PATH:/usr/local/sbin"

# Export iCloud drive path variable
export ICLOUD="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
alias icloud="cd $ICLOUD"

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add to keychain quietly
ssh-add -K &> /dev/null

# Import local bashrc for machine specific run commands
if [ -f $HOME/.bashrc-local ]; then
  source $HOME/.bashrc-local
fi

