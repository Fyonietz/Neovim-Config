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

  -- Distraction free editing (<leader>z / :NoNeckPain toggle it, see config/keymaps.lua).
  --
  -- NoNeckPain silently skips the side buffers when its `width` is >= the current
  -- terminal width (and again when the remaining side padding is below
  -- `minSideBufferWidth`), which made the toggle look like a no-op on a terminal
  -- narrower than width + 2 * minSideBufferWidth. Derive the width from the
  -- terminal instead of hard-coding it, and follow terminal resizes so toggling a
  -- resized Neovim keeps working.
  {
    "shortcuts/no-neck-pain.nvim",
    config = function(_, opts)
      local function centered_width()
        -- ~70% of the terminal, clamped so narrow terminals still get side buffers.
        return math.min(120, math.max(50, math.floor(vim.o.columns * 0.7)))
      end

      opts.width = centered_width()
      opts.minSideBufferWidth = 5

      require("no-neck-pain").setup(opts)

      vim.api.nvim_create_autocmd("VimResized", {
        group = vim.api.nvim_create_augroup("NoNeckPainCenteredWidth", { clear = true }),
        callback = function()
          local width = centered_width()
          if width == _G.NoNeckPain.config.width then
            return
          end

          if _G.NoNeckPain.state ~= nil and _G.NoNeckPain.state.enabled then
            -- also updates the config, then re-centers the open side buffers
            require("no-neck-pain").resize(width)
          else
            -- plugin is off: only store it, the next enable uses it
            _G.NoNeckPain.config.width = width
          end
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
