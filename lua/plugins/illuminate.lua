return {
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      providers = { "lsp", "treesitter", "regex" },
      filetypes_denylist = {
        "snacks_picker_list",
        "snacks_picker_preview",
        "snacks_picker_input",
        "oil",
        "noice",
      },
    },
    config = function(_, opts)
      local illuminate = require("illuminate")
      illuminate.configure(opts)

      -- Start off by default
      illuminate.pause()

      local function is_enabled()
        return not require("illuminate.engine").is_paused()
      end

      -- Snacks toggle
      Snacks.toggle({
        name = "Illuminate",
        get = is_enabled,
        set = function(enabled)
          if enabled then
            illuminate.resume()
          else
            illuminate.pause()
          end
        end,
      }):map("<leader>ui")

      -- Conditional WinEnter/WinLeave
      vim.api.nvim_create_autocmd("WinLeave", {
        callback = function()
          if is_enabled() then
            illuminate.pause()
          end
        end,
      })

      vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
          if is_enabled() then
            illuminate.resume()
          end
        end,
      })

      -- Custom highlights (example)
      vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3c3f42" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3c3f42" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3c3f42" })
    end,
  },
}
