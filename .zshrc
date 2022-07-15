# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
zstyle ':omz:update' mode reminder

HIST_STAMPS="yyyy-mm-dd"

plugins=(git)

source $ZSH/oh-my-zsh.sh

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

# Add to keychain quietly
ssh-add -K &> /dev/null

# Bind NeoVim to vim
alias vim="nvim"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
