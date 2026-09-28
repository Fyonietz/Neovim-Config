vim.keymap.set("n", "<leader>cc", function()
  vim.cmd("botright split | resize 12 | Compile")
end, { desc = "Compile" })

vim.keymap.set("n", "<leader>cr", "<cmd>Recompile<cr>",  { desc = "Recompile" })
vim.keymap.set("n", "<leader>cn", "<cmd>NextError<cr>",  { desc = "Next error" })
vim.keymap.set("n", "<leader>cp", "<cmd>PrevError<cr>",  { desc = "Prev error" })
