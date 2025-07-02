#!/bin/bash

set -e

DOTFILES_DIR=~/terminal_editor_settings
cd "$DOTFILES_DIR"

echo "📤 Backing up dotfiles to $DOTFILES_DIR..."

# -------------------------------
# 🐚 Zsh and Oh My Zsh
# -------------------------------
cp ~/.zshrc "$DOTFILES_DIR/"
if [ -d ~/.oh-my-zsh ]; then
  echo "📥 Copying .oh-my-zsh..."
  mkdir -p "$DOTFILES_DIR/.oh-my-zsh"
  rsync -a ~/.oh-my-zsh/ "$DOTFILES_DIR/.oh-my-zsh/"
fi

# -------------------------------
# 📝 Vim and Neovim
# -------------------------------
cp ~/.vimrc "$DOTFILES_DIR/"
mkdir -p "$DOTFILES_DIR/.vim"
rsync -a ~/.vim/ "$DOTFILES_DIR/.vim/"

if [ -d ~/.config/nvim ]; then
  mkdir -p "$DOTFILES_DIR/.config/nvim"
  rsync -a ~/.config/nvim/ "$DOTFILES_DIR/.config/nvim/"
fi

# -------------------------------
# 💾 iTerm2 Preferences
# -------------------------------
echo "💾 Copying iTerm2 preferences..."
mkdir -p "$DOTFILES_DIR/iterm2"
defaults read com.googlecode.iterm2 > "$DOTFILES_DIR/iterm2/com.googlecode.iterm2.plist"

# -------------------------------
# 🔐 API Secrets (zshrc.secret)
# -------------------------------
SECRET_SRC=~/.zshrc.secret
SECRET_DST="$DOTFILES_DIR/.zshrc.secret.gpg"

if [ -f "$SECRET_SRC" ]; then
  echo "🔐 Encrypting ~/.zshrc.secret..."
  gpg --batch --yes --symmetric --cipher-algo AES256 "$SECRET_SRC"
  mv ~/.zshrc.secret.gpg "$SECRET_DST"
else
  echo "⚠️  No ~/.zshrc.secret file found. Skipping encryption."
fi

# -------------------------------
# 🔐 SSH Key Backup (encrypted)
# -------------------------------
SSH_BACKUP="$DOTFILES_DIR/ssh_keys.tar.gz.gpg"

echo "🔐 Archiving and encrypting SSH keys..."
tar -czf ssh_keys.tar.gz -C ~/.ssh config github github.pub gitlab gitlab.pub gitlab_molo gitlab_molo.pub 2>/dev/null || true
gpg --batch --yes --symmetric --cipher-algo AES256 ssh_keys.tar.gz
mv ssh_keys.tar.gz.gpg "$SSH_BACKUP"
rm -f ssh_keys.tar.gz

# -------------------------------
# ✅ Git Commit
# -------------------------------
echo "📝 Committing changes to git..."
git add .
git commit -m "🔄 Backup: $(date +'%Y-%m-%d %H:%M')"

# Optional: uncomment to push
# git push

echo "✅ Backup complete."

