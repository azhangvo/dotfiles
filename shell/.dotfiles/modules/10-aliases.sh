alias n="nvim"
alias g="git"
alias gs="git status"
alias gf="git fetch"
alias gd="git diff"
alias gdc="git diff --cached"
alias gau="git add -u"

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --icons=auto --group-directories-first"
  alias ll="eza -l --icons=auto --group-directories-first --git"
  alias la="eza -la --icons=auto --group-directories-first --git"
  alias lt="eza --tree --icons=auto --level=2"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat"
fi

# Attach to a tmux session, detaching any other client already attached to
# it (`-d`) -- avoids fighting over pane sizing when the same session is
# open from more than one terminal/machine at once. With no argument and
# fzf available, picks interactively from running sessions; otherwise falls
# back to tmux's own default target resolution (most recently used).
if command -v tmux >/dev/null 2>&1; then
  ta() {
    if [ -n "$1" ]; then
      tmux attach -d -t "$1"
    elif command -v fzf >/dev/null 2>&1; then
      local session
      session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null | fzf)"
      [ -n "$session" ] && tmux attach -d -t "$session"
    else
      tmux attach -d
    fi
  }

  # Detach every client from a session by name -- unlike ta's -d (a side
  # effect of attaching yourself), this detaches without attaching, and
  # doesn't need to know which tty/machine has it open.
  td() {
    if [ -n "$1" ]; then
      tmux detach-client -s "$1"
    elif command -v fzf >/dev/null 2>&1; then
      local session
      session="$(tmux list-sessions -F '#{session_name}' 2>/dev/null | fzf)"
      [ -n "$session" ] && tmux detach-client -s "$session"
    else
      echo "usage: td <session>" >&2
      return 1
    fi
  }
fi
