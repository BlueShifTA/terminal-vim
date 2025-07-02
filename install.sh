#!/bin/bash

set -e

DOTFILES_DIR=~/Project/terminal_editor_settings

echo "🔧 Setting up your terminal environment from $DOTFILES_DIR"

# -------------------------------
# 🍺 Homebrew
# -------------------------------
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# -------------------------------
# 📦 Essential tools
# -------------------------------
echo "📦 Installing terminal tools..."
brew install \
  zsh \
  macvim \
  neovim \
  node \
  python@3.10 \
  just \
  gdb \
  gnupg \
  ripgrep \
  lazygit \
  pyright \
  iterm2

# -------------------------------
# 🌀 Oh My Zsh
# -------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🌀 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# -------------------------------
# 🔗 Copy dotfiles
# -------------------------------
echo "🔗 Copying Zsh config..."
cp "$DOTFILES_DIR/.zshrc" ~/
cp -r "$DOTFILES_DIR/.oh-my-zsh" ~/

echo "🔁 Setting Zsh as default shell..."
chsh -s /bin/zsh

echo "🔗 Copying Vim config..."
cp "$DOTFILES_DIR/.vimrc" ~/
cp -r "$DOTFILES_DIR/.vim" ~/

if [ -d "$DOTFILES_DIR/.config/nvim" ]; then
  echo "🔗 Copying Neovim config..."
  mkdir -p ~/.config
  cp -r "$DOTFILES_DIR/.config/nvim" ~/.config/
fi

# -------------------------------
# 🔌 Install vim-plug
# -------------------------------
if [ ! -f ~/.vim/autoload/plug.vim ]; then
  echo "🔌 Installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

echo "📥 Installing Vim plugins..."
vim +'PlugInstall --sync' +qa

# -------------------------------
# 🌍 Node tools
# -------------------------------
echo "🌍 Installing global Node tools..."
npm install -g prettier eslint

# -------------------------------
# 💾 iTerm2 Preferences
# -------------------------------
if [ -f "$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist" ]; then
  echo "💾 Importing iTerm2 preferences..."
  defaults import com.googlecode.iterm2 "$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist"
  killall cfprefsd || true
fi

# -------------------------------
# 🔐 Decrypt API secrets
# -------------------------------
ENCRYPTED_SECRET="$DOTFILES_DIR/.zshrc.secret.gpg"
DECRYPTED_SECRET=~/.zshrc.secret

if [ -f "$ENCRYPTED_SECRET" ]; then
  echo "🔐 Decrypting .zshrc.secret.gpg..."
  gpg --batch --quiet --decrypt "$ENCRYPTED_SECRET" > "$DECRYPTED_SECRET"
  chmod 600 "$DECRYPTED_SECRET"
  echo "✅ Loaded ~/.zshrc.secret"
else
  echo "⚠️  No encrypted API secret found."
fi

# -------------------------------
# 🔐 Decrypt SSH keys
# -------------------------------
SSH_BACKUP="$DOTFILES_DIR/ssh_keys.tar.gz.gpg"
SSH_DIR="$HOME/.ssh"

if [ -f "$SSH_BACKUP" ]; then
  echo "🔐 Decrypting SSH keys..."
  mkdir -p "$SSH_DIR"
  gpg --quiet --decrypt "$SSH_BACKUP" | tar -xz -C "$SSH_DIR"

  chmod 700 "$SSH_DIR"
  chmod 600 "$SSH_DIR"/github "$SSH_DIR"/gitlab "$SSH_DIR"/gitlab_molo 2>/dev/null || true
  chmod 644 "$SSH_DIR"/*.pub 2>/dev/null || true
  echo "✅ SSH keys restored to ~/.ssh"
else
  echo "⚠️  No encrypted SSH keys found."
fi

echo "✅ Installation complete. Restart your terminal."
