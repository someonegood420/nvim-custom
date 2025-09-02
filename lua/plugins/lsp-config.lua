return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local lspconfig = require("lspconfig")

		-- Prefer cmp_nvim_lsp for better capabilities (if using cmp)
		local capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			require("cmp_nvim_lsp").default_capabilities() or {}
		)

		-- Setup Mason
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "basedpyright" },
			automatic_installation = true,
		})

		-- Lua LSP (let lazydev handle workspace.library)
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = vim.split(package.path, ";"),
					},
					diagnostics = {
						globals = { "vim", "require" }, -- fix "undefined global"
					},
					workspace = {
						checkThirdParty = false, -- let lazydev inject its library
					},
					telemetry = {
						enable = false,
					},
				},
			},
		})

		-- Python LSP
		lspconfig.basedpyright.setup({
			capabilities = capabilities,
		})
	end,
}
