#!/usr/bin/env zsh

main() {
  ask_for_sudo
  install_xcode_command_line_tools # next step requires "git" installed with xcode
  clone_dotfiles_repo
  install_homebrew
  install_packages_with_brewfile
  remove_packages_not_in_brewfile
  install_nvm # nvm doesn't support homebrew
  setup_fzf
  setup_symlinks
  setup_tmux
  setup_yabai
  setup_macos_system_and_application_preferences
  setup_macos_login_items
  remind_manual
}

DOTFILES_REPO=~/dotfiles

# Credit: https://github.com/sam-hosseini/dotfiles/blob/92cdd34570629fdb6d3e94865ba6b8bedd99dbe8/bootstrap.sh#L23
function ask_for_sudo {
  notify "INFO" 0 "\nPrompting for sudo password"
  if sudo --validate; then
    # Keep-alive
    while true; do sudo --non-interactive true; \
      sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
    notify "SUCCESS" 1 "Sudo password updated"
  else
      echo "FAIL" 1 "Sudo password update failed"
      exit 1
  fi
}

# Credit: https://github.com/sam-hosseini/dotfiles/blob/92cdd34570629fdb6d3e94865ba6b8bedd99dbe8/bootstrap.sh#L35
function install_xcode_command_line_tools {
  notify "INFO" 0 "\nInstalling Xcode command line tools"
  if softwareupdate --history | grep --silent "Command Line Tools"; then
    notify "INFO" 1 "Xcode command line tools already exists"
  else
    xcode-select --install
    read -n 1 -s -r -p "Press any key once installation is complete"

    if softwareupdate --history | grep --silent "Command Line Tools"; then
      notify "SUCCESS" 1 "Xcode command line tools installation succeeded"
    else
      notify "FAIL" 1 "Xcode command line tools installation failed"
      exit 1
    fi
  fi
}

# Credit: https://github.com/sam-hosseini/dotfiles/blob/92cdd34570629fdb6d3e94865ba6b8bedd99dbe8/bootstrap.sh#L173
function clone_dotfiles_repo {
  notify "INFO" 0 "\nCloning dotfiles repository into ${DOTFILES_REPO}"
  if test -e $DOTFILES_REPO; then
    notify "INFO" 1 "${DOTFILES_REPO} already exists"
    pull_latest_in_dotfiles_repo $DOTFILES_REPO
  else
    url=https://github.com/binaryluke/dotfiles.git
    if git clone "$url" $DOTFILES_REPO &> /dev/null && \
      git -C $DOTFILES_REPO remote set-url origin git@github.com:binaryluke/dotfiles.git &> /dev/null; then
        notify "SUCCESS" 1 "Dotfiles repository cloned into ${DOTFILES_REPO}"
    else
        notify "FAIL" 1 "Dotfiles repository cloning failed"
        exit 1
    fi
  fi
}

function pull_latest_in_dotfiles_repo {
  notify "INFO" 1 "Pulling latest changes in ${1} repository"
  if git -C $1 pull origin master &> /dev/null; then
    notify "SUCCESS" 2 "Pull successful in ${DOTFILES_REPO} repository"
  else
    notify "FAIL" 1 "Please pull latest changes in ${1} repository manually"
  fi
}

# Credit: https://github.com/sam-hosseini/dotfiles/blob/92cdd34570629fdb6d3e94865ba6b8bedd99dbe8/bootstrap.sh#L52
function install_homebrew {
  notify "INFO" 0 "\nInstalling Homebrew"
  if hash brew 2>/dev/null; then
    notify "INFO" 1 "Homebrew already exists; updating"
    if brew update &> /dev/null; then
      notify "SUCCESS" 2 "Homebrew updated successfully"
    else
      notify "FAIL" 2 "Homebrew failed to update"
    fi
  else
    url=https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    if yes | /bin/bash -c "$(curl -fsSL ${url})"; then
      notify "SUCCESS" 1 "Homebrew installation succeeded"
    else
      notify "FAIL" 1 "Homebrew installation failed"
      exit 1
    fi
  fi
}

function install_packages_with_brewfile {
  notify "INFO" 0 "\nInstalling Brewfile packages"

  BREWFILE=${DOTFILES_REPO}/Brewfile

  if brew bundle check --file="$BREWFILE" &> /dev/null; then
    notify "INFO" 1 "Brewfile packages already installed"
  else
    if brew bundle --file="$BREWFILE"; then
      notify "SUCCESS" 1 "Brewfile packages installation succeeded"
    else
      notify "FAIL" 1 "Brewfile packages installation failed"
      exit 1
    fi
  fi
}

function remove_packages_not_in_brewfile() {
  notify "INFO" 0 "\nRemoving Brew packages not listed in Brewfile"

  if [ "$(brew bundle cleanup)" != "" ]; then
    if brew bundle cleanup --force; then
      notify "SUCCESS" 1 "Packages removed successfully"
    else
      notify "FAIL" 1 "Failed to remove some packages"
    fi
  else
    notify "INFO" 1 "No packages to remove"
  fi
}

function install_nvm {
  notify "INFO" 0 "\nInstalling nvm"
  if [ -d "$HOME/.nvm" ]; then
    notify "INFO" 1 "Nvm already installed"
  else
    if git clone https://github.com/nvm-sh/nvm.git $HOME/.nvm &> /dev/null; then
      notify "SUCCESS" 1 "Nvm successfully cloned"
      if [ $? -eq 0 ]; then
        git -C $HOME/.nvm checkout v0.35.1 &> /dev/null
        if [ $? -eq 0 ]; then
          notify "SUCCESS" 2 "Latest version of nvm checkout out"
        else
          notify "FAIL" 2 "Failed to checkout latest version of nvm"
          exit 1
        fi
      else
        notify "FAIL" 2 "Failed to clone nvm repo"
        exit 1
      fi
      notify "SUCCESS" 1 "Successfully installed nvm"
    else
      notify "FAIL" 1 "Nvm failed to clone"
    fi
  fi
}

function setup_fzf {
  notify "INFO" 0 "\nSetting up fzf"
  $(brew --prefix)/opt/fzf/install --no-fish --no-bash --update-rc --key-bindings --completion 
  notify "SUCCESS" 1 "fzf key bindings and fuzzy completion done"
}

function setup_symlinks {
  notify "INFO" 0 "\nSetting up symlinks"

  symlink "zsh:zshrc" ${DOTFILES_REPO}/.zshrc $HOME/.zshrc
  # Disable zprofile for now as seems not needed and speeds up by ~1s
  # symlink "zsh:zprofile" ${DOTFILES_REPO}/.profile $HOME/.zprofile
  symlink "zsh:hushlogin" ${DOTFILES_REPO}/.hushlogin $HOME/.hushlogin
  symlink "zsh:inputrc" ${DOTFILES_REPO}/.inputrc $HOME/.inputrc
  symlink "alacritty" ${DOTFILES_REPO}/alacritty $HOME/.config/alacritty
  symlink "nvim" ${DOTFILES_REPO}/nvim $HOME/.config/nvim
  symlink "macos" ${DOTFILES_REPO}/.macos $HOME/.macos
  symlink "git:config" ${DOTFILES_REPO}/.gitconfig $HOME/.gitconfig
  symlink "git:ignore" ${DOTFILES_REPO}/.gitignore-global $HOME/.gitignore

  # vscode settings
  mkdir -p $HOME/Library/Application\ Support/Code/User/snippets
  symlink "vscode:settings.json" ${DOTFILES_REPO}/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
  symlink "vscode:keybindings.json" ${DOTFILES_REPO}/vscode/keybindings.json $HOME/Library/Application\ Support/Code/User/keybindings.json
  symlink "vscode:snippets" ${DOTFILES_REPO}/vscode/snippets/ $HOME/Library/Application\ Support/Code/User/snippets

  # amethyst settings
  symlink "amethyst:plist" ${DOTFILES_REPO}/amethyst/plist $HOME/Library/Preferences/com.amethyst.Amethyst.plist

  notify "INFO" 1 "Symlinks setup complete"
}

function symlink() {
  application=$1
  the_dir=$2
  the_link=$3

  if rm -rf "$the_link" && ln -s "$the_dir" "$the_link"; then
    notify "SUCCESS" 1 "Symlinking for \"${application}\" done"
  else
    notify "FAIL" 1 "Symlinking for \"${application}\" failed"
    exit 1
  fi
}

function setup_tmux {
  notify "INFO" 0 "\nNot yet implemented: setup_tmux"
}

function setup_yabai {
  notify "INFO" 0 "\nNot yet implemented: setup_yabai"
}

function setup_macos_system_and_application_preferences {
  notify "INFO" 0 "\nSetting MacOS system and application preferences"
  if source $HOME/.macos; then
    notify "SUCCESS" 1 "Preferences successfully applied"
  else
    notify "FAIL" 1 "Preferences failed to apply"
  fi
}

function setup_macos_login_items {
  notify "INFO" 0 "\nNot yet implemented: setup_macos_login_items"
}

function remind_manual() {
  notify "INFO" 0 "\nManual install the following:\nAlacritty\nSnagIt\nAmethyst\nChrome\nLast Pass\nSlack\nObsidian\nVLC\nPacker (after NeoVim build & install)\nWallpapers: https://wall.alphacoders.com/by_sub_category.php?id=173052&name=Girl+Wallpapers\nSpace Launcher: https://spacelauncherapp.com/\n"
}

function notify() {
  local TYPE=$1 # ""/"INFO", "SUCCESS", "FAIL"
  local INDENT=$2 # 0..infinity
  local MSG=$3
  local OUT=""

  while [ $INDENT -gt 0 ]; do
    OUT="$OUT--"
    if [ $INDENT -eq 1 ]; then
      OUT="$OUT> "
    fi
    INDENT=$((INDENT-1))
  done

  case $TYPE in
    "SUCCESS")
      OUT="$OUT\e[38;5;47m" # Green
      ;;
    "FAIL")
      OUT="$OUT\e[38;5;160m" # Red
      ;;
  esac

  OUT="$OUT$MSG\e[0m"
  echo -e "$OUT"
}

main "$@"

