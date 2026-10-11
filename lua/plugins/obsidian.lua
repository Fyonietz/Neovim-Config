return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local file = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.root(file ~= "" and file or vim.uv.cwd(), { ".git" })
        or vim.uv.cwd()
        vim.filetype.add({ extension = { canvas = "json" } })

      require("obsidian").setup({
        legacy_commands = false,
        workspaces = {
          { name = vim.fs.basename(root), path = root .. "/vault" },
        },
        completion = { nvim_cmp = true, min_chars = 2 },
        daily_notes = { folder = "daily" },
      })
    end,
  },
}
