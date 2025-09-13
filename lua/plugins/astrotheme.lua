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
				["snacks.nvim"] = false,
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
						tabline = "none",
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
				global = {},

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
						hl.Variable = { fg = "#FF2E97" }

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
						hl.LineNr = { fg = "#b30059" } -- optional: other line numbers
					end,
					["@String"] = { fg = "#0EF3FF" },
					["@comment"] = { fg = "#00ff00", italic = true },
					["@function"] = { fg = "#ff7edb" },
					["@function.call"] = { fg = "#ffcc00" },
					["@function.method"] = { fg = "#ffcc00" },
					["@function.builtin"] = { fg = "#FFD400" },
					["@keyword"] = { fg = "#40A9FF", bold = true },
					["@variable"] = { fg = "#FF2E97" },
					["@field"] = { fg = "#FFD400" },
					["@parameter"] = { fg = "#FF2E97" },
					["@type.builtin"] = { fg = "#FF2CF1", bold = true },
					["@variable.member"] = { fg = "#FFD400" },
					["@variable.builtin"] = { fg = "#FFD400" },
					["@operator"] = { fg = "#FF2CF1" },
					["@punctuation.bracket"] = { fg = "#af6df9" },
					["@punctuation.delimiter"] = { fg = "#ff4450" },
					["@string"] = { fg = "#0EF3FF" },
					["Boolean"] = { fg = "#0EF3FF", bold = true },
					["@number.float"] = { fg = "#0EF3FF" },
					["@number"] = { fg = "#0EF3FF" },
					["@property"] = { fg = "#61e2ff" },
					["@type"] = { fg = "#ff2cf1" },
					["Include"] = { fg = "#ffcc00" },
					["Structure"] = { fg = "#40a9ff" },
					["Conditional"] = { fg = "#ff2cf1" },
					["SnacksDashboardDesc"] = { fg = "#0EF3FF", bg = "none" },
					["SnacksDashboardIcon"] = { fg = "#FF2592", bg = "none" },
					["SnacksDashboardSpecial"] = { fg = "#FF2E97", bg = "none" },
					["SnacksDashboardFile"] = { fg = "#0EF3FF", bg = "none" },
					["SnacksDashboardTitle"] = { fg = "#FF2592", bg = "none" },
					["SnacksDashboardHeader"] = { fg = "#FF2592", bg = "none" },
					["SnacksDashboardFooter"] = { fg = "#FF2592", bg = "none" },
					["SnacksDashboardGitType"] = { fg = "#FF2592", bg = "none" },
					["SnacksDashboardGitBranch"] = { fg = "#FF2592", bg = "none" },
					["FloatTitle"] = { fg = "#FF2592", bg = "none" },
					["NvimTreeRootFolder"] = { fg = "#ee984d", bg = "none" },
					["NvimTreeEndOfBuffer"] = { fg = "#ee984d", bg = "none" },
					["CursorLine"] = { bg = "#06060d" },
					["MatchParen"] = { fg = "#EB8332", bg = "#333340" },
					["SnacksDim"] = { fg = "#222245", italic = true },
					["DiagnosticUnnecessary"] = { fg = "#264522", italic = true },
				},
			},
			palette = "astrodark",
			style = {
				transparent = true,
				inactive = false,
				float = true,
				neotree = true,
				border = true,
			},
		})
		vim.cmd.colorscheme("astrotheme")
	end,
}
