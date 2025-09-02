return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- only start saving sessions when a file is opened
    opts = {
      options = { "buffers", "curdir", "tabpages", "winsize" }, -- default session data
    },
  },
}
