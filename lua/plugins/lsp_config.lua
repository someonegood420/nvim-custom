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
            ensure_installed = { "lua_ls" },
            automatic_installation = true,
        })
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)

                -- Disable hover for ruff since it doesn't provide useful hover info
                if client and client.name == "ruff" then
                    client.server_capabilities.hoverProvider = false
                end

                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
                end

        -- lsp keymaps
        -- stylua: ignore start
        map("<leader>ch", vim.diagnostic.open_float, "Hover Diagnostics")
        map("<leader>cH", vim.lsp.buf.hover, "Hover Info")
        map("<leader>cR", vim.lsp.buf.rename, "Rename")
        map("<leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
        map("<leader>cA", function() vim.lsp.buf.code_action({ context = { only = { "source" } } }) end, "Source Action")
        map("<leader>cc", vim.lsp.codelens.run, "Run Codelens", { "n", "v" })
        map("<leader>cC", vim.lsp.codelens.refresh, "Refresh & Display Codelens", { "n" })
        map("<leader>cI", function() Snacks.picker.lsp_config() end, "LSP Info")
        map("<leader>cr", function() Snacks.picker.lsp_references() end, "Goto References")
        map("<leader>ci", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
        map("<leader>cd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
        map("<leader>cD", function() Snacks.picker.lsp_declarations() end, "Goto Declaration")
        map("<leader>cM", function() Snacks.picker.lsp_symbols() end, "Document Symbols")
        map("<leader>cW", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")
        map("<leader>ct", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
                -- stylua: ignore end
            end,
        }) -- Lua LSP (let lazydev handle workspace.library)
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
    end,
}
