return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
        -- stylua: ignore start
			{ "<leader>h", function() require("harpoon"):list():add() end, desc = "HarpMark" },
      { "<leader>v", function()
          local harpoon = require("harpoon")
          local list = harpoon:list()
          local ui_max_width = math.max(30, math.floor(vim.o.columns * 0.25))
          local height_in_lines = 10
          local row = math.floor((vim.o.lines - height_in_lines) / 2) - 5
          local col = math.floor((vim.o.columns - ui_max_width) / 2) - 1
          harpoon.ui:toggle_quick_menu(list, {
            border = "rounded",
            title = " Harpoon ",
            title_pos = "center",
            ui_max_width = ui_max_width,
            height_in_lines = height_in_lines,
            row =  math.floor((vim.o.lines - height_in_lines) / 2) - 5,
            col = math.floor((vim.o.columns - ui_max_width) / 2) - 1,
          })
        end, desc = "HarpMenu" },
			{ "<leader>1", function() require("harpoon"):list():select(1) end, desc = "File 1" },
			{ "<leader>2", function() require("harpoon"):list():select(2) end, desc = "File 2" },
			{ "<leader>3", function() require("harpoon"):list():select(3) end, desc = "File 3" },
			{ "<leader>4", function() require("harpoon"):list():select(4) end, desc = "File 4" },
			-- stylua: ignore end
		},
		config = function() require("harpoon"):setup() end,
	},
}
