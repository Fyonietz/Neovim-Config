-- ================================================================================================
-- keymaps.lua — global key mappings (single source of truth)
-- ================================================================================================
-- Every global (non-plugin-lazy) mapping lives here. Plugin specs under lua/plugins/ only keep
-- the `keys = {}` tables that lazy.nvim needs for lazy-loading (e.g. flash.nvim).
-- ================================================================================================

local map = vim.keymap.set

-- ------------------------------------------------------------------------------------------------
-- Search / navigation
-- ------------------------------------------------------------------------------------------------
map("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "n", "nzzzv", { desc = "Next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- ------------------------------------------------------------------------------------------------
-- Editing
-- ------------------------------------------------------------------------------------------------
map("n", "Y", "y$", { desc = "Yank to end of line" })
map("n", "J", "mzJ`z", { desc = "Join lines and keep cursor position" })
map("x", "<leader>p", '"_dP', { desc = "Paste without yanking" })
map({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete without yanking" })

-- Better indenting in visual mode
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ------------------------------------------------------------------------------------------------
-- Windows
-- ------------------------------------------------------------------------------------------------
-- Vertical navigation is mirrored from the default <C-w>h / <C-w>l; up/down use the native
-- <C-w>k / <C-w>j. <C-w> is intentionally left untouched so the whole built-in prefix still works.
map("n", "<A-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<A-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })

map("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- ------------------------------------------------------------------------------------------------
-- Insert mode movement (arrow-key equivalents)
-- ------------------------------------------------------------------------------------------------
map("i", "<C-h>", "<Left>", { desc = "Move left" })
map("i", "<C-j>", "<Down>", { desc = "Move down" })
map("i", "<C-k>", "<Up>", { desc = "Move up" })
map("i", "<C-l>", "<Right>", { desc = "Move right" })

-- ------------------------------------------------------------------------------------------------
-- Buffers (barbar.nvim)
-- ------------------------------------------------------------------------------------------------
map("n", "<C-h>", "<Cmd>BufferPrevious<CR>", { desc = "Previous buffer" })
map("n", "<C-l>", "<Cmd>BufferNext<CR>", { desc = "Next buffer" })
map("n", "<C-q>", "<Cmd>BufferClose<CR>", { desc = "Close buffer" })

map("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

map("n", "<leader>tn", "<Cmd>enew<CR>", { desc = "New buffer" })
map("n", "<leader>td", function()
  local current_file = vim.fn.expand("%:p")
  vim.cmd(current_file ~= "" and ("edit " .. current_file) or "enew")
end, { desc = "Duplicate buffer" })

map("n", "<leader>we", function()
  vim.ui.input({ prompt = "File to open: ", completion = "file" }, function(input)
    if input and input ~= "" then
      vim.cmd("edit " .. input)
    end
  end)
end, { desc = "Open file in buffer" })

map("n", "<leader>bd", function()
  if #vim.fn.getbufinfo({ buflisted = 1 }) > 1 then
    vim.cmd("BufferClose")
  else
    vim.cmd("q")
  end
end, { desc = "Smart close buffer" })

map("n", "<leader>bo", "<Cmd>BufferCloseAllButCurrent<CR>", { desc = "Close other buffers" })
map("n", "<leader>br", "<Cmd>BufferCloseBuffersRight<CR>", { desc = "Close buffers to the right" })
map("n", "<leader>bl", "<Cmd>BufferCloseBuffersLeft<CR>", { desc = "Close buffers to the left" })
map("n", "<leader>tp", "<Cmd>BufferPin<CR>", { desc = "Pin buffer" })
map("n", "<leader>t>", "<Cmd>BufferMoveNext<CR>", { desc = "Move buffer right" })
map("n", "<leader>t<", "<Cmd>BufferMovePrevious<CR>", { desc = "Move buffer left" })

for i = 1, 9 do
  map("n", "<leader>" .. i, "<Cmd>BufferGoto " .. i .. "<CR>", { desc = "Go to buffer " .. i })
end
map("n", "<leader>0", "<Cmd>BufferLast<CR>", { desc = "Go to last buffer" })

-- ------------------------------------------------------------------------------------------------
-- Files
-- ------------------------------------------------------------------------------------------------
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file tree", silent = true })
map("n", "<leader>ff", ":find ", { desc = "Find file" })
map("n", "<leader>r", "<cmd>RnvimrToggle<CR>", { desc = "Open file manager (ranger)", silent = true })

map("n", "<leader>pa", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("file:", path)
end, { desc = "Copy full file path (print)" })

map("n", "<leader>pf", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  print("Full path: " .. path)
end, { desc = "Copy full file path" })

map("n", "<leader>pr", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  print("Relative path: " .. path)
end, { desc = "Copy relative file path" })

map("n", "<leader>rr", function()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("New file name: ", old_name)
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd("saveas " .. new_name)
    vim.fn.delete(old_name)
    print("File renamed to: " .. new_name)
  end
end, { desc = "Rename current file" })

-- ------------------------------------------------------------------------------------------------
-- Config
-- ------------------------------------------------------------------------------------------------
map("n", "<leader>rc", ":e $MYVIMRC<CR>", { desc = "Edit config" })
map("n", "<leader>rl", ":so $MYVIMRC<CR>", { desc = "Reload config" })

-- ------------------------------------------------------------------------------------------------
-- Terminal
-- ------------------------------------------------------------------------------------------------
map("n", "<leader>t", function()
  require("config.terminal").toggle()
end, { desc = "Toggle floating terminal", silent = true })

map("t", "<Esc>", function()
  require("config.terminal").close()
end, { desc = "Close floating terminal", silent = true })

-- ------------------------------------------------------------------------------------------------
-- Sessions & zen mode
-- ------------------------------------------------------------------------------------------------
map("n", "<leader>ss", ":Sessions<CR>", { desc = "Pick session" })
map("n", "<leader><CR>", function()
  require("mini.sessions").select()
end, { desc = "Select session" })

map("n", "<leader>z", "<cmd>NoNeckPain<CR>", { desc = "Toggle zen mode" })


