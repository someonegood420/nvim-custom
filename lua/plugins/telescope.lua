return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	cmd = "Telescope",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		--Telescope
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fl", builtin.live_grep, { desc = "T-scope Grep" })
		vim.keymap.set("n", "<leader>fd", builtin.current_buffer_fuzzy_find, { desc = "Tscope-fzf" })

		telescope.setup({
			defaults = {
				prompt_prefix = "   ",
				selection_caret = " ",
				entry_prefix = " ",
				sorting_strategy = "ascending",
				layout_config = {
					horizontal = {
						prompt_position = "top",
						preview_width = 0.55,
					},
					width = 0.87,
					height = 0.80,
				},
				mappings = {
					n = {
						["q"] = actions.close,
					},
				},
			},
			pickers = {
				oldfiles = {
					initial_mode = "normal", -- Recent files picker opens in normal mode
				},
			},
		})
	end,
}
