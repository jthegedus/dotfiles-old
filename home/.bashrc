###
### Source the auto-generated config from /etc/bashrc (NixOS 2023.05 insallation)
###
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

### Source the .bashrc_default file which was sourced from a default PopOS 20.04 installation
if [ -f "$HOME/.bashrc_default" ]; then
  source "$HOME/.bashrc_default"
fi

### Custom

# Aliases
if command -v macchina > /dev/null 2>&1; then
  alias cl="clear && macchina"
fi
if command -v exa > /dev/null 2>&1; then
  alias ll="exa -al -I .git --git"
  alias lt="exa -alT -I .git --git"
fi
alias q="cd ~"
alias d="cd ~/dev"
alias gl="git log --all --decorate --oneline --graph"
alias gs="git status --short"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"

# Terminal start
if command -v macchina > /dev/null 2>&1; then
  macchina
else
  printf "Warning: macchina command not found.\n"
fi

if command -v starship > /dev/null 2>&1; then
  eval "$(starship init bash)"
else
  printf "Warning: starship command not found.\n"
fi
