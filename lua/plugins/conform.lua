return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Format on save
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },

      -- Formatter setup per filetype
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        sh = { "shfmt" },
        go = { "gofmt" },
        -- Add more as needed
      },
    },
  },
}
