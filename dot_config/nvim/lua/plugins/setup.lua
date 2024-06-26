local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
	use("navarasu/onedark.nvim")
	use("wbthomason/packer.nvim")
	use("nvim-tree/nvim-tree.lua")
	use("nvim-tree/nvim-web-devicons")
	use("lervag/vimtex")
	use({ "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } })
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("neovim/nvim-lspconfig")
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("ray-x/go.nvim")
	use("airblade/vim-gitgutter")
	use("mfussenegger/nvim-dap")
	use("leoluz/nvim-dap-go")
	use({ "rcarriga/nvim-dap-ui", requires = { "nvim-neotest/nvim-nio" } })

	if packer_bootstrap then
		require("packer").sync()
	end
end)
