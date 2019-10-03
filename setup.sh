#!/bin/bash
set -e
set -u

## printing ##
# colors 
RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

function gecho {
  echo "${Gre}[message] $1${RCol}"
}

function yecho {
  echo "${Yel}[warning] $1${RCol}"
}

function recho {
  echo "${Red}[error] $1${RCol}"
  exit 1
}

## install functions ##

# checks if a tool needs to be installed
function needs_install {
  [[ $(command -v $1) == "" ]] && return 

  false
}

# install command line tool with homebrew
function install_brew {
  (command -v $1 > /dev/null  && yecho "$1 already installed, skipping") || 
    (yecho "$1 not found, installing via homebrew..." && brew install $1)
}

# install application with cask
function install_cask {
  if ! brew cask info $1 &>/dev/null; then
    yecho "$1 not found, installing..." >&2
    brew cask install $1
  else
    yecho "$1 already installed, skipping..." >&2
  fi
}

# create symbolic links between home folder and .dotfiles
function linkdotfile {
  FILE="$1"
  LINK=$(find ~/.dotfiles/** -type f -name "$FILE")

  [[ -z "$LINK" ]] && recho "Failed to find link for $FILE. Aborting..."

  if [ ! -e ~/$FILE -a ! -L ~/$FILE ]; then
      yecho "$FILE not found, creting new link..." >&2
      ln -sfn $LINK ~/$FILE
  else
    yecho "$FILE found - do you want to overwrite with a new symbolic link?" >&2
    read -p "Overwrite (y/n)?" CONT
    if [ "$CONT" = "y" ]; then
      gecho "Linking $FILE to $LINK..."
      ln -sfn $LINK ~/$FILE
    else
      yecho "Skipping linking $FILE..."
    fi
  fi
}

# are we in right directory?
[[ $(basename $(pwd)) == ".dotfiles" ]] || 
  recho "doesn't look like you're in .dotfiles/" >&2

## install dependencies ##
gecho "1) Installing core dependencies."

if needs_install xcode-select; then 
  yecho "Installing Xcode Command Line Tools" >&2
  xcode-select --install
fi 

if needs_install pod; then 
  yecho "Installing Cocoapods." >&2
  sudo gem install cocoapods
fi 

if needs_install brew; then 
  yecho "Installing Homebrew and Cask" >&2
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/cask
fi

# install applications
gecho "2) Installing applications"

install_cask macdown
install_cask sourcetree
install_cask visual-studio-code 

# install zsh
gecho "3) Installing zsh and oh-my-zsh"

install_brew zsh

if [ ! -d "$HOME/.dotfiles/oh-my-zsh" ]; then 
  yecho "Installing oh-my-zsh" >&2
  ZSH="$HOME/.dotfiles/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi  

# link config files 
gecho "4) Linking configuration files"

linkdotfile .gitconfig
linkdotfile .gitignore_global
linkdotfile .zshrc

gecho "Setup complete 🎉"
