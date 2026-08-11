if command -v fzf >/dev/null 2>&1; then
  # Same Kanagawa Dragon hex as nvim/tmux/starship, kept in sync by hand.
  #   bg1 #1D1C19  bg2 #282727  text #c5c9c5  yellow #c4b28a
  #   green #87a987  red #c4746e  gray #625e5a
  export FZF_DEFAULT_OPTS="\
--color=fg:#c5c9c5,bg:#1D1C19,fg+:#c5c9c5,bg+:#282727,hl:#c4b28a,hl+:#c4b28a \
--color=info:#87a987,prompt:#c4746e,pointer:#c4b28a,marker:#87a987,spinner:#c4b28a \
--color=border:#c4b28a,label:#c4b28a,header:#625e5a \
--height=60% --layout=reverse --border=rounded \
--tmux=center,80%,60%"
fi
