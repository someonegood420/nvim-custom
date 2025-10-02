return {
  {
    "theawakener0/TraceBack",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim", -- optional but recommended
      -- "echasnovski/mini.nvim",       -- optional alternative UI
    },
    cmd = { "TraceBack", "TraceBackToggle", "TraceBackLens" },
    keys = {
      { "<leader>tt", "<cmd>TraceBack<cr>",                 desc = "Timeline" },
      { "<leader>th", "<cmd>TraceBack history<cr>",         desc = "History" },
      { "<leader>tu", "<cmd>TraceBack undo<cr>",            desc = "Undo" },
      { "<leader>tc", "<cmd>TraceBack capture<cr>",         desc = "Capture" },
      { "<leader>tr", "<cmd>TraceBack restore<cr>",         desc = "Restore" },
      { "<leader>tp", "<cmd>TraceBack replay<cr>",          desc = "Replay" },
      { "<leader>ts", "<cmd>TraceBack toggle_security<cr>", desc = "Toggle Security" },
    },
    opts = {
      ui = { picker = "telescope" },
      lenses = {
        code = false,
        lsp = false,
        security = false,
        auto_render = false,
        debounce_ms = 120,
        event_debounce = {
          DiagnosticChanged = 80,
          TextChanged = 300,
          TextChangedI = 300,
          WinScrolled = 120,
          CursorHold = 0,
          InsertLeave = 80,
          BufEnter = 100,
          BufWinEnter = 100,
          LspAttach = 50,
        },
        max_annotations = 200,
        scan_window = 400,
        treesitter = true,
        lsp_max_per_line = 1,
        lsp_truncate = 120,
        lsp_show_codes = true,
        lsp_show_source = false,
        code_show_metrics = true,
        security_auto_render = false,
        security_context_analysis = false,
        security_smart_filtering = false,
      },
      keymaps = {
        timeline = "<Leader>tt",
        history = "<Leader>th",
        undo = "<Leader>tu",
        capture = "<Leader>tc",
        restore = "<Leader>tr",
        replay = "<Leader>tp",
        toggle_security = "<Leader>ts",
      },
      telescope = {
        enabled = true,
        theme = "ivy",
        layout_config = { height = 0.4, preview_width = 0.6 },
      },
    },
    config = function(_, opts)
      require("traceback").setup(opts)
    end,
  },
}
