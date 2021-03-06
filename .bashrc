# Git aliases
alias g="git"
alias gb="git branch"
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
alias gcl="git clone"

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

# Export iCloud drive path variable
export ICLOUD="$HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
alias icloud="cd $ICLOUD"

# Prompt
# Color reference: https://misc.flogisoft.com/bash/tip_colors_and_formatting
COLOR_RED_BG="\e[41m"
COLOR_GREEN_BG="\e[48;5;70m"
COLOR_BLUE_BG="\e[44m"
COLOR_LIGHT_BLUE_BG="\e[104m"
COLOR_ORANGE_BG="\e[48;5;208m"

# type -a update_terminal_cwd
update_cwd() {
  local url_path='';
  { 
    local i ch hexch LC_CTYPE=C LC_COLLATE=C LC_ALL= LANG=;
    for ((i = 0; i < ${#PWD}; ++i))
    do
      ch="${PWD:i:1}";
      if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
        url_path+="$ch";
      else
        printf -v hexch "%02X" "'$ch";
        url_path+="%${hexch: -2:2}";
      fi;
    done
  };
  printf '\e]7;%s\a' "file://$HOSTNAME$url_path"
}

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
# Append not override so MacOS can set the correct cwd
# Reference: https://github.com/Bash-it/bash-it/issues/240
PROMPT_COMMAND="create_prompt;update_cwd;"

# Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Bash completion
# Reference: https://itnext.io/programmable-completion-for-bash-on-macos-f81a0103080b
if [ -r "/usr/local/etc/profile.d/bash_completion.sh" ]; then
  . "/usr/local/etc/profile.d/bash_completion.sh"
  # Reference: https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
  # Reference: https://stackoverflow.com/questions/9869227/git-autocomplete-in-bash-aliases 
  . "$HOME/.git-completion"
  __git_complete g _git
  __git_complete gb _git_branch
  __git_complete gs _git_status
  __git_complete ga _git_add
  __git_complete gd _git_diff
  __git_complete gm _git_merge
  __git_complete gf _git_fetch
  __git_complete gr _git_remote
  __git_complete gc _git_commit
  __git_complete gco _git_checkout
  __git_complete gp _git_push
  __git_complete glg _git_log
  __git_complete gl _git_pull
  __git_complete gcl _git_clone
  # Reference: https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker
  . "$HOME/.docker-completion"
fi

# Add to keychain quietly
ssh-add -K &> /dev/null

# Import local bashrc for machine specific run commands
if [ -f $HOME/.bashrc-local ]; then
  source $HOME/.bashrc-local
fi

