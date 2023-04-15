SCRIPTS="${HOME}/scripts"
NODENV="${HOME}/.nodenv/bin"
NEOVIM="${HOME}/neovim/bin"
GOLANG="/usr/local/go/bin"

export PATH="${SCRIPTS}:${NEOVIM}:${NODENV}:${GOLANG}:${PATH}"

# Application Aliases
#alias vim="/Users/binaryluke/personal/neovim/build/bin/nvim"
alias fd=fdfind

# Git Aliases
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

# Vim journal
# https://www.youtube.com/watch?v=EJqnWXDJZr0
alias vj="vim ~/journal/vim.md"

# Tmux sessionizer
bind '"\C-f":"tmux-sessionizer\n"'

# Nodenv
eval "$(nodenv init - bash)"

# Ssh keys into agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github

