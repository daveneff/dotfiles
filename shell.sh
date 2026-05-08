#!/bin/bash
set -u

DOTFILES_HOME="$HOME/.dotfiles"

RCol='\033[0m'
Gre='\033[0;32m'
Red='\033[0;31m'
Yel='\033[0;33m'

function gecho { echo "${Gre}[message] $1${RCol}"; }
function yecho { echo "${Yel}[warning] $1${RCol}"; }
function recho { echo "${Red}[error] $1${RCol}"; exit 1; }

function linkdotfile {
  FILE="$1"
  DEST="${2:-$HOME/$FILE}"
  LINK=$(find $DOTFILES_HOME -type f -name "$FILE")

  [[ -z "$LINK" ]] && recho "Failed to find link for $FILE. Aborting..."

  if [ ! -e $DEST -a ! -L $DEST ]; then
    yecho "$FILE not found, creating new link..."
    ln -sfn $LINK $DEST
  else
    yecho "$FILE found - do you want to overwrite with a new symbolic link?"
    read -p "Overwrite (y/n)?" CONT
    if [ "$CONT" = "y" ]; then
      gecho "Linking $FILE to $LINK..."
      ln -sfn $LINK $DEST
    else
      yecho "Skipping linking $FILE..."
    fi
  fi
}

gecho "1) Installing core dependencies"

if ! xcode-select -p &>/dev/null; then
  xcode-select --install
  yecho "Xcode Command Line Tools installation started. Complete the dialog, then press any key to continue..."
  read -n 1 -s
fi

if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

gecho "2) Installing shell tools"

PACKAGES=(
  eza
  fzf
  rbenv
  starship
  zinit
  zsh-autosuggestions
  zsh-syntax-highlighting
)
brew install ${PACKAGES[@]}

brew install --cask font-meslo-lg-nerd-font

gecho "3) Linking config files"

linkdotfile .zshrc
mkdir -p $HOME/.config
ln -sfn $DOTFILES_HOME/starship.toml $HOME/.config/starship.toml

gecho "Shell setup complete 🎉"
yecho "Remember to set your terminal font to 'MesloLGS Nerd Font' for icons to render correctly."
