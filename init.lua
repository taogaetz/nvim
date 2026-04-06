-- init.lua reload test
require("config.lazy")
local wk = require("which-key")

vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.opt.autoread = true

local uv = vim.uv or vim.loop
local reload_group = vim.api.nvim_create_augroup("AgentLiveReload", { clear = true })
local live_reload_timer = uv.new_timer()

local function checktime_now()
	vim.cmd("silent! checktime")
end

vim.api.nvim_create_autocmd({
	"FocusGained",
	"BufEnter",
	"CursorHold",
	"CursorHoldI",
	"TermLeave",
	"WinEnter",
}, {
	group = reload_group,
	pattern = "*",
	callback = function()
		-- Recheck the file on disk so external agent edits are loaded automatically.
		checktime_now()
	end,
})

live_reload_timer:start(0, 1000, vim.schedule_wrap(checktime_now))

vim.api.nvim_create_autocmd("VimLeavePre", {
	group = reload_group,
	callback = function()
		if live_reload_timer and not live_reload_timer:is_closing() then
			live_reload_timer:stop()
			live_reload_timer:close()
		end
	end,
})

-- Faster response to external edits.
vim.opt.updatetime = 500

wk.add({
	mode = { "n", "v", "x" },
	{ '<leader>o',        ':update<CR> :source<CR>',       desc = "write & source" },
	{ '<leader>L',        ':Lazy<CR>',                     desc = "open Lazy" },
	{ '<leader>p',        ":Pick grep_live tool='rg'<CR>", desc = "Pick grep", },
	{ '<leader><leader>', ":Pick files<CR>",               desc = "Pick dir", },
	{ '<leader>h',        ":Pick help<CR>",                desc = "Pick Help", },
	{ "<leader>q",        "<cmd>q!<cr>",                   desc = "force quit" }, -- no need to specify mode since it's inherited
	{ "qq",               "<cmd>q!<cr>",                   desc = "fast quit" },
	{ "<leader>w",        "<cmd>w<cr>",                    desc = "Write" },
	{ '<leader>lf',       vim.lsp.buf.format,              desc = "format file with lsp" },
	{ '<leader>y',            '"+y<CR>',                       desc = "yank to clipboard" },
	{ '<leader>x',        '"+d<CR>',                       desc = "cut to clipboard" },
})


vim.lsp.enable({ 'lua_ls', 'svelte', 'jsonls' })

vim.lsp.config('jsonls', {
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    }
  }
})


vim.cmd("colorscheme vague")
vim.cmd(":hi statusline guibg=NONE")


require('nvim-ts-autotag').setup({
  opts = {
    -- Defaults
    enable_close = true, -- Auto close tags
    enable_rename = true, -- Auto rename pairs of tags
    enable_close_on_slash = false -- Auto close on trailing </
  },
  -- Also override individual filetype configs, these take priority.
  -- Empty by default, useful if one of the "opts" global settings
  -- doesn't work well in a specific filetype
  per_filetype = {
    ["html"] = {
      enable_close = false
    }
  }
})
