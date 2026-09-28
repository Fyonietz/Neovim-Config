-- ================================================================================================
-- plugins/barbar.lua — buffer/tab bar
-- ================================================================================================
-- All buffer keymaps live in lua/config/keymaps.lua.
-- ================================================================================================

return {
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.barbar_auto_setup = false
      vim.opt.showtabline = 2
    end,
    opts = {
      animation = true,
      auto_hide = false,
      tabpages = true,
      clickable = true,
      highlight_visible = true, -- was misspelled `higtlight_visible` before
      icons = {
        buffer_index = true,
        buffer_number = false,
        button = "󰅖",

        diagnostics = {
          [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "󰅚 " },
          [vim.diagnostic.severity.WARN]  = { enabled = true, icon = "󰀦 " },
          [vim.diagnostic.severity.INFO]  = { enabled = true, icon = "󰋼 " },
          [vim.diagnostic.severity.HINT]  = { enabled = true, icon = "󰌵 " },
        },

        gitsigns = {
          added = { enabled = true, icon = "+" },
          changed = { enabled = true, icon = "~" },
          deleted = { enabled = true, icon = "-" },
        },

        filetype = {
          enabled = true,
        },

        separator = {
          left = "▎",
          right = "",
        },
      },
    },
  },
}
