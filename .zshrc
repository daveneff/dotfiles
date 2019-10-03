## ENVS ##

export PATH=$PATH:$HOME/bin:/usr/local/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# Visual Studio Code
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Ruby gems
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

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
