#!/bin/sh

touch ~/.vladistan.dotfiles.codespaces.v11

# Find the directory containing the install scripts
script_dir=$(dirname "$0")
echo "We are running from ${script_dir}"

# Move existing .zshrc to  backup as it will be clobbered
echo "Backing up existing zshrc"
if [ -f ~/.zshrc ]; then
  mv ~/.zshrc ~/.zshrc.bak
fi

# Install dotfiles
echo "Installing dotfiles"
"${script_dir}/manage/dotfiles.sh" install

echo "Changing default shell for user : ${USER}"
sudo chsh -s /bin/zsh "${USER}"
