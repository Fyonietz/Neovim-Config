local toggle_compile_win = function()
  local buf = vim.fn.bufnr("*compilation*")
  if buf == -1 then return end

  local wins = vim.fn.win_findbuf(buf)
  if #wins > 0 then
    vim.api.nvim_win_close(wins[1], false)
  else
    vim.cmd("botright split | resize 12 | buffer " .. buf)
  end
end

-- Default command comes from the first line of ./.compile
local function project_command()
  local f = io.open(vim.fn.getcwd() .. "/.compile", "r")
  if not f then return "" end
  local cmd = f:read("*l") or ""
  f:close()
  return cmd
end

return {
  "ej-shafran/compile-mode.nvim",
  branch = "latest",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    vim.g.compile_mode = {
      recompile_no_fail = true,
      ask_about_save = false,
      focus_compilation_buffer = false,
      auto_scroll = true,
      ask_to_interrupt = false,
      default_command = project_command,
    }

    vim.api.nvim_create_autocmd("BufWinEnter", {
      pattern = "*compilation*",
      callback = function(args)
        vim.cmd("wincmd J | resize 12")

        vim.keymap.set("n", "<C-/>", toggle_compile_win, { buffer = args.buf, desc = "Close compile window" })
        vim.keymap.set("n", "<C-_>", toggle_compile_win, { buffer = args.buf, desc = "Close compile window (fallback)" })
      end,
    })
  end,
  keys = {
    { "<leader>cc", "<cmd>Compile<cr>",          desc = "Compile" },
    { "<leader>cr", "<cmd>Recompile<cr>",        desc = "Recompile" },
    { "<leader>ck", "<cmd>CompileInterrupt<cr>", desc = "Kill compile" },
    { "<leader>cn", "<cmd>NextError<cr>",        desc = "Next error" },
    { "<leader>cp", "<cmd>PrevError<cr>",        desc = "Prev error" },

    { "<C-/>", toggle_compile_win, desc = "Toggle compile window" },
    { "<C-_>", toggle_compile_win, desc = "Toggle compile window (fallback)" },
  },
}
