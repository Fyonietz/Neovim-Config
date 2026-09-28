-- ================================================================================================
-- plugins/nvim-tree.lua — file explorer
-- ================================================================================================

return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      view = {
        -- Enable the floating window
        float = {
          enable = true,
          quit_on_focus_loss = true, -- Auto-closes when you click away or open a file
          open_win_config = function()
            local screen_w = vim.opt.columns:get()
            local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
            
            -- Set size to 60% width and 80% height of your screen
            local window_w = math.floor(screen_w * 0.6)
            local window_h = math.floor(screen_h * 0.8)
            
            -- Center the window
            local center_x = math.floor((screen_w - window_w) / 2)
            local center_y = math.floor((screen_h - window_h) / 2)

            return {
              border = "rounded",
              relative = "editor",
              row = center_y,
              col = center_x,
              width = window_w,
              height = window_h,
            }
          end,
        },
      },
      filters = {
        git_ignored = false,
        dotfiles = false,
      },
    },
  },
}
