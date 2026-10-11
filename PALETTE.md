# Zhixu

A portable dark palette based on Gruber Darker and Handmade Hero, refined for comfortable reading and clearly separated syntax colors. The approved Focus theme is [zhixu.focus-theme](zhixu.focus-theme).

The name comes from 秩序 (zhì xù), meaning order or orderliness, with the theme's motto: everything in its place. [Chinese dictionary](https://dict.concised.moe.edu.tw/dictView.jsp?ID=29339&la=0&powerMode=0).

The JSON export below is the canonical data for creating Neovim, Emacs, VS Code, Alacritty, and other themes. `core` contains exact colors from the Focus theme, `core_sources` records their original keys, and `extensions` contains additional syntax, interface, and terminal roles. All 96 original Focus entries are preserved in `focus_rgba`.

## Design and porting rules

- Preserve the four main syntax roles: apricot keywords, sage green types, lavender strings, and slate comments. Builtin type names such as `string`, `int`, and `bool` use the type color; quoted text uses the string color.
- Apply the string color to ordinary, raw, multiline, character, and regex literals. Keep string escapes lavender; optional underline can distinguish escapes without introducing another hue.
- Use muted blue (`extensions.function_call`, `#91ADC7`) for function and method calls, including qualified package and object calls. In `gl.BindVertexArray(VAO)`, `BindVertexArray` is blue; the package prefix `gl` and argument `VAO` keep their normal identifier/default colors.
- Keep separately identified function declarations, punctuation, symbolic operators, and generic literal values warm neutral. Variables and enum members use the identifier color. Numbers and builtin variables use mauve; builtin functions and macros use bronze, including when called.
- Give documentation comments the comment color, including docstrings when the parser explicitly classifies them as documentation. Explicit TODO / warning markers can use the existing Focus comment highlight colors.
- Use regular text by default. Color carries the distinction; bold and italics are optional accents. Aim for at least 4.5:1 contrast for normal syntax text on the editor and current-line backgrounds.
- Preserve syntax foregrounds during selection where supported. If a target requires one selected-text foreground, use `core.foreground`. Use diagnostic underlines or gutters to preserve the underlying token color.
- Cover both grammar and semantic highlighting. When a builtin type is classified as a keyword by a language grammar, add a specific type scope or face override. Check the target's token inspector; changing a theme cannot reclassify tokens the parser fails to identify.
- Map semantic `function` and `method` tokens to the call color so semantic highlighting preserves blue calls. Where the target cannot separate calls from declarations, use blue for its shared function/method group. Keep explicit builtin overrides bronze.
- Use opaque charcoal surfaces. Additions supply missing roles for ports; they do not change the approved Focus theme.

## Core and syntax roles

| Role | Export key | Hex | Intended use |
| --- | --- | --- | --- |
| Editor background | `core.background` | `#101112` | Deep, slightly cool charcoal |
| Panels / title bars | `core.panel_background` | `#0D0E0F` | Darker surrounding surfaces |
| Popups / menus / status line | `core.raised_background` | `#1A1C1E` | Raised charcoal; Focus popup / dialog surface |
| Current line | `core.current_line_background` | `#181A1C` | Subtle line emphasis |
| Default text / function declarations / operators | `core.foreground` | `#E3DCD3` | Warm, readable neutral |
| Function / method calls | `extensions.function_call` | `#91ADC7` | Muted blue; color the called name in qualified calls |
| Variables / identifiers / enum members | `core.identifier` | `#CEC8C0` | Slightly quieter neutral |
| UI text | `core.ui_foreground` | `#CFC3B7` | Warm interface foreground |
| Secondary UI text | `core.ui_dim` | `#9B8D80` | Dim labels and metadata |
| Comments / documentation | `core.comment` | `#8295A3` | Muted slate, including comment delimiters |
| Types / builtin types | `core.type` | `#A8CAA0` | Stronger sage green |
| Keywords / control flow | `core.keyword` | `#DDB08C` | Muted pastel apricot |
| Strings / characters / regex literals | `core.string` | `#B8ACD4` | Lavender, including raw and multiline strings |
| Numbers / builtin variables | `core.number` | `#C3A6B6` | Dusty mauve |
| Macros / builtin functions / notes | `core.macro` | `#C7A68B` | Muted bronze |
| Modifiers / attributes / directives | `core.modifier` | `#CAA28C` | Dusty peach |
| Secondary document headings | `core.secondary_heading` | `#D7AD8E` | Soft peach |
| Selection background | `core.selection_background` | `#43382F` | Warm charcoal |
| Current search match background | `core.search_background` | `#624732` | Deeper bronze |
| Cursor | `core.cursor` | `#DDB08C` | Apricot with charcoal text underneath |

Booleans and null-like literal values default to `core.foreground`. Generic named constants default to `core.identifier`; use the number color only when a mode cannot separate numeric literals. H1 uses `core.keyword`; H2-H6 use `core.secondary_heading`. Markdown inline code uses `core.string`, and links can use `extensions.blue` with underline.

`extensions.function_call` shares the exact value of `extensions.blue` but names the syntax role explicitly for future ports. It takes precedence over the neutral Focus `code_function` value for calls; `focus_rgba` remains an exact copy of the original Focus theme.

## Focus popups and notifications

`background3` is the popup, dialog, and tooltip surface. `ui_success`, `ui_warning_dim`, and `ui_error` fill success, warning, and error notifications; `ui_default` supplies their text. These fill colors must stay dark. Keep diagnostic foregrounds in `core.success`, `core.keyword`, and `core.error` instead. [Focus drawing source](https://github.com/focus-editor/focus/blob/main/src/draw.jai).

| Surface | Focus background key | Background | Text (`ui_default`) | Contrast |
| --- | --- | --- | --- | --- |
| Popup / tooltip | `background3` | `#1A1C1E` | `#CFC3B7` | 9.88:1 |
| Success notification | `ui_success` | `#26352C` | `#CFC3B7` | 7.46:1 |
| Warning notification | `ui_warning_dim` | `#3D3024` | `#CFC3B7` | 7.37:1 |
| Error notification | `ui_error` | `#44272A` | `#CFC3B7` | 7.74:1 |

`core.raised_background` maps to `background3`. Notification fills are exported separately as `core.notification_success_background`, `core.notification_warning_background`, and `core.notification_error_background`. `core.success` maps to `code_addition`, preserving its readable sage foreground even though `ui_success` is a dark fill. Popup labels continue to use the lighter `ui_dim` / `text_input_label` colors.

## Additional interface and diagnostic roles

`extensions.blue` and `extensions.cyan` complete the terminal palette and provide information / hint colors. The extension also supplies a neutral border, subtle gutter text, disabled text, bright ANSI variants, and backgrounds for diagnostics and changed diff regions. `foreground_disabled` and `ansi_black` are intentionally subdued; use the comment or UI dim color for readable text.

Use `core.raised_background` for completion menus, hovers, active tabs, and the status line; use `core.panel_background` for sidebars and inactive tabs. Normal line numbers, whitespace markers, folded text, and inlay hints can use `extensions.foreground_subtle`. The active line number and active tab underline use `core.keyword`. Buttons and badges can pair `core.keyword` with `core.background` as text.

| Diagnostic | Foreground / underline | Subtle background |
| --- | --- | --- |
| Error | `core.error` / `#D49A91` | `core.error_background` / `#44272A` |
| Warning | `core.keyword` / `#DDB08C` | `core.warning_background` / `#3D3024` |
| Information | `extensions.blue` / `#91ADC7` | `extensions.info_background` / `#202C36` |
| Hint | `extensions.cyan` / `#91BEBB` | `extensions.hint_background` / `#223431` |
| Success | `core.success` / `#A8B59A` | `core.success_background` / `#26352C` |

Diff and Git roles:

| Role | Foreground / gutter | Background |
| --- | --- | --- |
| Added / untracked | `core.success` / `#A8B59A` | `focus_rgba.region_addition` / `#26352C4C` |
| Removed | `core.error` / `#D49A91` | `focus_rgba.region_deletion` / `#44272A4C` |
| Changed / modified | `extensions.blue` / `#91ADC7` | `extensions.diff_change_background` / `#263341` |
| Changed word | Preserve syntax foreground | `extensions.diff_text_background` / `#34485A` |
| Renamed | `extensions.cyan` / `#91BEBB` | Editor background |
| Ignored | `extensions.foreground_subtle` | Editor background |

## Transparency and opaque fallbacks

Colors use sRGB hex with alpha last: `#RRGGBB` or `#RRGGBBAA`. `focus_rgba` reproduces the source exactly, including `FF` for fully opaque colors. UI overlays retain their alpha when the target supports it; syntax foregrounds use six-digit hex.

`opaque_over_background` contains an opaque fallback for every translucent Focus entry, blended over `core.background`. It uses per-channel sRGB interpolation: `round(overlay * alpha + background * (1 - alpha))`, with `alpha = AA / 255`. These are portable approximations; a renderer using linear-light blending can differ. Recompute over a different panel background when necessary.

For example, occurrence / inactive-search overlays use `#DDB08C26` or the opaque fallback `#2F2924`. Inactive selections use `#43382F99` or `#2F2823`. Active bracket backgrounds use `#DDB08C40` or `#433931`.

Neovim and Emacs ports should use opaque fallbacks for background overlays. VS Code UI colors can retain alpha, especially for occurrence, inactive-selection, and search-range decorations; semantic token foregrounds are opaque. Alacritty color values use six-digit hex. An alpha of `00` means no overlay: omit that effect instead of painting its fallback as a solid layer. [VS Code color formats](https://code.visualstudio.com/api/references/theme-color#color-formats), [semantic token colors](https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#theming), [Alacritty colors](https://alacritty.org/config-alacritty.html#colors).

## Editor syntax mappings

The following assignments are palette recommendations. Face, capture, and scope availability depends on the installed version, grammar, and language mode. Use language-specific overrides when the base groups do not cover a token. [Neovim syntax groups](https://neovim.io/doc/user/syntax/), [Tree-sitter captures](https://neovim.io/doc/user/treesitter/), [Emacs Font Lock faces](https://www.gnu.org/software/emacs/manual/html_node/elisp/Faces-for-Font-Lock.html), [VS Code theme format](https://code.visualstudio.com/api/extension-guides/color-theme), [VS Code semantic tokens](https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide).

| Role | Neovim groups / captures | Emacs faces | VS Code TextMate scopes / semantic tokens |
| --- | --- | --- | --- |
| `core.comment` | `Comment`, `@comment`, `@string.documentation` | `font-lock-comment-face`, `font-lock-comment-delimiter-face`, `font-lock-doc-face` | `comment`; semantic `comment` |
| `core.type` | `Type`, `@type`, `@type.builtin`, `@type.definition` | `font-lock-type-face`; language-specific builtin type faces | `entity.name.type`, `support.type`, `support.class`, `storage.type`; semantic `type`, `class`, `struct`, `interface`, `enum`, `typeParameter` |
| `core.keyword` | `Statement`, `Keyword`, `Conditional`, `Repeat`, `Exception`, `@keyword` | `font-lock-keyword-face` | `keyword`; semantic `keyword` |
| `core.string` | `String`, `Character`, `@string`, `@string.regexp`, `@string.escape`, `@character` | `font-lock-string-face`, `font-lock-escape-face` if available | `string`, `constant.character`; semantic `string`, `regexp` |
| `core.number` | `Number`, `Float`, `@number`, `@number.float`, `@variable.builtin` | `font-lock-number-face` if available; numeric faces for the mode | `constant.numeric`, `support.variable`; semantic `number`, `variable.defaultLibrary` |
| `core.identifier` | `Identifier`, `@variable`, `@variable.parameter`, `@property` | `font-lock-variable-name-face`, `font-lock-variable-use-face` if available | `variable.other`, `variable.parameter`; semantic `variable`, `parameter`, `property`, `enumMember` |
| `core.foreground` | `Operator`, `Boolean`, `@function`, `@function.method`, `@operator`, `@boolean` | `font-lock-function-name-face`, `font-lock-operator-face`, `font-lock-punctuation-face` where available | Declaration `entity.name.function` scopes, `keyword.operator`, `constant.language`; semantic `operator` |
| `extensions.function_call` | `@function.call`, `@function.method.call`; `Function` when calls and declarations share one group | `font-lock-function-call-face`; `eglot-semantic-function`, `eglot-semantic-method` where available | Grammar-specific function/method call scopes; semantic `function`, `method` |
| `core.macro` | `Macro`, `@function.macro`, `@function.builtin` | `font-lock-builtin-face`; mode-specific macro faces | `entity.name.function.preprocessor`, `support.function`; semantic `macro`, `function.defaultLibrary`, `method.defaultLibrary` |
| `core.modifier` | `PreProc`, `Define`, `Include`, `@attribute`, `@keyword.modifier`, `@keyword.directive` | `font-lock-preprocessor-face`; attribute faces for the mode | `storage.modifier`, `entity.other.attribute-name`, preprocessor directives; semantic `modifier`, `decorator` |

For Neovim, enable true color and also map LSP semantic type groups such as `@lsp.type.type`, `@lsp.type.class`, `@lsp.type.struct`, `@lsp.type.interface`, `@lsp.type.enum`, and `@lsp.type.typeParameter` to `core.type`. Map semantic strings and comments to their matching roles. More specific captures such as `@string.documentation`, `@function.builtin`, and `@keyword.modifier` need explicit overrides to keep their intended colors. Treat symbolic operators as neutral; word operators can follow keywords. Where emitted, map `@lsp.typemod.function.defaultLibrary` and `@lsp.typemod.method.defaultLibrary` to `core.macro`, and `@lsp.typemod.variable.defaultLibrary` to `core.number`. Keep builtin types green rather than assigning one color to every `defaultLibrary` modifier. [Neovim semantic highlighting](https://neovim.io/doc/user/lsp/#lsp-semantic-highlight).

Set `@function.call`, `@function.method.call`, `@lsp.type.function`, and `@lsp.type.method` explicitly to `extensions.function_call`. Keep grammar declaration captures `@function` and `@function.method` neutral. [Neovim function captures](https://neovim.io/doc/user/treesitter/#treesitter-highlight-groups).

For Emacs, guard optional faces with `facep` when supporting older versions. `font-lock-constant-face` can use `core.identifier`; if a mode uses that face for all numbers, use `core.number` as its fallback. Explicitly set `font-lock-doc-face` to slate so inherited string styling does not turn documentation lavender. Keep `font-lock-function-name-face` neutral and set `font-lock-function-call-face` to `extensions.function_call`. Eglot function and method semantic faces inherit the call face; its operator face stays neutral. Package-specific semantic faces should inherit these roles.

If an Odin mode or another grammar does not identify qualified calls, add a language-specific query or non-overriding font-lock rule for the called member in `.Name(...)`. Preserve package prefixes, non-call fields, strings, and comments. A face color alone cannot highlight an unclassified call.

For VS Code, define both `tokenColors` and `semanticTokenColors`, and enable `semanticHighlighting`. Map `type.defaultLibrary` and other builtin type tokens to green. Place specific operator, modifier, builtin, and type rules after broad grammar rules; inspect ambiguous `storage.type` scopes so declaration keywords stay apricot while datatype names stay green. Keep documentation comments slate. [VS Code semantic highlighting](https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#theming).

Set semantic `function` and `method` to `extensions.function_call`, with `function.defaultLibrary` and `method.defaultLibrary` staying bronze. Add matching TextMate call scopes from the language's token inspector; a broad neutral `entity.name.function` rule must not erase a more specific call rule. [VS Code semantic token rules](https://code.visualstudio.com/api/language-extensions/semantic-highlight-guide#semantic-coloring-in-color-themes).

## Editor interface mappings

Apply these role assignments to the target's interface groups. Refer to [Neovim highlight groups](https://neovim.io/doc/user/syntax/#highlight-groups), [Emacs standard faces](https://www.gnu.org/software/emacs/manual/html_node/emacs/Standard-Faces.html), and [VS Code UI colors](https://code.visualstudio.com/api/references/theme-color) for version-specific details.

| Role | Neovim | Emacs | VS Code |
| --- | --- | --- | --- |
| Editor `foreground` / `background` | `Normal`, `NormalNC` | `default` | `editor.foreground`, `editor.background` |
| Cursor `cursor` / `cursor_text` | `Cursor` background / foreground | `cursor` background | `editorCursor.foreground`, `editorCursor.background` |
| Current-line background | `CursorLine` | `hl-line` | `editor.lineHighlightBackground` |
| Gutter subtle / active apricot | `LineNr`, `CursorLineNr`; `SignColumn` uses editor background | `line-number`, `line-number-current-line` | `editorLineNumber.foreground`, `editorLineNumber.activeForeground` |
| Selection background | `Visual` | `region` | `editor.selectionBackground` |
| Focused / other search match backgrounds | `IncSearch` / `Search` | `isearch` / `lazy-highlight` | `editor.findMatchBackground` / `editor.findMatchHighlightBackground` |
| Raised popup background / neutral border | `NormalFloat`, `Pmenu`, `FloatBorder`; `PmenuSel` uses selection | Completion / tooltip faces exposed by the package | `editorWidget.background`, `editorWidget.border`, `editorSuggestWidget.background` |
| Raised active / panel inactive status line | `StatusLine`, `StatusLineNC` | `mode-line`, `mode-line-active` if available, `mode-line-inactive` | `statusBar.background`, `statusBar.foreground` |
| Neutral divider | `WinSeparator` | `vertical-border` | `panel.border`, `sideBar.border` |
| Error / warning / info / hint | `DiagnosticError`, `DiagnosticWarn`, `DiagnosticInfo`, `DiagnosticHint` and corresponding underline groups | `error` / `warning`; package-specific info / hint faces use blue / cyan | `editorError.foreground`, `editorWarning.foreground`, `editorInfo.foreground`, `editorHint.foreground` |
| Diff backgrounds | `DiffAdd`, `DiffDelete`, `DiffChange`, `DiffText` | `diff-added`, `diff-removed`, `diff-changed`; package-specific refined diff faces | `diffEditor.insertedTextBackground`, `diffEditor.removedTextBackground` |

Focused search uses `core.search_background`; other search matches use the opaque `search_result_inactive` fallback or its RGBA source. Match text can retain its syntax foreground; otherwise use `core.foreground`. Keep diagnostic foregrounds in gutters, underlines, and messages rather than replacing source-token colors.

## Terminal ANSI palette

ANSI colors are a compatible extension of the palette. The conventional yellow slot uses apricot; the magenta slot uses lavender. Bright variants increase lightness gently. ANSI black is a dark charcoal swatch; bright black uses readable slate.

| ANSI indices (normal / bright) | Name | Normal | Bright |
| --- | --- | --- | --- |
| 0 / 8 | black | `#25282C` | `#8295A3` |
| 1 / 9 | red | `#D49A91` | `#E2ADA3` |
| 2 / 10 | green | `#A8CAA0` | `#BEDBB6` |
| 3 / 11 | yellow | `#DDB08C` | `#E9C49D` |
| 4 / 12 | blue | `#91ADC7` | `#ABC5DC` |
| 5 / 13 | magenta | `#B8ACD4` | `#CEBEE7` |
| 6 / 14 | cyan | `#91BEBB` | `#ABD5D1` |
| 7 / 15 | white | `#E3DCD3` | `#F0E9E1` |

For Alacritty, copy `ansi.normal` into `[colors.normal]` and `ansi.bright` into `[colors.bright]`. Set `[colors.primary]` background / foreground from `core.background` / `core.foreground`, `dim_foreground` from `core.ui_dim`, and `bright_foreground` from `extensions.foreground_bright`. Set `[colors.cursor]` cursor / text from `core.cursor` / `core.cursor_text`.

Set `[colors.selection]` background to `core.selection_background` and text to `CellForeground` to preserve cell colors. In `[colors.search]`, use `core.search_background` for `focused_match.background` and the opaque `search_result_inactive` fallback for `matches.background`, both with `core.foreground` as foreground. Leave `draw_bold_text_with_bright_colors` false for stable colors and let Alacritty calculate optional dim ANSI variants. Use window opacity 1.0 for the approved background. [Alacritty configuration](https://alacritty.org/config-alacritty.html#colors).

VS Code terminal colors use the same values under `terminal.ansiBlack` through `terminal.ansiWhite` and `terminal.ansiBrightBlack` through `terminal.ansiBrightWhite`. Editors running inside a terminal should use their own true-color syntax palette; the terminal ANSI table supplies application colors and a 16-color fallback. [VS Code terminal colors](https://code.visualstudio.com/api/references/theme-color#integrated-terminal-colors).

## Port verification sample

Check this sample before and after semantic highlighting activates: `string` and `Message` are green types; `type`, `func`, `return`, and `const` are apricot keywords; quoted text is lavender; comments are slate; `42` is mauve.

```go
// Documentation stays slate, separate from literals.
type Message string

func hello(name string) Message {
    return Message("hello, " + name)
}

const limit = 42
```

Check qualified calls before and after semantic highlighting activates. In this Odin sample, `BindVertexArray` and `Draw` are muted blue; `gl`, `renderer`, and the arguments keep their normal identifier/default colors. `draw` is neutral when identified as a declaration. The quoted call text stays lavender and the commented call stays slate.

```odin
draw :: proc() {
    gl.BindVertexArray(VAO)
    renderer.Draw(vertices)
    label := "gl.BindVertexArray(VAO)"
    // gl.BindVertexArray(VAO)
}
```
Also inspect raw and multiline literals, character literals, selection, completion menus, search matches, diagnostic underlines, and added / removed diff lines. A mode or language server may classify tokens differently; refine its scopes or captures while preserving the role colors.

## Machine-readable export

Extract the single `json` fence below. The role names are portable palette keys, not configuration keys for a particular editor. Prefer `core` for shared roles, `extensions` for additional roles, `ansi` for terminals, and `focus_rgba` for a complete Focus conversion. Use `extensions.function_call` for function and method calls even though the original Focus function color is neutral. `opaque_over_background` supplies the corresponding six-digit fallback for every translucent source entry.

```json
{
  "schema_version": 1,
  "name": "Zhixu",
  "id": "zhixu",
  "variant": "dark",
  "color_space": "sRGB",
  "source": {
    "file": "zhixu.focus-theme",
    "format_version": 25
  },
  "core": {
    "background": "#101112",
    "panel_background": "#0D0E0F",
    "raised_background": "#1A1C1E",
    "current_line_background": "#181A1C",
    "foreground": "#E3DCD3",
    "identifier": "#CEC8C0",
    "ui_foreground": "#CFC3B7",
    "ui_dim": "#9B8D80",
    "comment": "#8295A3",
    "type": "#A8CAA0",
    "keyword": "#DDB08C",
    "string": "#B8ACD4",
    "number": "#C3A6B6",
    "macro": "#C7A68B",
    "modifier": "#CAA28C",
    "secondary_heading": "#D7AD8E",
    "error": "#D49A91",
    "success": "#A8B59A",
    "error_background": "#44272A",
    "warning_background": "#3D3024",
    "success_background": "#26352C",
    "selection_background": "#43382F",
    "search_background": "#624732",
    "cursor": "#DDB08C",
    "cursor_text": "#101112",
    "inactive_overlay": "#050505",
    "notification_warning_background": "#3D3024",
    "notification_error_background": "#44272A",
    "notification_success_background": "#26352C"
  },
  "core_sources": {
    "background": "background0",
    "panel_background": "background1",
    "raised_background": "background3",
    "current_line_background": "cursor_line_highlight",
    "foreground": "code_default",
    "identifier": "code_identifier",
    "ui_foreground": "ui_default",
    "ui_dim": "ui_dim",
    "comment": "code_comment",
    "type": "code_type",
    "keyword": "code_keyword",
    "string": "code_string_literal",
    "number": "code_number",
    "macro": "code_macro",
    "modifier": "code_modifier",
    "secondary_heading": "code_header2",
    "error": "code_error",
    "success": "code_addition",
    "error_background": "region_error",
    "warning_background": "region_warning",
    "success_background": "region_success",
    "selection_background": "selection_active",
    "search_background": "search_result_active",
    "cursor": "cursor",
    "cursor_text": "char_under_cursor",
    "inactive_overlay": "inactive_pane_dim_overlay",
    "notification_warning_background": "ui_warning_dim",
    "notification_error_background": "ui_error",
    "notification_success_background": "ui_success"
  },
  "extensions": {
    "blue": "#91ADC7",
    "function_call": "#91ADC7",
    "cyan": "#91BEBB",
    "border": "#34383D",
    "foreground_subtle": "#788691",
    "foreground_disabled": "#6B625B",
    "foreground_bright": "#F0E9E1",
    "ansi_black": "#25282C",
    "red_bright": "#E2ADA3",
    "green_bright": "#BEDBB6",
    "yellow_bright": "#E9C49D",
    "blue_bright": "#ABC5DC",
    "magenta_bright": "#CEBEE7",
    "cyan_bright": "#ABD5D1",
    "info_background": "#202C36",
    "hint_background": "#223431",
    "diff_change_background": "#263341",
    "diff_text_background": "#34485A"
  },
  "ansi": {
    "normal": {
      "black": "#25282C",
      "red": "#D49A91",
      "green": "#A8CAA0",
      "yellow": "#DDB08C",
      "blue": "#91ADC7",
      "magenta": "#B8ACD4",
      "cyan": "#91BEBB",
      "white": "#E3DCD3"
    },
    "bright": {
      "black": "#8295A3",
      "red": "#E2ADA3",
      "green": "#BEDBB6",
      "yellow": "#E9C49D",
      "blue": "#ABC5DC",
      "magenta": "#CEBEE7",
      "cyan": "#ABD5D1",
      "white": "#F0E9E1"
    }
  },
  "focus_rgba": {
    "background0": "#101112FF",
    "background1": "#0D0E0FFF",
    "background2": "#1A1C1EFF",
    "background3": "#1A1C1EFF",
    "background4": "#0D0E0FFF",
    "selection_active": "#43382FFF",
    "selection_inactive": "#43382F99",
    "selection_highlight": "#DDB08C26",
    "search_result_active": "#624732FF",
    "search_result_inactive": "#DDB08C26",
    "scrollbar": "#A1846F66",
    "scrollbar_hover": "#A1846FB3",
    "scrollbar_background": "#DDB08C0D",
    "cursor": "#DDB08CFF",
    "cursor_inactive": "#DDB08C11",
    "paste_animation": "#DDB08C4C",
    "splitter": "#DDB08C19",
    "splitter_hover": "#DDB08C4C",
    "letter_highlight": "#DDB08CFF",
    "list_cursor_lite": "#DDB08C19",
    "list_cursor": "#DDB08C4C",
    "shadow_dark": "#0607087F",
    "shadow_transparent": "#06070800",
    "text_input_label": "#9B8D80FF",
    "char_under_cursor": "#101112FF",
    "ui_default": "#CFC3B7FF",
    "ui_dim": "#9B8D80FF",
    "ui_neutral": "#9B8D80FF",
    "ui_warning": "#DDB08CFF",
    "ui_warning_dim": "#3D3024FF",
    "ui_error": "#44272AFF",
    "ui_error_bright": "#D49A91FF",
    "ui_success": "#26352CFF",
    "region_scope_export": "#101112FF",
    "region_scope_file": "#101112FF",
    "region_scope_module": "#101112FF",
    "region_header": "#101112FF",
    "region_success": "#26352CFF",
    "region_warning": "#3D3024FF",
    "region_error": "#44272AFF",
    "region_heredoc": "#0D0E0FFF",
    "build_panel_background": "#101112FF",
    "build_panel_scrollbar": "#A1846F66",
    "build_panel_scrollbar_hover": "#A1846FB3",
    "build_panel_scrollbar_background": "#DDB08C0D",
    "build_panel_title_bar": "#0D0E0FFF",
    "code_default": "#E3DCD3FF",
    "code_comment": "#8295A3FF",
    "code_type": "#A8CAA0FF",
    "code_function": "#E3DCD3FF",
    "code_punctuation": "#E3DCD3FF",
    "code_operation": "#E3DCD3FF",
    "code_string_literal": "#B8ACD4FF",
    "code_value": "#E3DCD3FF",
    "code_highlight": "#DDB08CFF",
    "code_error": "#D49A91FF",
    "code_keyword": "#DDB08CFF",
    "code_warning": "#DDB08CFF",
    "code_invalid": "#D49A91FF",
    "code_multiline_string": "#B8ACD4FF",
    "code_raw_string": "#B8ACD4FF",
    "code_char_literal": "#B8ACD4FF",
    "code_identifier": "#CEC8C0FF",
    "code_note": "#C7A68BFF",
    "code_number": "#C3A6B6FF",
    "code_multiline_comment": "#8295A3FF",
    "code_modifier": "#CAA28CFF",
    "code_attribute": "#CAA28CFF",
    "code_enum_variant": "#CEC8C0FF",
    "code_macro": "#C7A68BFF",
    "code_builtin_variable": "#C3A6B6FF",
    "code_builtin_function": "#C7A68BFF",
    "code_builtin_exception": "#C7A68BFF",
    "code_directive": "#CAA28CFF",
    "code_directive_modifier": "#CAA28CFF",
    "code_header": "#DDB08CFF",
    "code_header2": "#D7AD8EFF",
    "code_header3": "#D7AD8EFF",
    "code_header4": "#D7AD8EFF",
    "code_header5": "#D7AD8EFF",
    "code_header6": "#D7AD8EFF",
    "ruler": "#DDB08C11",
    "bracket_highlight": "#DDB08C40",
    "indent_guide": "#DDB08C19",
    "active_pane_border": "#DDB08C33",
    "inactive_pane_dim_overlay": "#050505FF",
    "code_comment_highlight1": "#C7A68BFF",
    "code_comment_highlight2": "#D49A91FF",
    "code_comment_highlight3": "#DDB08CFF",
    "code_comment_highlight4": "#E3DCD3FF",
    "cursor_line_highlight": "#181A1CFF",
    "color_preview_title_bar": "#0D0E0FFF",
    "code_addition": "#A8B59AFF",
    "code_deletion": "#D49A91FF",
    "region_addition": "#26352C4C",
    "region_deletion": "#44272A4C"
  },
  "opaque_over_background": {
    "selection_inactive": "#2F2823",
    "selection_highlight": "#2F2924",
    "search_result_inactive": "#2F2924",
    "scrollbar": "#4A3F37",
    "scrollbar_hover": "#766253",
    "scrollbar_background": "#1A1918",
    "cursor_inactive": "#1E1C1A",
    "paste_animation": "#4D4036",
    "splitter": "#24211E",
    "splitter_hover": "#4D4036",
    "list_cursor_lite": "#24211E",
    "list_cursor": "#4D4036",
    "shadow_dark": "#0B0C0D",
    "shadow_transparent": "#101112",
    "build_panel_scrollbar": "#4A3F37",
    "build_panel_scrollbar_hover": "#766253",
    "build_panel_scrollbar_background": "#1A1918",
    "ruler": "#1E1C1A",
    "bracket_highlight": "#433931",
    "indent_guide": "#24211E",
    "active_pane_border": "#39312A",
    "region_addition": "#171C1A",
    "region_deletion": "#1F1819"
  }
}
```

