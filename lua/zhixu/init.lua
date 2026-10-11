local M = {}

---Configure the next :colorscheme zhixu load. Each call starts from defaults.
---@param opts? table
function M.setup(opts)
  require("zhixu.config").setup(opts)
end

---Return a fresh palette, including the configured on_colors callback.
---@return table
function M.get_palette()
  local palette = vim.deepcopy(require("zhixu.palette"))
  local callback = require("zhixu.config").options.on_colors
  if callback then
    callback(palette)
  end
  return palette
end

---Highlight references for fzf.vim's g:fzf_colors.
---@return table
function M.fzf_colors()
  return {
    fg = { "fg", "NormalFloat" },
    bg = { "bg", "NormalFloat" },
    hl = { "fg", "Keyword" },
    ["fg+"] = { "fg", "PmenuSel" },
    ["bg+"] = { "bg", "PmenuSel" },
    ["hl+"] = { "fg", "Keyword" },
    info = { "fg", "Comment" },
    border = { "fg", "FloatBorder" },
    prompt = { "fg", "Keyword" },
    pointer = { "fg", "Keyword" },
    marker = { "fg", "DiagnosticHint" },
    spinner = { "fg", "Keyword" },
    header = { "fg", "Comment" },
  }
end

function M.load()
  assert(vim.fn.has("nvim-0.10") == 1, "zhixu requires Neovim 0.10 or newer")
  local opts = require("zhixu.config").options
  local palette = M.get_palette()
  local groups = {}
  for _, module in ipairs({ "editor", "syntax", "plugins" }) do
    for name, definition in pairs(require("zhixu.groups." .. module).get(palette, opts)) do
      groups[name] = definition
    end
  end
  if opts.on_highlights then
    opts.on_highlights(groups, palette)
  end

  if not vim.o.termguicolors then
    vim.o.termguicolors = true
  end
  if vim.o.background ~= "dark" then
    vim.o.background = "dark"
  end
  -- Neovim's highlight clear restores defaults, including syntax highlights.
  vim.cmd("highlight clear")
  vim.g.colors_name = "zhixu"
  for name, definition in pairs(groups) do
    vim.api.nvim_set_hl(0, name, definition)
  end

  if opts.terminal_colors then
    local names = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
    for index, name in ipairs(names) do
      vim.g["terminal_color_" .. (index - 1)] = palette.ansi.normal[name]
      vim.g["terminal_color_" .. (index + 7)] = palette.ansi.bright[name]
    end
  end
end

return M
