return {
	{
		"folke/snacks.nvim",
		event = "VimEnter",
		config = function()
			local Snacks = require("snacks")
			Snacks.setup({
				indent = {
					enabled = true,
					hl = "#938a0c",
					scope = {
						hl = "SnacksIndent3",
					},
				},
				notifier = { enabled = true },
				dashboard = {
					width = 60,
					pane_gap = 4,
					preset = {
						header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
						keys = {
							{
								icon = " ",
								key = "f",
								desc = "Find File",
								action = ":lua Snacks.dashboard.pick('files')",
							},
							{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
							{
								icon = " ",
								key = "g",
								desc = "Find Text",
								action = ":lua Snacks.dashboard.pick('live_grep')",
							},
							{
								icon = " ",
								key = "r",
								desc = "Recent Files",
								action = ":lua Snacks.dashboard.pick('oldfiles')",
							},
							{
								icon = " ",
								key = "c",
								desc = "Config",
								action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
							},
							{
								icon = " ",
								key = "s",
								desc = "Session Picker",
								action = function()
									local sessions_dir = vim.fn.stdpath("data") .. "/sessions"

									-- Check if the sessions directory exists
									local stat = vim.loop.fs_stat(sessions_dir)
									if not stat or stat.type ~= "directory" then
										vim.notify(
											"No sessions directory found at: " .. sessions_dir,
											vim.log.levels.ERROR
										)
										return
									end

									-- Use Telescope to browse and select session files
									require("telescope.builtin").find_files({
										prompt_title = "Select a session",
										cwd = sessions_dir,
										initial_mode = "normal", -- Open Telescope in normal mode
										attach_mappings = function(_, map)
											local actions = require("telescope.actions")
											local action_state = require("telescope.actions.state")

											-- On <CR>, load the selected session file
											map("n", "<CR>", function(prompt_bufnr)
												local selection = action_state.get_selected_entry()
												actions.close(prompt_bufnr)
												if selection then
													local session_file = sessions_dir .. "/" .. selection.value
													vim.cmd("source " .. vim.fn.fnameescape(session_file))
													vim.notify("Session loaded: " .. selection.value)
												end
											end)

											return true
										end,
									})
								end,
							},
							{
								icon = "󰒲 ",
								key = "L",
								desc = "Lazy",
								action = ":Lazy",
								enabled = package.loaded.lazy ~= nil,
							},
							{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
						},
					},
					sections = {
						{ section = "header" },
						{
							pane = 2,
							section = "terminal",
							cmd = 'powershell -ExecutionPolicy Bypass -File "C:\\scripts\\colorsplash.ps1"',
							height = 7,
							padding = 1,
						},
						{ section = "keys", gap = 1, padding = 1 },
						{
							pane = 2,
							icon = " ",
							title = "Recent Files",
							section = "recent_files",
							indent = 2,
							padding = 1,
						},
						{
							pane = 2,
							icon = " ",
							title = "Projects",
							section = "projects",
							indent = 2,
							padding = 1,
						},
						{
							pane = 2,
							icon = " ",
							title = "Git Status",
							section = "terminal",
							enabled = function()
								return Snacks.git.get_root() ~= nil
							end,
							cmd = "git status --short --branch --renames",
							height = 5,
							padding = 1,
							ttl = 5 * 60, -- refresh every 5 min
							indent = 3,
						},
						{ section = "startup" },
					},
				},
			})
		end,
	},
}
