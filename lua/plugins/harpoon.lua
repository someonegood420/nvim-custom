return {
	{
		"ThePrimeagen/harpoon",
		keys = {
			{ "<leader>a", ":lua require('harpoon.mark').add_file()<CR>", desc = "Mark-Harpoon" },
			{ "<leader>h", ":lua require('harpoon.ui').toggle_quick_menu()<CR>", desc = "Harpoon-menu" },
			{ "<leader>1", ":lua require('harpoon.ui').nav_file(1)<CR>", desc = "file 1" },
			{ "<leader>2", ":lua require('harpoon.ui').nav_file(2)<CR>", desc = "file 2" },
			{ "<leader>3", ":lua require('harpoon.ui').nav_file(3)<CR>", desc = "file 3" },
			{ "<leader>4", ":lua require('harpoon.ui').nav_file(4)<CR>", desc = "file 4" },
		},
		config = function()
			require("harpoon").setup({})
		end,
	},
}
