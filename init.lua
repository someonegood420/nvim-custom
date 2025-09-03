require("config.lazy")
require("keymaps")
require("config.options")
require("recorder")
<<<<<<< HEAD
vim.api.nvim_set_hl(0, "IblChar", { fg = "#5c6370" }) -- normal indent line
=======
require("utils.session_manager")
vim.api.nvim_set_hl(0, "IblChar", { fg = "#5c6370" })      -- normal indent line
>>>>>>> cd8d81c (keymaps and better theme and added scope.nvim to open tabs better)
vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#BFB410" }) -- current scope line
-- Match FloatBorder background to Normal background
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "OilHeader", { bg = "none", fg = "#ffffff" }) -- header
<<<<<<< HEAD
vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- main Oil buffer
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- if float window
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" }) -- optional
=======
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })                    -- main Oil buffer
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })               -- if float window
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })                -- optional
>>>>>>> cd8d81c (keymaps and better theme and added scope.nvim to open tabs better)
