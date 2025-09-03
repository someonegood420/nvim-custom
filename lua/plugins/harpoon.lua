return {
<<<<<<< HEAD
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
=======
  {
    "ThePrimeagen/harpoon",
    keys = {
      { "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Mark-Harpoon" },
      { "<leader>h", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon-menu" },
      { "<leader>1", function() require("harpoon.ui").nav_file(1) end,         desc = "file 1" },
      { "<leader>2", function() require("harpoon.ui").nav_file(2) end,         desc = "file 2" },
      { "<leader>3", function() require("harpoon.ui").nav_file(3) end,         desc = "file 3" },
      { "<leader>4", function() require("harpoon.ui").nav_file(4) end,         desc = "file 4" },
    },
    config = function()
      require("harpoon").setup({})
    end,
  },
>>>>>>> cd8d81c (keymaps and better theme and added scope.nvim to open tabs better)
}
