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

echo "==> Unstowing: ${PACKAGES[*]}"
stow -D -v -t "$HOME" -d "$DOTFILES_ROOT" "${PACKAGES[@]}"

# Reverse of install.sh's append_hook: strip the marked block back out.
# Leaves the rest of the file untouched -- these rc files aren't stowed, so
# unstowing above doesn't touch them at all.
remove_hook() {
  local rc_file="$1" mark_start="# >>> dotfiles >>>" mark_end="# <<< dotfiles <<<"

  [ -f "$rc_file" ] || return 0
  grep -qF "$mark_start" "$rc_file" || return 0

  local tmp
  tmp="$(mktemp)"
  awk -v s="$mark_start" -v e="$mark_end" '
    $0 == s { skip=1; next }
    $0 == e { skip=0; next }
    !skip
  ' "$rc_file" > "$tmp"
  mv "$tmp" "$rc_file"
  echo "==> unhooked $rc_file"
}

if [[ " ${PACKAGES[*]} " == *" shell "* ]]; then
  echo "==> Removing shell hooks"
  remove_hook "$HOME/.bashrc"
  remove_hook "$HOME/.zshrc"
  remove_hook "$HOME/.bash_profile"
fi

if [[ " ${PACKAGES[*]} " == *" git "* ]]; then
  echo "==> Removing git hook"
  remove_hook "$HOME/.gitconfig"
fi

# Reverse of install.sh's cache rebuild: the custom .tmTheme is gone now
# that bat is unstowed, so clear the cache rather than rebuild it --
# rebuilding would just bake in a now-dangling reference to it.
if [[ " ${PACKAGES[*]} " == *" bat "* ]] && command -v bat >/dev/null 2>&1; then
  echo "==> Clearing bat/delta theme cache"
  bat cache --clear
fi

echo "==> Done"
