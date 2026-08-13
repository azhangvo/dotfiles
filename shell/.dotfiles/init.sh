DOTFILES_DIR="$HOME/.dotfiles"

for f in "$DOTFILES_DIR"/modules/*.sh; do
  [ -e "$f" ] || continue
  . "$f"
done

if [ -n "$ZSH_VERSION" ]; then
  for f in "$DOTFILES_DIR"/zsh/*.zsh; do
    [ -e "$f" ] || continue
    . "$f"
  done
elif [ -n "$BASH_VERSION" ]; then
  for f in "$DOTFILES_DIR"/bash/*.sh; do
    [ -e "$f" ] || continue
    . "$f"
  done
fi

unset DOTFILES_DIR f
