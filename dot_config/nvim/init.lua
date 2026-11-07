local set = vim.opt

set.colorcolumn = "100"
set.number = true
set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.autoread = true
set.termguicolors = true

vim.g.mapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Plugins (built-in manager, :h vim.pack). Update with :lua vim.pack.update()
vim.pack.add({
	"https://github.com/navarasu/onedark.nvim",
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-telescope/telescope.nvim",
	"https://github.com/nvim-tree/nvim-tree.lua",
	"https://github.com/nvim-tree/nvim-web-devicons",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/lervag/vimtex",
	"https://github.com/airblade/vim-gitgutter",
})

-- Colors
require("onedark").setup({ style = "darker" })
require("onedark").load()

-- Telescope
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#181818" })
vim.api.nvim_set_hl(0, "TelescopeSelection", { bg = "#424242" })

-- File tree
require("nvim-tree").setup({ view = { adaptive_size = true } })
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>")
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function(data)
		if vim.fn.isdirectory(data.file) == 1 then
			vim.cmd.cd(data.file)
			require("nvim-tree.api").tree.open()
		end
	end,
})

-- VimTeX
vim.g.vimtex_view_method = "zathura"

-- Treesitter: built-in, best effort. Uses a parser if one is installed,
-- otherwise falls back to regular vim syntax highlighting.
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		pcall(vim.treesitter.start, args.buf)
	end,
})

-- LSP: only enable servers that are actually installed.
-- Defaults (0.11+): K hover, grn rename, gra code action, grr references,
-- gri implementation, gO symbols, CTRL-S signature help, [d / ]d diagnostics.
vim.lsp.config("clangd", { cmd = { "clangd", "--clang-tidy" } })
vim.lsp.config("pyright", {
	settings = { python = { analysis = { typeCheckingMode = "off" } } },
})
for _, server in ipairs({ "clangd", "pyright", "gopls" }) do
	local cmd = vim.lsp.config[server].cmd
	if type(cmd) == "table" and vim.fn.executable(cmd[1]) == 1 then
		vim.lsp.enable(server)
	end
end

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = args.buf })
		vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = args.buf })
		if client and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})

-- Format Go on save (gopls also organizes imports via code action)
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		vim.lsp.buf.format()
	end,
})
