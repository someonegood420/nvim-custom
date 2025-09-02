-- lua/recorder.lua
local M = {}
local rec_notify_id = nil

local function store_notify_id(res)
	if not res then
		return
	end
	if type(res) == "table" then
		if res.id then
			rec_notify_id = res.id
		elseif res[1] and type(res[1]) == "number" then
			rec_notify_id = res[1]
		end
	elseif type(res) == "number" or type(res) == "string" then
		rec_notify_id = res
	end
end

local function show_recording(reg)
	local ok, res = pcall(
		vim.notify,
		"● Recording @" .. reg,
		vim.log.levels.INFO,
		{ title = "Macro", timeout = false, replace = rec_notify_id }
	)
	if ok then
		store_notify_id(res)
	end
end

local function replace_with_stopped()
	-- Replace the persistent REC notif with a short Stopped message.
	pcall(vim.notify, "■ Stopped Recording", vim.log.levels.WARN, {
		title = "Macro",
		timeout = 1400,
		replace = rec_notify_id,
	})

	-- best-effort: clear any leftover via noice CLI (no error if not available)
	pcall(function()
		local noice = require("noice")
		if noice and noice.cmd then
			noice.cmd("dismiss") -- dismiss all visible messages (safe fallback)
		end
	end)

	rec_notify_id = nil
end

-- Show or update the recording notification
vim.api.nvim_create_autocmd("RecordingEnter", {
	callback = function()
		local reg = vim.fn.reg_recording() or ""
		if reg == "" then
			return
		end

		-- show (or replace) persistent notification via vim.notify -> Noice
		show_recording(reg)
	end,
})

-- On leave: poll briefly because RecordingLeave may fire before internal flag clears.
vim.api.nvim_create_autocmd("RecordingLeave", {
	callback = function()
		-- small deferred start so we don't race with internal state update
		vim.defer_fn(function()
			local attempts = 0
			local max_attempts = 60 -- ~60 * 20ms = 1.2s max
			local function poll()
				attempts = attempts + 1
				local cur = vim.fn.reg_recording() or ""
				if cur == "" or attempts >= max_attempts then
					-- replace/hide the persistent recording notification
					replace_with_stopped()
				else
					vim.defer_fn(poll, 20)
				end
			end
			poll()
		end, 10)
	end,
})

return M
