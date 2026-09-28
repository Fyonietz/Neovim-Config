return {
  {
    "nvim-mini/mini.sessions",
    version = "*",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      local MiniSessions = require("mini.sessions")

      MiniSessions.setup({
        autoread = false,
        autowrite = true,
        directory = vim.fn.stdpath("data") .. "/session",
        file = "MySession.vim",
        hooks = {
          pre = {
            write = function()
                pcall(vim.cmd, "NvimTreeClose")
              vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
            end,
          },
        },
      })

      -- `:Sessions` — telescope picker over the session directory
      vim.api.nvim_create_user_command("Sessions", function()
        local dir = MiniSessions.config.directory
        local sessions = {}
        for _, file in ipairs(vim.fn.readdir(dir)) do
          if vim.fn.isdirectory(dir .. "/" .. file) == 0 then
            sessions[#sessions + 1] = file
          end
        end

        require("telescope.pickers").new({}, {
          prompt_title = "Sessions",
          finder = require("telescope.finders").new_table({ results = sessions }),
          sorter = require("telescope.config").values.generic_sorter({}),
          attach_mappings = function(prompt_bufnr)
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
              local selection = action_state.get_selected_entry()
              if selection then
                MiniSessions.read(selection[1])
              end
            end)

            return true
          end,
        }):find()
      end, { desc = "Pick a session" })

      -- The function that triggers the empty UI prompt
      local save_session_ui = function()
        vim.ui.input({ 
          prompt = "Save session as: ", 
          -- default parameter removed so it starts empty
        }, function(input)
          if input and input ~= "" then
            MiniSessions.write(input)
            vim.notify("Session saved as: " .. input, vim.log.levels.INFO)
          end
        end)
      end

      -- Create the user command (optional, but good for command line usage)
      vim.api.nvim_create_user_command("SessionWrite", save_session_ui, { desc = "Write a session with UI prompt" })

      -- Map CTRL+S in Normal mode to trigger the UI prompt
      vim.keymap.set("n", "<C-s>", save_session_ui, { desc = "Save session" })

    end,
  },
}
