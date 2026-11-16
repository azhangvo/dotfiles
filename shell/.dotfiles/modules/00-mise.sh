# 00- so tools it puts on PATH exist before later modules check `command -v`.
# Interactive-only: mise's hook-env (run immediately by `mise activate`,
# not just on later prompts) writes terminal synchronized-output escape
# codes to stderr -- even for a plain `ssh host command`, since sshd
# always sources this via the login shell regardless of what command
# runs. Broke Ansible's sudo prompt detection on daedalus; see
# become_plugins/local_sudo.py in the ansible repo for the full story.
if [[ $- == *i* ]] && command -v mise >/dev/null 2>&1; then
  if [ -n "$ZSH_VERSION" ]; then
    eval "$(mise activate zsh)"
  elif [ -n "$BASH_VERSION" ]; then
    eval "$(mise activate bash)"
  fi
fi
