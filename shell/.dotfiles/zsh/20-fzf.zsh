if [[ $- == *i* ]] && command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi
