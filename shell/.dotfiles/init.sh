DOTFILES_DIR="$HOME/.dotfiles"

for f in $(find "$DOTFILES_DIR/modules" -maxdepth 1 -name '*.sh' 2>/dev/null | sort); do
  . "$f"
done

if [ -n "$ZSH_VERSION" ]; then
  for f in $(find "$DOTFILES_DIR/zsh" -maxdepth 1 -name '*.zsh' 2>/dev/null | sort); do
    . "$f"
  done
elif [ -n "$BASH_VERSION" ]; then
  for f in $(find "$DOTFILES_DIR/bash" -maxdepth 1 -name '*.sh' 2>/dev/null | sort); do
    . "$f"
  done
fi

unset DOTFILES_DIR f
