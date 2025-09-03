return {
<<<<<<< HEAD
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
=======
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    config = function()
      local Snacks = require("snacks")

      -- 🔹 Session helpers
      local function session_name_from_cwd()
        -- Replace \ / : with % so filenames are Windows-safe
        return vim.fn.getcwd():gsub("[\\/:]", "%%")
      end

      local function session_file()
        return vim.fn.stdpath("data") .. "/sessions/" .. session_name_from_cwd() .. ".vim"
      end

      local function sessions_dir()
        return vim.fn.stdpath("data") .. "/sessions"
      end

      -- 🔹 Commands for saving/loading sessions
      vim.api.nvim_create_user_command("SessionSave", function()
        vim.fn.mkdir(sessions_dir(), "p") -- ensure dir exists
        vim.cmd("mksession! " .. vim.fn.fnameescape(session_file()))
        vim.notify("Session saved: " .. session_file())
      end, {})

      vim.api.nvim_create_user_command("SessionLoad", function()
        local file = session_file()
        if vim.fn.filereadable(file) == 1 then
          vim.cmd("silent! source " .. vim.fn.fnameescape(file))
          vim.notify("Session loaded: " .. file)
        else
          vim.notify("No session found for cwd: " .. vim.fn.getcwd(), vim.log.levels.WARN)
        end
      end, {})

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
              sort_lastused = false,
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
        scroll = { enabled = true },
        notifier = { enabled = true },
        dashboard = {
          width = 60,
          pane_gap = 4,
          preset = {
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
                  local sessions_dir = vim.fn.stdpath("state") .. "/sessions" -- persistence.nvim stores here
                  local stat = vim.loop.fs_stat(sessions_dir)
                  if not stat or stat.type ~= "directory" then
                    vim.notify("No sessions found at: " .. sessions_dir, vim.log.levels.ERROR)
                    return
                  end

                  require("telescope.builtin").find_files({
                    prompt_title = "Select a session",
                    cwd = sessions_dir,
                    glob_pattern = "*.vim", -- only show session files
                    initial_mode = "normal",
                    attach_mappings = function(_, map)
                      local actions = require("telescope.actions")
                      local action_state = require("telescope.actions.state")

                      map("i", "<CR>", function(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if selection then
                          local path = sessions_dir .. "/" .. selection.value
                          require("persistence").load({ session = path })
                          vim.notify("Session loaded: " .. selection.value)
                        end
                      end)

                      map("n", "<CR>", function(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        if selection then
                          local path = sessions_dir .. "/" .. selection.value
                          require("persistence").load({ session = path })
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
            { section = "keys",   gap = 1, padding = 1 },
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
      local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { desc = desc })
      end

      map("<leader>bc", function() Snacks.bufdelete() end, "Close Buffer")
      map("<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config"), title = "Config Files" }) end,
        "Config Files")
      map("<leader>fe", function() Snacks.explorer() end, "File Explorer")
      map("<leader>ff", function() Snacks.picker.files() end, "Files")
      map("<leader>fF", function() Snacks.picker.files({ hidden = true }) end, "All Files")
      map("<leader>fg", function() Snacks.picker.git_files() end, "Git Files")
      map("<leader>fp", function() Snacks.picker.projects() end, "Projects")
      map("<leader>fr", function() Snacks.picker.recent() end, "Recent")
      map("<leader>fb", function() Snacks.picker.grep_buffers() end, "Grep Open Buffs")
      map("<leader>fg", function() Snacks.picker.grep() end, "Grep Files")
      map("<leader>fG", function() Snacks.picker.grep() end, "Grep All Files")
      map("<leader>fw", function() Snacks.picker.grep_word() end, "Grep Selection/Word", { "n", "x" })
      map('<leader>s"', function() Snacks.picker.registers() end, "Reg")
      map('<leader>s/', function() Snacks.picker.search_history() end, "Search History")
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
    end,
  },
>>>>>>> cd8d81c (keymaps and better theme and added scope.nvim to open tabs better)
}
