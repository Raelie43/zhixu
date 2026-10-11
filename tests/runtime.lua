-- Run from the repo root: nvim --headless -u NONE -i NONE -l tests/runtime.lua
-- An optional argument points at an extracted release archive instead.
local root = vim.fn.getcwd()
local fixture = vim.fn.tempname()
local uv = vim.uv or vim.loop
local saved = {}

local function block(owner, key)
  saved[#saved + 1] = { owner, key, owner[key] }
  owner[key] = function()
    error("theme runtime must not call " .. key)
  end
end

local function restore()
  for _, entry in ipairs(saved) do
    entry[1][entry[2]] = entry[3]
  end
end

local function run()
  local package_root = fixture .. "/pack/zhixu/opt/zhixu"
  vim.fn.mkdir(package_root, "p")
  local source = arg[1] or root
  for _, directory in ipairs({ "colors", "lua", "doc" }) do
    for _, file in ipairs(vim.fn.globpath(source, directory .. "/**/*", false, true)) do
      if vim.fn.filereadable(file) == 1 and not file:match("[/\\]tags$") then
        local relative = file:sub(#source + 2)
        local destination = package_root .. "/" .. relative
        vim.fn.mkdir(vim.fn.fnamemodify(destination, ":h"), "p")
        vim.fn.writefile(vim.fn.readfile(file, "b"), destination, "b")
      end
    end
  end
  assert(vim.fn.filereadable(package_root .. "/colors/zhixu.lua") == 1, "colorscheme packaged")
  assert(vim.fn.filereadable(package_root .. "/PALETTE.md") == 0, "no palette document installed")
  assert(vim.fn.isdirectory(package_root .. "/scripts") == 0, "no generator installed")
  assert(vim.fn.isdirectory(package_root .. "/plugin") == 0, "no automatic startup code")
  vim.opt.packpath:prepend(fixture)
  vim.cmd("packadd zhixu")
  assert(package.loaded.zhixu == nil, "adding package must not load the theme")

  vim.cmd("syntax enable")
  local hooks = vim.api.nvim_get_autocmds({})
  local timers = vim.fn.timer_info()
  block(vim.fn, "readfile")
  block(vim.fn, "json_decode")
  block(vim.fn, "system")
  block(vim.fn, "systemlist")
  block(vim.fn, "jobstart")
  block(vim.fn, "timer_start")
  block(vim.json, "decode")
  block(io, "open")
  block(vim.api, "nvim_create_autocmd")
  block(vim.api, "nvim_create_user_command")
  block(vim, "schedule")
  block(vim, "defer_fn")
  block(vim, "system")
  block(uv, "new_timer")
  block(uv, "spawn")

  local started = uv.hrtime()
  vim.cmd("colorscheme zhixu")
  local cold = (uv.hrtime() - started) / 1e6
  assert(vim.g.colors_name == "zhixu", "native package entrypoint")
  assert(vim.api.nvim_get_hl(0, { name = "Normal" }).bg == 0x101112, "baked-in background")
  assert(vim.deep_equal(vim.api.nvim_get_autocmds({}), hooks), "no added autocommands")
  assert(vim.deep_equal(vim.fn.timer_info(), timers), "no added timers")

  local samples = {}
  for _ = 1, 100 do
    started = uv.hrtime()
    vim.cmd("colorscheme zhixu")
    samples[#samples + 1] = (uv.hrtime() - started) / 1e6
  end
  table.sort(samples)
  print(
    ("Zhixu native package: cold %.2f ms; reload median %.2f ms, p95 %.2f ms; no document parsing or background work"):format(
      cold,
      samples[50],
      samples[95]
    )
  )
end

local ok, err = xpcall(run, debug.traceback)
restore()
-- Only delete the exact temporary directory created for this run.
assert(vim.fn.fnamemodify(fixture, ":p") ~= vim.fn.fnamemodify(root, ":p"))
vim.fn.delete(fixture, "rf")
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
