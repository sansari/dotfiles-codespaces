#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root. Use sudo." >&2
  exit 1
fi

# Define variables
MARKER_FILE="/root/.sansari.dotfiles.codespaces.v1"
ZSHRC_SYMLINK="/root/.zshrc"
ZSHRC_TARGET="/path/to/your/repo/.zshrc.symlink"  # Replace with the actual path to .zshrc.symlink in your repo
OH_MY_ZSH_DIR="/root/.oh-my-zsh"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"

# Create a marker file in root's home directory
echo "Creating marker file at ${MARKER_FILE}"
touch "${MARKER_FILE}"

# Find the directory containing the install scripts
script_dir=$(dirname "$0")
echo "Running install scripts from: ${script_dir}"

# Backup existing .zshrc.symlink if it exists
if [ -h "${ZSHRC_SYMLINK}" ] || [ -f "${ZSHRC_SYMLINK}" ]; then
  echo "Backing up existing .zshrc"
  mv "${ZSHRC_SYMLINK}" "${ZSHRC_SYMLINK}.bak"
  echo "Backup created at ${ZSHRC_SYMLINK}.bak"
fi

# Create symlink for .zshrc.symlink
echo "Creating symlink for .zshrc.symlink"
ln -s "${ZSHRC_TARGET}" "${ZSHRC_SYMLINK}"
echo "Symlink created: ${ZSHRC_SYMLINK} -> ${ZSHRC_TARGET}"

# Ensure Oh My Zsh is installed
if [ -d "${OH_MY_ZSH_DIR}" ]; then
  echo "Oh My Zsh is already installed at ${OH_MY_ZSH_DIR}. Skipping installation."
else
  echo "Oh My Zsh not found. Installing Oh My Zsh..."
  # Install Oh My Zsh in unattended mode without changing .zshrc
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL ${OH_MY_ZSH_INSTALL_URL})" --unattended
  if [ $? -eq 0 ]; then
    echo "Oh My Zsh installed successfully."
  else
    echo "Failed to install Oh My Zsh." >&2
    exit 1
  fi
fi

# Install dotfiles using manage/dotfiles.sh
echo "Installing dotfiles"
"${script_dir}/manage/dotfiles.sh" install

# Change default shell to zsh for root, if not already set
CURRENT_SHELL=$(getent passwd root | cut -d: -f7)
if [ "${CURRENT_SHELL}" != "/bin/zsh" ]; then
  echo "Changing default shell to /bin/zsh for root"
  chsh -s /bin/zsh root
else
  echo "Default shell for root is already /bin/zsh. Skipping shell change."
fi

# Ensure ownership of .oh-my-zsh and .zshrc remains with root
echo "Ensuring ownership of .oh-my-zsh and .zshrc remains with root"
chown -R root:root "${OH_MY_ZSH_DIR}"
chown root:root "${ZSHRC_SYMLINK}"

# Create Oh My Zsh custom themes directory if it doesn't exist
mkdir -p "$HOME/zsh/themes"

# Copy custom theme
cp "$DOTFILES/themes/robbyrussell.zsh-theme" "$HOME/zsh/themes/"

echo "Installation complete. Please restart your terminal."
