return {
<<<<<<< HEAD
	"rebelot/heirline.nvim",
	event = "VeryLazy",
	config = function()
		local heirline = require("heirline")
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")

		-- Manual dark mode palette
		local colors = {
			bg = "#03020e", -- bar background
			fg = "#4d8bee", -- bar foreground
			black = "#000000",
			red = "#f38ba8",
			green = "#a6e3a1",
			yellow = "#f9e2af",
			blue = "#89b4fa",
			magenta = "#f5c2e7",
			dark_pink = "#080526",
			cyan = "#94e2d5",
			orange = "#fab387",
			pink = "#FF2E97",
		}

		-- Ensure the whole statusline uses dark background
		vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
		vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.black, fg = colors.fg })

		-- Mode mapping based on lualine's implementation (RESTORED)
		local mode_map = {
			["n"] = "NORMAL",
			["no"] = "O-PENDING",
			["nov"] = "O-PENDING",
			["noV"] = "O-PENDING",
			["no\22"] = "O-PENDING",
			["niI"] = "NORMAL",
			["niR"] = "NORMAL",
			["niV"] = "NORMAL",
			["nt"] = "NORMAL",
			["ntT"] = "NORMAL",
			["v"] = "VISUAL",
			["vs"] = "VISUAL",
			["V"] = "V-LINE",
			["Vs"] = "V-LINE",
			["\22"] = "V-BLOCK",
			["\22s"] = "V-BLOCK",
			["s"] = "SELECT",
			["S"] = "S-LINE",
			["\19"] = "S-BLOCK",
			["i"] = "INSERT",
			["ic"] = "INSERT",
			["ix"] = "INSERT",
			["R"] = "REPLACE",
			["Rc"] = "REPLACE",
			["Rx"] = "REPLACE",
			["Rv"] = "V-REPLACE",
			["Rvc"] = "V-REPLACE",
			["Rvx"] = "V-REPLACE",
			["c"] = "COMMAND",
			["cv"] = "EX",
			["ce"] = "EX",
			["r"] = "REPLACE",
			["rm"] = "MORE",
			["r?"] = "CONFIRM",
			["!"] = "SHELL",
			["t"] = "TERMINAL",
		}

		local function get_mode_name()
			local mode_code = vim.api.nvim_get_mode().mode
			return mode_map[mode_code] or mode_code:upper()
		end

		-- Manual mode colors (no theme highlights)
		local function get_mode_color()
			local mode_code = vim.api.nvim_get_mode().mode
			local mc = {
				-- NORMAL family
				["n"] = colors.blue,
				["no"] = colors.blue,
				["nov"] = colors.blue,
				["noV"] = colors.blue,
				["no\22"] = colors.blue,
				["niI"] = colors.blue,
				["niR"] = colors.blue,
				["niV"] = colors.blue,
				["nt"] = colors.blue,
				["ntT"] = colors.blue,
				-- VISUAL family
				["v"] = colors.magenta,
				["vs"] = colors.magenta,
				["V"] = colors.magenta,
				["Vs"] = colors.magenta,
				["\22"] = colors.magenta,
				["\22s"] = colors.magenta,
				-- SELECT
				["s"] = colors.yellow,
				["S"] = colors.yellow,
				["\19"] = colors.yellow,
				-- INSERT
				["i"] = colors.green,
				["ic"] = colors.green,
				["ix"] = colors.green,
				-- REPLACE family
				["R"] = colors.red,
				["Rc"] = colors.red,
				["Rx"] = colors.red,
				["Rv"] = colors.red,
				["Rvc"] = colors.red,
				["Rvx"] = colors.red,
				["r"] = colors.red,
				-- COMMAND / EX / MORE / CONFIRM
				["c"] = colors.orange,
				["cv"] = colors.orange,
				["ce"] = colors.orange,
				["rm"] = colors.orange,
				["r?"] = colors.orange,
				-- SHELL / TERMINAL
				["!"] = colors.cyan,
				["t"] = colors.cyan,
			}
			return mc[mode_code] or colors.blue
		end

		local function with_trailing_space(component)
			return {
				component,
				{ condition = component.condition, provider = " " },
			}
		end

		local function with_leading_space(component)
			return {
				{ condition = component.condition, provider = " " },
				component,
			}
		end

		local ViMode = {
			{
				provider = function()
					return " " .. get_mode_name() .. " "
				end,
				hl = function()
					return {
						bg = get_mode_color(),
						fg = colors.black, -- solid dark text on bright mode color
						bold = true,
					}
				end,
			},
			{
				provider = "",
				hl = function()
					return { fg = get_mode_color() }
				end,
			},
		}

		local FileEncoding = {
			condition = function()
				local win_config = vim.api.nvim_win_get_config(0)
				local is_floating = win_config.relative ~= ""
				return not is_floating
			end,
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
				return enc
			end,
		}

		local FileFormat = {
			condition = function()
				local win_config = vim.api.nvim_win_get_config(0)
				local is_floating = win_config.relative ~= ""
				return not is_floating
			end,
			provider = function()
				local fileformat_symbols = {
					unix = "",
					dos = "",
					mac = "",
				}
				local format = vim.bo.fileformat
				local symbol = fileformat_symbols[format] or format
				return symbol
			end,
		}

		local GitBranch = {
			condition = function()
				return vim.b.gitsigns_head and not vim.b.gitsigns_git_status
			end,
			provider = function()
				local gs = vim.b.gitsigns_status_dict
				if not gs then
					return ""
				end
				return "󰘬 " .. gs.head
			end,
			update = {
				"User",
				pattern = "GitSignsUpdate",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		local GitDiffs = {
			condition = function()
				if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
					return false
				end
				local gs = vim.b.gitsigns_status_dict
				if not gs then
					return false
				end
				return (gs.added and gs.added > 0) or (gs.changed and gs.changed > 0) or (gs.removed and gs.removed > 0)
			end,
			static = {
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				},
			},
			{
				provider = function(self)
					local gs = vim.b.gitsigns_status_dict
					if not gs or not gs.added or gs.added == 0 then
						return ""
					end
					local is_first = true
					return (is_first and "" or " ") .. self.symbols.added .. gs.added
				end,
				hl = { fg = colors.green },
			},
			{
				provider = function(self)
					local gs = vim.b.gitsigns_status_dict
					if not gs or not gs.changed or gs.changed == 0 then
						return ""
					end
					local is_first = not (gs.added and gs.added > 0)
					return (is_first and "" or " ") .. self.symbols.modified .. gs.changed
				end,
				hl = { fg = colors.yellow },
			},
			{
				provider = function(self)
					local gs = vim.b.gitsigns_status_dict
					if not gs or not gs.removed or gs.removed == 0 then
						return ""
					end
					local is_first = not ((gs.added and gs.added > 0) or (gs.changed and gs.changed > 0))
					return (is_first and "" or " ") .. self.symbols.removed .. gs.removed
				end,
				hl = { fg = colors.red },
			},
			update = {
				"User",
				pattern = "GitSignsUpdate",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		local Diagnostics = {
			condition = conditions.has_diagnostics,
			static = (function()
				local signs = vim.diagnostic.config().signs
				local icons = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				}

				if type(signs) == "table" and signs.text then
					icons = signs.text
				end

				return {
					error_icon = icons[vim.diagnostic.severity.ERROR],
					warn_icon = icons[vim.diagnostic.severity.WARN],
					info_icon = icons[vim.diagnostic.severity.INFO],
					hint_icon = icons[vim.diagnostic.severity.HINT],
				}
			end)(),
			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = {
				"DiagnosticChanged",
				"BufEnter",
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
					vim.cmd("redrawtabline")
				end),
			},
			{
				provider = function(self)
					if self.errors == 0 then
						return ""
					end
					local is_first = true
					return (is_first and "" or " ") .. self.error_icon .. self.errors
				end,
				hl = "DiagnosticError",
			},
			{
				provider = function(self)
					if self.warnings == 0 then
						return ""
					end
					local is_first = self.errors == 0
					return (is_first and "" or " ") .. self.warn_icon .. self.warnings
				end,
				hl = "DiagnosticWarn",
			},
			{
				provider = function(self)
					if self.info == 0 then
						return ""
					end
					local is_first = self.errors == 0 and self.warnings == 0
					return (is_first and "" or " ") .. self.info_icon .. self.info
				end,
				hl = "DiagnosticInfo",
			},
			{
				provider = function(self)
					if self.hints == 0 then
						return ""
					end
					local is_first = self.errors == 0 and self.warnings == 0 and self.info == 0
					return (is_first and "" or " ") .. self.hint_icon .. self.hints
				end,
				hl = "DiagnosticHint",
			},
		}

		local LineColumn = {
			condition = function()
				local win_config = vim.api.nvim_win_get_config(0)
				local is_floating = win_config.relative ~= ""
				return not is_floating
			end,
			provider = function()
				return string.format("%d:%d", vim.fn.line("."), vim.fn.col("."))
			end,
		}

		local FilePercent = {
			condition = function()
				local win_config = vim.api.nvim_win_get_config(0)
				local is_floating = win_config.relative ~= ""
				return not is_floating
			end,
			provider = function()
				local line, total = vim.fn.line("."), vim.fn.line("$")
				if line == 1 then
					return "top"
				elseif line == total then
					return "bot"
				else
					return string.format("%d%%%%", math.floor((line / total) * 100))
				end
			end,
		}

		local Clock = {
			{
				provider = "",
				hl = function()
					return { fg = colors.dark_pink }
				end,
			},
			{
				provider = function()
					return "  " .. os.date("%H:%M") .. " "
				end,
				hl = function()
					return {
						bg = colors.dark_pink,
						fg = colors.pink,
						bold = true,
					}
				end,
			},
			update = {
				"ModeChanged",
				"User",
				pattern = { "*:*", "HeirlineClockUpdate" },
				callback = vim.schedule_wrap(function()
					vim.cmd("redrawstatus")
				end),
			},
		}

		local uv = vim.uv or vim.loop
		uv.new_timer():start(
			(60 - tonumber(os.date("%S"))) * 1000,
			60000,
			vim.schedule_wrap(function()
				vim.api.nvim_exec_autocmds("User", { pattern = "HeirlineClockUpdate", modeline = false })
			end)
		)
		local WorkDirFull = {
			provider = function()
				return "  " .. vim.fn.getcwd() .. " "
			end,
			hl = { fg = colors.yellow, bg = colors.bg },
		}
		local statusline = {
			with_trailing_space(ViMode),
			with_trailing_space(GitBranch),
			with_trailing_space(GitDiffs),
			with_trailing_space(WorkDirFull),
			-- Removed custom path component here
			with_trailing_space(Diagnostics),
			{ provider = "%=" },
			-- Removed ActiveTooling since it depends on plugins
			with_leading_space(FileEncoding),
			with_leading_space(FileFormat),
			with_leading_space(LineColumn),
			with_leading_space(FilePercent),
			with_leading_space(Clock),
		}

		heirline.setup({
			statusline = statusline,
			hl = { bg = colors.bg, fg = colors.fg }, -- dark bar globally
		})
	end,
=======
  "rebelot/heirline.nvim",
  event = "VeryLazy",
  config = function()
    local heirline = require("heirline")
    local conditions = require("heirline.conditions")
    local utils = require("heirline.utils")

    -- Manual dark mode palette
    local colors = {
      bg = "#03020e", -- bar background
      fg = "#4d8bee", -- bar foreground
      black = "#000000",
      red = "#f38ba8",
      green = "#a6e3a1",
      yellow = "#f9e2af",
      blue = "#89b4fa",
      magenta = "#f5c2e7",
      directory = "#ee984d",
      dark_pink = "#080526",
      cyan = "#94e2d5",
      orange = "#fab387",
      pink = "#FF2E97",
    }

    -- Ensure the whole statusline uses dark background
    vim.api.nvim_set_hl(0, "StatusLine", { bg = colors.bg, fg = colors.fg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = colors.black, fg = colors.fg })

    -- Mode mapping based on lualine's implementation (RESTORED)
    local mode_map = {
      ["n"] = "NORMAL",
      ["no"] = "O-PENDING",
      ["nov"] = "O-PENDING",
      ["noV"] = "O-PENDING",
      ["no\22"] = "O-PENDING",
      ["niI"] = "NORMAL",
      ["niR"] = "NORMAL",
      ["niV"] = "NORMAL",
      ["nt"] = "NORMAL",
      ["ntT"] = "NORMAL",
      ["v"] = "VISUAL",
      ["vs"] = "VISUAL",
      ["V"] = "V-LINE",
      ["Vs"] = "V-LINE",
      ["\22"] = "V-BLOCK",
      ["\22s"] = "V-BLOCK",
      ["s"] = "SELECT",
      ["S"] = "S-LINE",
      ["\19"] = "S-BLOCK",
      ["i"] = "INSERT",
      ["ic"] = "INSERT",
      ["ix"] = "INSERT",
      ["R"] = "REPLACE",
      ["Rc"] = "REPLACE",
      ["Rx"] = "REPLACE",
      ["Rv"] = "V-REPLACE",
      ["Rvc"] = "V-REPLACE",
      ["Rvx"] = "V-REPLACE",
      ["c"] = "COMMAND",
      ["cv"] = "EX",
      ["ce"] = "EX",
      ["r"] = "REPLACE",
      ["rm"] = "MORE",
      ["r?"] = "CONFIRM",
      ["!"] = "SHELL",
      ["t"] = "TERMINAL",
    }

    local function get_mode_name()
      local mode_code = vim.api.nvim_get_mode().mode
      return mode_map[mode_code] or mode_code:upper()
    end

    -- Manual mode colors (no theme highlights)
    local function get_mode_color()
      local mode_code = vim.api.nvim_get_mode().mode
      local mc = {
        -- NORMAL family
        ["n"] = colors.blue,
        ["no"] = colors.blue,
        ["nov"] = colors.blue,
        ["noV"] = colors.blue,
        ["no\22"] = colors.blue,
        ["niI"] = colors.blue,
        ["niR"] = colors.blue,
        ["niV"] = colors.blue,
        ["nt"] = colors.blue,
        ["ntT"] = colors.blue,
        -- VISUAL family
        ["v"] = colors.magenta,
        ["vs"] = colors.magenta,
        ["V"] = colors.magenta,
        ["Vs"] = colors.magenta,
        ["\22"] = colors.magenta,
        ["\22s"] = colors.magenta,
        -- SELECT
        ["s"] = colors.yellow,
        ["S"] = colors.yellow,
        ["\19"] = colors.yellow,
        -- INSERT
        ["i"] = colors.green,
        ["ic"] = colors.green,
        ["ix"] = colors.green,
        -- REPLACE family
        ["R"] = colors.red,
        ["Rc"] = colors.red,
        ["Rx"] = colors.red,
        ["Rv"] = colors.red,
        ["Rvc"] = colors.red,
        ["Rvx"] = colors.red,
        ["r"] = colors.red,
        -- COMMAND / EX / MORE / CONFIRM
        ["c"] = colors.orange,
        ["cv"] = colors.orange,
        ["ce"] = colors.orange,
        ["rm"] = colors.orange,
        ["r?"] = colors.orange,
        -- SHELL / TERMINAL
        ["!"] = colors.cyan,
        ["t"] = colors.cyan,
      }
      return mc[mode_code] or colors.blue
    end

    local function with_trailing_space(component)
      return {
        component,
        { condition = component.condition, provider = " " },
      }
    end

    local function with_leading_space(component)
      return {
        { condition = component.condition, provider = " " },
        component,
      }
    end

    local ViMode = {
      {
        provider = function()
          return " " .. get_mode_name() .. " "
        end,
        hl = function()
          return {
            bg = get_mode_color(),
            fg = colors.black, -- solid dark text on bright mode color
            bold = true,
          }
        end,
      },
      {
        provider = "",
        hl = function()
          return { fg = get_mode_color() }
        end,
      },
    }

    local FileEncoding = {
      condition = function()
        local win_config = vim.api.nvim_win_get_config(0)
        local is_floating = win_config.relative ~= ""
        return not is_floating
      end,
      provider = function()
        local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
        return enc
      end,
    }

    local FileFormat = {
      condition = function()
        local win_config = vim.api.nvim_win_get_config(0)
        local is_floating = win_config.relative ~= ""
        return not is_floating
      end,
      provider = function()
        local fileformat_symbols = {
          unix = "",
          dos = "",
          mac = "",
        }
        local format = vim.bo.fileformat
        local symbol = fileformat_symbols[format] or format
        return symbol
      end,
    }

    local GitBranch = {
      condition = function()
        return vim.b.gitsigns_head and not vim.b.gitsigns_git_status
      end,
      provider = function()
        local gs = vim.b.gitsigns_status_dict
        if not gs then
          return ""
        end
        return "󰘬 " .. gs.head
      end,
      update = {
        "User",
        pattern = "GitSignsUpdate",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local GitDiffs = {
      condition = function()
        if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
          return false
        end
        local gs = vim.b.gitsigns_status_dict
        if not gs then
          return false
        end
        return (gs.added and gs.added > 0) or (gs.changed and gs.changed > 0) or (gs.removed and gs.removed > 0)
      end,
      static = {
        symbols = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      },
      {
        provider = function(self)
          local gs = vim.b.gitsigns_status_dict
          if not gs or not gs.added or gs.added == 0 then
            return ""
          end
          local is_first = true
          return (is_first and "" or " ") .. self.symbols.added .. gs.added
        end,
        hl = { fg = colors.green },
      },
      {
        provider = function(self)
          local gs = vim.b.gitsigns_status_dict
          if not gs or not gs.changed or gs.changed == 0 then
            return ""
          end
          local is_first = not (gs.added and gs.added > 0)
          return (is_first and "" or " ") .. self.symbols.modified .. gs.changed
        end,
        hl = { fg = colors.yellow },
      },
      {
        provider = function(self)
          local gs = vim.b.gitsigns_status_dict
          if not gs or not gs.removed or gs.removed == 0 then
            return ""
          end
          local is_first = not ((gs.added and gs.added > 0) or (gs.changed and gs.changed > 0))
          return (is_first and "" or " ") .. self.symbols.removed .. gs.removed
        end,
        hl = { fg = colors.red },
      },
      update = {
        "User",
        pattern = "GitSignsUpdate",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local Diagnostics = {
      condition = conditions.has_diagnostics,
      static = (function()
        local signs = vim.diagnostic.config().signs
        local icons = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        }

        if type(signs) == "table" and signs.text then
          icons = signs.text
        end

        return {
          error_icon = icons[vim.diagnostic.severity.ERROR],
          warn_icon = icons[vim.diagnostic.severity.WARN],
          info_icon = icons[vim.diagnostic.severity.INFO],
          hint_icon = icons[vim.diagnostic.severity.HINT],
        }
      end)(),
      init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      end,
      update = {
        "DiagnosticChanged",
        "BufEnter",
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
          vim.cmd("redrawtabline")
        end),
      },
      {
        provider = function(self)
          if self.errors == 0 then
            return ""
          end
          local is_first = true
          return (is_first and "" or " ") .. self.error_icon .. self.errors
        end,
        hl = "DiagnosticError",
      },
      {
        provider = function(self)
          if self.warnings == 0 then
            return ""
          end
          local is_first = self.errors == 0
          return (is_first and "" or " ") .. self.warn_icon .. self.warnings
        end,
        hl = "DiagnosticWarn",
      },
      {
        provider = function(self)
          if self.info == 0 then
            return ""
          end
          local is_first = self.errors == 0 and self.warnings == 0
          return (is_first and "" or " ") .. self.info_icon .. self.info
        end,
        hl = "DiagnosticInfo",
      },
      {
        provider = function(self)
          if self.hints == 0 then
            return ""
          end
          local is_first = self.errors == 0 and self.warnings == 0 and self.info == 0
          return (is_first and "" or " ") .. self.hint_icon .. self.hints
        end,
        hl = "DiagnosticHint",
      },
    }

    local LineColumn = {
      condition = function()
        local win_config = vim.api.nvim_win_get_config(0)
        local is_floating = win_config.relative ~= ""
        return not is_floating
      end,
      provider = function()
        return string.format("%d:%d", vim.fn.line("."), vim.fn.col("."))
      end,
    }

    local FilePercent = {
      condition = function()
        local win_config = vim.api.nvim_win_get_config(0)
        local is_floating = win_config.relative ~= ""
        return not is_floating
      end,
      provider = function()
        local line, total = vim.fn.line("."), vim.fn.line("$")
        if line == 1 then
          return "top"
        elseif line == total then
          return "bot"
        else
          return string.format("%d%%%%", math.floor((line / total) * 100))
        end
      end,
    }

    local Clock = {
      {
        provider = "",
        hl = function()
          return { fg = colors.dark_pink }
        end,
      },
      {
        provider = function()
          return " " .. os.date("%H:%M") .. " "
        end,
        hl = function()
          return {
            bg = colors.dark_pink,
            fg = colors.pink,
            bold = true,
          }
        end,
      },
      update = {
        "ModeChanged",
        "User",
        pattern = { "*:*", "HeirlineClockUpdate" },
        callback = vim.schedule_wrap(function()
          vim.cmd("redrawstatus")
        end),
      },
    }

    local uv = vim.uv or vim.loop
    uv.new_timer():start(
      (60 - tonumber(os.date("%S"))) * 1000,
      60000,
      vim.schedule_wrap(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "HeirlineClockUpdate", modeline = false })
      end)
    )
    local WorkDirFull = {
      provider = function()
        return "  " .. vim.fn.getcwd() .. " "
      end,
      hl = { fg = colors.directory, bg = colors.bg },
    }
    local statusline = {
      with_trailing_space(ViMode),
      with_trailing_space(GitBranch),
      with_trailing_space(GitDiffs),
      with_trailing_space(WorkDirFull),
      -- Removed custom path component here
      with_trailing_space(Diagnostics),
      { provider = "%=" },
      -- Removed ActiveTooling since it depends on plugins
      with_leading_space(FileEncoding),
      with_leading_space(FileFormat),
      with_leading_space(LineColumn),
      with_leading_space(FilePercent),
      with_leading_space(Clock),
    }

    heirline.setup({
      statusline = statusline,
      hl = { bg = colors.bg, fg = colors.fg }, -- dark bar globally
    })
  end,
>>>>>>> cd8d81c (keymaps and better theme and added scope.nvim to open tabs better)
}
