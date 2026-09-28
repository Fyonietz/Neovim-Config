-- return {
--   {
--     "chrisgrieser/nvim-spider",
--     lazy = true,
--       -- Overrides default w, e, and b to stop at CamelCase/snake_case boundaries
--       keys = {
--       { "w", "<cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" } },
--       { "e", "<cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" } },
--       { "b", "<cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" } },
--     },
--   },
-- }
return {

{
  "chaoren/vim-wordmotion",
  event = "VeryLazy",
  init = function()
    vim.opt.selection = "inclusive"
  end,
}
}
