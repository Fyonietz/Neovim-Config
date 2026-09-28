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
  -- Alternative theme, kept around for quick switching (`:colorscheme github_dark` etc.).
  {
    "projekt0n/github-nvim-theme",
    lazy = true,
    priority = 1000,
  },
}
