vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = vim.diagnostic.severity.ERROR },

	-- Can switch between these as you prefer
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Teest shows up underneath the line, with virtual lines

	-- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
	jump = { float = true },
})

vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>dp", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)

-- Center screen when using C-d and C-u
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Shift+Tab to unindent
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Unindent in insert mode" })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Quick search and replace
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Yank everything in Harpoon list
vim.keymap.set("n", "<leader>hy", function()
	local harpoon = require("harpoon")
	local list = harpoon:list()
	local result = {}

	for i, item in ipairs(list.items) do
		local filepath = item.value
		local filename = vim.fn.fnamemodify(filepath, ":t")

		local lines = vim.fn.readfile(filepath)
		local content = table.concat(lines, "\n")

		table.insert(result, string.format("File %d: %s\n---\n%s", i, filename, content))
	end

	local final_text = table.concat(result, "\n\n")

	-- Copy to system clipboard
	vim.fn.setreg("+", final_text)

	print("Copied Harpoon files to clipboard")
end, { desc = "Copy all Harpoon file contents to clipboard" })
