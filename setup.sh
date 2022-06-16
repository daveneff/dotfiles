#!/bin/bash
set -e
set -u

# Install locations
DOTFILES_HOME="$HOME/.dotfiles"

######################################
############ echo helpers ############
######################################

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

#####################################
############# functions #############
#####################################

# create symbolic links between home folder and .dotfiles
function linkdotfile {
  FILE="$1"
  LINK=$(find $DOTFILES_HOME/** -type f -name "$FILE")

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

# checks if a tool needs to be installed
function needs_install {
  if test ! $(which $1); then
    yecho "$1 not found, installing..."
    true
  else 
    yecho "$1 already installed, skipping..."
    false
  fi
}

######################################
############# the script #############
######################################

# are we in right directory?
[[ $(basename $(pwd)) == ".dotfiles" ]] || 
  recho "doesn't look like you're in .dotfiles/" >&2

# install dependencies
gecho "1) Installing core dependencies."

if needs_install xcode-select; then 
  xcode-select --install
fi 

if needs_install brew; then 
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew tap homebrew/cask
fi

# install applications
gecho "2) Installing applications"

CASKS=(
  figma
  fork
  iterm2
  kaleidoscope
  macdown
  notion
  proxyman
  reveal
  visual-studio-code
)
brew install --cask ${CASKS[@]}

# install command line tools
gecho "3) Installing command line tools"

# first, install latest ruby version locally
brew install ruby

RUBY_GEMS=(
    bundler
    fastlane
)
gem install ${RUBY_GEMS[@]}

PACKAGES=(
  cocoapods
  git-lfs
  python3
)
brew install ${PACKAGES[@]}

# install oh-my-zsh
if [ ! -d "$DOTFILES_HOME/oh-my-zsh" ]; then 
  yecho "Installing oh-my-zsh"
  ZSH="$DOTFILES_HOME/oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi  

# link config files 
gecho "4) Linking configuration files"

linkdotfile .gitconfig
linkdotfile .gitignore_global
linkdotfile .zshrc

gecho "Setup complete 🎉"
