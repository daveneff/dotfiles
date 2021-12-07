# dotfiles

This is me experimenting with dotfiles for machine configuration.

## Installation

For a new OS X development environment

1) If Xcode isn't already installed, install developer command line tools:

   `xcode-select --install`

2) Clone this repo and run the installer:
   ```
    git clone https://github.com/daveneff/dotfiles.git ~/.dotfiles
    cd ~/.dotfiles
    sh setup.sh
   ```
    This script does the following:
   - Installs any missing tools 
   - Installs preferred applications
   - Installs zsh and oh-my-zsh
   - Creates symlinks to config files
