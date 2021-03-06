#!/usr/bin/env bash

main() {
  ask_for_sudo
  install_xcode_command_line_tools # next step requires "git" installed with xcode
  clone_dotfiles_repo
  install_homebrew
  install_packages_with_brewfile
  remove_packages_not_in_brewfile
  download_bash_completions
  change_shell_to_latest_bash
  install_nvm # nvm doesn't support homebrew
  install_latest_node_with_nvm
  setup_symlinks
  install_vim_plug
  run_vim_plug_clean_update_install
  setup_tmux
  setup_yabai
  setup_macos_system_and_application_preferences
  setup_macos_login_items
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
    url=https://raw.githubusercontent.com/Homebrew/install/master/install
    if yes | /usr/bin/ruby -e "$(curl -fsSL ${url})"; then
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

function download_bash_completions() {
  notify "INFO" 0 "\nDownloading bash completions"

  if curl -Lfso ~/.git-completion https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash &> /dev/null; then
    notify "SUCCESS" 1 "Git completion downloaded successfully"
  else
    notify "FAIL" 1 "Git completion failed to download"
  fi

  if curl -Lfso ~/.docker-completion https://raw.githubusercontent.com/docker/cli/master/contrib/completion/bash/docker &> /dev/null; then
    notify "SUCCESS" 1 "Docker completion downloaded successfully"
  else
    notify "FAIL" 1 "Docker completion failed to download"
  fi
}

function change_shell_to_latest_bash {
  notify "INFO" 0 "\nChanging default shell to latest Bash"
  if [ "$SHELL" == "/usr/local/bin/bash" ]; then
    notify "INFO" 1 "Latest Bash is already the default shell"
  else
    user=$(whoami)
    notify "INFO" 1 "Adding latest Bash to /etc/shells"
    if grep --fixed-strings --line-regexp --quiet "/usr/local/bin/bash" /etc/shells; then
      notify "INFO" 2 "Latest Bash already exists in /etc/shells"
    else
      if echo /usr/local/bin/bash | sudo tee -a /etc/shells > /dev/null; then
        notify "SUCCESS" 2 "Latest Bash successfully added to /etc/shells"
      else
        notify "FAIL" 1 "Failed to add latest Bash to /etc/shells"
        exit 1
      fi 
    fi
    notify "INFO" 1 "Switching shell to latest Bash for \"${user}\""
    if sudo chsh -s /usr/local/bin/bash "$user"; then
      notify "SUCCESS" 2 "Latest Bash shell successfully set as default for \"${user}\""
    else
      notify "FAIL" 2 "Failed to set latest Bash as default shell"
      exit 1
    fi 
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

function install_latest_node_with_nvm {
  notify "INFO" 0 "\nInstalling latest node with nvm"
  export NVM_DIR="$HOME/.nvm"

  # Source nvm script
  if source $NVM_DIR/nvm.sh &> /dev/null; then
    notify "SUCCESS" 1 "Nvm sourced successfully"
  else
    notify "FAIL" 1 "Failed to source nvm"
    exit 1
  fi

  # Install latest node
  if nvm install node &> /dev/null; then
    notify "SUCCESS" 1 "Latest node installed"
  else
    notify "FAIL" 1 "Failed to installed latest node"
    exit 1
  fi

  # Set latest node as the default
  if nvm alias default node &> /dev/null; then
    notify "SUCCESS" 1 "Latest node installed and set as the default"
  else
    notify "FAIL" 1 "Failed to set latest node as default"
  fi
}

function setup_symlinks {
  notify "INFO" 0 "\nSetting up symlinks"

  symlink "bash:bashrc" ${DOTFILES_REPO}/.bashrc $HOME/.bashrc
  symlink "bash:bash_profile" ${DOTFILES_REPO}/.profile $HOME/.bash_profile
  symlink "bash:profile" ${DOTFILES_REPO}/.profile $HOME/.profile
  symlink "bash:hushlogin" ${DOTFILES_REPO}/.hushlogin $HOME/.hushlogin
  symlink "bash:inputrc" ${DOTFILES_REPO}/.inputrc $HOME/.inputrc
  symlink "macos" ${DOTFILES_REPO}/.macos $HOME/.macos
  symlink "git:config" ${DOTFILES_REPO}/.gitconfig $HOME/.gitconfig
  symlink "git:ignore" ${DOTFILES_REPO}/.gitignore-global $HOME/.gitignore

  # vim settings
  symlink "vim" ${DOTFILES_REPO}/.vim $HOME/.vim

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

function install_vim_plug {
  notify "INFO" 0 "\nInstalling vim plugin manager"
  if [ -f $DOTFILES_REPO/.vim/autoload/plug.vim ]; then
    notify "INFO" 1 "Vim Plug already installed"
  else
    if curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim &> /dev/null; then
      notify "SUCCESS" 1 "Vim Plug installed successfully"
    else
      notify "FAIL" 1 "Vim Plug failed to install"
    fi
  fi
}

function run_vim_plug_clean_update_install {
  notify "INFO" 0 "\nRunning Vim Plug commands"

  # Prune
  if vim +PlugClean +qa!; then
    notify "SUCCESS" 1 "Vim PlugClean run successfully"
  else
    notify "FAIL" 1 "Vim PlugClean failed"
  fi

  # Update
  if vim +PlugUpdate +qa!; then
    notify "SUCCESS" 1 "Vim PlugUpdate run successfully"
  else
    notify "FAIL" 1 "Vim PlugUpdate failed"
  fi

  # Install
  if vim +PlugInstall +qa!; then
    notify "SUCCESS" 1 "Vim PlugInstall run successfully"
  else
    notify "FAIL" 1 "Vim PlugInstall failed"
  fi

  # Dependencies
  if pip3 install --user pynvim; then
    notify "SUCCESS" 1 "pynvim dependency for denite installed successfully"
  else
    notify "FAIL" 1 "pynvim dependency for denite failed to install"
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

