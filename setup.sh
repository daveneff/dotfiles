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
      yecho "$file not found, linking..." >&2
      ln -s ~/dotfiles/$file ~/$file
  else
      gecho "$file found, ignoring..." >&2
  fi
}

# are we in right directory?
[[ $(basename $(pwd)) == "dotfiles" ]] || 
  recho "doesn't look like you're in dotfiles/" >&2

## install dependencies ##

if needs_install xcode-select; then 
  yecho "Installing XCode command line tools" >&2
  xcode-select --install
fi 

# cocoapods
if needs_install pod; then 
  yecho "Installing Cocoapods." >&2
  gem install cocoapods --user-install
fi 

# homebrew
if needs_install brew; then 
  yecho "Installing Homebrew" >&2
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew tap caskroom/cask
  brew tap caskroom/versions
else 
  yecho "Updating Homebrew" >&2
  brew update
fi

# link config files 
linkdotfile .gitconfig
linkdotfile .gitignore_global
linkdotfile .zshrc

# install zshell
install_brew zsh

if [ ! -d "$HOME/.oh-my-zsh" ]; then 
  yecho "Installing oh-my-zsh" >&2
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# install applications
brew cask install macdown
brew cask install visual-studio-code 
brew cask install sourcetree

yecho "run the following to change shell to zsh... :" >&2
echo "  chsh -s /bin/zsh "
