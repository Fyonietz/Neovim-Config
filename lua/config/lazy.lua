-- ================================================================================================
-- lazy.lua — lazy.nvim setup
-- ================================================================================================
-- All plugin specs live under lua/plugins/*.lua and are imported automatically.
-- ================================================================================================

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  install = { colorscheme = { "onedark" } },
  checker = { enabled = false },
})
