local p = require("zhixu").get_palette()
local c, e = p.core, p.extensions
local transparent = require("zhixu.config").options.transparent
local panel = transparent and "NONE" or c.panel_background
local raised = transparent and "NONE" or c.raised_background

local function mode(accent)
  return {
    a = { fg = c.background, bg = accent, gui = "none" },
    b = { fg = c.ui_foreground, bg = raised, gui = "none" },
    c = { fg = c.ui_dim, bg = panel, gui = "none" },
  }
end

return {
  normal = mode(c.keyword),
  insert = mode(c.type),
  visual = mode(c.string),
  replace = mode(c.error),
  command = mode(e.blue),
  terminal = mode(e.cyan),
  inactive = {
    a = { fg = c.ui_dim, bg = panel, gui = "none" },
    b = { fg = c.ui_dim, bg = panel, gui = "none" },
    c = { fg = c.ui_dim, bg = panel, gui = "none" },
  },
}
