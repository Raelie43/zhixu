-- Run from the repo root: nvim --headless -u NONE -i NONE -l tests/run.lua
vim.opt.runtimepath:prepend(vim.fn.getcwd())

local function check_equal(actual, expected, message)
  assert(
    vim.deep_equal(actual, expected),
    message .. ": expected " .. vim.inspect(expected) .. ", got " .. vim.inspect(actual)
  )
end

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name, link = false })
end

local function hex(color)
  return tonumber(color:sub(2), 16)
end

local function run()
  local theme = require("zhixu")
  local markdown = table.concat(vim.fn.readfile("PALETTE.md"), "\n")
  local source = vim.json.decode(assert(markdown:match("```json%s*(.-)%s*```")))
  local palette = theme.get_palette()
  for _, section in ipairs({ "core", "extensions", "ansi", "opaque_over_background" }) do
    check_equal(palette[section], source[section], "canonical palette: " .. section)
  end
  palette.core.background = "#FFFFFF"
  check_equal(theme.get_palette().core.background, source.core.background, "palette is isolated")

  vim.cmd("syntax enable")
  vim.cmd("colorscheme zhixu")
  check_equal(vim.g.colors_name, "zhixu", "colorscheme entrypoint")
  check_equal(vim.o.background, "dark", "dark background")
  check_equal(vim.o.termguicolors, true, "true color")
  check_equal(hl("Normal").bg, hex(source.core.background), "editor background")
  local syntax = {
    Keyword = source.core.keyword,
    Type = source.core.type,
    String = source.core.string,
    Comment = source.core.comment,
    Number = source.core.number,
    Boolean = source.core.foreground,
    Operator = source.core.foreground,
    Identifier = source.core.identifier,
    ["@function"] = source.core.foreground,
    ["@function.method"] = source.core.foreground,
    ["@function.call"] = source.extensions.function_call,
    ["@function.method.call"] = source.extensions.function_call,
    ["@function.builtin"] = source.core.macro,
    ["@string.escape"] = source.core.string,
    ["@string.documentation"] = source.core.comment,
    ["@type.builtin"] = source.core.type,
    ["@variable.builtin"] = source.core.number,
    ["@lsp.type.function"] = source.extensions.function_call,
    ["@lsp.type.method"] = source.extensions.function_call,
    ["@lsp.type.enumMember"] = source.core.identifier,
    ["@lsp.typemod.function.defaultLibrary"] = source.core.macro,
    ["@lsp.typemod.method.defaultLibrary"] = source.core.macro,
    ["@lsp.typemod.variable.defaultLibrary"] = source.core.number,
  }
  for name, color in pairs(syntax) do
    local definition = hl(name)
    check_equal(definition.fg, hex(color), name .. " foreground")
    assert(not definition.bold and not definition.italic, name .. " must be regular by default")
  end
  for _, name in ipairs({
    "Visual",
    "Search",
    "MatchParen",
    "DiffAdd",
    "DiffDelete",
    "DiffChange",
    "DiffText",
    "LspReferenceText",
  }) do
    assert(hl(name).fg == nil, name .. " must preserve the syntax foreground")
  end
  check_equal(
    hl("DiffAdd").bg,
    hex(source.opaque_over_background.region_addition),
    "opaque diff overlay"
  )
  check_equal(
    hl("Search").bg,
    hex(source.opaque_over_background.search_result_inactive),
    "opaque search overlay"
  )
  check_equal(hl("DiagnosticUnderlineError").sp, hex(source.core.error), "diagnostic underline")
  assert(hl("DiagnosticUnderlineError").fg == nil, "diagnostics must preserve syntax colors")
  check_equal(
    hl("SnacksNotifierWarn").bg,
    hex(source.core.notification_warning_background),
    "notification fill"
  )

  local ansi = { "black", "red", "green", "yellow", "blue", "magenta", "cyan", "white" }
  for index, name in ipairs(ansi) do
    check_equal(
      vim.g["terminal_color_" .. (index - 1)],
      source.ansi.normal[name],
      "normal ANSI " .. name
    )
    check_equal(
      vim.g["terminal_color_" .. (index + 7)],
      source.ansi.bright[name],
      "bright ANSI " .. name
    )
  end

  local plugins = {
    mini = "MiniPickNormal",
    telescope = "TelescopeNormal",
    fzf_lua = "FzfLuaFzfNormal",
    blink = "BlinkCmpMenu",
    cmp = "CmpItemAbbr",
    oil = "OilDir",
    gitsigns = "GitSignsAdd",
    which_key = "WhichKey",
    lazy = "LazyNormal",
    mason = "MasonNormal",
    notify = "NotifyINFOBody",
    noice = "NoiceCmdline",
    snacks = "SnacksPickerNormal",
    trouble = "TroubleNormal",
    nvim_tree = "NvimTreeNormal",
    neo_tree = "NeoTreeNormal",
    indent_blankline = "IblIndent",
    bufferline = "BufferLineFill",
    flash = "FlashLabel",
    dashboard = "DashboardHeader",
    alpha = "AlphaHeader",
    render_markdown = "RenderMarkdownH1",
  }
  for name, group in pairs(plugins) do
    assert(next(hl(group)) ~= nil, name .. " highlight must exist")
  end

  -- Every theme link resolves without cycles or missing destinations.
  local groups = {}
  for _, module in ipairs({ "editor", "syntax", "plugins" }) do
    groups = vim.tbl_extend(
      "force",
      groups,
      require("zhixu.groups." .. module).get(theme.get_palette(), require("zhixu.config").options)
    )
  end
  for name, definition in pairs(groups) do
    local seen = { [name] = true }
    while definition.link do
      assert(not seen[definition.link], "highlight cycle at " .. name)
      seen[definition.link] = true
      definition = assert(groups[definition.link], "missing highlight target from " .. name)
    end
  end

  -- Plugins loaded after the theme must not replace its groups with defaults.
  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { default = true, link = "Error" })
  check_equal(hl("BlinkCmpMenu").bg, hex(source.core.raised_background), "late plugin load")

  theme.setup({ transparent = true })
  vim.cmd("colorscheme zhixu")
  for _, name in ipairs({
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "StatusLine",
    "TelescopeNormal",
    "BlinkCmpMenu",
    "MiniStatuslineDevinfo",
    "NvimTreeNormal",
    "NeoTreeNormal",
    "NeoTreeTitleBar",
    "BufferLineBufferSelected",
  }) do
    assert(hl(name).bg == nil, name .. " transparent background")
  end
  assert(hl("Visual").bg ~= nil, "transparent mode keeps selection visible")
  package.loaded["lualine.themes.zhixu"] = nil
  check_equal(require("lualine.themes.zhixu").normal.b.bg, "NONE", "transparent lualine")

  theme.setup({ integrations = { blink = false, mini = false } })
  vim.cmd("colorscheme zhixu")
  assert(next(hl("BlinkCmpMenu")) == nil, "disabled blink is cleared on reload")
  assert(next(hl("MiniPickNormal")) == nil, "disabled mini is cleared on reload")
  assert(next(hl("OilDir")) ~= nil, "unspecified integrations stay enabled")
  theme.setup({ integrations = false })
  vim.cmd("colorscheme zhixu")
  for _, group in pairs(plugins) do
    assert(next(hl(group)) == nil, group .. " disabled globally")
  end

  vim.g.terminal_color_0 = "#123456"
  theme.setup({
    terminal_colors = false,
    styles = { comments = { italic = true }, keywords = { bold = true } },
    on_colors = function(p)
      p.core.comment = "#AABBCC"
    end,
    on_highlights = function(h, p)
      h.FloatBorder = { fg = p.core.keyword }
      h.ZhixuCustom = { fg = p.core.type }
    end,
  })
  vim.cmd("colorscheme zhixu")
  check_equal(hl("Comment").fg, 0xAABBCC, "palette callback")
  check_equal(hl("Comment").italic, true, "comment style")
  check_equal(hl("Keyword").bold, true, "keyword style")
  check_equal(hl("FloatBorder").fg, hex(source.core.keyword), "highlight callback")
  check_equal(hl("ZhixuCustom").fg, hex(source.core.type), "custom highlight")
  check_equal(vim.g.terminal_color_0, "#123456", "terminal opt-out")
  for key, reference in pairs(theme.fzf_colors()) do
    assert(hl(reference[2])[reference[1]] ~= nil, "fzf.vim color reference " .. key)
  end

  vim.cmd("colorscheme default")
  theme.setup()
  vim.cmd("colorscheme zhixu")
  check_equal(hl("Comment").fg, hex(source.core.comment), "reset after switching themes")
  assert(not hl("Comment").italic and not hl("Keyword").bold, "styles reset")
  check_equal(
    theme.get_palette().core.comment,
    source.core.comment,
    "callback did not mutate the canonical palette"
  )
  package.loaded["lualine.themes.zhixu"] = nil
  check_equal(require("lualine.themes.zhixu").normal.a.bg, source.core.keyword, "lualine theme")

  for _, opts in ipairs({
    { transparent = "yes" },
    { integrations = { typo = true } },
    { styles = { typo = {} } },
    { on_colors = true },
  }) do
    assert(not pcall(theme.setup, opts), "invalid configuration must fail")
  end
  check_equal(vim.g.colors_name, "zhixu", "failed setup leaves the current theme intact")
  print("Zhixu: palette, syntax, plugin, configuration, and reload checks passed")
end

local ok, err = xpcall(run, debug.traceback)
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
