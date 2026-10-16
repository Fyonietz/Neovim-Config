---@diagnostic disable: undefined-global
local M = {}

local pid = vim.fn.getpid()
local sock = "unix:/tmp/nvim-compile-" .. pid
local log = "/tmp/nvim-compile-" .. pid .. ".log"
local last_cmd = nil

-- gcc/clang/zig use nvim's defaults plus this; dotnet needs its own pattern
local efm = table.concat({
  "%f(%l\\,%c): %trror %m",
  "%f(%l\\,%c): %tarning %m",
  "%f:%l:%c: %t%*[^:]: %m",
  "%f:%l:%c: %m",
  "%f:%l: %m",
}, ",")

local function ctl(args)
  local cmd = { "kitty", "@", "--to", sock }
  vim.list_extend(cmd, args)
  return vim.system(cmd, { text = true }):wait()
end

function M.alive()
  return ctl({ "ls" }).code == 0
end

function M.open()
  if M.alive() then return true end
  vim.system({
    "kitty", "--detach",
    "--class", "nvim-compile",
    "--title", "compile",
    "--directory", vim.fn.getcwd(),
    "-o", "allow_remote_control=socket-only",
    "--listen-on", sock,
  })
  local ok = vim.wait(3000, M.alive, 50)
  if ok then
    vim.defer_fn(function()
      vim.system({ "niri", "msg", "action", "consume-window-into-column" }):wait()

      local out = vim.system({ "niri", "msg", "--json", "windows" }, { text = true }):wait().stdout
      local ok_json, wins = pcall(vim.json.decode, out or "[]")
      if not ok_json then return end
      for _, w in ipairs(wins) do
        if w.app_id == "nvim-compile" then
          vim.system({
            "niri", "msg", "action", "set-window-height",
            "--id", tostring(w.id), "30%",
          })
          break
        end
      end
    end, 150)
  end
  return ok
end

function M.run(cmd)
  if not M.open() then
    vim.notify("kitty did not start", vim.log.levels.ERROR)
    return
  end
  last_cmd = cmd
  -- sh -c keeps this working in bash, zsh and fish; tee writes the log
  local line = "sh -c " .. vim.fn.shellescape(cmd) .. " 2>&1 | tee " .. log
  ctl({ "send-text", "\3\r" .. line .. "\r" })
end

function M.kill()
  if M.alive() then ctl({ "send-text", "\3" }) end
end

function M.close()
  if M.alive() then ctl({ "close-window", "--match", "all" }) end
  os.remove(log)
end

-- Read the log into quickfix and jump to the first error
function M.errors()
  if vim.fn.filereadable(log) == 0 then
    vim.notify("No compile log yet", vim.log.levels.WARN)
    return
  end
  vim.fn.setqflist({}, " ", {
    title = "compile",
    lines = vim.fn.readfile(log),
    efm = efm,
  })
  if #vim.fn.getqflist() == 0 then
    vim.notify("No errors found")
    return
  end
  vim.cmd("cfirst")
end

function M.next_error()
  pcall(vim.cmd, "cnext")
end

function M.prev_error()
  pcall(vim.cmd, "cprev")
end

-- First line of ./.compile, or ""
local function project_command()
  local f = io.open(vim.fn.getcwd() .. "/.compile", "r")
  if not f then return "" end
  local cmd = f:read("*l") or ""
  f:close()
  return cmd
end

function M.compile()
  local default = project_command()
  if default == "" then default = last_cmd or "" end
  vim.ui.input({ prompt = "Compile: ", default = default }, function(input)
    if input and input ~= "" then M.run(input) end
  end)
end

function M.recompile()
  if last_cmd then M.run(last_cmd) else M.compile() end
end

function M.setup()
  vim.keymap.set("n", "<F4>", M.compile,    { desc = "Compile (kitty)" })
  vim.keymap.set("n", "<F5>", M.recompile,  { desc = "Recompile (kitty)" })
  vim.keymap.set("n", "<F6>", M.kill,       { desc = "Kill compile (kitty)" })
  vim.keymap.set("n", "<F7>", M.errors,     { desc = "Load compile errors" })
  vim.keymap.set("n", "<F8>", M.next_error, { desc = "Next compile error" })
  vim.keymap.set("n", "<F9>", M.prev_error, { desc = "Prev compile error" })

  vim.api.nvim_create_autocmd("VimLeavePre", { callback = M.close })
end

return M
