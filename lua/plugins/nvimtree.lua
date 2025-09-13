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

      -- Set CWD
      local function set_cwd()
        local node = api.tree.get_node_under_cursor()
        if node.type == "directory" then
          api.tree.change_root(node.absolute_path)
        end
      end
      vim.keymap.set('n', '<C-d>', set_cwd, { noremap = true, silent = true, buffer = bufnr, desc = 'Set CWD' })

      -- Keep other default mappings
      api.config.mappings.default_on_attach(bufnr)
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
      on_attach = my_on_attach,
    })
  end
}
