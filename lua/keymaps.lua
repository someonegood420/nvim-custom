-- lua/keymaps.lua
local map = vim.keymap.set
--basic
map("n", "y", '"+y')
map("v", "y", '"+y')
map("x", "y", '"+y')
map("n", "p", '"+p', { desc = "Paste from system clipboard" })
--Directory
--for Cding into directories
map("n", "<leader>dD", function()
  vim.cmd.cd("..")
end, { desc = "parent path" })

map("n", "<leader>dd", function()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd.cd(vim.fn.expand("%:p:h"))
  end
end, { desc = "file path" })
--Window-local
map("n", "<leader>dW", function()
  vim.cmd.lcd("..")
end, { desc = "window parent path" })

map("n", "<leader>dw", function()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd.lcd(vim.fn.expand("%:p:h"))
  end
end, { desc = "window file path" })

-- Tab-local
map("n", "<leader>dT", function()
  vim.cmd.tcd("..")
end, { desc = "tab parent path" })

map("n", "<leader>dt", function()
  if vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd.tcd(vim.fn.expand("%:p:h"))
  end
end, { desc = "tab file path" })
-- Help
map("n", "<leader>K", "<Cmd>norm! K<CR>", { desc = "Keywordprg" })
-- Buffers
map("n", "<leader>.", "<Cmd>e #<CR>", { desc = "Alter Buff" })
map("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next Buff" })
map("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Prev Buff" })
map("n", "<leader>bC", "<Cmd>bd<CR>", { desc = "Close Buff & Window" })
map("n", "<leader>bo", function()
  local tab_buffers = {}
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      local buf = vim.api.nvim_win_get_buf(win)
      tab_buffers[buf] = true
    end
  end
  local function is_listable_buffer(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
      return false
    end
    -- Check if buffer is listed (this is the main filter most pickers use)
    if not vim.bo[buf].buflisted then
      return false
    end
    -- Optional: exclude certain buffer types that pickers typically filter out
    local buftype = vim.bo[buf].buftype
    if buftype == "quickfix" or buftype == "help" or buftype == "terminal" then
      return false
    end
    -- Now includes unnamed buffers (removed the name == "" check)
    return true
  end

  local total_listable_buffers = 0
  local deleted = 0
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_listable_buffer(buf) then
      total_listable_buffers = total_listable_buffers + 1
      if not tab_buffers[buf] then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
        deleted = deleted + 1
      end
    end
  end

  if deleted > 0 then
    vim.notify(string.format("Closed %d buffer%s", deleted, deleted == 1 and "" or "s"))
  else
    vim.notify("No buffers to close")
  end
end, { desc = "Close Other Buffers" })
--Tabs
map("n", "<leader><Tab><Tab>", "<Cmd>tabnew<CR>", { desc = "New Tab" })
map("n", "<leader><Tab>n", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
map("n", "<leader><Tab>c", "<Cmd>tabclose<CR>", { desc = "Close Tab" })
map("n", "<leader><Tab>p", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
map("n", "<leader><Tab>o", function()
  local tab_count = #vim.api.nvim_list_tabpages()
  if tab_count > 1 then
    vim.cmd("tabonly")
    vim.notify(string.format("Closed %d tab%s", tab_count - 1, tab_count - 1 == 1 and "" or "s"))
  else
    vim.notify("No tabs to close")
  end
end, { desc = "Close Other Tabs" })
-- Terminal
map("n", "<leader>TF", "<Cmd>terminal<CR>", { desc = "Fullscreen Terminal" })
map("n", "<leader>Tv", "<Cmd>vsplit | terminal<CR>", { desc = "Vertical Terminal" })
map("n", "<leader>Th", "<Cmd>split | terminal<CR>", { desc = "Horizontal Terminal" })

-- Windows
map("n", "<C-h>", "<C-w><C-h>", { desc = "Go to Left Window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Go to Right Window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Go to Upper Window" })

map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Go to Left Window from Terminal" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Go to Right Window from Terminal" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Go to Lower Window from Terminal" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Go to Upper Window from Terminal" })

map("n", "<A-h>", "<C-w>H", { desc = "Move Window to Far Left" })
map("n", "<A-j>", "<C-w>J", { desc = "Move Window to Far Bottom" })
map("n", "<A-k>", "<C-w>K", { desc = "Move Window to Far Top" })
map("n", "<A-l>", "<C-w>L", { desc = "Move Window to Far Right" })

map("t", "<A-h>", "<C-\\><C-n><C-w>Hi", { desc = "Move Window to Far Left from Terminal" })
map("t", "<A-j>", "<C-\\><C-n><C-w>Ji", { desc = "Move Window to Far Bottom from Terminal" })
map("t", "<A-k>", "<C-\\><C-n><C-w>Ki", { desc = "Move Window to Far Top from Terminal" })
map("t", "<A-l>", "<C-\\><C-n><C-w>Li", { desc = "Move Window to Far Right from Terminal" })

map("n", "<leader>wx", "<C-w>x", { desc = "Swap Window with Next" })
map("n", "<leader>wc", "<C-W>c", { desc = "Close Window" })
map("n", "<leader>wo", "<C-w>o", { desc = "Close Other Windows" })
map("n", "<leader>wn", "<C-w>w", { desc = "Next Window" })
map("n", "<leader>wp", "<C-w>p", { desc = "Previous Window" })
map("n", "<leader>wt", "<C-w>T", { desc = "Break out into a new tab" })
map("n", "<leader>wh", ":split<CR>", { desc = "Horizontal Split" })
map("n", "<leader>wv", ":vsplit<CR>", { desc = "Vertical Split" })
--scrolloff
local scroll_toggle_enabled = true
local default_scrolloff = vim.o.scrolloff or 0

vim.keymap.set("n", "<leader>uS", function()
  -- name used in lazy.nvim spec for scrollEOF
  local plugin_name = "scrollEOF.nvim"

  -- retrieve plugin entry from lazy config
  local plugin = require("lazy.core.config").plugins[plugin_name]

  if not plugin then
    vim.notify("Plugin '" .. plugin_name .. "' not found in lazy.nvim", vim.log.levels.ERROR)
    return
  end

  if scroll_toggle_enabled then
    -- Disable both scrolloff and the plugin
    -- Save your default scrolloff if not already saved
    default_scrolloff = vim.o.scrolloff or default_scrolloff

    vim.o.scrolloff = 0
    plugin.enabled = false
    -- reload plugin so the changes take effect
    require("lazy.core.loader").reload(plugin_name)

    scroll_toggle_enabled = false
    vim.notify("scrolloff disabled", vim.log.levels.INFO)
  else
    -- Enable both scrolloff and the plugin
    vim.o.scrolloff = default_scrolloff > 0 and default_scrolloff or 8 -- fallback to 8 if default was 0
    plugin.enabled = true
    require("lazy.core.loader").reload(plugin_name)

    scroll_toggle_enabled = true
    vim.notify("scrolloff enabled (" .. vim.o.scrolloff .. ")", vim.log.levels.INFO)
  end
end, { desc = "Toggle scrolloff" })
-- #################Plugins################
-- Mason
map("n", "<leader>cm", "<Cmd>Mason<CR>", { desc = "Mason" })
--Lazy
map("n", "<leader>l", "<Cmd>Lazy<CR>", { desc = "Lazy" })
--Nvimtree
map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", { desc = "NvimTree" })
--Oil
map("n", "<leader>o", function()
  require("oil").open()
end, { desc = "Oil" })
--menu
map("n", "<C-t>", function()
  -- Delete any old menus before opening the new one
  require("menu.utils").delete_old_menus()

  local buf = vim.api.nvim_get_current_buf()

  -- Check if the current buffer is NvimTree
  if vim.bo[buf].ft == "NvimTree" then
    require("menu").open("nvimtree")
  else
    require("menu").open("default")
  end
end, { desc = "Open menu based on buffer type" })

-- Mouse users + nvimtree users
map({ "n", "v" }, "<RightMouse>", function()
  -- Delete old menus before opening a new one
  require("menu.utils").delete_old_menus()

  -- Print the filetype of the clicked buffer
  local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)

  -- Determine which menu to open based on buffer type
  local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

  -- Open the determined menu
  require("menu").open(options, { mouse = true })
end, { desc = "Open menu based on right-click buffer" })

--Telescope
local builtin = require("telescope.builtin")
map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
map("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Help Pages" })
map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent Files" })
map("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
map("n", "<leader>fc", builtin.current_buffer_fuzzy_find, { desc = "Find in Current Buffer" })

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- Quickfix list
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

map("n", "<leader>xq", function()
  local success, err = pcall(function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
      vim.cmd.cclose()
    else
      vim.cmd.copen()
    end
  end)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix list" })

-- Location list
map("n", "<leader>xl", function()
  local success, err = pcall(function()
    if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
      vim.cmd.lclose()
    else
      vim.cmd.lopen()
    end
  end)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })
-- Clear search, diff update and redraw (refresh ui)
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Refresh UI" })
--fun stuff
map("n", "<leader>?K", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "<leader>?s", "<Cmd>Store<CR>", { desc = "Store" })
map("n", "<leader>?t", ":Typr<CR>", { desc = "Typr" })
