#!/bin/bash
set -e
set -u

RCol='\033[0m'
Gre='\033[0;32m'

function gecho { echo "${Gre}[message] $1${RCol}"; }

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

gecho "1) Installing apps"

CASKS=(
  figma
  fork
  iterm2
  notion
  reveal
  visual-studio-code
)
brew install --cask ${CASKS[@]}

gecho "2) Installing packages"

PACKAGES=(
  gh
  git-lfs
  node
)
brew install ${PACKAGES[@]}

gecho "App install complete 🎉"
