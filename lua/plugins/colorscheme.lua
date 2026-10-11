-- ================================================================================================
-- plugins/colorscheme.lua — theme
-- ================================================================================================

return {
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- load before everything else
    -- config = function()
    --   vim.cmd.colorscheme("onedark")
    -- end,
  },
  {
      "sainnhe/sonokai",
      priority = 1000, -- load before everything else

  },
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    priority = 1000,
  },
    {
      'uloco/bluloco.nvim',
      lazy = false,
      priority = 1000,
      dependencies = { 'rktjmp/lush.nvim' },
      opts = {},
    },
    {
      'rmehri01/onenord.nvim',
      lazy = false,
      priority = 1000,
    }
}
