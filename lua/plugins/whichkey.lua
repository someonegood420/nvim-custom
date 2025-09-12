return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      delay = 0,
      defaults = {},
      show_help = true,
      spec = {
        -- individual keymaps
        { "<leader>rt", icon = { icon = "", hl = "MiniIconsRed" } },
        { "<leader>ta", icon = { icon = "󰱑", hl = "MiniIconsGreen" } },
        { "<leader>tf", icon = { icon = "󰱑", hl = "MiniIconsGreen" } },
        { "<leader>K", icon = { icon = "󰋽", hl = "MiniIconsBlue" } },
        { "<leader>a", icon = { icon = "", hl = "MiniIconsYellow" } },
        { "<leader>cm", icon = { icon = "󱁤", hl = "MiniIconsGrey" } },
        { "<leader>e", icon = { icon = "󰨚", hl = "MiniIconsYellow" } },
        { "<leader><leader>", desc = "Beacon", icon = { icon = "󰞏", hl = "MiniIconsYellow" } },
        -- groups
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "File/Find" },
        { "<leader>g", group = "Git" },
        { "<leader>gh", group = "Hunks" },
        { "<leader>d", group = "Directory" },
        { "<leader>n", group = "Noice" },
        { "<leader>r", group = "Run", icon = { icon = "", hl = "MiniIconsRed" } },
        { "<leader>s", group = "Search" },
        { "<leader>S", group = "Session" },
        { "<leader>t", group = "Test", icon = { icon = "󰱑", hl = "MiniIconsGreen" } },
        { "<leader>T", group = "Terminal" },
        { "<leader>u", group = "UI" },
        { "<leader>w", group = "Window" },
        { "<leader>x", group = "Diag/Qckfix" },
        { "<leader><Tab>", group = "Tab" },
        { "<leader>?", group = "Funstuff" },
      },
    },
    config = function(_, opts)
      require("which-key").setup(opts)
    end,
  },
}
