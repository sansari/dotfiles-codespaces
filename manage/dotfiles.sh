#!/bin/sh

# shellcheck disable=SC2162,SC2030,SC2031,SC2001

# Get the absolute path of the script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Set the dotfiles directory relative to the script
DOTFILES_DIR="${SCRIPT_DIR}/../dotfiles"

walk() {
  COMMAND="$1"

  find "${DOTFILES_DIR}" \
    -path '*/.git' -prune -o \
    -name '*.symlink' -print | while read TARGET; do
    # For $DOTFILES_DIR/dir1/dir2/file.symlink
    #   WITHIN_DIR:   dir1/dir2/file.symlink
    #   ABSOLUTE_PATH: /full/path/to/dir1/dir2/file.symlink
    #   LINK_PATH:    dir1/dir2/file
    #   LINK:         $HOME/dir1/dir2/file
    #   LINK_DIR:     $HOME/dir1/dir2

    WITHIN_DIR=$(echo "$TARGET" | sed -e 's|^'"$DOTFILES_DIR"'/||')
    ABSOLUTE_PATH=$(readlink -f "$TARGET")
    LINK_PATH=$(echo "$WITHIN_DIR" | sed -e 's|.symlink$||')
    LINK="$HOME/$LINK_PATH"
    LINK_DIR=$(echo "$LINK" | sed -e 's|/[^/]*$||')

    $COMMAND
  done
}

list() {
  echo "$WITHIN_DIR"
  echo "  -> $LINK"
}

install() {
  if [ -h "$LINK" ]; then
    # The target is already symlinked.
    return
  fi

  if [ -e "$LINK" ]; then
    echo "[collide] $LINK_PATH"
    return
  fi

  echo "[link]    $LINK_PATH"
  mkdir -p "$LINK_DIR"
  ln -s "$ABSOLUTE_PATH" "$LINK"
}

uninstall() {
  if [ -h "$LINK" ]; then

    echo "[unlink]  $LINK_PATH"
    rm "$LINK"
    # Try to remove the containing directory.  This will fail if
    # there's other stuff there, and that's totally fine.
    rmdir "$LINK_DIR" >/dev/null 2>&1
    return
  fi

  if [ -e "$LINK" ]; then
    echo "[collide] $LINK_PATH"
    return
  fi
}

COMMAND="$1"
if [ -z "$COMMAND" ]; then
  echo "Usage: dotfiles install"
  echo "       dotfiles uninstall"
  echo "       dotfiles list"
  exit 1
fi

case "$COMMAND" in
list) walk list ;;
install) walk install ;;
uninstall) walk uninstall ;;
*)
  echo "Unknown command $COMMAND"
  exit 1
  ;;
esac
