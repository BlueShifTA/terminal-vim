-- 🖥️ BASIC SETTINGS
vim.opt.mouse = "a"  -- Enable mouse support in all modes
vim.opt.clipboard = "unnamedplus"  -- Sync Neovim with system clipboard
vim.opt.shell = "/bin/zsh"  -- Use Zsh as default shell
vim.opt.shellcmdflag = "-c"  -- Ensure commands execute properly
vim.opt.termguicolors = true  -- Enable true colors
vim.opt.history = 700
vim.opt.number = true
vim.opt.cmdheight = 2
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.autoread = true
vim.opt.laststatus = 2  -- Always show status line
vim.opt.background = "dark"
-- Always open vertical splits on the right
vim.opt.splitright = true

-- Always open horizontal splits at the bottom
vim.opt.splitbelow = true

vim.api.nvim_create_autocmd("WinNew", {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.cmd("wincmd p") -- Move to the last accessed window
    end, 10) -- Slight delay to ensure window opens before moving
  end
})

-- Set leader key
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Python provider
vim.g.python3_host_prog = "$HOME/lino_Software/mono/.venv/bin/python3"

-- Install lazy.nvim if missing
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 🚀 Load Plugins
require("lazy").setup({
  -- File Explorer
  { "preservim/nerdtree" },


  -- LSP, Code Navigation, Completion
  { "neovim/nvim-lspconfig" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Real-time Linting
  { "dense-analysis/ale" },

  -- Debugging
  { "mfussenegger/nvim-dap" },

  -- Search Plugin
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Optional: Project Management
  { "tpope/vim-projectionist" },

  -- Optional: Monokai Theme
  { "tanvirtin/monokai.nvim" },

})

-- 🎨 THEME & UI CUSTOMIZATIONS
require('monokai').setup{}

-- Cursor and Visuals
vim.opt.guifont = "Monaco:h18"
vim.opt.guicursor = "n-v-c:block-Cursor,i:ver25-iCursor"

-- Highlighting
vim.cmd("highlight CursorLine guibg=#002b36")  -- Dim cursor line
vim.cmd("highlight Cursor guifg=NONE guibg=#333333")
vim.cmd("highlight iCursor guifg=NONE guibg=#444444")
vim.cmd("highlight Normal guibg=NONE ctermbg=NONE guifg=#5CFB75")
vim.cmd("highlight LineNr guibg=FFFB0B")
vim.cmd("highlight VertSplit guibg=NONE guifg=#00FF00")
vim.cmd("highlight Function guifg=#78F8FE")
vim.cmd("highlight Statement guifg=#FCFA6A")
vim.cmd("highlight Repeat guifg=#FCFA6A")
vim.cmd("highlight Operator guifg=#FCFA6A")
vim.cmd("highlight Conditional guifg=#FCFA6A")
vim.cmd("highlight Define guifg=#78F8FE")
vim.cmd("highlight String guifg=#E36CED")
vim.cmd("highlight Comment guifg=#78F8FE")
vim.cmd("highlight Number guifg=#E36CED")

-- 🛠️ KEY MAPPINGS

-- Navigation
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true })

-- File Operations
vim.api.nvim_set_keymap("n", "<leader>w", ":w!<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>wq", ":wq!<CR>", { noremap = true })

-- Copilot Keybinding
vim.api.nvim_set_keymap("i", "<C-Space>", 'copilot#Accept("")', { expr = true, silent = true, noremap = true })

-- NERDTree

vim.api.nvim_set_keymap("n", "<leader>nt", ":NERDTreeToggle<CR>", { noremap = true })
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 30
vim.api.nvim_create_autocmd("VimEnter", { command = "NERDTree | wincmd p" })

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = [[if winnr("$") == 1 && exists("b:NERDTree") | quit | endif]]
})


-- LSP & Diagnostics
vim.api.nvim_set_keymap("n", "<leader>jd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-M>", function() vim.diagnostic.open_float(nil, { focusable = true, border = "rounded" }) end, { noremap = true, silent = true })

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 4 },
  signs = true,
  underline = true,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
  end,
})

-- ALE (Linting)
vim.g.ale_linters = {
  python = {'flake8', 'pyright'},
  javascript = {'eslint'},
  typescript = {'eslint'},
  cpp = {'clangd'}
}
vim.g.ale_fixers = {
  ['*'] = {'remove_trailing_lines', 'trim_whitespace'},
  python = {'black'},
  javascript = {'eslint'},
  typescript = {'eslint'}
}
vim.g.ale_fix_on_save = 1


-- Telescope (Search)
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true })

-- LSP Configuration
local lspconfig = require('lspconfig')
lspconfig.pyright.setup({
  root_dir = function(fname) return require("lspconfig.util").find_git_ancestor(fname) or vim.fn.expand("~/lino_Software/mono/projects") end,
  settings = { python = { analysis = { extraPaths = { "/Users/sekin/lino_Software/mono/projects/api/lino_api", "/Users/sekin/lino_Software/mono/projects/lino/lino" }, diagnosticMode = "workspace", useLibraryCodeForTypes = true } } }
})
lspconfig.ts_ls.setup{}
lspconfig.clangd.setup{}

-- Auto-completion
local cmp = require'cmp'
cmp.setup({
  mapping = {
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },
  sources = { { name = 'nvim_lsp' }, { name = 'buffer' } }
})

-- Debugging (DAP)
local dap = require('dap')
dap.adapters.python = { type = 'executable', command = '/usr/bin/python3', args = { '-m', 'debugpy.adapter' } }
dap.configurations.python = { { type = 'python', request = 'launch', name = "Launch file", program = "${file}" } }

-- ENVIRONMENT VARIABLES
vim.env.PYTHONPATH = "/Users/sekin/mono/projects"


-- Misc.

vim.api.nvim_set_keymap("n", "<Left>", "col('.') == 1 ? 'gk$' : '<Left>'", { noremap = true, expr = true })
vim.api.nvim_set_keymap("n", "<Right>", "col('.') >= col('$') - 1 ? 'gj0' : '<Right>'", { noremap = true, expr = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local last_pos = vim.fn.line("'\"")
    if last_pos > 1 and last_pos <= vim.fn.line("$") then
      vim.api.nvim_win_set_cursor(0, { last_pos, 0 })
    end
  end
})


