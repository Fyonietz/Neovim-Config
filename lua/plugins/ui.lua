-- ================================================================================================
-- plugins/ui.lua — motion, animation and window UI
-- ================================================================================================

return {
  -- Jump anywhere with a two-character label
{
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      -- OFFICIAL Flash text/word selection
      {
        "S",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            pattern = ".",
            search = {
              mode = function(pattern)
                if pattern:sub(1, 1) == "." then
                  pattern = pattern:sub(2)
                end
                -- Matches subwords (CamelCase/snake_case) or standard words cleanly
                return ([[<M\w*>]]):format(pattern), ([[<M]]):format(pattern)
              end,
            },
            jump = { pos = "range" },
          })
        end,
        desc = "Flash Select Subword/Word",
      },
    },
  },

  -- Smooth cursor/scroll animation
  {
    "echasnovski/mini.animate",
    config = function()
      local animate = require("mini.animate")
      animate.setup({
        cursor = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
        },
        scroll = {
          enable = true,
          timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
        },
      })
    end,
  },

  -- Smear cursor
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      -- Insert-mode cursor is a vertical bar and should stay crisp while typing
      vertical_bar_cursor_insert_mode = true,
      smear_insert_mode = false,
      vertical_bar_cursor = false,
    },
  },

  -- Distraction free editing
  {
    "shortcuts/no-neck-pain.nvim",
    opts = { width = 120 },
    config = function(_, opts)
      require("no-neck-pain").setup(opts)
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("no-neck-pain").enable()
        end,
      })
    end,
  },


  -- Discord rich presence
  { "vyfor/cord.nvim" },

  -- Ranger file manager
  {
    "kevinhwang91/rnvimr",
    config = function()
      vim.g.rnvimr_enable_ex = 1      -- replace netrw
      vim.g.rnvimr_enable_picker = 1  -- open file in current window
    end,
  },
}
