#!/usr/bin/env bash
set -euo pipefail

DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v stow >/dev/null 2>&1; then
  echo "error: GNU Stow is required but not installed (e.g. \`brew install stow\`)." >&2
  exit 1
fi

# Auto-discover packages: any top-level directory in the repo.
PACKAGES=()
for d in "$DOTFILES_ROOT"/*/; do
  name="$(basename "$d")"
  [ "$name" = ".git" ] && continue
  PACKAGES+=("$name")
done

if [ "$#" -gt 0 ]; then
  PACKAGES=("$@")
fi

echo "==> Stowing: ${PACKAGES[*]}"
stow -v -t "$HOME" -d "$DOTFILES_ROOT" "${PACKAGES[@]}"

# Special case: real ~/.bashrc, ~/.zshrc, ~/.bash_profile are never stowed
# directly (they're add-ons, not overrides — see BACKLOG.md). Instead, ensure
# each has a one-time idempotent hook appended.
append_hook() {
  local rc_file="$1" source_line="$2" mark="# >>> dotfiles >>>"

  if [ -f "$rc_file" ] && grep -qF "$mark" "$rc_file"; then
    echo "==> $rc_file already hooked"
    return
  fi

  {
    echo ""
    echo "$mark"
    echo "$source_line"
    echo "# <<< dotfiles <<<"
  } >> "$rc_file"
  echo "==> hooked $rc_file"
}

if [[ " ${PACKAGES[*]} " == *" shell "* ]]; then
  echo "==> Wiring shell hooks"
  append_hook "$HOME/.bashrc" '[ -f "$HOME/.dotfiles/init.sh" ] && . "$HOME/.dotfiles/init.sh"'
  append_hook "$HOME/.zshrc" '[ -f "$HOME/.dotfiles/init.sh" ] && . "$HOME/.dotfiles/init.sh"'
  append_hook "$HOME/.bash_profile" '[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"'
fi

# Same reasoning as the shell rc files: ~/.gitconfig is never stowed
# directly, since it needs to hold a machine-local [user] name/email that
# has no business being in a repo meant to be pushed publicly. Only a hook
# pointing at the shared, repo-managed config is appended. If ~/.gitconfig
# doesn't exist yet, this creates it with just the hook -- you'll still
# need to add your own [user] section once, by hand, per machine.
if [[ " ${PACKAGES[*]} " == *" git "* ]]; then
  echo "==> Wiring git hook"
  append_hook "$HOME/.gitconfig" '[include]
	path = ~/.dotfiles/gitconfig'
fi

"$DOTFILES_ROOT/check-tools.sh"

echo "==> Done"
