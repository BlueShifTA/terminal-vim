#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔧 Setting up your terminal environment from $DOTFILES_DIR"

# -------------------------------
# 🍺 Homebrew
# -------------------------------
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="/opt/homebrew/bin:$PATH"

# -------------------------------
# 📦 Essential tools
# -------------------------------
echo "📦 Installing terminal tools..."
brew install \
  zsh \
  vim \
  neovim \
  node \
  python \
  just \
  gdb \
  gnupg \
  ripgrep \
  lazygit \
  pyright

echo "🐍 Ensuring Python tooling (rope for Coc)..."
if command -v uv >/dev/null 2>&1; then
  echo "   using uv to install rope"
  uv pip install --upgrade rope
else
  PYTHON_HOST="$(command -v python3 || command -v python || true)"
  if [ -n "$PYTHON_HOST" ]; then
    echo "   using python at $PYTHON_HOST"
    "$PYTHON_HOST" -m pip install --upgrade pip >/dev/null 2>&1 || true
    "$PYTHON_HOST" -m pip install --upgrade rope
  else
    echo "⚠️  No python interpreter found on PATH; skipping rope install"
  fi
fi

brew install --cask iterm2

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
cp -r "$DOTFILES_DIR/.oh-my-zsh" ~/ 2>/dev/null || true

echo "🔁 Setting Zsh as default shell..."
chsh -s /bin/zsh

echo "🔗 Copying Vim config..."
cp "$DOTFILES_DIR/.vimrc" ~/
cp -r "$DOTFILES_DIR/.vim" ~/ 2>/dev/null || true

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

  echo "🔐 Fixing SSH permissions..."
  chmod 700 ~/.ssh
  chown "$USER:staff" ~/.ssh
  chmod 400 ~/.ssh/git* 2>/dev/null || true
  chmod 644 ~/.ssh/config 2>/dev/null || true

  echo "✅ SSH keys restored to ~/.ssh"
else
  echo "⚠️  No encrypted SSH keys found."
fi

echo "🔧 Configuring Git..."

git config --global push.autoSetupRemote true
git config --global pull.rebase true
git config --global rebase.autoStash true

echo "✅ Git is now configured with:"
echo "  • push.autoSetupRemote = true"
echo "  • pull.rebase = true"
echo "  • rebase.autoStash = true"

echo "✅ Installation complete. Please restart your terminal."
