# dotfiles
- Download the init.sh with git/curl/wget and run. Will install and setup most of the setup automatically except for font.
- Script and configs are currently W.I.P

dotfiles for:
- zsh
- powerlevel10k
- vim/neovim

Configs for WSL:
- Remove folder highlighting for Windows folders
- Powershell alias

Others to be added as needed

## TODO:
- Refactor this repo to reflect current configs and have better organization
- Refactor and finish script

## Note:
- zsh, git, and wget are installed with this script in case they are not instlled already
  - Package manager is checked to limit incompatibility
- In some cases the powerlevel10k config's icon may not render properly and 'p10k configure' may have to be run manually
- The configs in the nvim folder are mainly just things im tinkering with to learn how lua configs in neovim work
  - Config im actually using is the init.vim file not in the folder
  - Install vim-plug for nvim folder configs from here: https://github.com/junegunn/vim-plug
