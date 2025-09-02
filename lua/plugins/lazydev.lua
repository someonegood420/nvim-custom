return {
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on Lua files
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"folke/neodev.nvim",
		enabled = false, -- prevent conflict with lazydev
	},
}
