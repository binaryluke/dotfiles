# List directories after cd
c() {
  \cd $1;
  ls -a;
}
alias cd="c"

# Git aliases
alias g="git"
alias gs="git status"
alias ga="git add"
alias gd="git diff"
alias gdca="git diff --cached"
alias gdc="git diff --cached"
alias gm="git merge"
alias gf="git fetch"
alias gr="git remote"
alias gc="git commit"
alias gco="git checkout"
alias gp="git push"
alias glg="git log"
alias gl="git pull"

# Docker aliases
alias d="docker"
alias dc="docker-compose"

# Other aliases
alias n="npm"
alias vime="vim -u $HOME/.vim/essential.vim"
alias vdot="vim $HOME/dotfiles"

# Prompt
# Color reference: https://misc.flogisoft.com/bash/tip_colors_and_formatting
COLOR_RED_BG="\e[41m"
COLOR_GREEN_BG="\e[48;5;70m"
COLOR_BLUE_BG="\e[44m"
COLOR_LIGHT_BLUE_BG="\e[104m"
COLOR_ORANGE_BG="\e[48;5;208m"
create_prompt() {
  # Exit code
  local EXIT_TEXT="$?"
  local EXIT_BG="$COLOR_RED_BG"
  if [ "$EXIT_TEXT" == "0" ]; then
    local EXIT_BG="$COLOR_GREEN_BG"
  fi
  PS1="$EXIT_BG $EXIT_TEXT "

  # Git if is repository
  local GIT_BRANCH_TEXT=$(git symbolic-ref HEAD 2> /dev/null | sed -e 's,.*/\(.*\),\1,')
  if [ "$GIT_BRANCH_TEXT" != "" ]; then
    local GIT_NUM_CHANGES=$(git --no-optional-locks status --porcelain=v1 2> /dev/null | wc -l | awk '{$1=$1;print}')
    if [ "$GIT_NUM_CHANGES" == "0" ]; then
      local GIT_BG="$COLOR_GREEN_BG"
    else
      local GIT_BG="$COLOR_ORANGE_BG"
    fi
    PS1="$PS1$GIT_BG $GIT_NUM_CHANGES $GIT_BRANCH_TEXT "
  fi

  # Time
  local TIME_TEXT="\@"
  local TIME_BG="$COLOR_BLUE_BG"
  PS1="$PS1$TIME_BG $TIME_TEXT "

  # Directory
  local DIR_TEXT="\w"
  local DIR_BG="$COLOR_LIGHT_BLUE_BG"
  PS1="$PS1$DIR_BG $DIR_TEXT "

  PS1="\n$PS1\e[0m\n\$ "
}
PROMPT_COMMAND=create_prompt

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Import local bashrc for machine specific run commands
if [ -f $HOME/.bashrc-local ]; then
  source $HOME/.bashrc-local
fi

