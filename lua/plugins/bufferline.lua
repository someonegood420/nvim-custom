return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = {
			"tiagovla/scope.nvim", -- added scope.nvim
		},
		config = function()
			-- Enabled scope.nvim
			require("scope").setup({})

			-- keymaps
			vim.keymap.set("n", "gb", ":BufferLinePick<CR>", { silent = true })
			--highlights
			require("bufferline").setup({
				-- THE FIX IS HERE: All instances of "none" are changed to 'NONE'
				highlights = {
					fill = { fg = "#b5b5b5", bg = "NONE" },
					background = { fg = "#b5b5b5", bg = "NONE" },
					tab = { fg = "#666666", bg = "NONE" },
					tab_selected = { fg = "#FF2E97", bg = "NONE" },
					tab_separator = { fg = "#262626", bg = "NONE" },
					tab_separator_selected = { fg = "#262626", bg = "NONE" },
					tab_close = { fg = "#ff8787", bg = "NONE" },

					close_button = { fg = "#ff8787", bg = "NONE" },
					close_button_visible = { fg = "#ff8787", bg = "NONE" },
					close_button_selected = { fg = "#ff8787", bg = "NONE" },

					buffer_visible = { fg = "#ffffff", bg = "NONE" },
					buffer_selected = { fg = "#ffffff", bg = "NONE", bold = true, italic = false },

					modified = { fg = "#00ff00", bg = "NONE" },
					modified_visible = { fg = "#00ff00", bg = "NONE" },
					modified_selected = { fg = "#00ff00", bg = "NONE" },

					pick_selected = { fg = "#ffd700", bg = "NONE", bold = true, italic = false },
					pick_visible = { fg = "#ffd700", bg = "NONE", bold = true, italic = false },
				},
				options = {
					-- Your options remain the same
					tab_size = 0,
					show_buffer_icons = false,
					buffer_close_icon = "",
					modified_icon = "",
					close_icon = "",
					left_trunc_marker = "",
					enforce_regular_tabs = false,
					right_trunc_marker = "",
					color_icons = false,
					seperator = false, -- Note: The option name is 'separator_style', not 'seperator'
					indicator_icon = "",
					separator_style = { "", "" },
					pick = { alphabet = "fjhgdkla" },
				},
			})

			-- This block of code is now redundant for bufferline
			-- You can safely remove it if you have no other plugins using this global variable
			vim.g.transparent_groups = vim.list_extend(
				vim.g.transparent_groups or {},
				vim.tbl_map(function(v)
					return v.hl_group
				end, vim.tbl_values(require("bufferline.config").highlights))
			)
		end,
	},
}
