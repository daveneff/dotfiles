## ENVS ##

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Visual Studio Code command line tool
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

source $ZSH/oh-my-zsh.sh

# Theme
# More at https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

## PLUGINS ##
plugins=(
  git 
  z
)

## Functions ##

# Open a file in MacDown
function macdown {
    "$(mdfind kMDItemCFBundleIdentifier=com.uranusjr.macdown | head -n1)/Contents/SharedSupport/bin/macdown" $@
}
