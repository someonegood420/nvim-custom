return {
	name = "Tabs",
	finder = function(opts, ctx)
		local items = {} ---@type snacks.picker.finder.Item[]
		local current_buf = vim.api.nvim_get_current_buf()
		local alternate_buf = vim.fn.bufnr("#")
		local current_tabpage = vim.api.nvim_get_current_tabpage()

		local tabpages = vim.api.nvim_list_tabpages()
		-- Sort tabpages by number to ensure consistent ordering
		table.sort(
			tabpages,
			function(a, b) return vim.api.nvim_tabpage_get_number(a) < vim.api.nvim_tabpage_get_number(b) end
		)

		-- Helper: get only buffers actually open in this tab
		local function get_buffers_in_tab(tabpage_id)
			local buf_set = {}

			for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage_id)) do
				local buf = vim.api.nvim_win_get_buf(win)
				-- Skip [No Name] buffers
				if vim.api.nvim_buf_get_name(buf) ~= "" then buf_set[buf] = true end
			end

			local bufs = {}
			for buf in pairs(buf_set) do
				table.insert(bufs, buf)
			end
			table.sort(bufs)
			return bufs
		end

		for _, tabpage_id in ipairs(tabpages) do
			local tab_num = vim.api.nvim_tabpage_get_number(tabpage_id)
			local is_current_tab = tabpage_id == current_tabpage

			-- Add tabpage header
			table.insert(items, {
				type = "tab_header",
				text = "Tab #" .. tab_num .. " " .. tostring(tab_num),
				tabpage_id = tabpage_id,
				is_current = is_current_tab,
			})

			local tab_buffers_to_display = {}
			local buffers_seen_in_tab = {}

			-- Get all buffers for this tab
			local buffers_in_tab = get_buffers_in_tab(tabpage_id)
			for _, buf in ipairs(buffers_in_tab) do
				if buffers_seen_in_tab[buf] then goto continue end
				buffers_seen_in_tab[buf] = true

				local name = vim.api.nvim_buf_get_name(buf)
				if name == "" then
					name = "[No Name]"
				else
					name = vim.fn.fnamemodify(name, ":t")
				end

				local info = vim.fn.getbufinfo(buf)[1] or {}
				local mark = vim.api.nvim_buf_get_mark(buf, '"')
				local flags = {
					buf == current_buf and "%" or (buf == alternate_buf and "#" or ""),
					(info.hidden == 1 or not vim.api.nvim_buf_is_loaded(buf)) and "h"
						or (#(info.windows or {}) > 0) and "a"
						or "",
					vim.bo[buf].readonly and "=" or "",
					info.changed == 1 and "+" or "",
				}

				table.insert(tab_buffers_to_display, {
					type = "buffer_entry",
					flags = table.concat(flags),
					buf = buf,
					file = name,
					text = tostring(buf) .. " " .. name,
					info = info,
					filetype = vim.bo[buf].filetype,
					tabpage_id = tabpage_id,
					is_current = (buf == current_buf and is_current_tab),
					pos = mark[1] ~= 0 and mark or { info.lnum, 0 },
				})
				::continue::
			end

			-- Add buffers to main items list
			for _, buffer_item in ipairs(tab_buffers_to_display) do
				table.insert(items, buffer_item)
			end
		end

		return ctx.filter:filter(items)
	end,
	format = function(item, picker)
		local ret = {}
		if item.type == "tab_header" then
			local hl = "SnacksPickerDirectory"
			ret[#ret + 1] = { "Tab #" .. vim.api.nvim_tabpage_get_number(item.tabpage_id), hl }
			if item.is_current then ret[#ret + 1] = { " ", "SnacksPickerBufNr" } end
		elseif item.type == "buffer_entry" then
			local icon, icon_hl = "", ""
			local name, cat = item.file, "file"

			if item.buf and vim.api.nvim_buf_is_loaded(item.buf) then
				name = vim.bo[item.buf].filetype
				cat = "filetype"
			end

			local new_icon, new_icon_hl = Snacks.util.icon(name, cat, {
				fallback = picker.opts.icons.files,
			})
			icon = new_icon or icon
			icon_hl = new_icon_hl or icon_hl

			icon = Snacks.picker.util.align(icon, picker.opts.formatters.file.icon_width or 2)

			ret[#ret + 1] = { "  " }
			ret[#ret + 1] = { Snacks.picker.util.align(tostring(item.buf), 3), "SnacksPickerBufNr" }
			ret[#ret + 1] = { " " }
			ret[#ret + 1] = {
				Snacks.picker.util.align(item.flags or "", 2, { align = "right" }),
				"SnacksPickerBufFlags",
			}
			ret[#ret + 1] = { " " }
			ret[#ret + 1] = { icon, icon_hl }

			local full_path = Snacks.picker.util.path(item) or item.file
			local truncated_path =
				Snacks.picker.util.truncpath(full_path, picker.opts.formatters.file.truncate or 40, { cwd = picker:cwd() })

			local dir, base = truncated_path:match("^(.*)/(.+)$")
			if base and dir then
				ret[#ret + 1] = { dir .. "/", "SnacksPickerDir" }
				ret[#ret + 1] = { base, "SnacksPickerFile" }
			else
				ret[#ret + 1] = { truncated_path, "SnacksPickerFile" }
			end

			if item.pos and item.pos[1] and item.pos[1] > 0 then
				ret[#ret + 1] = { ":", "SnacksPickerDelim" }
				ret[#ret + 1] = { tostring(item.pos[1]), "SnacksPickerRow" }
				if item.pos[2] and item.pos[2] > 0 then
					ret[#ret + 1] = { ":", "SnacksPickerDelim" }
					ret[#ret + 1] = { tostring(item.pos[2]), "SnacksPickerCol" }
				end
			end
		end
		return ret
	end,
	confirm = function(picker, item)
		picker:close()
		if item.type == "tab_header" then
			if item.tabpage_id then vim.api.nvim_set_current_tabpage(item.tabpage_id) end
		elseif item.type == "buffer_entry" then
			if item.tabpage_id then
				vim.api.nvim_set_current_tabpage(item.tabpage_id)
				if item.buf then vim.api.nvim_set_current_buf(item.buf) end
				if item.pos and item.pos[1] then pcall(vim.api.nvim_win_set_cursor, 0, item.pos) end
			end
		end
	end,
	actions = {},
	win = {
		input = { keys = {} },
	},
	layout = {
		preset = "default",
	},
}
