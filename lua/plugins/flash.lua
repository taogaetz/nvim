return {
		-- this plugin is also affecting ftFT motions
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	-- stylua: ignore
	keys = {
		mode = { "n", "x", "o" },
		{ "<leader>s",           function() require("flash").jump() end, desc = "Flash" },
	}
}
