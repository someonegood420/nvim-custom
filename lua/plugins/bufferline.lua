return {
	"akinsho/bufferline.nvim",
	version = "*", -- or a specific tag
	config = function()
		require("bufferline").setup({
			highlights = {
				fill = { fg = "#666666", bg = "#000008" },
				background = { fg = "#666666", bg = "#000008" },
				tab = { fg = "#666666", bg = "#00000a" },
				tab_selected = { fg = "#FF2E97", bg = "#020214" },
				tab_separator = { fg = "#262626", bg = "#00000a" },
				tab_separator_selected = { fg = "#262626", bg = "#020214", sp = "#020214", underline = false },
				tab_close = { fg = "#ff8787", bg = "#00000a" },

				close_button = { fg = "#ff8787", bg = "#020214" },
				close_button_visible = { fg = "#ff8787", bg = "#00000a" },
				close_button_selected = { fg = "#ff8787", bg = "#020214" },

				buffer_visible = { fg = "#ffffff", bg = "#00000a" },
				buffer_selected = { fg = "#ffffff", bg = "#020214", bold = true, italic = false },
				modified = { fg = "#00ff00", bg = "#020214" },
				modified_visible = { fg = "#00ff00", bg = "#020214" },
				modified_selected = { fg = "#00ff00", bg = "#666666" },
				pick_selected = { fg = "#ffd700", bg = "#666666", bold = true, italic = false },
				pick_visible = { fg = "#ffd700", bg = "#333333", bold = true, italic = false },
			},
			options = {
				tab_size = 0,
				show_buffer_icons = false,
				buffer_close_icon = "",
				modified_icon = "",
				close_icon = "",
				left_trunc_marker = "",
				enforce_regular_tabs = false,
				right_trunc_marker = "",
				color_icons = false,
				seperator = false,
				indicator_icon = " ",
				separator_style = { "", "" },
			},
		})
	end,
}
