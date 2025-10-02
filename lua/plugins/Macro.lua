return {
  {
    "ecthelionvi/NeoComposer.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
    keys = {
      { "<leader>mr", desc = "Toggle Macro Record" },
      { "<leader>mp", desc = "Play Macro" },
      { "<leader>my", desc = "Yank Macro" },
      { "<leader>ms", desc = "Stop Macro" },
      { "<leader>mm", desc = "Macro Menu" },
      { "<leader>mj", desc = "Next Macro" },
      { "<leader>mk", desc = "Prev Macro" },
    },
    opts = {
      notify = true,
      delay_timer = 150,
      queue_most_recent = false,

      keymaps = {
        toggle_record     = "<leader>mr",
        play_macro        = "<leader>mp",
        yank_macro        = "<leader>my",
        stop_macro        = "<leader>ms",
        toggle_macro_menu = "<leader>mm",
        cycle_next        = "<leader>mj",
        cycle_prev        = "<leader>mk",
      },

      colors = {
        bg = 'none',
        fg = "#ff9e64",
        red = "#ec5f67",
        blue = "#5fb3b3",
        green = "#99c794",
        text_bg = "#16161e",
        text_delay = "",
        text_play = "",
        text_rec = "",
      },

      window = {
        width = 50,
        height = 10,
        border = "rounded",
        winhl = {
          Normal = "ComposerNormal",
          FloatTitle = "ComposerFloatTitle",
        },
      },
    },
    config = function(_, opts)
      require("NeoComposer").setup(opts)
      vim.api.nvim_set_hl(0, "ComposerFloatTitle", { fg = "#FF2592", bold = true })
    end,
  },
}
