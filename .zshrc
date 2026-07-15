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
# Git helpers
# ─────────────────────────────────────────────
# Both cleanup helpers DRY-RUN by default: they only print what they would
# delete. Pass `--go` as the last argument to actually delete. Nothing is
# removed unless you opt in.

# Preview (or delete with --go) local branches already merged into the given
# base (default: develop). Fetches + prunes stale remote-tracking refs first.
# Usage: git-cleanup            # dry run against develop
#        git-cleanup main       # dry run against main
#        git-cleanup develop --go   # actually delete (safe -d)
git-cleanup() {
  local base="develop" go=0 arg
  for arg in "$@"; do
    if [ "$arg" = "--go" ]; then go=1; else base="$arg"; fi
  done
  git fetch --prune
  local branches
  branches=$(git branch --merged "$base" | grep -vE "^\*|^\s*(develop|main|master)$" | sed 's/^[[:space:]]*//')
  if [ -z "$branches" ]; then echo "No merged branches to clean up (base: $base)."; return; fi
  if [ "$go" -eq 1 ]; then
    echo "$branches" | xargs -r git branch -d
  else
    echo "Would delete (merged into $base). Re-run with --go to delete:"
    echo "$branches" | sed 's/^/  /'
  fi
}

# Preview (or delete with --go) local branches whose GitHub PR is merged.
# Catches squash-merges that `git-cleanup` misses. Requires the `gh` CLI.
# Deletion uses -D because squashed branches don't look merged to git.
# Usage: git-cleanup-prs        # dry run
#        git-cleanup-prs --go   # actually delete
git-cleanup-prs() {
  local go=0
  [ "$1" = "--go" ] && go=1
  git fetch --prune
  local b state found=0
  for b in $(git branch --format='%(refname:short)' | grep -vE '^(develop|main|master)$'); do
    state=$(gh pr view "$b" --json state -q .state 2>/dev/null)
    if [ "$state" = "MERGED" ]; then
      found=1
      if [ "$go" -eq 1 ]; then
        git branch -D "$b"
      else
        echo "  $b (PR merged)"
      fi
    fi
  done
  if [ "$found" -eq 0 ]; then
    echo "No branches with merged PRs found."
  elif [ "$go" -eq 0 ]; then
    echo "Re-run with --go to delete the above."
  fi
}

# ─────────────────────────────────────────────
# Prompt (Starship)
# ─────────────────────────────────────────────
eval "$(starship init zsh)"
