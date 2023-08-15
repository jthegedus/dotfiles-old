###
### Source the auto-generated config from /etc/bashrc (NixOS 2023.05 insallation)
###
if [ -f /etc/bashrc ]; then
  source /etc/bashrc
fi

### Custom

# Aliases
alias cl="clear && macchina"
alias ll="exa -al -I .git --git"
alias lt="exa -alT -I .git --git"
alias q="cd ~"
alias d="cd ~/dev"
alias gl="git log --all --decorate --oneline --graph"
alias gs="git status --short"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"

# Terminal start
macchina
eval "$(starship init bash)"

