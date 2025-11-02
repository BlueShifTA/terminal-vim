# Terminal & Vim Workflow

| Command | Description |
| --- | --- |
| `,jd` | Jump to definition with Coc (primary navigation workhorse). |
| `,sf` | FZF file picker in the current working directory. |
| `,rn` | Rename symbol via Coc’s LSP rename. |
| `,sF` | FZF file picker from the project (Git) root. |
| `,sg` | Ripgrep search in the current directory using FZF. |
| `,sG` | Ripgrep search from the project root. |
| `,jt` | Jump to type definition. |
| `,jr` | List references for the symbol under the cursor. |
| `,ca` | Trigger Coc code actions for quick fixes/refactors. |
| `,gs` | Open Fugitive status window for Git operations. |
| `,gh` | Show history for the current file (`:Gclog %`). |
| `,gL` | Open the current file/commit in the browser via GBrowse. |
| `,gY` | Copy a shareable Git URL for the current file/commit. |
| `,ga` | Stage tracked changes (`git add -u`). |
| `,gd` | Vertical diff split against HEAD. |
| `,gl` | Repository history (`:0Gclog`). |
| `,gw` | Stage the current buffer (`:Gwrite`). |
| `,gc` | Start an interactive `git commit`. |

## What This Repository Gives You
- Opinionated Vim setup with Coc, ALE, FZF, NERDTree, Vimspector, Fugitive/Rhubarb/GitLab integration, Copilot, and Vim AI helpers.
- Unified keybinding scheme built around the comma leader and mnemonic prefixes (`j` for jumps, `s` for search, `g` for Git).
- Project-aware search commands using ripgrep and FZF for both current directory and Git root scopes.
- Git workflows directly from Vim, including blame, history, GBrowse links, and quick staging/committing.
- Python LSP support (Pyright) ready to go; ALE handles formatting with Black/pycln and Prettier/ESLint for JS/TS.

## Quick Start
1. **Clone** this repository wherever you store your dotfiles, e.g.
   ```bash
   git clone git@github.com:yourname/terminal-vim.git ~/terminal-vim
   ```
2. **Bootstrap a new Mac** (Homebrew, shells, Vim configs, plugins, tooling):
   ```bash
   cd ~/terminal-vim
   ./scripts/install.sh
   ```
3. **Open Vim** once to let vim-plug sync plugins (only runs automatically if they are missing). If you add new plugins later, run `:PlugInstall` manually.
4. **Install Coc extensions** as needed (they will auto-install on first launch, but you can re-run):
   ```vim
   :CocInstall coc-pyright coc-json coc-tsserver coc-yaml
   ```
5. **Clean up secrets artifacts** (after restoring them to `~/.zshrc.secret` / `~/.ssh`):
   ```bash
   ./scripts/cleanup.sh
   ```
6. **Rewrite history to drop encrypted files**:
   ```bash
   ./scripts/repo_clean.sh
   ```

## Key Plugins Included
- **dense-analysis/ale** – linting/formatting on save.
- **neoclide/coc.nvim** – LSP client providing jump, rename, code actions.
- **junegunn/fzf.vim** – Fuzzy search front-end backed by ripgrep.
- **preservim/nerdtree** – Project drawer (auto-opens when Vim starts without args).
- **tpope/vim-fugitive**, **tpope/vim-rhubarb**, **shumphrey/fugitive-gitlab.vim** – Git status, blame, diff, history, and GBrowse links for GitHub/GitLab.
- **puremourning/vimspector** – Debugger interface.
- **github/copilot.vim** & **madox2/vim-ai** – AI pair programming/chat from inside Vim.

## Notes & Tips
- Leader is set to comma (`let mapleader = ','`).
- Visual selections `*`/`#` reuse `VisualSelection()` to search forward/backward.
- The FZF commands automatically ignore typical build artifacts (`dist`, `build`, `node_modules`, `.cache`, miniﬁed files).
- `install.sh` uses `uv` (if available) to install Python dependencies like `rope`.
- GBrowse requires your Git remote to be HTTPS/SSH pointing to GitHub or GitLab; the GitLab handler is preconfigured for `gitlab.com`.

## Secrets Workflow
- `scripts/backup.sh` encrypts `~/.zshrc.secret` and your selected SSH keys using AES-256 symmetric GPG. You choose the passphrase when prompted; it isn’t stored anywhere, so remember it.
- `scripts/install.sh` detects those `.gpg` files and decrypts them back into place, prompting for the same passphrase during setup.
- Run `scripts/cleanup.sh` after you’ve restored secrets to remove the encrypted archives from the repository working tree (and unstage them if they were tracked). Follow up with `./scripts/repo_clean.sh` to scrub them from Git history and force-push the rewritten history so the secrets disappear everywhere.

## Minimal Vim Config
Need something portable for any machine? Use the provided `.vimrc_small`:

```bash
cp .vimrc_small ~/.vimrc
```

It installs only the essentials—`coc.nvim` for go-to-definition, `fzf.vim` for file search, and `nerdtree` for navigation—while keeping the rest of the setup lightweight. Run `:PlugInstall` the first time to fetch the plugins. All key bindings mirror the defaults described above (``,jd`` for definition, `,sf`/`,sg` for search, `,nt` for NERDTree toggle).

Feel free to tailor mappings or plugin lists to your workflow—this repository is meant to be a starting point that captures the core everyday motions listed in the table above.
