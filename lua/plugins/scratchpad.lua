return {
  "athar-qadri/scratchpad.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local scratchpad = require("scratchpad")
    scratchpad:setup({ settings = { sync_on_ui_close = true } })
  end,
  keys = {
    {
      "<Leader>.",
      function()
        local scratchpad = require("scratchpad")
        scratchpad.ui:new_scratchpad()
      end,
      desc = "show scratch pad",
    },
    {
      "<leader>ps",
      function()
        local scratchpad = require("scratchpad")
        scratchpad.ui:sync()
      end,
      mode = { "n", "v" },
      desc = "Push selection / current line to scratchpad",
    },
  },
}
