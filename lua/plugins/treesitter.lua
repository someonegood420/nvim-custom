return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",

    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
         "lua", "vim", "json", "python", "markdown", "html", "css"
        }, -- add more as needed
        auto_install = true,

        highlight = {
          enable = true,
        },

        indent = {
          enable = true,
        },
      }
    end,
  },
}
