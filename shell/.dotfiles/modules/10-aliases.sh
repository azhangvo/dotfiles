alias n="nvim"
alias g="git"
alias gs="git status"
alias gf="git fetch"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=auto --group-directories-first"
  alias ll="eza -l --icons=auto --group-directories-first --git"
  alias la="eza -la --icons=auto --group-directories-first --git"
  alias lt="eza --tree --icons=auto --level=2"
fi
