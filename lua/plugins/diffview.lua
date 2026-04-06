return {
	"sindrets/diffview.nvim",
	lazy = false,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", opts = {} },
	},
	opts = {
		default_args = {
			DiffviewOpen = { "--imply-local" },
		},
		use_icons = true,
		watch_index = true,
		view = {
			default = {
				layout = "diff2_horizontal",
				winbar_info = false,
			},
			file_history = {
				layout = "diff2_horizontal",
				winbar_info = false,
			},
		},
		keymaps = {
			view = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
			},
			file_panel = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
			},
			file_history_panel = {
				{ "n", "q", "<cmd>DiffviewClose<cr>", { desc = "Close diffview" } },
			},
		},
	},
	config = function(_, opts)
		require("diffview").setup(opts)

		local function is_git_ignored(filepath)
			vim.fn.system("git check-ignore -q " .. vim.fn.shellescape(filepath))
			return vim.v.shell_error == 0
		end

		local function update_left_pane()
			pcall(function()
				local lib = require("diffview.lib")
				local view = lib.get_current_view()
				if view then
					view:update_files()
				end
			end)
		end

		require("custom.directory-watcher").registerOnChangeHandler("diffview", function(filepath, _events)
			local is_in_dot_git_dir = filepath:match("/%.git/") or filepath:match("^%.git/")
			if is_in_dot_git_dir or not is_git_ignored(filepath) then
				update_left_pane()
			end
		end)

		vim.api.nvim_create_autocmd("FocusGained", {
			callback = update_left_pane,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "DiffviewViewLeave",
			callback = function()
				vim.cmd("silent! DiffviewClose")
			end,
		})

		vim.api.nvim_create_autocmd("VimLeavePre", {
			callback = function()
				require("custom.directory-watcher").stop("diffview")
			end,
		})

		vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", { desc = "open diffview" })
		vim.keymap.set("n", "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", { desc = "file history" })
		vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>", { desc = "repo history" })
	end,
}
