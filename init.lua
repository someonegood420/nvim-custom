require("config.lazy")
require("keymaps")
require("config.options")
require("recorder")
vim.api.nvim_set_hl(0, "IblChar", { fg = "#5c6370" }) -- normal indent line
vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#BFB410" }) -- current scope line
-- Match FloatBorder background to Normal background
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
