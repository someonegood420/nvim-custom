return {
	"AstroNvim/astrotheme",
	lazy = false,
	priority = 1000,
	config = function()
		require("astrotheme").setup({
			plugin_default = "auto",
			plugins = {
				["bufferline.nvim"] = false,
				["heirline.nvim"] = false,
			},

			palettes = {
				astrodark = {
					ui = {
						base = "#000008",
						text = "#fdfeff",
						current_line = "#0f0a26",
						selection = "#310072",
						border = "#150f53",
						title = "#ff2592",
						statusline = "#03020e",
						text_active = "#4d8bee",
						tabline = "#020214",
						inactive_base = "#00000a",
						tab_border = "#110c26",
						sidebar = "#00000a",
						sidebar_fg = "#ff0080",
						float = "#010612",
						float_border = "#030f27",
						prompt = "#ff2592",
						scrollbar = "#0f0a26",
						highlight = "#3794ff",
						menu_selection = "#310072",
						none_text = "#fdfeff",
						text_inactive = "#888888",
						text_match = "#ff0080",
					},

					syntax = {
						comment = "#00DF25",
						string = "#0EF3FF",
						number = "#FFD400",
						boolean = "#FF2E97",
						constant = "#FF2E97",
						char = "#C832FF",
						keyword = "#FF2CF1",
						storage = "#40A9FF",
						type = "#FF1BF0",
						preproc = "#FF2E97",
						func = "#39C0FF",
						special = "#C832FF",
						operator = "#FFEE80",
						delimiter = "#FFEE80",
					},

					types = {
						class = "#DBCD00",
						interface = "#FF2E97",
						parameter = "#FF2E97",
						property = "#40A9FF",
						field = "#FFD400",
						attribute = "#FFD400",
						namespace = "#973DFD",
						constructor = "#6AB0FF",
					},

					git = {
						add = "#0097fc",
						change = "#fdd81d",
						delete = "#d800ca",
						conflict = "#ec0076",
					},

					diagnostic = {
						error = "#ac077a",
						warn = "#fad46d",
						info = "#af21e7",
						hint = "#4ce64c",
					},

					misc = {
						link = "#3794ff",
						heading = "#ff2592",
						bold = "#ff2592",
						italic = "#d31b77",
						underline = "#ff0080",
					},
				},
			},
			highlights = {
				global = {
					modify_hl_groups = function(hl, c)
						-- Example of global overrides
						hl.PluginColor4 = { fg = c.my_grey, bg = c.none }
					end,
				},

				astrodark = {
					modify_hl_groups = function(hl, c)
						-- Comments
						hl.Comment = { fg = "#00DF25", italic = true }

						-- Strings
						hl.String = { fg = "#0EF3FF" }

						-- Numbers
						hl.Number = { fg = "#FFD400" }

						-- Booleans / Constants
						hl.Boolean = { fg = "#FF2E97" }
						hl.Constant = { fg = "#FF2E97" }
						hl.Character = { fg = "#C832FF" }

						-- Keywords / Storage / Types
						hl.Keyword = { fg = "#FF2CF1" }
						hl.StorageClass = { fg = "#40A9FF" }
						hl.Type = { fg = "#FF1BF0" }
						hl.PreProc = { fg = "#FF2E97" }

						-- Functions / Special / Operators / Delimiters
						hl.Function = { fg = "#39C0FF" }
						hl.Special = { fg = "#C832FF" }
						hl.Operator = { fg = "#FFEE80" }
						hl.Delimiter = { fg = "#FFEE80" }

						-- Classes / Interfaces / Fields / Properties / Namespaces / Constructors
						hl.ClassName = { fg = "#DBCD00" }
						hl.Interface = { fg = "#FF2E97" }
						hl.Parameter = { fg = "#FF2E97" }
						hl.Property = { fg = "#40A9FF" }
						hl.Field = { fg = "#FFD400" }
						hl.Attribute = { fg = "#FFD400" }
						hl.Namespace = { fg = "#973DFD" }
						hl.Constructor = { fg = "#6AB0FF" }

						-- Git
						hl.GitAdd = { fg = "#0097fc" }
						hl.GitChange = { fg = "#fdd81d" }
						hl.GitDelete = { fg = "#d800ca" }
						hl.GitConflict = { fg = "#ec0076" }

						-- Diagnostics
						hl.Error = { fg = "#ac077a" }
						hl.Warn = { fg = "#fad46d" }
						hl.Info = { fg = "#af21e7" }
						hl.Hint = { fg = "#4ce64c" }

						-- Misc
						hl.Link = { fg = "#3794ff" }
						hl.Heading = { fg = "#ff2592" }
						hl.Bold = { fg = "#ff2592", bold = true }
						hl.Italic = { fg = "#d31b77", italic = true }
						hl.Underline = { fg = "#ff0080", underline = true }

						hl.CursorLineNr = { fg = "#00FF00" } -- bright green for current line number
						hl.LineNr = { fg = "#AAAAAA" } -- optional: other line numbers
						-- Strings override example
						hl["@String"] = { fg = "#0EF3FF" }
					end,
				},
			},
			palette = "astrodark",

			style = {
				transparent = false,
				inactive = true,
				float = true,
				neotree = true,
				border = true,
			},
		})
		vim.cmd.colorscheme("astrotheme")
	end,
}
