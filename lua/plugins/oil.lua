return {
<<<<<<< HEAD
	"stevearc/oil.nvim",
	cmd = "Oil",
	opts = {
		keymaps = {
			["_"] = "actions.select",
			["g_"] = "actions.open_cwd",
		},
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			path_display = "center", -- centers the current path at the top
		},
		float = {
			-- Use percentage-based sizing (87% width, 75% height)
			max_width = math.floor(vim.o.columns * 0.87),
			max_height = math.floor(vim.o.lines * 0.75),
		},
	},
    -- stylua: ignore
    keys = { { "<leader>o", function() vim.cmd("Oil --float") end, desc = "Oil", mode = "n" } },
	config = function(_, opts)
		require("oil").setup(opts)
		vim.api.nvim_set_hl(0, "OilHeader", { bg = "none" }) -- path line

		vim.api.nvim_set_hl(0, "OilNormal", { bg = "none" }) -- main buffer background if needed
	end,
=======
  "stevearc/oil.nvim",
  cmd = "Oil",
  opts = {
    keymaps = {
      ["_"] = "actions.select",
      ["g_"] = "actions.open_cwd",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
      path_display = "center", -- centers the current path at the top
    },
    float = {
      -- Use percentage-based sizing (87% width, 75% height)
      max_width = math.floor(vim.o.columns * 0.87),
      max_height = math.floor(vim.o.lines * 0.75),
    },
  },
  -- stylua: ignore
  keys = { { "<leader>o", function() vim.cmd("Oil --float") end, desc = "Oil", mode = "n" } },
  config = function(_, opts)
    require("oil").setup(opts)
    vim.api.nvim_set_hl(0, "OilHeader", { bg = "none" }) -- path line

    vim.api.nvim_set_hl(0, "OilNormal", { bg = "none" }) -- main buffer background if needed
  end,
>>>>>>> cd8d81c (keymaps and better theme and added scope.nvim to open tabs better)
}
