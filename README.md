# ⚡flash.nvim

`flash.nvim` lets you navigate your code with search labels,
enhanced character motions, and Treesitter integration.

<table>
  <tr>
    <th>Search Integration</th>
    <th>Standalone Jump</th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/folke/flash.nvim/assets/292349/e0ac4cbc-fa54-4505-8261-43ec0505518d" />
    </td>
    <td>
      <img src="https://github.com/folke/flash.nvim/assets/292349/90af85e3-3f22-4c51-af4b-2a2488c9560b" />
    </td>
  </tr>
  <tr>
    <th><code>f</code>, <code>t</code>, <code>F</code>, <code>T</code></th>
    <th>Treesitter</th>
  </tr>
  <tr>
    <td>
      <img src="https://github.com/folke/flash.nvim/assets/292349/379cb2de-8ec3-4acf-8811-d3590a5854b6" />
    </td>
    <td>
      <img src="https://github.com/folke/flash.nvim/assets/292349/b963b05e-3d28-45ff-b43a-928a06e5f92a" />
    </td>
  </tr>
</table>

## ✨ Features

- 🔍 **Search Integration**: integrate **flash.nvim** with your regular
  search using `/` or `?`. Labels appear next to the matches,
  allowing you to quickly jump to any location. Labels are
  guaranteed not to exist as a continuation of the search pattern.
- ⌨️ **type as many characters as you want** before using a jump label.
- ⚡ **Enhanced `f`, `t`, `F`, `T` motions**
- 🌳 **Treesitter Integration**: all parents of the Treesitter node
  under your cursor are highlighted with a label for quick selection
  of a specific Treesitter node.
- 🎯 **Jump Mode**: a standalone jumping mode similar to search
- 🔎 **Search Modes**: `exact`, `search` (regex), and `fuzzy` search modes
- 🪟 **Multi Window** jumping
- 🌐 **Remote Actions**: perform motions in remote locations
- ⚫ **dot-repeatable** jumps
- 📡 **highly extensible**: check the [examples](https://github.com/folke/flash.nvim#-examples)

## 📋 Requirements

- Neovim >= **0.8.0** (needs to be built with **LuaJIT**)

## 📦 Installation

Install the plugin with your preferred package manager:

[lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        -- default options: exact mode, multi window, all directions, with a backdrop
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "o", "x" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
  },
}
```

## ⚙️ Configuration

**flash.nvim** is highly configurable. Please refer to the default settings below.

<details><summary>Default Settings</summary>

```lua
{
  -- labels = "abcdefghijklmnopqrstuvwxyz",
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    -- search/jump in all windows
    multi_window = true,
    -- search direction
    forward = true,
    -- when `false`, find only matches in the given direction
    wrap = true,
    ---@type Flash.Pattern.Mode
    -- Each mode will take ignorecase and smartcase into account.
    -- * exact: exact match
    -- * search: regular search
    -- * fuzzy: fuzzy search
    -- * fun(str): custom function that returns a pattern
    --   For example, to only match at the beginning of a word:
    --   mode = function(str)
    --     return "\\<" .. str
    --   end,
    mode = "exact",
    -- behave like `incsearch`
    incremental = false,
    -- Excluded filetypes and custom window filters
    ---@type (string|fun(win:window))[]
    exclude = {
      "notify",
      "noice",
      "cmp_menu",
      function(win)
        -- exclude non-focusable windows
        return not vim.api.nvim_win_get_config(win).focusable
      end,
    },
    -- Optional trigger character that needs to be typed before
    -- a jump label can be used. It's NOT recommended to set this,
    -- unless you know what you're doing
    trigger = "",
    -- max pattern length. If the pattern length is equal to this
    -- labels will no longer be skipped. When it exceeds this length
    -- it will either end in a jump or terminate the search
    max_length = nil, ---@type number?
  },
  jump = {
    -- save location in the jumplist
    jumplist = true,
    -- jump position
    pos = "start", ---@type "start" | "end" | "range"
    -- add pattern to search history
    history = false,
    -- add pattern to search register
    register = false,
    -- clear highlight after jump
    nohlsearch = false,
    -- automatically jump when there is only one match
    autojump = false,
    -- You can force inclusive/exclusive jumps by setting the
    -- `inclusive` option. By default it will be automatically
    -- set based on the mode.
    inclusive = nil, ---@type boolean?
    -- jump position offset. Not used for range jumps.
    -- 0: default
    -- 1: when pos == "end" and pos < current position
    offset = nil, ---@type number
  },
  highlight = {
    label = {
      -- add a label for the first match in the current window.
      -- you can always jump to the first match with `<CR>`
      current = true,
      -- show the label after the match
      after = true, ---@type boolean|number[]
      -- show the label before the match
      before = false, ---@type boolean|number[]
      -- position of the label extmark
      style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
      -- flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default only lower-case labels are re-used.
      reuse = "lowercase", ---@type "lowercase" | "all"
    },
    -- show a backdrop with hl FlashBackdrop
    backdrop = true,
    -- Highlight the search matches
    matches = true,
    -- extmark priority
    priority = 5000,
    groups = {
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel",
    },
  },
  -- action to perform when picking a label.
  -- defaults to the jumping logic depending on the mode.
  ---@type fun(match:Flash.Match, state:Flash.State)|nil
  action = nil,
  -- initial pattern to use when opening flash
  pattern = "",
  -- When `true`, flash will try to continue the last search
  continue = false,
  -- You can override the default options for a specific mode.
  -- Use it with `require("flash").jump({mode = "forward"})`
  ---@type table<string, Flash.Config>
  modes = {
    -- options used when flash is activated through
    -- a regular search with `/` or `?`
    search = {
      enabled = true, -- enable flash for search
      highlight = { backdrop = false },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        -- `forward` will be automatically set to the search direction
        -- `mode` is always set to `search`
        -- `incremental` is set to `true` when `incsearch` is enabled
      },
    },
    -- options used when flash is activated through
    -- `f`, `F`, `t`, `T`, `;` and `,` motions
    char = {
      enabled = true,
      -- by default all keymaps are enabled, but you can disable some of them,
      -- by removing them from the list.
      keys = { "f", "F", "t", "T", ";", "," },
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    -- options used for treesitter selections
    -- `require("flash").treesitter()`
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range" },
      highlight = {
        label = { before = true, after = true, style = "inline" },
        backdrop = false,
        matches = false,
      },
    },
    -- options used for remote flash
    remote = {}
  },
  -- options for the floating window that shows the prompt,
  -- for regular jumps
  prompt = {
    enabled = true,
    prefix = { { "⚡", "FlashPromptIcon" } },
    win_config = {
      relative = "editor",
      width = 1, -- when <=1 it's a percentage of the editor width
      height = 1,
      row = -1, -- when negative it's an offset from the bottom
      col = 0, -- when negative it's an offset from the right
      zindex = 1000,
    },
  },
}
```

</details>

## 🚀 Usage

- **Treesitter**: `require("flash").treesitter(opts?)` opens **flash** in **Treesitter** mode
  - use a jump label, or use `;` and `,` to increase/decrease the selection
- **regular search**: search as you normally do, but enhanced with jump labels
- `f`, `t`, `F`, `T` motions:
  - After typing `f{char}` or `F{char},` you can repeat the motion with `f`
    or go to the previous match with `F` to undo a jump.
  - Similarly, after typing `t{char}` or `T{char},` you can repeat the motion
    with `t` or go to the previous match with `T`.
  - You can also go to the next match with `;` or previous match with `,`
  - Any highlights clear automatically when moving, changing buffers,
    or pressing `<esc>`.
- **remote**: `require("flash").remote(opts?)` opens **flash** in **remote** mode
  - this is only useful in operator pending mode.
  - For example, press `yr` to start yanking and open flash
    - select a label to set the cursor position
    - perform any motion, like `iw` or even start flash Treesitter with `S`
    - the yank will be performed on the new selection
    - you'll be back in the original window / position
- **jump**: `require("flash").jump(opts?)` opens **flash** with the given options
  - type any number of characters before typing a jump label
- **VS Code**: some functionality is changed/disabled when running **flash** in **VS Code**:
  - `prompt` is disabled
  - `highlights` are set to different defaults that will actually work in VS Code
  - `search.multi_window` is disabled, since VS Code has problems with `vim.api.nvim_set_current_win`

## 📡 API

The options for `require("flash").jump(opts?)`, are the same as
those in the config section, but can additionally have the following fields:

- `matcher`: a custom function that generates matches for a given window
- `labeler`: a custom function to label matches

You can also add labels in the `matcher` function and then set `labeler`
to an empty function `labeler = function() end`

<details><summary>Type Definitions</summary>

```typescript
type FlashMatcher = (win: number, state: FlashState) => FlashMatch[];
type FlashLabeler = (matches: FlashMatch[], state: FlashState) => void;

interface FlashMatch {
  win: number;
  pos: [number, number]; // (1,0)-indexed
  end_pos: [number, number]; // (1,0)-indexed
  label?: string;
}

// Check the code for the full definition
// of Flash.State at `lua/flash/state.lua`
type FlashState = {};
```

</details>

## 💡 Examples

<details><summary>Forward search only</summary>

```lua
require("flash").jump({
  search = { forward = true, wrap = false, multi_window = false },
})
```

</details>

<details><summary>Backward search only</summary>

```lua
require("flash").jump({
  search = { forward = false, wrap = false, multi_window = false },
})
```

</details>

<details><summary>Show diagnostics at target, without changing cursor position</summary>

```lua
require("flash").jump({
  action = function(match, state)
    vim.api.nvim_win_call(match.win, function()
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      vim.diagnostic.open_float()
      vim.api.nvim_win_set_cursor(match.win, state.pos)
    end)
  end,
})

-- More advanced example that also highlights diagnostics:
require("flash").jump({
  matcher = function(win)
    ---@param diag Diagnostic
    return vim.tbl_map(function(diag)
      return {
        pos = { diag.lnum + 1, diag.col },
        end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
      }
    end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
  end,
  action = function(match, state)
    vim.api.nvim_win_call(match.win, function()
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      vim.diagnostic.open_float()
      vim.api.nvim_win_set_cursor(match.win, state.pos)
    end)
  end,
})
```

</details>

<details><summary>Match beginning of words only</summary>

```lua
require("flash").jump({
  search = {
    mode = function(str)
      return "\\<" .. str
    end,
  },
})
```

</details>

<details><summary>Initialize flash with the word under the cursor</summary>

```lua
require("flash").jump({
  pattern = vim.fn.expand("<cword>"),
})
```

</details>

<details><summary>Jump to a line</summary>

```lua
require("flash").jump({
  search = { mode = "search" },
  highlight = { label = { after = { 0, 0 } } },
  pattern = "^"
})
```

</details>

<details><summary>Select any word</summary>

```lua
require("flash").jump({
  pattern = ".", -- initialize pattern with any char
  search = {
    mode = function(pattern)
      -- remove leading dot
      if pattern:sub(1, 1) == "." then
        pattern = pattern:sub(2)
      end
      -- return word pattern and proper skip pattern
      return ([[\v<%s\w*>]]):format(pattern), ([[\v<%s]]):format(pattern)
    end,
  },
  -- select the range
  jump = { pos = "range" },
})
```

</details>

<details><summary>Jump to a position, make a Treesitter selection and jump back</summary>

This should be bound to a keymap like `<leader>t`.
Then you could do `y<leader>t` to remotely yank a Treesitter selection.

```lua
vim.keymap.set({ "n", "x", "o" }, "<leader>t", function()
  local win = vim.api.nvim_get_current_win()
  local view = vim.fn.winsaveview()
  require("flash").jump({
    action = function(match, state)
      state:hide()
      vim.api.nvim_set_current_win(match.win)
      vim.api.nvim_win_set_cursor(match.win, match.pos)
      require("flash").treesitter()
      vim.schedule(function()
        vim.api.nvim_set_current_win(win)
        vim.fn.winrestview(view)
      end)
    end,
  })
end)
```

Alternatively, this can be achieved using a remote action:

- `yr` to start yank and remote
- select a label
- `S` to start Treesitter node selection
- pick a Treesitter label

</details>

<details><summary><code>f</code>, <code>t</code>, <code>F</code>, <code>T</code> with labels</summary>

```lua
-- to use this, make sure to set `opts.modes.char.enabled = false`
local Config = require("flash.config")
local Char = require("flash.plugins.char")
for _, motion in ipairs({ "f", "t", "F", "T" }) do
  vim.keymap.set({ "n", "x", "o" }, motion, function()
    require("flash").jump(Config.get({
      mode = "char",
      search = {
        mode = Char.mode(motion),
        max_length = 1,
      },
    }, Char.motions[motion]))
  end)
end
```

</details>

<details><summary>Telescope integration</summary>

This will allow you to use `s` in normal mode
and `<c-s>` in insert mode, to jump to a label in Telescope results.

```lua
{
    "nvim-telescope/telescope.nvim",
    optional = true,
    opts = function(_, opts)
      local function flash(prompt_bufnr)
        require("flash").jump({
          pattern = "^",
          highlight = { label = { after = { 0, 0 } } },
          search = {
            mode = "search",
            exclude = {
              function(win)
                return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
              end,
            },
          },
          action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
          end,
        })
      end
      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        mappings = {
          n = { s = flash },
          i = { ["<c-s>"] = flash },
        },
      })
    end,
  }
```

</details>

<details><summary>Continue last search</summary>

```lua
require("flash").jump({continue = true})
```

</details>

## 🌈 Highlights

| Group           | Default      | Description    |
| --------------- | ------------ | -------------- |
| `FlashBackdrop` | `Comment`    | backdrop       |
| `FlashMatch`    | `Search`     | search matches |
| `FlashCurrent`  | `IncSearch`  | current match  |
| `FlashLabel`    | `Substitute` | jump label     |

## 📦 Alternatives

- [leap.nvim](https://github.com/ggandor/leap.nvim)
- [lightspeed.nvim](https://github.com/ggandor/lightspeed.nvim)
- [vim-sneak](https://github.com/justinmk/vim-sneak)
- [mini.jump](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-jump.md)
- [mini.jump2d](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-jump2d.md)
- [hop.nvim](https://github.com/phaazon/hop.nvim)
- [pounce.nvim](https://github.com/rlane/pounce.nvim)
- [sj.nvim](https://github.com/woosaaahh/sj.nvim)
- [nvim-treehopper](https://github.com/mfussenegger/nvim-treehopper)
- [flit.nvim](https://github.com/ggandor/flit.nvim)
