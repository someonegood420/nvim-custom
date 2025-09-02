return {
	"akinsho/bufferline.nvim",
	version = "*", -- or a specific tag
	dependencies = "nvim-tree/nvim-web-devicons",
	config = function()
		require("bufferline").setup()
	end,
}
