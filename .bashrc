# Dotfiles git management - credit: 
# https://www.anand-iyer.com/blog/2018/a-simpler-way-to-manage-your-dotfiles.html
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# List directories after cd
c() {
  \cd $1;
  ls -a;
}
alias cd="c"

alias g="git"
alias d="docker"
alias dc="docker-compose"
alias n="npm"

# Prompt
# Color reference: https://misc.flogisoft.com/bash/tip_colors_and_formatting
COLOR_RED_BG="\e[41m"
COLOR_GREEN_BG="\e[48;5;70m"
COLOR_BLUE_BG="\e[44m"
COLOR_LIGHT_BLUE_BG="\e[104m"
create_prompt() {
  local EXIT_TEXT="$?"
  local EXIT_BG="$COLOR_RED_BG"
  if [ "$EXIT_TEXT" == "0" ]; then
    local EXIT_BG="$COLOR_GREEN_BG"
  fi
  local TIME_TEXT="\@"
  local TIME_BG="$COLOR_BLUE_BG"
  local DIR_TEXT="\w"
  local DIR_BG="$COLOR_LIGHT_BLUE_BG"

  PS1="$EXIT_BG $EXIT_TEXT $TIME_BG $TIME_TEXT $DIR_BG $DIR_TEXT \e[0m\n\$ "
}
PROMPT_COMMAND=create_prompt
