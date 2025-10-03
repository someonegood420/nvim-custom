-- lua/keymaps.lua
local map = vim.keymap.set
--basic
map("n", "y", '"+y')
map("v", "y", '"+y')
map("x", "y", '"+y')
map("n", "p", '"+p', { desc = "Paste from system clipboard" })
map("n", "<leader>q", "<Cmd>x<CR>", { desc = "Save and quit" })
map("n", "<leader>Q", "<Cmd>q!<CR>")
map("n", "<leader>w", "<Cmd>w<CR>")
map("n", "<leader>W", "<Cmd>wall<CR>")
--Macro
map("n", "<leader>m1", "GVggy", { desc = "Copy file" })
map("n", "<leader>m2", "GVggp", { desc = "Paste file" })
map("n", "<leader>m3", "GVggd", { desc = "Delete file" })
--Marks
local last_global_jump = { mark = nil, file = nil, line = nil }
-- Toggle/jump/clear marks
local function toggle_or_jump(mark)
	if mark:match("%u") then
		-- 🔹 GLOBAL MARK (A-Z)
		local found = nil
		for _, m in ipairs(vim.fn.getmarklist()) do
			if m.mark == "'" .. mark then -- Marks in getmarklist() are prefixed with '
				found = m
				break
			end
		end

		if found then
			local curfile = vim.fn.expand("%:p") -- current file full path
			local mark_file = vim.fn.fnamemodify(found.file, ":p") -- normalize
			local cursor = vim.api.nvim_win_get_cursor(0) -- {line, col}
			local line, col = found.pos[2], found.pos[3]

			-- Are we exactly on the mark line? (loose check)
			local at_mark_line = (curfile == mark_file and cursor[1] == line)

			-- Did we just jump to this same global mark previously and haven't moved?
			local just_jumped_same = (
				last_global_jump.mark == mark
				and last_global_jump.file == mark_file
				and cursor[1] == last_global_jump.line
			)

			if at_mark_line or just_jumped_same then
				-- Clear the global mark using :delmarks
				vim.cmd("delmarks " .. mark)
				vim.notify("Global mark " .. mark .. " cleared", vim.log.levels.INFO)
				-- reset tracker
				last_global_jump.mark = nil
				last_global_jump.file = nil
				last_global_jump.line = nil
			else
				-- Jump to the mark (open file if needed)
				local success, err = pcall(function()
					if curfile ~= mark_file then vim.cmd("edit " .. vim.fn.fnameescape(found.file)) end
					vim.api.nvim_win_set_cursor(0, { line, col })
				end)
				if not success then
					vim.notify("Failed to jump to global mark " .. mark .. ": " .. err, vim.log.levels.ERROR)
				else
					-- record that we just jumped to this global mark so a follow-up press can clear it
					last_global_jump.mark = mark
					last_global_jump.file = mark_file
					last_global_jump.line = line
					vim.notify("Jumped to global mark " .. mark, vim.log.levels.INFO)
				end
			end
		else
			-- No mark yet -> set it
			vim.cmd("normal! m" .. mark)
			vim.notify("Global mark " .. mark .. " set", vim.log.levels.INFO)
		end
	else
		-- 🔹 LOCAL MARK (a-z)
		local pos = vim.api.nvim_buf_get_mark(0, mark)
		local cursor = vim.api.nvim_win_get_cursor(0)

		if pos[1] > 0 then
			if pos[1] == cursor[1] and pos[2] == cursor[2] then
				-- Cursor is at the mark's position -> clear it
				vim.api.nvim_buf_del_mark(0, mark)
				vim.notify("Local mark " .. mark .. " cleared", vim.log.levels.INFO)
			else
				-- Jump to local mark
				vim.api.nvim_win_set_cursor(0, { pos[1], pos[2] })
				vim.notify("Jumped to local mark " .. mark, vim.log.levels.INFO)
			end
		else
			-- Set new local mark
			vim.cmd("normal! m" .. mark)
			vim.notify("Local mark " .. mark .. " set", vim.log.levels.INFO)
		end
	end
end
-- Mark-related mappings
map("n", "<leader>jk", "`", { desc = "Jump" })
map("n", "<leader>jj", "m", { desc = "Mark" })
map("n", "<leader>j1", function() toggle_or_jump("z") end, { desc = "Mark z (local)" })
map("n", "<leader>j2", function() toggle_or_jump("x") end, { desc = "Mark x (local)" })
map("n", "<leader>j3", function() toggle_or_jump("c") end, { desc = "Mark c (local)" })
map("n", "<leader>j4", function() toggle_or_jump("v") end, { desc = "Mark v (local)" })
map("n", "<leader>J1", function() toggle_or_jump("Z") end, { desc = "Mark Z (global)" })
map("n", "<leader>J2", function() toggle_or_jump("X") end, { desc = "Mark X (global)" })
map("n", "<leader>J3", function() toggle_or_jump("C") end, { desc = "Mark C (global)" })
map("n", "<leader>J4", function() toggle_or_jump("V") end, { desc = "Mark V (global)" })
map("n", "<leader>jh", "<C-o>", { desc = "Prev" })
map("n", "<leader>jn", "<C-i>", { desc = "Next" })
map("n", "<leader>jl", "``", { desc = "Cycle" })
map("n", "<leader>jd", "g;", { desc = "PrevC" })
map("n", "<leader>js", "g.", { desc = "NextC" })
map("n", "<leader>jf", "`.", { desc = "LastC" })
map("n", "<leader>ja", "`^", { desc = "Edit" })
--Directory
--for Cding into directories
map("n", "<leader>dD", function() vim.cmd.cd("..") end, { desc = "parent path" })

map("n", "<leader>dd", function()
	if vim.api.nvim_buf_get_name(0) ~= "" then vim.cmd.cd(vim.fn.expand("%:p:h")) end
end, { desc = "file path" })
--Window-llocal
map("n", "<leader>dW", function() vim.cmd.lcd("..") end, { desc = "window parent path" })

map("n", "<leader>dw", function()
	if vim.api.nvim_buf_get_name(0) ~= "" then vim.cmd.lcd(vim.fn.expand("%:p:h")) end
end, { desc = "window file path" })

-- Tab-local
map("n", "<leader>dT", function() vim.cmd.tcd("..") end, { desc = "tab parent path" })

map("n", "<leader>dt", function()
	if vim.api.nvim_buf_get_name(0) ~= "" then vim.cmd.tcd(vim.fn.expand("%:p:h")) end
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
		if not vim.api.nvim_buf_is_valid(buf) then return false end
		-- Check if buffer is listed (this is the main filter most pickers use)
		if not vim.bo[buf].buflisted then return false end
		-- Optional: exclude certain buffer types that pickers typically filter out
		local buftype = vim.bo[buf].buftype
		if buftype == "quickfix" or buftype == "help" or buftype == "terminal" then return false end
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

map("n", "<leader>ix", "<C-w>x", { desc = "Swap Window with Next" })
map("n", "<leader>ic", "<C-W>c", { desc = "Close Window" })
map("n", "<leader>io", "<C-w>o", { desc = "Close Other Windows" })
map("n", "<leader>in", "<C-w>w", { desc = "Next Window" })
map("n", "<leader>ip", "<C-w>p", { desc = "Previous Window" })
map("n", "<leader>it", "<C-w>T", { desc = "Break out into a new tab" })
map("n", "<leader>ih", ":split<CR>", { desc = "Horizontal Split" })
map("n", "<leader>iv", ":vsplit<CR>", { desc = "Vertical Split" })
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
		vim.o.scrolloff = default_scrolloff > 0 and default_scrolloff or 5 -- fallback to 8 if default was 0
		plugin.enabled = true
		require("lazy.core.loader").reload(plugin_name)

		scroll_toggle_enabled = true
		vim.notify("scrolloff enabled (" .. vim.o.scrolloff .. ")", vim.log.levels.INFO)
	end
end, { desc = "Toggle scrolloff" })
-- #################Plugins################
-- buffer list
map("n", "<leader>l", function() require("utils.buffer_picker").toggle() end, { desc = "l-Buff" })
-- tab list
map("n", "<leader>L", function() require("utils.tab_picker").toggle() end, { desc = "L-Tab" })
-- Mason
map("n", "<leader>cm", "<Cmd>Mason<CR>", { desc = "Mason" })
--Lazy
map("n", "<leader>cl", "<Cmd>Lazy<CR>", { desc = "Lazy" })
--Nvimtree
map("n", "<leader>e", "<Cmd>NvimTreeToggle<CR>", { desc = "NvimTree" })
--Oil
map("n", "<leader>o", function() require("oil").open() end, { desc = "Oil" })
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
map("n", "<leader>fl", builtin.live_grep, { desc = "T-scope Grep" })
map("n", "<leader>fd", builtin.current_buffer_fuzzy_find, { desc = "Tscope-fzf" })

-- Commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })
-- Helper: open quickfix/location list in floating window
-- quickfix floating window functions
local function open_list_floating(list_type)
	local items = (list_type == "quickfix") and vim.fn.getqflist({ items = 1 }) or vim.fn.getloclist(0, { items = 1 })

	if #items.items == 0 then
		vim.notify(list_type .. " list is empty", vim.log.levels.WARN)
		return
	end

	local buf = vim.api.nvim_create_buf(false, true)
	local lines = {}
	for _, v in ipairs(items.items) do
		local text = v.text or ""
		table.insert(
			lines,
			string.format("%s:%d:%d: %s", v.bufnr > 0 and vim.fn.bufname(v.bufnr) or "", v.lnum or 0, v.col or 0, text)
		)
	end
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	local width = math.floor(vim.o.columns * 0.7)
	local height = math.floor(vim.o.lines * 0.7)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
		style = "minimal",
		border = "rounded",
	}
	vim.api.nvim_open_win(buf, true, opts)
end

-- Quickfix navigation stays the same
map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- Quickfix toggle (floating)
map("n", "<leader>xq", function() open_list_floating("quickfix") end, { desc = "Quickfix list (float)" })

-- Location list toggle (floating)
map("n", "<leader>xl", function() open_list_floating("location") end, { desc = "Location List (float)" })

-- Clear search, diff update and redraw (refresh ui)
map("n", "<leader>ur", "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>", { desc = "Refresh UI" })
--fun stuff
map("n", "<leader>?K", vim.lsp.buf.hover, { desc = "LSP Hover" })
map("n", "<leader>?s", "<Cmd>Store<CR>", { desc = "Store" })
map("n", "<leader>?t", ":Typr<CR>", { desc = "Typr" })
