#!/bin/bash
set -e
set -u

## printing ##

# colors 
RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

#functions
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

# look for command line tool, if not install via homebrew
function install_brew {
  (command -v $1 > /dev/null  && gecho "$1 found...") || 
    (yecho "$1 not found, installing via homebrew..." && brew install $1)
}

# function for linking dotfiles
function linkdotfile {
  file="$1"
  if [ ! -e ~/$file -a ! -L ~/$file ]; then
      yecho "$file not found, creting new link..." >&2
      ln -sfn ~/.dotfiles/$file ~/$file
  else
    gecho "$file found - do you want to overwrite with a new link?" >&2
    read -p "Overwrite (y/n)?" CONT
    if [ "$CONT" = "y" ]; then
      ln -sfn ~/.dotfiles/$file ~/$file
    else
      yecho "Skipping linking $file..."
    fi
  fi
}

# are we in right directory?
[[ $(basename $(pwd)) == ".dotfiles" ]] || 
  recho "doesn't look like you're in .dotfiles/" >&2

## install dependencies ##
gecho "1) Install core dependencies."

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
gecho "2) Install applications"

brew cask install macdown
brew cask install sourcetree
brew cask install visual-studio-code 

# install zsh
gecho "3) Install zsh and oh-my-zsh"
install_brew zsh
if [ ! -d "$HOME/.dotfiles/oh-my-zsh" ]; then 
  yecho "Installing oh-my-zsh" >&2
  ZSH="$HOME/.dotfiles/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi  

# link config files 
gecho "4) Link configuration files"

linkdotfile .gitconfig
linkdotfile .gitignore_global
linkdotfile .zshrc

gecho "Setup complete ✅"