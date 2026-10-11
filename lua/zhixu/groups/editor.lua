local M = {}

function M.get(p, opts)
  local c, e, o = p.core, p.extensions, p.opaque_over_background
  local bg = opts.transparent and "NONE" or c.background
  local panel = opts.transparent and "NONE" or c.panel_background
  local raised = opts.transparent and "NONE" or c.raised_background
  local groups = {
    Normal = { fg = c.foreground, bg = bg },
    NormalNC = { fg = c.foreground, bg = bg },
    NormalFloat = { fg = c.ui_foreground, bg = raised },
    FloatBorder = { fg = e.border, bg = raised },
    FloatTitle = { fg = c.keyword, bg = raised },
    FloatFooter = { fg = c.ui_dim, bg = raised },
    ColorColumn = { bg = o.ruler },
    Conceal = { fg = c.comment },
    Cursor = { fg = c.cursor_text, bg = c.cursor },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { link = "Cursor" },
    TermCursorNC = { bg = o.cursor_inactive },
    CursorLine = { bg = c.current_line_background },
    CursorColumn = { link = "CursorLine" },
    CursorLineNr = { fg = c.keyword },
    CursorLineSign = { bg = c.current_line_background },
    CursorLineFold = { fg = e.foreground_subtle, bg = c.current_line_background },
    LineNr = { fg = e.foreground_subtle },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { bg = bg },
    FoldColumn = { fg = e.foreground_subtle, bg = bg },
    Folded = { fg = e.foreground_subtle, bg = panel },
    EndOfBuffer = { fg = e.border },
    NonText = { fg = e.foreground_subtle },
    Whitespace = { fg = e.border },
    SpecialKey = { fg = e.foreground_subtle },
    WinSeparator = { fg = e.border },
    VertSplit = { link = "WinSeparator" },
    WinBar = { fg = c.ui_foreground, bg = bg },
    WinBarNC = { fg = c.ui_dim, bg = bg },
    StatusLine = { fg = c.ui_foreground, bg = raised },
    StatusLineNC = { fg = c.ui_dim, bg = panel },
    StatusLineTerm = { link = "StatusLine" },
    StatusLineTermNC = { link = "StatusLineNC" },
    TabLine = { fg = c.ui_dim, bg = panel },
    TabLineFill = { bg = panel },
    TabLineSel = { fg = c.keyword, bg = raised, underline = true },
    Title = { fg = c.keyword },
    Directory = { fg = c.type },
    Visual = { bg = c.selection_background },
    VisualNOS = { bg = o.selection_inactive },
    Search = { bg = o.search_result_inactive },
    IncSearch = { bg = c.search_background },
    CurSearch = { link = "IncSearch" },
    Substitute = { bg = c.search_background },
    MatchParen = { bg = o.bracket_highlight },
    Pmenu = { fg = c.ui_foreground, bg = raised },
    PmenuSel = { fg = c.foreground, bg = c.selection_background },
    PmenuKind = { fg = c.type, bg = raised },
    PmenuKindSel = { fg = c.type, bg = c.selection_background },
    PmenuExtra = { fg = c.ui_dim, bg = raised },
    PmenuExtraSel = { fg = c.ui_dim, bg = c.selection_background },
    PmenuSbar = { bg = panel },
    PmenuThumb = { bg = o.scrollbar },
    PmenuMatch = { fg = c.keyword },
    PmenuMatchSel = { fg = c.keyword, bg = c.selection_background },
    PmenuBorder = { link = "FloatBorder" },
    PmenuShadow = { bg = o.shadow_dark },
    PmenuShadowThrough = { bg = o.shadow_dark },
    ComplMatchIns = { link = "PmenuMatch" },
    WildMenu = { link = "PmenuSel" },
    Question = { fg = c.type },
    MoreMsg = { fg = c.type },
    ModeMsg = { fg = c.ui_foreground },
    MsgArea = { fg = c.ui_foreground, bg = bg },
    MsgSeparator = { fg = e.border, bg = panel },
    ErrorMsg = { fg = c.error },
    WarningMsg = { fg = c.keyword },
    Error = { fg = c.error },
    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.keyword, undercurl = true },
    SpellLocal = { sp = e.cyan, undercurl = true },
    SpellRare = { sp = e.blue, undercurl = true },
    DiffAdd = { bg = o.region_addition },
    DiffDelete = { bg = o.region_deletion },
    DiffChange = { bg = e.diff_change_background },
    DiffText = { bg = e.diff_text_background },
    Added = { fg = c.success },
    Removed = { fg = c.error },
    Changed = { fg = e.blue },
    QuickFixLine = { bg = c.selection_background },
    qfLineNr = { link = "LineNr" },
    qfFileName = { link = "Directory" },
    LspReferenceText = { bg = o.selection_highlight },
    LspReferenceRead = { link = "LspReferenceText" },
    LspReferenceWrite = { link = "LspReferenceText" },
    LspReferenceTarget = { link = "LspReferenceText" },
    LspInlayHint = { fg = e.foreground_subtle },
    LspCodeLens = { fg = e.foreground_subtle },
    LspCodeLensSeparator = { fg = e.foreground_subtle },
    LspSignatureActiveParameter = { bg = c.selection_background },
    SnippetTabstop = { bg = o.selection_highlight },
  }

  local diagnostics = {
    Error = { c.error, c.error_background },
    Warn = { c.keyword, c.warning_background },
    Info = { e.blue, e.info_background },
    Hint = { e.cyan, e.hint_background },
    Ok = { c.success, c.success_background },
  }
  for severity, colors in pairs(diagnostics) do
    groups["Diagnostic" .. severity] = { fg = colors[1] }
    groups["DiagnosticSign" .. severity] = { fg = colors[1] }
    groups["DiagnosticFloating" .. severity] = { fg = colors[1], bg = raised }
    groups["DiagnosticVirtualText" .. severity] = { fg = colors[1], bg = colors[2] }
    groups["DiagnosticVirtualLines" .. severity] = { fg = colors[1] }
    groups["DiagnosticUnderline" .. severity] = { sp = colors[1], undercurl = true }
  end
  groups.DiagnosticDeprecated = { sp = c.ui_dim, strikethrough = true }
  groups.DiagnosticUnnecessary = { sp = e.foreground_subtle, underdotted = true }
  return groups
end

return M
