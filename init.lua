require("config.lazy")
local wk = require("which-key")

vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = "rounded"

wk.add({
	mode = { "n", "v", "x" },
	{ '<leader>o',        ':update<CR> :source<CR>',       desc = "write & source" },
	{ '<leader>L',        ':Lazy<CR>',                     desc = "open Lazy" },
	{ '<leader>p',        ":Pick grep_live tool='rg'<CR>", desc = "Pick grep", },
	{ '<leader><leader>', ":Pick files<CR>",               desc = "Pick dir", },
	{ '<leader>h',        ":Pick help<CR>",                desc = "Pick Help", },
	{ "<leader>q",        "<cmd>q!<cr>",                   desc = "force quit" }, -- no need to specify mode since it's inherited
	{ "qq",               "<cmd>q<cr>",                    desc = "fast quit" },
	{ "<leader>w",        "<cmd>w<cr>",                    desc = "Write" },
	{ '<leader>lf',       vim.lsp.buf.format,              desc = "format file with lsp" },
	{ '<S-y>',            '"+y<CR>',                       desc = "yank to clipboard" },
	{ '<leader>x',        '"+d<CR>',                       desc = "cut to clipboard" },
})


vim.lsp.enable({ 'lua_ls' })

vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")
