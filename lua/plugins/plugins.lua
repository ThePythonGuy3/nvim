return {
	{ "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},

	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		cmd = {
			"NvimTreeFocus",
		}
	},

	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},

	{
		"s1n7ax/nvim-window-picker"
	},

	-- LSP Stuff --
	{
		"neovim/nvim-lspconfig"
	},

	{
		"hrsh7th/cmp-nvim-lsp"
	},

	{
		"hrsh7th/cmp-buffer"
	},

	{
		"hrsh7th/cmp-path"
	},

	{
		"hrsh7th/cmp-cmdline"
	},

	{
		"hrsh7th/nvim-cmp"
	},

	{
		"L3MON4D3/LuaSnip"
	},

	{
		"saadparwaiz1/cmp_luasnip"
	},

	-- Brackets --
	{
		"m4xshen/autoclose.nvim"
	}
}