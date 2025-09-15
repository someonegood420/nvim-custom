local M = {}

local picker_buf, picker_win
local previous_win
local tab_lookup = {}

-- Get all buffers in a tab
local function get_buffers_in_tab(tab)
	local buf_set = {}
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
		local buf = vim.api.nvim_win_get_buf(win)
		buf_set[buf] = true
	end

	local bufnames = {}
	for buf in pairs(buf_set) do
		local name = vim.api.nvim_buf_get_name(buf)
		if name == "" then
			name = "[No Name]"
		else
			name = vim.fn.fnamemodify(name, ":t")
		end
		table.insert(bufnames, name)
	end

	table.sort(bufnames)
	return bufnames
end

local function get_tabs()
	local tabs = {}
	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		local bufnames = get_buffers_in_tab(tab)
		if #bufnames == 0 then table.insert(bufnames, "[No Buffers]") end
		tabs[#tabs + 1] = {
			tabpage_id = tab,
			name = "(" .. vim.api.nvim_tabpage_get_number(tab) .. ")" .. " (" .. table.concat(bufnames, ", ") .. ")",
		}
	end
	return tabs
end

local function close_picker()
	if picker_win and vim.api.nvim_win_is_valid(picker_win) then vim.api.nvim_win_close(picker_win, true) end
	picker_buf = nil
	picker_win = nil
end

local function open_picker()
	previous_win = vim.api.nvim_get_current_win()

	local tabs = get_tabs()
	local height = math.max(#tabs + 2, 10)
	local width = math.max(30, math.floor(vim.o.columns * 0.25))
	local row = math.floor((vim.o.lines - height) / 2) - 5
	local col = math.floor((vim.o.columns - width) / 2) - 1

	picker_buf = vim.api.nvim_create_buf(false, true)
	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		border = "rounded",
		title = " Tab Picker ",
		title_pos = "center",
	}
	picker_win = vim.api.nvim_open_win(picker_buf, true, opts)

	vim.bo[picker_buf].buftype = "nofile"
	vim.bo[picker_buf].bufhidden = "wipe"
	vim.cmd("stopinsert")

	tab_lookup = {}
	local lines = {}
	for i, tab in ipairs(tabs) do
		table.insert(lines, tab.name)
		tab_lookup[i] = tab.tabpage_id
	end
	vim.api.nvim_buf_set_lines(picker_buf, 0, -1, false, lines)
	vim.bo[picker_buf].modifiable = false

	-- Jump to current tab
	local current_tab = vim.api.nvim_get_current_tabpage()
	for i, tab in ipairs(tabs) do
		if tab.tabpage_id == current_tab then
			vim.api.nvim_win_set_cursor(picker_win, { i, 0 })
			break
		end
	end

	local opts_map = { nowait = true, noremap = true, silent = true, buffer = picker_buf }

	-- Closing behaviors
	vim.keymap.set("n", "q", close_picker, opts_map)
	vim.keymap.set("n", "<Esc>", close_picker, opts_map)

	-- Confirm selection
	vim.keymap.set("n", "h", function()
		local line = vim.api.nvim_win_get_cursor(picker_win)[1]
		local tabpage_id = tab_lookup[line]
		if tabpage_id then
			close_picker()
			vim.api.nvim_set_current_tabpage(tabpage_id)
		end
	end, opts_map)

	-- Navigate only (no auto-close)
	vim.keymap.set("n", "j", function()
		local row = vim.api.nvim_win_get_cursor(picker_win)[1]
		local max_row = #tab_lookup
		vim.api.nvim_win_set_cursor(picker_win, { math.min(row + 1, max_row), 0 })
	end, opts_map)

	vim.keymap.set("n", "k", function()
		local row = vim.api.nvim_win_get_cursor(picker_win)[1]
		vim.api.nvim_win_set_cursor(picker_win, { math.max(row - 1, 1), 0 })
	end, opts_map)

	-- Autocmds for extra close options
	vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
		buffer = picker_buf,
		once = true,
		callback = close_picker,
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		once = true,
		callback = close_picker,
	})
end

function M.toggle()
	if picker_win and vim.api.nvim_win_is_valid(picker_win) then
		close_picker()
	else
		open_picker()
	end
end

return M
