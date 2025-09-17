-- Debug notify override
vim.fn.original_notify = vim.notify
vim.notify = function(msg, level, opts)
	if msg:match(".*:%d+:") then
		return -- ignore buffer load position messages
	end
	return vim.fn.original_notify(msg, level, opts)
end
require("config.lazy")
require("keymaps")
require("config.options")
require("utils.recorder")
require("utils.session_manager")
require("scrollEOF").setup()
require("utils.Beacon").setup()

vim.api.nvim_set_hl(0, "IblChar", { fg = "#5c6370" }) -- normal indent line
vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#BFB410" }) -- current scope line
-- Match FloatBorder background to Normal background
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "OilHeader", { bg = "none", fg = "#ffffff" }) -- header
vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- main Oil buffer
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- if float window
vim.cmd("runtime plugin/matchparen.vim")
vim.api.nvim_set_hl(0, "CursorLine", { bg = "#06060d" })
--Neovide settings
vim.g.neovide_opacity = 0 -- Set transparency (0.0 = fully transparent, 1.0 = fully opaque)     -- optional
vim.o.guifont = "JetBrainsMono Nerd Font Propo:h12"
vim.g.neovide_cursor_animate_command_line = false
vim.g.neovide_window_blurred = false
vim.g.neovide_fullscreen = true
vim.g.neovide_floating_blur_amount_x = 15.0
vim.g.neovide_floating_blur_amount_y = 15.0
vim.g.neovide_cursor_hack = false
vim.g.neovide_cursor_short_animation_length = 0.1
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_cursor_trail_size = 0
vim.g.neovide_cursor_vfx_mode = ""
vim.g.neovide_scroll_animation_far_lines = 9999
