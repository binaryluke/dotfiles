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

# Git alias
alias gst="git status"
alias gd="git diff"
alias gc="git commit"
alias gcl="git clone"
alias ga="git add"
alias gp="git push"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

