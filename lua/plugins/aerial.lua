return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    -- Make sure web-devicons is loaded
    require("nvim-web-devicons").setup()

    -- Aerial setup options
    local aerial_opts = {
      layout = {
        default_direction = "float",
        placement = "edge",
      },
      attach_mode = "window", -- only attach mappings to the sidebar
      backends = { "lsp", "treesitter" },
      icons = {
        File = "📄",
        Module = "📦",
        Class = "🏷️",
        Method = "ƒ",
        Function = "ƒ",
        Variable = "𝓥",
        Constant = "ℂ",
        String = "📝",
        Number = "#",
        Boolean = "⊨",
        Array = "🗂",
        Object = "🛠️",
        Key = "🔑",
        Null = "∅",
        Enum = "📛",
        Interface = "🔗",
        Struct = "🏗️",
        Event = "🎉",
        Operator = "⚡",
        TypeParameter = "𝙏",
      },
      show_guides = true,
      guides = {
        mid_item = "│",
        last_item = "╰─",
        nested_top = "├─",
        whitespace = " ",
      },
      float = {
        relative = "editor",
        -- Use the override function for precise placement
        override = function(conf)
          -- Get the total width and height of the editor
          local editor_width = vim.o.columns
          local editor_height = vim.o.lines
          -- Define the floating window dimensions
          local float_width = conf.width or 35
          local float_height = conf.height or 30
          -- Calculate the position for the top-right anchor
          -- col = editor_width - window_width - 1 (or a small padding)
          conf.anchor = "NE"
          conf.row = 21
          conf.col = editor_width - float_width + 5
          -- Ensure border is set
          conf.border = "rounded"

          return conf
        end,
      },
    }

    -- Apply the setup
    require("aerial").setup(aerial_opts)

    -- Map <leader>a to toggle the sidebar
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle<CR>", { desc = "Aerial" })

    -- Buffer-local mappings only for the Aerial sidebar
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "aerial",
      callback = function(args)
        local bufnr = args.buf
        vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr, desc = "Next symbol" })
        vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr, desc = "Previous symbol" })
      end,
    })
  end,
}
