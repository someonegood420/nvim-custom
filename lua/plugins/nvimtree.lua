return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local function my_on_attach(bufnr)
      local api = require("nvim-tree.api")
      -- Remove <C-t> keymap
      vim.keymap.set("n", "<C-t>", "<Nop>", { buffer = bufnr })
      -- You can also set up your own keymaps here if you want
      -- Or leave it empty to just disable <C-t>
      api.config.mappings.default_on_attach(bufnr) -- keep other default mappings
    end

    require("nvim-tree").setup({
      view = {
        width = 30,
        side = "right",
      },
      renderer = {
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
          },
        },
      },
      filters = {
        dotfiles = false,
      },
      on_attach = my_on_attach, -- <--- Add this line!
    })
  end
}
