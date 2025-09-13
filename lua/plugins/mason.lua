return {
  "williamboman/mason.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        border = "rounded",
        backdrop = 100,
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
      },
      automatic_installation = true,
    })
  end,
}
