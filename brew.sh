#!/usr/bin/env bash

# Update to latest Homebrew
brew update

# Upgrade any already-installed fomulae
brew upgrade

# Save Homebrew installed location
BREW_PREFIX=$(brew --prefix)

# Install tools and applications
brew install awscli
brew install gnupg
brew install gradle
brew install maven
brew install pipenv
brew install tree
brew install vim

# Remove outdated versions from the cellar
brew cleanup

