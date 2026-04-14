require("config.keymaps")
require("config.options")

-- GitHub and CodeBerg helper functions
local gh = function(x)
    return "https://github.com/" .. x
end
local cb = function(x)
    return "https://codeberg.org/" .. x
end

-- Plugins
vim.pack.add({
    "https://github.com/ellisonleao/gruvbox.nvim",
    gh("nvim-lua/plenary.nvim"),
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/windwp/nvim-autopairs",
    gh("saghen/blink.cmp"),
    gh("lukas-reineke/indent-blankline.nvim"),
    "https://github.com/nvim-lualine/lualine.nvim",
    gh("brenoprata10/nvim-highlight-colors"),
    "https://github.com/nvim-telescope/telescope.nvim",
    gh("lewis6991/gitsigns.nvim"),
    gh("tpope/vim-fugitive"),
    { src = gh("ThePrimeagen/harpoon"),                           version = "harpoon2" },
    "https://github.com/stevearc/conform.nvim",
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    gh("windwp/nvim-ts-autotag"),
}, { confirm = false })

vim.cmd.colorscheme("gruvbox")
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", require("undotree").open)

require("nvim-autopairs").setup()
require("lualine").setup({
    options = {
        section_separators = { left = "", right = "", },
        component_separators = { left = "", right = "", },
    },
})
require("gitsigns").setup({
    signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
    }
})
require("ibl").setup()
require("telescope").setup({})
require("nvim-highlight-colors").setup({})
local pickers = require("telescope.builtin")
vim.keymap.set("n", "<leader>pf", pickers.find_files)
vim.keymap.set('n', '<C-p>', pickers.git_files, {})
vim.keymap.set("n", "<leader>pg", pickers.live_grep)
vim.keymap.set("n", "<leader>pb", pickers.buffers)
vim.keymap.set("n", "<leader>ph", pickers.help_tags)

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

-- harpoon setup
local harpoon = require("harpoon")
harpoon.setup()
vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end)
vim.keymap.set("n", "<C-e>", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<M-1>", function()
    harpoon:list():select(1)
end)
vim.keymap.set("n", "<M-2>", function()
    harpoon:list():select(2)
end)
vim.keymap.set("n", "<M-3>", function()
    harpoon:list():select(3)
end)
vim.keymap.set("n", "<M-4>", function()
    harpoon:list():select(4)
end)
vim.keymap.set("n", "<M-5>", function()
    harpoon:list():select(5)
end)

require("blink.cmp").setup({
    completion = {
        documentation = {
            auto_show = true,
        },
    },

    keymap = {
        -- these are the default blink keymaps
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        ['<CR>'] = { 'select_and_accept', 'fallback' },
        ['<Esc>'] = { 'cancel', 'hide_documentation', 'fallback' },

        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    fuzzy = {
        implementation = "lua",
    },
})

-- INFO: lsp server installation and configuration

-- lsp servers we want to use and their configuration
-- see `:h lspconfig-all` for available servers and their settings
local lsp_servers = {
    lua_ls = {
        -- https://luals.github.io/wiki/settings/ | `:h nvim_get_runtime_file`
        Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) } },
    },
}

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig", -- default configs for lsps

    -- NOTE: if you'd rather install the lsps through your OS package manager you
    -- can delete the next three mason-related lines and their setup calls below.
    -- see `:h lsp-quickstart` for more details.
    "https://github.com/mason-org/mason.nvim",                      -- package manager
    "https://github.com/mason-org/mason-lspconfig.nvim",            -- lspconfig bridge
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim", -- auto installer
}, { confirm = false })

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_keys(lsp_servers),
})

-- configure each lsp server on the table
-- to check what clients are attached to the current buffer, use
-- `:checkhealth vim.lsp`. to view default lsp keybindings, use `:h lsp-defaults`.
for server, config in pairs(lsp_servers) do
    vim.lsp.config(server, {
        settings = config,

        -- only create the keymaps if the server attaches successfully
        -- on_attach = function(_, bufnr)
        --     vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { buffer = bufnr, desc = "vim.lsp.buf.format()" })
        -- end,
    })
end

require("conform").setup({
    notify_on_error = false,
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
    },
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        python = { "ruff_format" },
        svelte = { "prettier" },
        markdown = { "prettier" },
    },
})

vim.keymap.set("", "<leader>f", function()
    require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })


-- INFO: formatting and syntax highlighting
require("nvim-treesitter.install").update("all")
-- Ensure parsers are installed
local ensureInstalled = {
    "vimdoc", "javascript", "typescript", "lua",
    "jsdoc", "bash", "python", "svelte", "html",
}
local alreadyInstalled = require("nvim-treesitter.config").get_installed()
local parsersToInstall = vim.iter(ensureInstalled)
    :filter(function(parser)
        return not vim.tbl_contains(alreadyInstalled, parser)
    end)
    :totable()

if #parsersToInstall > 0 then
    require("nvim-treesitter").install(parsersToInstall)
end

-- Register FileType autocmd for highlighting and indentation
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
-- TODO: Make this work
-- require("nvim-ts-autotag").setup({
--     enable_close = true,
--     enable_rename = true,
--     enable_close_on_slash = true,
-- })
