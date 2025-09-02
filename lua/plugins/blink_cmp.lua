return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"rafamadriz/friendly-snippets",
			"hrsh7th/nvim-cmp", -- make sure nvim-cmp loads first
			{
				"L3MON4D3/LuaSnip",
				dependencies = "rafamadriz/friendly-snippets",
				opts = { history = true, updateevents = "TextChanged,TextChangedI" },
				config = function(_, opts)
					require("luasnip").config.set_config(opts)
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			"hrsh7th/cmp-nvim-lsp", -- ✅ fixes the module not found error
			{
				"windwp/nvim-autopairs",
				opts = {
					fast_wrap = {},
					disable_filetype = { "TelescopePrompt", "vim" },
				},
			},
		},
		opts = {
			snippets = { preset = "luasnip" },
			cmdline = { enabled = true },
			appearance = { nerd_font_variant = "normal" },
			fuzzy = { implementation = "prefer_rust" },
			sources = {
				default = { "lsp", "snippets", "buffer", "path", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100, -- optional: boosts completion priority
					},
				},
			},

			keymap = {
				preset = "default",
				["<CR>"] = { "accept", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
			},
			completion = {
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
				},
				menu = {
					border = "rounded",
					scrollbar = false,
					draw = {
						columns = { { "label" }, { "kind_icon" }, { "kind" } },
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon .. " "
								end,
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
						treesitter = {
							"lsp",
						},
					},
				},
			},
			signature = {
				enabled = true,
				window = {
					show_documentation = true,
					border = "rounded",
				},
			},
		},
	},
}
