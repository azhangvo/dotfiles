#!/usr/bin/env bash
set -euo pipefail

# Reports which external tools these configs assume are missing on $PATH.
# Purely a check -- never installs anything, no package manager involved.
# Presence is checked with `command -v`, which works the same on any
# platform/shell; how you actually install a given tool is up to you.

# name|why
TOOLS=(
  "stow|runs install.sh itself"
  "nvim|nvim/ config"
  "tmux|tmux/ config"
  "starship|shell/ prompt"
  "rg|nvim telescope find/grep (ripgrep)"
  "tree-sitter|nvim treesitter parser installs (tree-sitter-cli)"
  "fzf|shell/ Ctrl-R, Ctrl-T, Alt-C"
  "eza|shell/ ls/ll/la/lt aliases"
  "bat|shell/ cat alias"
  "delta|git/ diff pager (git-delta) -- git errors loudly without this one, doesn't silently skip it"
  "tldr|tealdeer, no config dependency, just the binary itself"
  "gh|GitHub CLI, no config dependency"
  "claude|nvim claudecode.nvim"
)

missing=()
for entry in "${TOOLS[@]}"; do
  name="${entry%%|*}"
  why="${entry#*|}"
  if ! command -v "$name" >/dev/null 2>&1; then
    missing+=("$name ($why)")
  fi
done

if [ "${#missing[@]}" -eq 0 ]; then
  echo "==> check-tools: all tracked tools present"
else
  echo "==> check-tools: missing ${#missing[@]} tool(s) these configs assume:"
  for m in "${missing[@]}"; do
    echo "    - $m"
  done
fi

echo "==> check-tools: also can't verify a Nerd Font is installed/selected"
echo "    in your terminal (needed for tmux/starship separator glyphs and"
echo "    nvim icons) -- no reliable cross-platform way to check that here."
