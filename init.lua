
-- init.lua — Suckless Neovim Config
-- author: Radley E. Sidwell-lewis
-- ================================================================================================
-- Layout:
--   lua/config/   core configuration (options, keymaps, autocmds, lsp, ui helpers)
--   lua/plugins/  one file per plugin / plugin group, imported by lazy.nvim
-- ================================================================================================

-- netrw is replaced by nvim-tree / rnvimr
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ------------------------------------------------------------------------------------------------
-- Core configuration (must run before plugins so options/leader keys are in place)
-- ------------------------------------------------------------------------------------------------
require("config.options")
require("config.autocmds")
require("config.keymaps")
require("config.statusline")
-- ------------------------------------------------------------------------------------------------
-- Plugins
-- ------------------------------------------------------------------------------------------------
require("config.lazy")

-- ------------------------------------------------------------------------------------------------
-- Configuration that depends on plugins being available
-- ------------------------------------------------------------------------------------------------
require("config.lsp")
require("config.highlights")
