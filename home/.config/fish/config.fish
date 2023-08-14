# aliases
alias cl='clear && macchina'
alias ll='exa -al -I .git --git'
alias lt='exa -alT -I .git --git'
alias q='cd ~'
alias d='cd ~/dev'
alias gl='git log --all --decorate --oneline --graph'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'

# prompt
starship init fish | source
