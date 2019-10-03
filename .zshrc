## Paths ##
export GEM_HOME=$HOME/.gem/bin
export LOCAL_BIN=$HOME/bin
# export GLOBAL_BIN=/usr/local/bin
export PATH=$PATH:$LOCAL_BIN:$GEM_HOME

## Oh-My-Zshell Config ##
# themes: https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"    
export ZSH="$HOME/dotfiles/oh-my-zsh"

## PLUGINS ##
plugins=(
  git 
  z
)

source $ZSH/oh-my-zsh.sh 
