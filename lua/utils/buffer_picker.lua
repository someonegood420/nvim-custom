local M = {}

local picker_buf, picker_win
local previous_buf, previous_win
local buffer_lookup = {}

local function get_buffers()
	local buffers = {}
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_option(buf, "buflisted") then
			table.insert(buffers, {
				bufnr = buf,
				name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"),
			})
		end
	end
	return buffers
end
local function close_picker()
	if picker_win and vim.api.nvim_win_is_valid(picker_win) then vim.api.nvim_win_close(picker_win, true) end
	picker_win = nil
	picker_buf = nil
end
local function open_picker()
	previous_buf = vim.api.nvim_get_current_buf()
	previous_win = vim.api.nvim_get_current_win() -- ✅ save active window

	local buffers = get_buffers()
	local height = math.max(#buffers + 2, 10)
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
		title = " Buffer Picker ",
		title_pos = "center",
	}
	picker_win = vim.api.nvim_open_win(picker_buf, true, opts)

	-- Fill buffer list
	buffer_lookup = {}
	local lines = {}
	for i, buf in ipairs(buffers) do
		table.insert(lines, buf.name ~= "" and buf.name or "[No Name]")
		buffer_lookup[i] = buf.bufnr
	end
	vim.api.nvim_buf_set_lines(picker_buf, 0, -1, false, lines)

	-- Jump cursor to current buffer
	for i, buf in ipairs(buffers) do
		if buf.bufnr == previous_buf then
			vim.api.nvim_win_set_cursor(picker_win, { i, 0 })
			break
		end
	end

	-- Keymaps
	local opts_map = { nowait = true, noremap = true, silent = true, buffer = picker_buf }

	-- Close picker
	vim.keymap.set("n", "q", function() vim.api.nvim_win_close(picker_win, true) end, opts_map)

	local function switch_to_cursor_buf()
		local line = vim.api.nvim_win_get_cursor(picker_win)[1]
		local bufnr = buffer_lookup[line]
		if bufnr and previous_win and vim.api.nvim_win_is_valid(previous_win) then
			vim.api.nvim_set_current_win(previous_win)
			vim.api.nvim_set_current_buf(bufnr)
			-- ⚠️ don’t jump back into picker_win if it’s closed
			if picker_win and vim.api.nvim_win_is_valid(picker_win) then vim.api.nvim_set_current_win(picker_win) end
		end
	end

	-- Navigate + switch live
	vim.keymap.set("n", "j", function()
		vim.cmd.normal({ args = { "j" }, bang = true })
		switch_to_cursor_buf()
	end, opts_map)

	vim.keymap.set("n", "k", function()
		vim.cmd.normal({ args = { "k" }, bang = true })
		switch_to_cursor_buf()
	end, opts_map)

	-- Delete buffer with dd
	vim.keymap.set("n", "dd", function()
		local line = vim.api.nvim_win_get_cursor(picker_win)[1]
		local bufnr = buffer_lookup[line]
		if bufnr then
			vim.cmd.bdelete(bufnr)
			vim.api.nvim_set_current_win(previous_win)
			vim.api.nvim_set_current_buf(previous_buf)
			vim.api.nvim_win_close(picker_win, true)
			M.toggle() -- reopen refreshed
		end
	end, opts_map)

	-- Auto-close picker in common exit cases

	-- Auto-close picker when the picker loses focus or editing starts

	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		callback = function()
			vim.defer_fn(function()
				if picker_win and vim.api.nvim_win_is_valid(picker_win) then
					if vim.api.nvim_get_current_win() ~= picker_win then close_picker() end
				end
			end, 20) -- 20ms delay gives j/k preview time to bounce back
		end,
	})

	vim.api.nvim_create_autocmd("InsertEnter", {
		callback = function() close_picker() end,
	})

	-- Auto-close if you move the cursor in another window (mouse clicks etc.)
	vim.api.nvim_create_autocmd("CursorMoved", {
		callback = function()
			if picker_win and vim.api.nvim_win_is_valid(picker_win) then
				if vim.api.nvim_get_current_win() ~= picker_win then close_picker() end
			end
		end,
	})
end
function M.toggle()
	if picker_win and vim.api.nvim_win_is_valid(picker_win) then
		vim.api.nvim_win_close(picker_win, true)
		picker_win = nil
		picker_buf = nil
	else
		open_picker()
	end
end

return M
