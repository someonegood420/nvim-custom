return {
	{
		"stevearc/conform.nvim",
		opts = {
			-- Format on save
			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 1000,
			},

			-- Formatter setup per filetype
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "black" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				cs = { "csharpier" },
				json = { "prettier" },
				yaml = { "prettier" },
				html = { "prettier" },
				css = { "prettier" },
				sh = { "shfmt" },
				go = { "gofmt" },
			},

			-- Explicit formatter definitions (pointing to mason bin directory)
			formatters = {
				stylua = {
					command = vim.fn.stdpath("data") .. "/mason/packages/stylua/stylua.exe",
				},
				csharpier = {
					command = vim.fn.stdpath("data") .. "/mason/packages/stylua/stylua.exe",
				},
				black = {
					command = vim.fn.stdpath("data") .. "/mason/packages/black",
				},
				prettier = {
					command = vim.fn.stdpath("data") .. "/mason/b/prettier",
				},
				shfmt = {
					command = vim.fn.stdpath("data") .. "/mason/bin/shfmt",
				},
				gofmt = {
					command = vim.fn.stdpath("data") .. "/mason/bin/gofmt",
				},
			},
		},
	},
}
