return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.opt_local.conceallevel = 2
        end,
      })
    end,
    config = function()
      vim.filetype.add({ extension = { canvas = "json" } })

      local file = vim.api.nvim_buf_get_name(0)
      local root = vim.fs.root(file ~= "" and file or vim.uv.cwd(), { ".git" })
        or vim.uv.cwd()

      require("obsidian").setup({
        legacy_commands = false,
        workspaces = {
          { name = vim.fs.basename(root), path = root .. "/vault" },
        },
        daily_notes = { folder = "daily" },
      })
    end,
  },
}
