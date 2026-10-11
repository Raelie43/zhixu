local M = {}

local defaults = {
  transparent = false,
  terminal_colors = true,
  styles = { comments = {}, keywords = {}, functions = {}, variables = {} },
  integrations = true,
}

M.options = vim.deepcopy(defaults)

function M.setup(opts)
  opts = opts or {}
  assert(type(opts) == "table", "zhixu: setup expects a table")
  for key in pairs(opts) do
    assert(
      defaults[key] ~= nil or key == "on_colors" or key == "on_highlights",
      "zhixu: unknown option " .. key
    )
  end
  local options = vim.tbl_deep_extend("force", vim.deepcopy(defaults), opts)
  for _, key in ipairs({ "transparent", "terminal_colors" }) do
    assert(type(options[key]) == "boolean", "zhixu: " .. key .. " must be a boolean")
  end
  assert(type(options.styles) == "table", "zhixu: styles must be a table")
  for key, value in pairs(options.styles) do
    assert(defaults.styles[key] ~= nil, "zhixu: unknown style " .. key)
    assert(type(value) == "table", "zhixu: styles." .. key .. " must be a table")
  end
  assert(
    type(options.integrations) == "boolean" or type(options.integrations) == "table",
    "zhixu: integrations must be a boolean or table"
  )
  if type(options.integrations) == "table" then
    for key, value in pairs(options.integrations) do
      assert(require("zhixu.groups.plugins").names[key], "zhixu: unknown integration " .. key)
      assert(type(value) == "boolean", "zhixu: integrations." .. key .. " must be a boolean")
    end
  end
  for _, key in ipairs({ "on_colors", "on_highlights" }) do
    assert(
      options[key] == nil or type(options[key]) == "function",
      "zhixu: " .. key .. " must be a function"
    )
  end
  M.options = options
end

return M
