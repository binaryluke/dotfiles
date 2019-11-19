#!/usr/bin/env bash

main() {
  ask_for_sudo
  install_xcode_command_line_tools # next step requires "git" installed with xcode
  clone_dotfiles_repo
  install_homebrew
  install_packages_with_brewfile
  change_shell_to_latest_bash
  setup_symlinks
  setup_vim
  setup_tmux
  setup_yabai
  setup_macos_system_preferences
  setup_macos_application_preferences
  setup_macos_login_items
}

# Credit: https://github.com/sam-hosseini/dotfiles/blob/92cdd34570629fdb6d3e94865ba6b8bedd99dbe8/bootstrap.sh#L23
function ask_for_sudo {
  echo "Prompting for sudo password"
  if sudo --validate; then
    # Keep-alive
    while true; do sudo --non-interactive true; \
      sleep 10; kill -0 "$$" || exit; done 2>/dev/null &
    echo "Sudo password updated"
  else
      echo "Sudo password update failed"
      exit 1
  fi
}

function install_xcode_command_line_tools {
  echo "Not yet implemented: install_xcode_command_line_tools"
}

function clone_dotfiles_repo {
  echo "Not yet implemented: clone_dotfiles_repo"
}

function install_homebrew {
  echo "Not yet implemented: install_homebrew"
}

function install_packages_with_brewfile {
  echo "Not yet implemented: install_packages_with_brewfile"
}

function change_shell_to_latest_bash {
  echo "Not yet implemented: change_shell_to_latest_bash"
}

function setup_symlinks {
  echo "Not yet implemented: setup_symlinks"
}

function setup_vim {
  echo "Not yet implemented: setup_vim"
}

function setup_tmux {
  echo "Not yet implemented: setup_tmux"
}

function setup_yabai {
  echo "Not yet implemented: setup_yabai"
}

function setup_macos_system_preferences {
  echo "Not yet implemented: setup_macos_system_preferences"
}

function setup_macos_application_preferences {
  echo "Not yet implemented: setup_macos_application_preferences"
}

function setup_macos_login_items {
  echo "Not yet implemented: setup_macos_login_items"
}

main "$@"

