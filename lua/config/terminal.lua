-- ================================================================================================
-- terminal.lua — floating terminal
-- ================================================================================================
-- Exposes M.toggle() / M.close(); the keymaps live in lua/config/keymaps.lua.
-- ================================================================================================

local M = {}

local state = {
  buf = nil,
  win = nil,
  is_open = false,
}

function M.close()
  if state.is_open and state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, false)
  end
  state.is_open = false
end

function M.toggle()
  -- Already open: toggle closed
  if state.is_open and state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close()
    return
  end

  -- Create the scratch buffer on first use
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then
    state.buf = vim.api.nvim_create_buf(false, true)
    vim.bo[state.buf].bufhidden = "hide"
  end

  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)

  state.win = vim.api.nvim_open_win(state.buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })

  vim.wo[state.win].winblend = 0
  vim.wo[state.win].winhighlight = "Normal:FloatingTermNormal,FloatBorder:FloatingTermBorder"
  vim.api.nvim_set_hl(0, "FloatingTermNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatingTermBorder", { bg = "none" })

  -- Only spawn a shell if the buffer is still empty
  local has_terminal = false
  for _, line in ipairs(vim.api.nvim_buf_get_lines(state.buf, 0, -1, false)) do
    if line ~= "" then
      has_terminal = true
      break
    end
  end

  if not has_terminal then
    vim.fn.termopen(os.getenv("SHELL"))
  end

  state.is_open = true
  vim.cmd("startinsert")

  -- Close the window when focus leaves the terminal buffer
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = state.buf,
    once = true,
    callback = M.close,
  })
end

return M
