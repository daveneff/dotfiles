# ─────────────────────────────────────────────
# Homebrew
# ─────────────────────────────────────────────
eval "$(/opt/homebrew/bin/brew shellenv)"

# ─────────────────────────────────────────────
# Paths
# ─────────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"

# ─────────────────────────────────────────────
# History
# ─────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS       # don't save duplicate commands
setopt HIST_IGNORE_SPACE      # don't save commands starting with a space
setopt SHARE_HISTORY          # share history across terminal sessions

# ─────────────────────────────────────────────
# Completion
# ─────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive completion

# ─────────────────────────────────────────────
# Ruby / rbenv (CocoaPods, Fastlane)
# ─────────────────────────────────────────────
eval "$(rbenv init - zsh)"

# ─────────────────────────────────────────────
# Plugins
# ─────────────────────────────────────────────
source /opt/homebrew/opt/zinit/zinit.zsh
zinit snippet OMZP::git   # Oh My Zsh git plugin (~150 aliases)
zinit snippet OMZP::z     # frecent directory jumping

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source <(fzf --zsh)

# ─────────────────────────────────────────────
# Aliases
# ─────────────────────────────────────────────
alias l="eza -1 --icons -a  --group-directories-first"
alias lf="eza -1 --icons"
alias ll="eza -la --icons --group-directories-first --git"
alias lt="eza --tree --icons --level=2"
alias ..="cd .."
alias ...="cd ../.."

alias desktop="cd ~/Desktop"
alias repos="cd ~/Desktop/repos"
alias downloads="cd ~/Downloads"

alias xco="xed ."                                      # open Xcode in current dir
alias xcclean="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias sim="open -a Simulator"
alias xcb="xcodebuild"

# ─────────────────────────────────────────────
# Prompt (Starship)
# ─────────────────────────────────────────────
eval "$(starship init zsh)"
