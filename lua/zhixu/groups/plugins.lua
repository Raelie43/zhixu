local M = {}

M.names = {
  mini = true,
  telescope = true,
  fzf_lua = true,
  blink = true,
  cmp = true,
  oil = true,
  gitsigns = true,
  which_key = true,
  lazy = true,
  mason = true,
  notify = true,
  noice = true,
  snacks = true,
  trouble = true,
  nvim_tree = true,
  neo_tree = true,
  indent_blankline = true,
  bufferline = true,
  flash = true,
  dashboard = true,
  alpha = true,
  render_markdown = true,
}

function M.get(p, opts)
  if opts.integrations == false then
    return {}
  end
  local c, e, o = p.core, p.extensions, p.opaque_over_background
  local groups = {}
  local function add(name, definitions)
    if type(opts.integrations) == "table" and opts.integrations[name] == false then
      return
    end
    for group, definition in pairs(definitions) do
      groups[group] = definition
    end
  end

  if opts.integrations == true or opts.integrations.mini ~= false then
    add("mini", require("zhixu.groups.mini").get(p, opts))
  end
  add("telescope", {
    TelescopeNormal = { link = "NormalFloat" },
    TelescopePromptNormal = { link = "NormalFloat" },
    TelescopeResultsNormal = { link = "NormalFloat" },
    TelescopePreviewNormal = { link = "NormalFloat" },
    TelescopeBorder = { link = "FloatBorder" },
    TelescopePromptBorder = { link = "FloatBorder" },
    TelescopeResultsBorder = { link = "FloatBorder" },
    TelescopePreviewBorder = { link = "FloatBorder" },
    TelescopeTitle = { link = "FloatTitle" },
    TelescopePromptTitle = { link = "FloatTitle" },
    TelescopeResultsTitle = { link = "FloatTitle" },
    TelescopePreviewTitle = { link = "FloatTitle" },
    TelescopePromptPrefix = { fg = c.keyword },
    TelescopePromptCounter = { fg = c.ui_dim },
    TelescopeSelection = { bg = c.selection_background },
    TelescopeSelectionCaret = { fg = c.keyword, bg = c.selection_background },
    TelescopeMultiSelection = { fg = e.cyan },
    TelescopeMultiIcon = { fg = e.cyan },
    TelescopeMatching = { fg = c.keyword },
    TelescopePreviewLine = { link = "Visual" },
    TelescopePreviewMatch = { link = "Search" },
    TelescopeResultsClass = { link = "Type" },
    TelescopeResultsStruct = { link = "Type" },
    TelescopeResultsField = { link = "Identifier" },
    TelescopeResultsMethod = { link = "Function" },
    TelescopeResultsFunction = { link = "Function" },
    TelescopeResultsVariable = { link = "Identifier" },
    TelescopeResultsDiffAdd = { link = "Added" },
    TelescopeResultsDiffChange = { link = "Changed" },
    TelescopeResultsDiffDelete = { link = "Removed" },
    TelescopeResultsDiffUntracked = { link = "Added" },
  })
  add("fzf_lua", {
    FzfLuaNormal = { link = "NormalFloat" },
    FzfLuaBorder = { link = "FloatBorder" },
    FzfLuaTitle = { link = "FloatTitle" },
    FzfLuaTitleFlags = { fg = e.cyan },
    FzfLuaBackdrop = { bg = c.panel_background },
    FzfLuaHelpNormal = { link = "NormalFloat" },
    FzfLuaHelpBorder = { link = "FloatBorder" },
    FzfLuaPreviewNormal = { link = "NormalFloat" },
    FzfLuaPreviewBorder = { link = "FloatBorder" },
    FzfLuaPreviewTitle = { link = "FloatTitle" },
    FzfLuaCursor = { link = "Cursor" },
    FzfLuaCursorLine = { fg = c.foreground, bg = c.selection_background },
    FzfLuaCursorLineNr = { link = "CursorLineNr" },
    FzfLuaSearch = { link = "Search" },
    FzfLuaScrollBorderEmpty = { fg = e.border },
    FzfLuaScrollBorderFull = { fg = c.ui_dim },
    FzfLuaScrollFloatEmpty = { bg = c.panel_background },
    FzfLuaScrollFloatFull = { bg = o.scrollbar },
    FzfLuaHeaderBind = { fg = c.keyword },
    FzfLuaHeaderText = { fg = c.ui_dim },
    FzfLuaPathColNr = { fg = c.ui_dim },
    FzfLuaPathLineNr = { fg = c.number },
    FzfLuaBufName = { fg = c.ui_foreground },
    FzfLuaBufId = { fg = c.number },
    FzfLuaBufNr = { fg = c.number },
    FzfLuaBufLineNr = { fg = e.foreground_subtle },
    FzfLuaBufFlagCur = { fg = c.keyword },
    FzfLuaBufFlagAlt = { fg = e.cyan },
    FzfLuaTabTitle = { fg = c.keyword },
    FzfLuaTabMarker = { fg = c.keyword },
    FzfLuaDirIcon = { link = "Directory" },
    FzfLuaDirPart = { fg = c.ui_dim },
    FzfLuaFilePart = { fg = c.ui_foreground },
    FzfLuaLivePrompt = { fg = c.keyword },
    FzfLuaLiveSym = { fg = c.keyword },
    FzfLuaFzfNormal = { link = "NormalFloat" },
    FzfLuaFzfCursorLine = { fg = c.foreground, bg = c.selection_background },
    FzfLuaFzfMatch = { fg = c.keyword },
    FzfLuaFzfBorder = { link = "FloatBorder" },
    FzfLuaFzfScrollbar = { fg = c.ui_dim },
    FzfLuaFzfSeparator = { fg = e.border },
    FzfLuaFzfGutter = { link = "NormalFloat" },
    FzfLuaFzfHeader = { fg = c.ui_dim },
    FzfLuaFzfInfo = { fg = c.ui_dim },
    FzfLuaFzfPointer = { fg = c.keyword },
    FzfLuaFzfMarker = { fg = e.cyan },
    FzfLuaFzfSpinner = { fg = c.keyword },
    FzfLuaFzfPrompt = { fg = c.keyword },
    FzfLuaFzfQuery = { fg = c.ui_foreground },
  })
  add("blink", {
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },
    BlinkCmpScrollBarThumb = { link = "PmenuThumb" },
    BlinkCmpScrollBarGutter = { link = "PmenuSbar" },
    BlinkCmpLabel = { fg = c.ui_foreground },
    BlinkCmpLabelDeprecated = { fg = c.ui_dim, strikethrough = true },
    BlinkCmpLabelMatch = { fg = c.keyword },
    BlinkCmpLabelDetail = { fg = c.ui_dim },
    BlinkCmpLabelDescription = { fg = c.ui_dim },
    BlinkCmpKind = { fg = c.type },
    BlinkCmpSource = { fg = c.ui_dim },
    BlinkCmpGhostText = { fg = e.foreground_subtle },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpDocSeparator = { fg = e.border },
    BlinkCmpDocCursorLine = { link = "Visual" },
    BlinkCmpSignatureHelp = { link = "NormalFloat" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
    BlinkCmpSignatureHelpActiveParameter = { link = "LspSignatureActiveParameter" },
  })
  add("cmp", {
    CmpItemAbbr = { fg = c.ui_foreground },
    CmpItemAbbrDeprecated = { fg = c.ui_dim, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.keyword },
    CmpItemAbbrMatchFuzzy = { fg = c.keyword },
    CmpItemKind = { fg = c.type },
    CmpItemMenu = { fg = c.ui_dim },
    CmpGhostText = { fg = e.foreground_subtle },
  })
  local kinds = {
    Text = c.foreground,
    Method = e.function_call,
    Function = e.function_call,
    Constructor = c.type,
    Field = c.identifier,
    Variable = c.identifier,
    Class = c.type,
    Interface = c.type,
    Module = c.identifier,
    Property = c.identifier,
    Unit = c.number,
    Value = c.foreground,
    Enum = c.type,
    Keyword = c.keyword,
    Snippet = c.macro,
    Color = e.cyan,
    File = c.ui_foreground,
    Reference = e.cyan,
    Folder = c.type,
    EnumMember = c.identifier,
    Constant = c.identifier,
    Struct = c.type,
    Event = c.identifier,
    Operator = c.foreground,
    TypeParameter = c.type,
  }
  for kind, color in pairs(kinds) do
    add("blink", { ["BlinkCmpKind" .. kind] = { fg = color } })
    add("cmp", { ["CmpItemKind" .. kind] = { fg = color } })
  end
  local oil = {
    OilDir = { link = "Directory" },
    OilDirIcon = { link = "Directory" },
    OilFile = { fg = c.foreground },
    OilHidden = { fg = c.ui_dim },
    OilSocket = { fg = c.macro },
    OilLink = { fg = e.cyan },
    OilLinkTarget = { fg = c.ui_dim },
    OilOrphanLink = { fg = c.error },
    OilOrphanLinkTarget = { fg = c.error },
    OilEmpty = { fg = e.foreground_subtle },
    OilCreate = { link = "Added" },
    OilDelete = { link = "Removed" },
    OilMove = { fg = e.cyan },
    OilCopy = { fg = e.blue },
    OilChange = { link = "Changed" },
    OilRestore = { link = "Added" },
    OilPurge = { link = "Removed" },
    OilTrash = { link = "Removed" },
    OilTrashSourcePath = { fg = c.ui_dim },
  }
  for _, kind in ipairs({
    "Dir",
    "File",
    "Socket",
    "Link",
    "LinkTarget",
    "OrphanLink",
    "OrphanLinkTarget",
  }) do
    oil["Oil" .. kind .. "Hidden"] = { link = "Oil" .. kind }
  end
  add("oil", oil)

  local git = {}
  for suffix, target in pairs({
    Add = "Added",
    Change = "Changed",
    Delete = "Removed",
    Topdelete = "Removed",
    Changedelete = "Changed",
    Untracked = "Added",
  }) do
    git["GitSigns" .. suffix] = { link = target }
    git["GitSigns" .. suffix .. "Nr"] = { link = target }
    git["GitSigns" .. suffix .. "Ln"] = {
      link = target == "Removed" and "DiffDelete"
        or target == "Added" and "DiffAdd"
        or "DiffChange",
    }
    git["GitSigns" .. suffix .. "Cul"] = { link = target }
  end
  git.GitSignsCurrentLineBlame = { fg = c.comment }
  git.GitSignsAddInline = { link = "DiffAdd" }
  git.GitSignsDeleteInline = { link = "DiffDelete" }
  git.GitSignsChangeInline = { link = "DiffText" }
  git.GitSignsAddPreview = { link = "DiffAdd" }
  git.GitSignsDeletePreview = { link = "DiffDelete" }
  add("gitsigns", git)

  add("which_key", {
    WhichKey = { fg = c.keyword },
    WhichKeyGroup = { fg = c.type },
    WhichKeyDesc = { fg = c.ui_foreground },
    WhichKeySeparator = { fg = e.border },
    WhichKeyNormal = { link = "NormalFloat" },
    WhichKeyFloat = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyValue = { fg = c.ui_dim },
  })
  add("lazy", {
    LazyNormal = { link = "NormalFloat" },
    LazyButton = { link = "Pmenu" },
    LazyButtonActive = { link = "PmenuSel" },
    LazyH1 = { fg = c.background, bg = c.keyword },
    LazyH2 = { fg = c.secondary_heading },
    LazySpecial = { fg = c.macro },
    LazyProgressDone = { fg = c.success },
    LazyProgressTodo = { fg = e.border },
    LazyReasonPlugin = { fg = c.type },
    LazyReasonEvent = { fg = c.keyword },
    LazyReasonCmd = { fg = e.blue },
    LazyReasonKeys = { fg = c.string },
  })
  add("mason", {
    MasonNormal = { link = "NormalFloat" },
    MasonHeader = { fg = c.background, bg = c.keyword },
    MasonHeaderSecondary = { fg = c.background, bg = e.blue },
    MasonHighlight = { fg = e.blue },
    MasonHighlightBlock = { fg = c.background, bg = e.blue },
    MasonHighlightBlockBold = { fg = c.background, bg = e.blue },
    MasonHighlightSecondary = { fg = c.success },
    MasonHighlightBlockSecondary = { fg = c.background, bg = c.success },
    MasonMuted = { fg = c.ui_dim },
    MasonMutedBlock = { fg = c.ui_dim, bg = c.raised_background },
    MasonError = { fg = c.error },
  })
  local notify = { NotifyBackground = { bg = c.raised_background } }
  for severity, color in pairs({
    ERROR = c.error,
    WARN = c.keyword,
    INFO = e.blue,
    DEBUG = c.comment,
    TRACE = c.string,
  }) do
    notify["Notify" .. severity .. "Border"] = { fg = e.border }
    notify["Notify" .. severity .. "Icon"] = { fg = color }
    notify["Notify" .. severity .. "Title"] = { fg = color }
    notify["Notify" .. severity .. "Body"] = { link = "NormalFloat" }
  end
  add("notify", notify)
  add("noice", {
    NoiceCmdline = { link = "NormalFloat" },
    NoiceCmdlinePopup = { link = "NormalFloat" },
    NoiceCmdlinePopupBorder = { link = "FloatBorder" },
    NoiceCmdlineIcon = { fg = c.keyword },
    NoiceCmdlineIconSearch = { fg = c.keyword },
    NoiceCmdlinePopupBorderSearch = { fg = c.keyword },
    NoiceConfirm = { link = "NormalFloat" },
    NoiceConfirmBorder = { link = "FloatBorder" },
    NoiceMini = { link = "NormalFloat" },
    NoicePopup = { link = "NormalFloat" },
    NoicePopupBorder = { link = "FloatBorder" },
    NoiceFormatProgressDone = { fg = c.success },
    NoiceFormatProgressTodo = { fg = e.border },
    NoiceLspProgressTitle = { fg = c.keyword },
  })
  add("snacks", {
    SnacksNormal = { link = "NormalFloat" },
    SnacksWinBar = { link = "WinBar" },
    SnacksBackdrop = { bg = c.panel_background },
    SnacksPickerNormal = { link = "NormalFloat" },
    SnacksPickerBorder = { link = "FloatBorder" },
    SnacksPickerTitle = { link = "FloatTitle" },
    SnacksPickerMatch = { fg = c.keyword },
    SnacksPickerSelected = { fg = e.cyan },
    SnacksPickerDir = { fg = c.ui_dim },
    SnacksPickerFile = { fg = c.ui_foreground },
    SnacksPickerPrompt = { fg = c.keyword },
    SnacksPickerInput = { link = "NormalFloat" },
    SnacksPickerInputBorder = { link = "FloatBorder" },
    SnacksPickerListCursorLine = { link = "Visual" },
    SnacksPickerPreviewCursorLine = { link = "Visual" },
    SnacksPickerPreview = { link = "NormalFloat" },
    SnacksPickerPreviewBorder = { link = "FloatBorder" },
    SnacksPickerList = { link = "NormalFloat" },
    SnacksPickerListBorder = { link = "FloatBorder" },
    SnacksPickerGitStatusAdded = { link = "Added" },
    SnacksPickerGitStatusModified = { link = "Changed" },
    SnacksPickerGitStatusDeleted = { link = "Removed" },
    SnacksPickerGitStatusUntracked = { link = "Added" },
    SnacksPickerGitStatusIgnored = { fg = e.foreground_subtle },
    SnacksPickerGitStatusRenamed = { fg = e.cyan },
    SnacksPickerGitStatusCopied = { fg = e.blue },
    SnacksPickerDirectory = { link = "Directory" },
    SnacksPickerIconFunction = { link = "Function" },
    SnacksPickerIconMethod = { link = "Function" },
    SnacksIndent = { fg = o.indent_guide },
    SnacksIndentScope = { fg = o.active_pane_border },
    SnacksIndentChunk = { fg = o.active_pane_border },
    SnacksDashboardHeader = { fg = c.keyword },
    SnacksDashboardDesc = { fg = c.ui_foreground },
    SnacksDashboardIcon = { fg = c.type },
    SnacksDashboardKey = { fg = c.keyword },
    SnacksDashboardFooter = { fg = c.comment },
    SnacksNotifierHistory = { link = "NormalFloat" },
    SnacksNotifierMinimal = { link = "NormalFloat" },
  })
  for severity, colors in pairs({
    Info = { e.blue, c.raised_background },
    Warn = { c.keyword, c.notification_warning_background },
    Error = { c.error, c.notification_error_background },
    Debug = { c.comment, c.raised_background },
    Trace = { c.string, c.raised_background },
  }) do
    add("snacks", {
      ["SnacksNotifier" .. severity] = { fg = c.ui_foreground, bg = colors[2] },
      ["SnacksNotifierIcon" .. severity] = { fg = colors[1], bg = colors[2] },
      ["SnacksNotifierTitle" .. severity] = { fg = colors[1], bg = colors[2] },
      ["SnacksNotifierBorder" .. severity] = { fg = e.border, bg = colors[2] },
      ["SnacksNotifierFooter" .. severity] = { fg = c.ui_dim, bg = colors[2] },
    })
  end
  add("trouble", {
    TroubleNormal = { link = "NormalFloat" },
    TroubleNormalNC = { link = "NormalFloat" },
    TroubleText = { fg = c.ui_foreground },
    TroubleCount = { fg = c.number },
    TroubleIndent = { fg = e.border },
    TroubleLocation = { fg = c.ui_dim },
    TroubleCode = { fg = c.ui_dim },
    TroublePreview = { link = "Visual" },
    TroubleFileName = { fg = c.ui_foreground },
  })
  local panel = opts.transparent and "NONE" or c.panel_background
  local raised = opts.transparent and "NONE" or c.raised_background
  add("nvim_tree", {
    NvimTreeNormal = { fg = c.ui_foreground, bg = panel },
    NvimTreeNormalNC = { fg = c.ui_foreground, bg = panel },
    NvimTreeWinSeparator = { fg = e.border, bg = panel },
    NvimTreeRootFolder = { fg = c.keyword },
    NvimTreeFolderName = { fg = c.type },
    NvimTreeOpenedFolderName = { fg = c.type },
    NvimTreeEmptyFolderName = { fg = c.ui_dim },
    NvimTreeFolderIcon = { fg = c.type },
    NvimTreeIndentMarker = { fg = e.border },
    NvimTreeCursorLine = { link = "Visual" },
    NvimTreeGitDirty = { link = "Changed" },
    NvimTreeGitNew = { link = "Added" },
    NvimTreeGitDeleted = { link = "Removed" },
    NvimTreeGitIgnored = { fg = e.foreground_subtle },
    NvimTreeSymlink = { fg = e.cyan },
    NvimTreeSpecialFile = { fg = c.macro },
  })
  add("neo_tree", {
    NeoTreeNormal = { fg = c.ui_foreground, bg = panel },
    NeoTreeNormalNC = { fg = c.ui_foreground, bg = panel },
    NeoTreeWinSeparator = { fg = e.border, bg = panel },
    NeoTreeDirectoryName = { fg = c.type },
    NeoTreeDirectoryIcon = { fg = c.type },
    NeoTreeRootName = { fg = c.keyword },
    NeoTreeIndentMarker = { fg = e.border },
    NeoTreeExpander = { fg = c.ui_dim },
    NeoTreeGitAdded = { link = "Added" },
    NeoTreeGitModified = { link = "Changed" },
    NeoTreeGitDeleted = { link = "Removed" },
    NeoTreeGitUntracked = { link = "Added" },
    NeoTreeGitIgnored = { fg = e.foreground_subtle },
    NeoTreeGitConflict = { fg = c.error },
    NeoTreeFloatBorder = { link = "FloatBorder" },
    NeoTreeFloatTitle = { link = "FloatTitle" },
    NeoTreeCursorLine = { link = "Visual" },
    NeoTreeTitleBar = { fg = c.keyword, bg = raised },
  })
  add("indent_blankline", {
    IblIndent = { fg = o.indent_guide },
    IblWhitespace = { fg = o.indent_guide },
    IblScope = { fg = o.active_pane_border },
    IndentBlanklineChar = { fg = o.indent_guide },
    IndentBlanklineContextChar = { fg = o.active_pane_border },
  })
  add("bufferline", {
    BufferLineFill = { bg = panel },
    BufferLineBackground = { fg = c.ui_dim, bg = panel },
    BufferLineBufferSelected = {
      fg = c.keyword,
      bg = raised,
      underline = true,
      bold = false,
      italic = false,
    },
    BufferLineBufferVisible = { fg = c.ui_foreground, bg = panel },
    BufferLineTab = { fg = c.ui_dim, bg = panel },
    BufferLineTabSelected = { fg = c.keyword, bg = raised },
    BufferLineIndicatorSelected = { fg = c.keyword, bg = raised },
    BufferLineModified = { fg = c.modifier, bg = panel },
    BufferLineModifiedSelected = { fg = c.keyword, bg = raised },
    BufferLineSeparator = { fg = e.border, bg = panel },
    BufferLineSeparatorSelected = { fg = e.border, bg = raised },
  })
  add("flash", {
    FlashLabel = { fg = c.background, bg = c.keyword },
    FlashMatch = { bg = o.search_result_inactive },
    FlashCurrent = { bg = c.search_background },
    FlashBackdrop = { fg = e.foreground_subtle },
  })
  add("dashboard", {
    DashboardHeader = { fg = c.keyword },
    DashboardFooter = { fg = c.comment },
    DashboardCenter = { fg = c.ui_foreground },
    DashboardDesc = { fg = c.ui_foreground },
    DashboardIcon = { fg = c.type },
    DashboardKey = { fg = c.keyword },
    DashboardShortCut = { fg = e.blue },
  })
  add("alpha", {
    AlphaHeader = { fg = c.keyword },
    AlphaButtons = { fg = c.ui_foreground },
    AlphaShortcut = { fg = c.keyword },
    AlphaFooter = { fg = c.comment },
  })
  local markdown = {
    RenderMarkdownCode = { bg = c.panel_background },
    RenderMarkdownCodeInline = { fg = c.string, bg = c.raised_background },
    RenderMarkdownBullet = { fg = c.keyword },
    RenderMarkdownQuote = { fg = c.comment },
    RenderMarkdownLink = { link = "Underlined" },
    RenderMarkdownChecked = { fg = c.success },
    RenderMarkdownUnchecked = { fg = c.ui_dim },
    RenderMarkdownTableHead = { fg = c.keyword },
    RenderMarkdownTableRow = { fg = e.border },
  }
  for level = 1, 6 do
    markdown["RenderMarkdownH" .. level] = { fg = level == 1 and c.keyword or c.secondary_heading }
    markdown["RenderMarkdownH" .. level .. "Bg"] = { bg = c.raised_background }
  end
  add("render_markdown", markdown)
  return groups
end

return M
