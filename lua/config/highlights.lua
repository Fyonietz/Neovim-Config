-- ================================================================================================
-- highlights.lua — theme-dependent highlight overrides
-- ================================================================================================
-- Applied once at startup and re-applied on every ColorScheme event. This used to live inline in
-- init.lua.
-- ================================================================================================

local function apply()
  local hl = vim.api.nvim_set_hl

  -- Transparency
  hl(0, "Normal",       { bg = "none" })
  hl(0, "NormalNC",     { bg = "none" })
  hl(0, "EndOfBuffer",  { bg = "none" })
  hl(0, "NormalFloat",  { bg = "none" })
  hl(0, "FloatBorder",  { bg = "none" })
  hl(0, "SignColumn",   { bg = "none" })
  hl(0, "StatusLine",   { bg = "none" })
  hl(0, "StatusLineNC", { bg = "none" })
  hl(0, "TabLine",      { bg = "none" })
  hl(0, "TabLineFill",  { bg = "none", fg = "#767676" })
  hl(0, "TabLineSel",   { bg = "none" })
  hl(0, "ColorColumn",  { bg = "none" })
  hl(0, "Pmenu",        { bg = "none" })
  hl(0, "PmenuSel",     { bg = "#3e4451" })
  hl(0, "CursorLine",   { bg = "none" })
  hl(0, "LineNr",       { bg = "none" })
  hl(0, "CursorLineNr", { bg = "none" })
  hl(0, "NvimTreeNormal",   { bg = "none" })
  hl(0, "NvimTreeNormalNC", { bg = "none" })
  hl(0, "TelescopeNormal",  { bg = "none" })
  hl(0, "TelescopeBorder",  { bg = "none" })
end

apply()

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = apply,
})
