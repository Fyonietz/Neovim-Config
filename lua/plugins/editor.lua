-- ================================================================================================
-- plugins/editor.lua — editing quality of life
-- ================================================================================================

return {
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({})
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  { "dhruvasagar/vim-table-mode" },
}
