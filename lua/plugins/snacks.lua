return {

	{
		"folke/snacks.nvim",
		event = "VimEnter",
		config = function()
			local Snacks = require("snacks")
			local session_manager = require("utils.session_manager")

			-- 🔹 Snacks setup
			vim.api.nvim_set_hl(0, "MyIndentHL", { fg = "#938a0c" })
			Snacks.setup({
				indent = {
					enabled = true,
					hl = "SnacksPickerDimmed",
					scope = {
						hl = "SnacksIndent3",
					},
				},
				--- PICKER ---
				picker = {
					enabled = true,
					layouts = {
						default = {
							layout = {
								-- backdrop = false,
							},
						},
						select = {},
					},
					win = {
						preview = {
							wo = {
								wrap = false,
							},
						},
						input = {
							keys = {
								["q"] = { "close", mode = { "n" } },
							},
						},
					},
					sources = {
						buffers = {
							sort_lastused = true,
						},
						command_history = {
							layout = { preset = "select" },
						},
						search_history = {
							layout = { preset = "select" },
						},
						icons = {
							layout = { preset = "select" },
						},
					},
				},
				--- SCROLL ---
				scroll = {
					enabled = false,
				},
				notifier = {
					enabled = true,
					rules = {
						{ event = "BufEnter", enabled = false },
					},
				},
				dashboard = {
					width = 126,
					height = 90,
					pane_gap = 0,
					preset = {
						keys = {
							{
								icon = " ",
								key = "f",
								desc = "Files",
								action = ":lua Snacks.dashboard.pick('files')",
							},
							{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
							{
								icon = " ",
								key = "g",
								desc = "Grep",
								action = ":lua Snacks.dashboard.pick('live_grep')",
							},
							{
								icon = " ",
								key = "o",
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
								desc = "Session pick",
								action = function() session_manager.session_picker() end,
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
						{
							pane = 1,
							section = "terminal",
							cmd = 'img2art "C:/Users/ahad/AppData/Local/nvim/lua/plugins/dashboardgirl.jpg" --scale 0.37 --with-color --threshold 50',
							height = 51,
							width = 120,
						},
						{ pane = 2, section = "keys" },
						{
							pane = 2,
							icon = " ",
							title = "Recent Files",
							section = "recent_files",
						},
						{
							pane = 2,
							icon = " ",
							title = "Projects",
							section = "projects",
						},
						{
							pane = 2,
							icon = " ",
							title = "Git Status",
							section = "terminal",
							enabled = function() return Snacks.git.get_root() ~= nil end,
							cmd = "git status --short --branch --renames",
							height = 5,
							padding = 1,
							ttl = 5 * 60, -- refresh every 5 min
						},
					},
				},
			})
			local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
        -- stylua: ignore start
			map("<leader>bc", function() Snacks.bufdelete() end, "Close Buff")
      -- #find
			map("<leader>F", function() Snacks.picker.smart() end, "Smart find")
			map("<leader>fc", function() Snacks.picker.lines() end, "buff line")
			map("<leader>fC", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), title = "Config Files" }) end, "Config Files")
			map("<leader>fe", function() Snacks.explorer() end, "File Explorer")
			map("<leader>ff", function() Snacks.picker.files() end, "Files")
			map("<leader>fF", function() Snacks.picker.files({ hidden = true }) end, "All Files")
			map("<leader>gf", function() Snacks.picker.git_files() end, "Git Files")
			map("<leader>fp", function() Snacks.picker.projects() end, "Projects")
			map("<leader>fo", function() Snacks.picker.recent() vim.defer_fn(function() vim.cmd("stopinsert") end, 10) end, "Recent Files (normal mode)")
			map("<leader>fb", function() Snacks.picker.buffers() end, "Buffs")
			map("<leader>fB", function() Snacks.picker.grep_buffers() end, "Grep Open Buffs")
			map("<leader>fg", function() Snacks.picker.grep() end, "Grep Files")
			map("<leader>fG", function() Snacks.picker.grep() end, "Grep All Files")
			map("<leader>fw", function() Snacks.picker.grep_word() end, "Grep Selection/Word", { "n", "x" })
      -- #search
			map('<leader>s"', function() Snacks.picker.registers() end, "Reg")
			map("<leader>s/", function() Snacks.picker.search_history() end, "Search History")
			map("<leader>sa", function() Snacks.picker.autocmds() end, "Autocmds")
			map("<leader>sc", function() Snacks.picker.command_history() end, "Cmds History")
			map("<leader>sC", function() Snacks.picker.commands() end, "Cmds")
			map("<leader>sh", function() Snacks.picker.help() end, "Help Pages")
			map("<leader>sH", function() Snacks.picker.highlights() end, "Highlights")
			map("<leader>si", function() Snacks.picker.icons() end, "Icons")
			map("<leader>sj", function() Snacks.picker.jumps() end, "Jumps")
			map("<leader>sk", function() Snacks.picker.keymaps() end, "Keymaps")
			map("<leader>sl", function() Snacks.picker.loclist() end, "Location List")
			map("<leader>sm", function() Snacks.picker.marks() end, "Marks")
			map("<leader>sM", function() Snacks.picker.man() end, "Man Pages")
			map("<leader>sn", function() Snacks.notifier.show_history() end, "Noti History")
			map("<leader>sp", function() Snacks.picker.pickers() end, "Pickers")
			map("<leader>sq", function() Snacks.picker.qflist() end, "Qckfix List")
			map("<leader>sR", function() Snacks.picker.resume() end, "Resume")
			map("<leader>su", function() Snacks.picker.undo() end, "Undo History")
			map("<leader><Tab>s", function() Snacks.picker.pick("tabs") end, "Search Tabs")
      -- #Git
			map("<leader>gg", function() Snacks.lazygit({ cwd = vim.fn.fnamemodify(vim.fn.finddir(".git", ".;"), ":h") }) end, "Lazygit" )
			map("<leader>gb", function() Snacks.picker.git_log_line() end, "Git Blame Line")
			map("<leader>gf", function() Snacks.picker.git_files() end, "find Git Files")
			map("<leader>gB", function() Snacks.gitbrowse() end, "Git Browse")
			map("<leader>gl", function() Snacks.picker.git_log({ cwd = vim.fs.root(0, ".git") }) end, "Git Log")
			map("<leader>gL", function() Snacks.picker.git_log_line() end, "Git Log Line")
			map("<leader>gs", function() Snacks.picker.git_status() end, "Git Status")
			map("<leader>gS", function() Snacks.picker.git_stash() end, "Git Stash")
			map("<leader>gd", function() Snacks.picker.git_diff() end, "Git Diff (Hunks)")
			map("<leader>gF", function() Snacks.picker.git_log_file() end, "Git Current File History")
			-- stylua: ignore end
			Snacks.toggle({
				name = "Session Autosave",
				notify = false,
				get = function() return session_manager.is_autosave_enabled() end,
				set = function() session_manager.toggle_autosave() end,
			}):map("<leader>Sa")
			Snacks.toggle.line_number():map("<leader>ul")
			Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
			Snacks.toggle.dim():map("<leader>uD")
			Snacks.toggle.option("spell", { name = "Spell Check" }):map("<leader>us")
			Snacks.toggle.treesitter({ name = "Treesitter Highlighting" }):map("<leader>uT")
			Snacks.toggle.inlay_hints():map("<leader>uh")
			Snacks.toggle.indent():map("<leader>uI")
			Snacks.toggle.scroll():map("<leader>uR")
			Snacks.toggle({
				name = "Virtual Text",
				get = function() return vim.diagnostic.config().virtual_text end,
				set = function(state)
					vim.diagnostic.config({
						virtual_text = state,
						signs = not state,
					})
				end,
			}):map("<leader>uv")
		end,
	},
}
