# configure shell
DOTFILES_HOME="$HOME/.dotfiles"
CONFIGS_HOME="$DOTFILES_HOME/zsh"
source "$CONFIGS_HOME/.exports"
source "$CONFIGS_HOME/.aliases"
source "$CONFIGS_HOME/.functions"

# configure oh-my-zsh
# more at https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"    

plugins=(
  git 
  z
)

# set source after configuring
export ZSH="$DOTFILES_HOME/oh-my-zsh"
source $ZSH/oh-my-zsh.sh 