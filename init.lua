require("config.keymaps")
require("config.options")
require("config.lazy")

local autocmd = vim.api.nvim_create_autocmd

-- Auto remove trailing white space
autocmd({ "BufWritePre" }, {
    pattern = "*",
    command = [[%s/\s\+$//e]],
})
