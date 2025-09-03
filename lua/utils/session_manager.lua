-- session manager file

local M = {}

-- Flags
local auto_save = true
local auto_restore = false

-- Track the currently active session
local current_session = nil

-- Configuration
local config = {
  session_dir = vim.fn.stdpath("data") .. "/sessions/",
  last_session = "last",
}

-- Ensure session directory exists
local function ensure_session_dir()
  if vim.fn.isdirectory(config.session_dir) == 0 then
    vim.fn.mkdir(config.session_dir, "p")
  end
end

-- Get full path to session file
local function get_session_path(name)
  name = name or config.last_session
  if not name:match("%.vim$") then
    name = name .. ".vim"
  end
  return config.session_dir .. name
end

-- Clear everything to return to a clean Neovim state
local function clear_session()
  current_session = nil

  vim.v.this_session = ""
  vim.cmd("clearjumps")
  vim.cmd("delmarks!")
  vim.cmd("nohlsearch")
  vim.cmd("cd ~")

  vim.schedule(function()
    vim.cmd("silent! %bdelete!")
    vim.cmd("silent! tabonly!")
    vim.cmd("silent! only!")
    vim.cmd("enew")
  end)
end

-- Use the custom session picker
function M.session_picker()
  local picker = require("utils.session_picker")
  picker(M)
end

-- Save session
function M.save_session(name)
  ensure_session_dir()
  local session_path = get_session_path(name)

  -- Only save if we have buffers with actual files
  local has_files = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname ~= "" and vim.fn.filereadable(bufname) == 1 then
        has_files = true
        break
      end
    end
  end

  if has_files then
    vim.cmd("mksession! " .. vim.fn.fnameescape(session_path))
    current_session = name or config.last_session

    local display_name = name or config.last_session
    print('Saved session "' .. display_name .. '"')
  end
end

-- Load session with toggle behavior for same session

function M.load_session(path_or_name)
  local old_notify = vim.notify
  vim.notify = function() end -- suppress notifications temporarily

  -- existing session load code
  local session_path = path_or_name
  local session_name = vim.fn.fnamemodify(session_path, ":t:r")
  if current_session == session_name then
    clear_session()
    vim.notify = old_notify
    return
  end
  if vim.fn.filereadable(session_path) == 1 then
    vim.cmd("silent! %bdelete!")
    vim.cmd("source " .. vim.fn.fnameescape(session_path))
    current_session = session_name
  end

  vim.notify = old_notify -- restore notifications
end

-- Check if session exists
function M.session_exists(name)
  local session_path = get_session_path(name)
  return vim.fn.filereadable(session_path) == 1
end

-- Get current session name (for external use)
function M.get_current_session()
  return current_session
end

-- Check if a session is currently active
function M.is_session_active(name)
  return current_session == (name or config.last_session)
end

-- Toggle autosave
function M.toggle_autosave()
  auto_save = not auto_save
  print("Autosave " .. (auto_save and "enabled" or "disabled"))
end

-- Delete session
function M.delete_session(name)
  if not name or name == config.last_session then
    print("Cannot delete the last session")
    return false
  end

  local session_path = get_session_path(name)
  local deleted = false

  if vim.fn.filereadable(session_path) == 1 then
    vim.fn.delete(session_path)
    deleted = true
  end

  if current_session == name then
    current_session = nil
  end

  if deleted then
    print('Deleted session "' .. name .. '"')
    return true
  else
    print('Session "' .. name .. '" not found')
    return false
  end
end

-- Manual clear session function (exposed for session picker highlight updates)
function M.clear_session()
  clear_session()
end

-- Setup function
function M.setup(opts)
  if opts then
    config = vim.tbl_deep_extend("force", config, opts)
  end

  -- Keymaps
  vim.keymap.set("n", "<leader>SS", M.session_picker, { desc = "Search Sessions", silent = true })
  vim.keymap.set("n", "<leader>Sr", function()
    M.load_session(get_session_path())
  end, { desc = "Restore Last Session", silent = true })
  vim.keymap.set("n", "<leader>Ss", function()
    vim.ui.input({ prompt = "Session Name: " }, function(input)
      if input and input ~= "" then
        if input == config.last_session then
          print('Cannot name session "' .. config.last_session .. '" - this name is reserved')
          return
        end
        M.save_session(input)
      end
    end)
  end, { desc = "Save Session", silent = true })

  --snacks function autosave
  function M.is_autosave_enabled()
    return auto_save
  end

  --  -- Snacks toggle for autosave
  -- -- require("snacks")
  --   --   .toggle({
  --     --   name = "Session Autosave",
  --       -- get = function()
  --         -- return auto_save
  --        --end,
  --       -- set = function()
  --         -- auto_save = not auto_save
  --        end,
  --      })
  --      :map("<leader>Sa")

  -- Auto-save on exit
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      if auto_save then
        M.save_session(current_session)
      end
    end,
  })

  -- Auto-restore on startup
  if auto_restore then
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      callback = function()
        if vim.fn.argc(-1) == 0 then
          if M.session_exists() then
            M.load_session(get_session_path())
            current_session = config.last_session
          end
        end
      end,
    })
  end
end

M.setup()

return M
