# ~/.local/bin is where pipx installs executables
path=($HOME/bin $HOME/homebrew/bin $HOME/.local/bin $HOME/.npm-global/bin /usr/local/opt/mysql-client/bin /usr/local/sbin $path)
typeset -U path

##########
# iCloud #
##########
export ICLOUD="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"

#######
# Bat #
#######
export BAT_THEME="Solarized (dark)"

########
# Tmux #
########
alias th="tmux select-layout even-horizontal"
bindkey -s ^f "tmux-sessionizer\n"

#######
# Fzf #
#######
source <(fzf --zsh)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -a -d -s -h --du -C {}'"
# https://github.com/junegunn/fzf-git.sh
[ -f ~/fzf-git.sh ] && source ~/fzf-git.sh
# Disable flow control so that ctrl-gs works
# https://github.com/junegunn/fzf-git.sh?tab=readme-ov-file#list-of-bindings
# https://unix.stackexchange.com/questions/515252/how-do-you-disable-xon-off-flow-control
stty -ixon

##########
# nodenv #
##########
eval "$(nodenv init -)"

###############
# local (zsh) #
###############
[ -f ~/.zshrc-local ] && source ~/.zshrc-local

###########
# Aliases #
###########
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

# For pipx completions
autoload -U compinit && compinit
eval "$(register-python-argcomplete pipx)"
