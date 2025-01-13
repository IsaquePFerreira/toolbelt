-- General {{{1
vim.g.mapleader = ","
vim.opt.title = true
vim.opt.mouse = "a"
vim.opt.fileencoding = "utf-8"
vim.opt.wildmenu = true
vim.opt.wildmode = { "longest", "full" }
vim.opt.wildoptions = "pum"
vim.opt.pumheight = 10
vim.opt.wildignore = { "*.png", "*.jpg", "*.jpeg", "*.class" }
vim.opt.showtabline = 1
vim.opt.laststatus = 2
vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "no"
vim.opt.hidden = true
vim.opt.confirm = true
vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Plugins {{{1
local packer = require("packer")

vim.cmd([[packadd packer.nvim]])

packer.startup(function()
	use("wbthomason/packer.nvim")
	use("neovim/nvim-lspconfig")
	use("nvim-treesitter/nvim-treesitter")
	use("nvim-lua/plenary.nvim")
	use("MunifTanjim/nui.nvim")
	use("norcalli/nvim-colorizer.lua")
	use({ "nvim-neo-tree/neo-tree.nvim", branch = "v2.x" })
end)

-- Colors {{{1
vim.opt.background = "dark"
vim.cmd([[
if has('termguicolors')
   set termguicolors
endif
colorscheme dracula
syntax on
filetype plugin indent on

hi Normal guibg=NONE ctermbg=NONE
]])

-- Colorizer
require("colorizer").setup()

-- TreeSitter
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"lua",
		"vim",
		"javascript",
	},
	highlight = { enable = true },
	indent = { enable = true },
	autotag = {
		enable = true,
		filetypes = {
			"html",
			"javascript",
			"typescript",
			"vue",
			"xml",
		},
	},
})

-- Backup files {{{1
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.cmd([[
set path+=**
set undodir=~/.config/nvim/undodir
]])

-- Search {{{1
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Tabs {{{1
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = -1
vim.opt.expandtab = true

-- Editor {{{1
vim.opt.number = false
vim.opt.textwidth = 80
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.spell = false
vim.opt.spelllang = { "pt", "en" }
vim.opt.foldmethod = "marker"
vim.opt.list = false
vim.opt.listchars = { tab = "›-", space = "·", trail = "⋯", eol = "↲" }
vim.opt.fillchars = { vert = "│", fold = " ", eob = "~", lastline = "@" }
vim.opt.inccommand = "split"

-- LSP {{{1
local lspconfig = require("lspconfig")
local caps = vim.lsp.protocol.make_client_capabilities()
local no_format = function(client, bufnr)
	client.resolved_capabilities.document_formatting = false
end

caps.textDocument.completion.completionItem.snippetSupport = true

lspconfig.ts_ls.setup({
	capabilities = caps,
	on_attach = no_format,
})

lspconfig.emmet_ls.setup({
	capabilities = snip_caps,
	filetypes = {
		"css",
		"html",
		"javascriptreact",
		"less",
		"sass",
		"scss",
		"typescriptreact",
	},
})

-- Complete {{{1
vim.opt.completeopt = "menuone,longest,noinsert"
vim.cmd([[
set complete+=kspell
set shortmess+=c
]])

-- File browser {{{1
-- vim.cmd([[
-- let g:netrw_banner=0
-- let g:netrw_liststyle=0
-- let g:netrw_browse_splitl=4
-- let g:netrw_altv=1
-- let g:netrw_winsize=25
-- let g:netrw_keepdir=0
-- let g:netrw_localcopydircmd='cp -r'
-- ]])

-- Neo tree
require("neo-tree").setup({
	close_if_last_window = false,
	enable_diagnostics = true,
	enable_git_status = true,
	popup_border_style = "rounded",
	sort_case_insensitive = false,
	filesystem = {
		filtered_items = {
			hide_dotfiles = false,
			hide_gitignored = false,
		},
	},
	window = { width = 30 },
})

-- Autocmds {{{1
vim.cmd([[
autocmd Filetype * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

autocmd Filetype html setlocal tabstop=2 shiftwidth=2 expandtab

autocmd FileType md,markdown,txt,text, setlocal spell spelllang=pt,en

]])

-- Keymaps {{{1
local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

map("i", "jj", "<esc>")

map("n", "Q", "gq<cr>")

map("n", "j", "gj")
map("n", "k", "gk")

map("n", "<f4>", ":Term<cr>")
map("t", "<f4>", "exit<cr>")

map("n", "<leader>e", ":Neotree toggle<cr>")

map("n", "]b", ":bn<cr>")
map("n", "[b", ":bp<cr>")
map("n", "<leader>c", ":bd<cr>")

map("n", "<leader>t", ":tabnew<cr>")
map("n", "]t", "gt")
map("n", "[t", "gT")
vim.cmd([[nnoremap <leader>n :tabedit<space>]])

map("n", "<esc>", "<cmd>nohlsearch<cr>")

-- Toggles
map("n", "<leader>tn", ":set number!<cr>")
map("n", "<leader>ts", ":set spell!<cr>")
map("n", "<leader>tl", ":set list!<cr>")

-- Auto-Pairs {{{1
map("i", "''", "''<left>")
map("i", '""', '""<left>')
map("i", "()", "()<left>")
map("i", "<>", "<><left>")
map("i", "[]", "[]<left>")
map("i", "{}", "{}<left>")
map("i", "{<cr>", "{<cr><cr>}<c-o>k<c-t>")
map("i", "[[", "[[  ]]<c-o>2h")
map("i", "({", "({  })<c-o>2h")
map("i", "((", "((  ))<c-o>2h")

-- Surround {{{1
map("v", '<leader>"', 'c""<esc>P')
map("v", "<leader>'", "c''<esc>P")
map("v", "<leader>(", "c()<esc>P")
map("v", "<leader>[", "c[]<esc>P")
map("v", "<leader>{", "c{}<esc>P")
map("v", "<leader>`", "c``<esc>P")
map("v", "<leader><", "c<><esc>P")
map("v", "<leader>*", "c**<esc>P")

-- Auto-Complete {{{1
vim.cmd([[
set omnifunc=syntaxcomplete#Complete

inoremap <expr> <Tab> TabComplete()
fun! TabComplete()
    if getline('.')[col('.') - 2] =~ '\K' || pumvisible()
        return "\<C-N>"
    else
        return "\<Tab>"
    endif
endfun

inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
autocmd InsertCharPre * call AutoComplete()
fun! AutoComplete()
    if v:char =~ '\K'
                \ && getline('.')[col('.') - 4] !~ '\K'
                \ && getline('.')[col('.') - 3] =~ '\K'
                \ && getline('.')[col('.') - 2] =~ '\K' " last char
                \ && getline('.')[col('.') - 1] !~ '\K'

        call feedkeys("\<C-N>", 'n')
    end
endfun

" Create file without opening buffer
function! CreateInPreview()
  let l:filename = input('please enter filename: ')
  execute 'silent !touch ' . b:netrw_curdir.'/'.l:filename
  redraw!
endfunction

" Netrw: create file using touch instead of opening a buffer
function! Netrw_mappings()
  noremap <buffer>% :call CreateInPreview()<cr>
endfunction

augroup auto_commands
	autocmd filetype netrw call Netrw_mappings()
augroup END
]])

-- Term {{{1
vim.cmd([[command! Term :botright split term://$SHELL]])
vim.cmd([[
  autocmd TermOpen * setlocal listchars= nonumber norelativenumber nocursorline
  autocmd TermOpen * startinsert
  autocmd BufLeave term://* stopinsert
]])

-- FZF {{{1
vim.cmd([[ source /usr/share/doc/fzf/examples/fzf.vim ]])
map("n", "<c-p>", ":FZF<cr>")
