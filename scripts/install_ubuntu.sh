#!/usr/bin/env bash

set -euo pipefail

if [[ "${DEBUG:-}" == "1" ]]; then
  set -x
fi

if [[ $(uname -s) != "Linux" ]]; then
  echo "❌ This installer is intended for Ubuntu/Linux environments." >&2
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "❌ 'apt-get' not found. Are you sure this is an Ubuntu-based system?" >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "❌ This script requires 'sudo'. Please install sudo or run as a user with sudo privileges." >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

info() { printf '%s\n' "${1}"; }
warn() { printf '%s\n' "⚠️  ${1}"; }

info "🔧 Setting up your terminal environment from $DOTFILES_DIR"

info "📦 Updating apt package index..."
sudo apt-get update

REQUIRED_PACKAGES=(
  zsh
  vim
  neovim
  nodejs
  npm
  python3
  python3-pip
  ripgrep
  gnupg
  rsync
  curl
  tar
  git
  gdb
)

OPTIONAL_PACKAGES=(
  just
  lazygit
)

info "📦 Installing required packages with apt..."
sudo apt-get install -y "${REQUIRED_PACKAGES[@]}"

for pkg in "${OPTIONAL_PACKAGES[@]}"; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    continue
  fi
  info "📦 Installing optional package: $pkg"
  if ! sudo apt-get install -y "$pkg"; then
    warn "Could not install optional package '$pkg'. You can install it manually later if desired."
  fi
done

if ! command -v zsh >/dev/null 2>&1; then
  echo "❌ zsh did not install correctly. Aborting." >&2
  exit 1
fi

info "🐍 Ensuring Python tooling (rope for Coc)..."
PYTHON_HOST="$(command -v python3 || true)"
if [[ -n "$PYTHON_HOST" ]]; then
  "$PYTHON_HOST" -m pip install --upgrade --user pip >/dev/null 2>&1 || true
  "$PYTHON_HOST" -m pip install --upgrade --user rope
else
  warn "No python3 interpreter found on PATH; skipping rope install"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  info "🌀 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

info "🔗 Copying Zsh config..."
cp "$DOTFILES_DIR/.zshrc" ~/
cp -r "$DOTFILES_DIR/.oh-my-zsh" ~/ 2>/dev/null || true

info "🔁 Setting Zsh as default shell..."
ZSH_PATH="$(command -v zsh)"
if [[ -n "$ZSH_PATH" ]]; then
  chsh -s "$ZSH_PATH"
else
  warn "zsh not found on PATH; skipping chsh"
fi

info "🔗 Copying Vim config..."
cp "$DOTFILES_DIR/.vimrc" ~/
cp -r "$DOTFILES_DIR/.vim" ~/ 2>/dev/null || true

if [[ -d "$DOTFILES_DIR/.config/nvim" ]]; then
  info "🔗 Copying Neovim config..."
  mkdir -p "$HOME/.config"
  cp -r "$DOTFILES_DIR/.config/nvim" "$HOME/.config/"
fi

if [[ ! -f "$HOME/.vim/autoload/plug.vim" ]]; then
  info "🔌 Installing vim-plug..."
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "📥 Installing Vim plugins..."
vim +'PlugInstall --sync' +qa || warn "vim-plug install exited with a non-zero status. Run ':PlugInstall' manually if needed."

if command -v npm >/dev/null 2>&1; then
  info "🌍 Installing global Node tools..."
  if ! sudo npm install -g npm >/dev/null 2>&1; then
    warn "Failed to update npm globally; continuing with existing version."
  fi
  sudo npm install -g prettier eslint pyright || warn "Failed to install some global npm tools."
else
  warn "npm not found; skipping global Node tooling."
fi

ENCRYPTED_SECRET="$DOTFILES_DIR/.zshrc.secret.gpg"
DECRYPTED_SECRET="$HOME/.zshrc.secret"
if [[ -f "$ENCRYPTED_SECRET" ]]; then
  info "🔐 Decrypting .zshrc.secret.gpg..."
  if gpg --batch --quiet --decrypt "$ENCRYPTED_SECRET" > "$DECRYPTED_SECRET"; then
    chmod 600 "$DECRYPTED_SECRET"
    info "✅ Loaded ~/.zshrc.secret"
  else
    warn "Failed to decrypt .zshrc.secret.gpg"
  fi
else
  warn "No encrypted API secret found."
fi

SSH_BACKUP="$DOTFILES_DIR/ssh_keys.tar.gz.gpg"
SSH_DIR="$HOME/.ssh"
if [[ -f "$SSH_BACKUP" ]]; then
  info "🔐 Decrypting SSH keys..."
  mkdir -p "$SSH_DIR"
  if gpg --quiet --decrypt "$SSH_BACKUP" | tar -xz -C "$SSH_DIR"; then
    info "🔐 Fixing SSH permissions..."
    chmod 700 "$SSH_DIR"
    chown "$USER":"$(id -gn "$USER")" "$SSH_DIR"
    chmod 400 "$SSH_DIR"/git* 2>/dev/null || true
    chmod 644 "$SSH_DIR"/config 2>/dev/null || true
    info "✅ SSH keys restored to ~/.ssh"
  else
    warn "Failed to decrypt SSH key archive."
  fi
else
  warn "No encrypted SSH keys found."
fi

info "🔧 Configuring Git..."
git config --global push.autoSetupRemote true
git config --global pull.rebase true
git config --global rebase.autoStash true

info "✅ Git is now configured with:"
info "  • push.autoSetupRemote = true"
info "  • pull.rebase = true"
info "  • rebase.autoStash = true"

info "✅ Installation complete. Please restart your terminal."
