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
require("recorder")
require("utils.session_manager")

vim.api.nvim_set_hl(0, "IblChar", { fg = "#5c6370" })      -- normal indent line
vim.api.nvim_set_hl(0, "IblScopeChar", { fg = "#BFB410" }) -- current scope line
-- Match FloatBorder background to Normal background
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
vim.api.nvim_set_hl(0, "OilHeader", { bg = "none", fg = "#ffffff" }) -- header
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })                    -- main Oil buffer
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })               -- if float window
vim.api.nvim_set_hl(0, "CursorLine", { bg = "none" })                -- optional
