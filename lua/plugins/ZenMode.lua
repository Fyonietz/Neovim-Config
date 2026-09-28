return {
  {
    "folke/zen-mode.nvim",
    lazy = false,
    opts = {
      plugins = {
        options = {
          enabled = true,
          showtabline = 2, -- Officially tells Zen Mode NOT to hide Barbar
        },
      },
    },
    config = function(_, opts)
      require("zen-mode").setup(opts)

      vim.api.nvim_create_autocmd("BufEnter", {
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local bt = vim.bo[args.buf].buftype

          -- Only trigger on real files. 
          -- Ignores dashboards (dashboard-nvim/alpha), package managers, and floating windows.
          if ft ~= "dashboard" and ft ~= "alpha" and ft ~= "lazy" and bt == "" then
            
            -- vim.schedule waits for Neovim to completely finish drawing the buffer 
            -- before triggering Zen Mode, preventing layout crashes.
            vim.schedule(function()
              require("zen-mode").open() -- Use open() instead of toggle() so it never accidentally turns off
            end)
            
            return true -- Destroys the autocmd so it strictly only fires once per session
          end
        end,
      })
    end,
  },
}
