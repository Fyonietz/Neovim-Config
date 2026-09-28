-- ================================================================================================
-- plugins/treesitter.lua — treesitter parsers + highlighting + tag autoclose
-- ================================================================================================
-- nvim-treesitter's default branch is now `main`, a full incompatible rewrite: the
-- `nvim-treesitter.configs` module no longer exists, and highlighting/folding moved into
-- Neovim itself (`vim.treesitter.start()` / `vim.treesitter.foldexpr()`). This spec targets
-- that API, which requires Neovim 0.12+.
-- ================================================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- the `main` branch does not support lazy-loading
    build = ":TSUpdate",
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
      -- `ensure_installed` is gone; parsers are now installed explicitly. This runs
      -- asynchronously and is a no-op for parsers that are already present.
      require("nvim-treesitter").install({ "html", "css", "javascript", "astro", "vue", "typescript", "lua" })

      -- Highlighting is no longer a plugin option. Neovim enables it per buffer, and calling
      -- start() for a filetype with no parser installed throws — hence the pcall.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      require("nvim-ts-autotag").setup()
    end,
  },
}
