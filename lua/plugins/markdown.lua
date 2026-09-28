-- ================================================================================================
-- plugins/markdown.lua — markdown preview
-- ================================================================================================

return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
  },
}
