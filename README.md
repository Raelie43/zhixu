# Zhixu

*Everything in its place.*

A quiet, dark Neovim colorscheme built from the canonical
[Zhixu palette](https://github.com/raelie43/zhixu/blob/main/PALETTE.md).
Opaque charcoal surfaces, warm text, regular typography, and clearly separated syntax
colors. Requires **Neovim 0.10+** and a terminal with true-color support. No runtime
dependencies. Every color is baked into [palette.lua](lua/zhixu/palette.lua).
The runtime never reads or parses `PALETTE.md` and needs no build step.

| Role | Color |
| --- | --- |
| Background | `#101112` |
| Foreground / function declarations / symbolic operators | `#E3DCD3` |
| Keywords | `#DDB08C` |
| Types, including builtin types | `#A8CAA0` |
| Strings, characters, regexes, and escapes | `#B8ACD4` |
| Function and method calls | `#91ADC7` |
| Identifiers and enum members | `#CEC8C0` |
| Comments and documentation | `#8295A3` |
| Numbers and builtin variables | `#C3A6B6` |
| Builtin functions and macros | `#C7A68B` |

## Install

With Neovim's built-in [vim.pack](https://neovim.io/doc/user/pack/#vim.pack.add())
(**Neovim 0.12+**):

```lua
vim.pack.add({
  { src = "https://github.com/raelie43/zhixu", version = "main" },
})
vim.cmd.colorscheme("zhixu")
```

The example follows `main`; a published release tag can be used to pin a version. Optional
`require("zhixu").setup(...)` goes between `vim.pack.add()` and the colorscheme
command. The repository uses the standard `colors/`, `lua/`, and `doc/` layout;
no install hook, build command, or additional plugin is required.

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "raelie43/zhixu",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("zhixu")
  end,
}
```

With another plugin manager, install the same repository and load it with
`vim.cmd.colorscheme("zhixu")` or `:colorscheme zhixu`.

To try this checkout directly, add it to your runtime path:

```lua
vim.opt.runtimepath:prepend("B:/git/zhixu")
vim.cmd.colorscheme("zhixu")
```

## Configure

Setup is optional. Call it **before** loading the colorscheme. Each `setup()` call
starts from the defaults; changes take effect on the next colorscheme load.

```lua
require("zhixu").setup({
  transparent = false,
  terminal_colors = true,
  styles = {
    comments = {},
    keywords = {},
    functions = {},
    variables = {},
  },
  integrations = true,
})
vim.cmd.colorscheme("zhixu")
```

Set `styles.comments = { italic = true }` or `styles.keywords = { bold = true }`
for optional accents. Markdown emphasis retains its explicit bold / italic meaning.

`transparent = true` removes base backgrounds from the editor, floats, status line,
tabs, and sidebars. Selections, search matches, diffs, diagnostic fills, notifications,
and colored mode indicators stay visible. The default follows the palette's opaque
charcoal surfaces.

`terminal_colors = false` leaves your existing `g:terminal_color_0` through
`g:terminal_color_15` values untouched. The default applies all 16 exact ANSI colors
from the palette.

### Overrides

Callbacks receive fresh tables on every load. `on_colors` runs first;
`on_highlights` runs after all editor, syntax, and plugin groups are built. Mutate
the supplied tables directly:

```lua
require("zhixu").setup({
  on_colors = function(palette)
    palette.core.comment = "#91ADC7"
  end,
  on_highlights = function(hl, palette)
    hl.FloatBorder = { fg = palette.core.ui_dim }
    hl["@string.escape"] = { fg = palette.core.string, underline = true }
  end,
})
vim.cmd.colorscheme("zhixu")
```

`require("zhixu").get_palette()` returns an independent copy including `on_colors`
changes. Its sections keep the original export names: `core`, `extensions`,
`ansi`, and `opaque_over_background`.

## Plugin support

Highlights are registered without loading any plugins, so they are available when
plugins load lazily. All integrations are enabled by default. Disable individual
ones with `integrations = { telescope = false, blink = false }`, or disable all
plugin groups with `integrations = false`. Unspecified keys remain enabled.

| Configuration key | Integration |
| --- | --- |
| `mini` | [mini.nvim](https://github.com/nvim-mini/mini.nvim): pick, files, icons, statusline, tabline, clue, completion, snippets, diff, indentscope, starter, notify, jump, and more |
| `telescope` | [Telescope](https://github.com/nvim-telescope/telescope.nvim) |
| `fzf_lua` | [fzf-lua](https://github.com/ibhagwan/fzf-lua), including its embedded fzf UI |
| `blink` | [blink.cmp](https://github.com/saghen/blink.cmp), documentation, signatures, and completion kinds |
| `cmp` | nvim-cmp |
| `oil` | [oil.nvim](https://github.com/stevearc/oil.nvim), including hidden entries and trash actions |
| `gitsigns` | Gitsigns |
| `which_key` | which-key.nvim |
| `lazy`, `mason` | lazy.nvim and mason.nvim |
| `notify`, `noice` | nvim-notify and noice.nvim |
| `snacks` | Snacks picker, notifier, dashboard, and indentation |
| `trouble` | trouble.nvim |
| `nvim_tree`, `neo_tree` | nvim-tree and neo-tree |
| `indent_blankline` | indent-blankline / ibl |
| `bufferline` | bufferline.nvim |
| `flash` | flash.nvim |
| `dashboard`, `alpha` | dashboard-nvim and alpha-nvim |
| `render_markdown` | render-markdown.nvim |

### Lualine

A theme module is included. Configure it after setting up Zhixu:

```lua
require("lualine").setup({ options = { theme = "zhixu" } })
```

### fzf.vim

[fzf.vim](https://github.com/junegunn/fzf.vim) reads colors through `g:fzf_colors`.
Opt into the provided highlight references:

```lua
vim.g.fzf_colors = require("zhixu").fzf_colors()
```

## Syntax behavior

Tree-sitter declaration captures (`@function` and `@function.method`) stay neutral;
call captures are blue. Shared Vim `Function` and LSP function/method groups are
blue, with explicit builtin overrides in bronze. Language servers that use one
token type for declarations and calls will consequently show both in blue.

Selections, searches, reference highlights, and diff backgrounds preserve syntax
foregrounds. Diagnostic underlines use `sp` without replacing token colors. Alpha
overlays use the palette's exact opaque fallbacks.

A theme can only color tokens identified by your grammar or language server. Use
`:Inspect` to check ambiguous captures and `on_highlights` for language-specific
overrides. `@string.documentation` stays slate; ordinary strings stay lavender.

## Development

Edit the static Lua colors directly and keep the documented palette in sync.
The palette comparison in the tests catches accidental drift.

Theme code runs when `:colorscheme zhixu` is applied. It creates no autocommands,
timers, jobs, or callbacks for typing, scrolling, or redraws. Plugin support
consists of highlight definitions; it never loads those plugins.

Run the dependency-free checks from the repo root:

```sh
nvim --headless -u NONE -i NONE -l tests/run.lua
nvim --headless -u NONE -i NONE -l tests/runtime.lua
stylua --check lua colors tests
```

The checks cover exact palette values, syntax and semantic roles, ANSI colors,
highlight links, plugin defaults, transparency, disabled integrations, callbacks,
and switching away from and back to the theme. The runtime check installs only
`colors/`, `lua/`, and `doc/` in an isolated native package, blocks document
parsing and background work, and reports cold-load and reload timings.
See `:help zhixu` for the API.

Git release archives contain the runtime files and README; `.gitattributes`
excludes development files. Git clones retain the tests and palette documentation.
