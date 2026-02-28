require("config.keymaps")
require("config.options")
require("config.lazy")

local autocmd = vim.api.nvim_create_autocmd

-- Auto remove trailing white space
autocmd({ "BufWritePre" }, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(e)
        local opts = { buffer = e.buf }

        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

        -- Info
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

        -- Actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- Diagnostics - using <leader> instead of [ ]
        vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)
    end
})
