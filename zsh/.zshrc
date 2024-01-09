path+=("$HOME/bin")
path+=("$HOME/.npm-global/bin")
path+=("/usr/local/opt/mysql-client/bin") # mysql client
path+=("/usr/local/sbin") # Add brew lib to path (WTF? this is the sudo bin folder...)
typeset -U path

# Export iCloud drive path variable
export ICLOUD="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"

# Notes directory for use in scripts
export SECOND_BRAIN="$HOME/notes"

# Aliases
alias gst="git status"
alias gd="git diff"
alias gc="git commit"
alias gcl="git clone"
alias ga="git add"
alias gp="git push"
alias gst="git status"
alias glg="git log"
alias gdca="git diff --cached"
alias gco="git checkout"
alias gb="git branch"
alias gm="git merge"
alias g="git"
alias n="nvim"

# Vim journal
# https://www.youtube.com/watch?v=EJqnWXDJZr0
alias vj="vim ~/journal/vim.md"

bindkey -s ^f "tmux-sessionizer\n"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# nodenv
eval "$(nodenv init -)"

[ -f ~/.zshrc-local ] && source ~/.zshrc-local

