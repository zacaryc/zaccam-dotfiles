
local custom_hybrid = require('lualine.themes.seoul256')

-- CUSTOM THEME SETUP
local colors = {
  text         = '#BCBCBC',
  black        = '#282828',
  white        = '#ebdbb1',
  red          = '#fb4934',
  green        = '#5F875F',
  blue         = '#83a598',
  lightpurple  = '#A787AF',
  purple       = '#5F005F',
  yellow       = '#fe8019',
  gray         = '#a89984',
  darkgray     = '#3c3836',
  lightgray    = '#504945',
  inactivegray = '#7c6f64',
}

-- Vim Mode
custom_hybrid.normal.a.bg = colors.green
custom_hybrid.normal.a.fg = '#D7FFAF'
custom_hybrid.normal.a.gui = 'bold'
custom_hybrid.visual.a.bg = '#E84646'
custom_hybrid.visual.a.fg = colors.text
custom_hybrid.insert.a.bg = '#E84646'
custom_hybrid.insert.a.fg = colors.text
-- Diff/Fugitive
custom_hybrid.normal.b.bg = '#262626'

-- CUSTOM FUNCTION
local function mixed_indent ()
    local space_pat = [[\v^ +]]
    local tab_pat = [[\v^\t+]]
    local space_indent = vim.fn.search(space_pat, 'nwc')
    local tab_indent = vim.fn.search(tab_pat, 'nwc')
    local mixed = (space_indent > 0 and tab_indent > 0)
    local mixed_same_line
    if not mixed then
        mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
        mixed = mixed_same_line > 0
    end
    if not mixed then return '' end
    if mixed_same_line ~= nil and mixed_same_line > 0 then
        return 'mixed-indent: ['..mixed_same_line..']'
    end
    local space_indent_cnt = vim.fn.searchcount({pattern=space_pat, max_count=1e3}).total
    local tab_indent_cnt =  vim.fn.searchcount({pattern=tab_pat, max_count=1e3}).total
    if space_indent_cnt > tab_indent_cnt then
        return 'mixed-indent: ['..tab_indent..']'
    else
        return 'mixed-indent: ['..space_indent..']'
    end
end


local function trailing_whitespace()
    local space = vim.fn.search([[\s\+$]], 'nwc')
    return space ~= 0 and "TW:"..space or ""
end

local function custom_location()
    local line = vim.fn.line('.')
    local total_lines = vim.fn.line('$')
    local col = vim.fn.virtcol('.')
    return string.format(':%d/%d :%d', line, total_lines, col)
end

local config = {
  options = {
    icons_enabled = true,
    -- theme = 'auto',
    theme = custom_hybrid,
    -- theme = 'tokyonight',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
                    {'FugitiveHead', icon = ''},
                    { 'diff',
                        diff_color = {
                            removed = { fg = colors.red },
                        },
                    },
                    'diagnostics',
                },
    lualine_c = {
                    {'filename', path = 1, color = { fg = colors.text }, },
                },
    lualine_x = {
                    {'filetype',
                        colored = true,
                        icon = { align = 'right'},
                        color = { fg = colors.text },
                    },
                    'encoding',
                    'fileformat',
                },
    lualine_y = {
                    {'progress', color = { bg = colors.green }},
                    { custom_location, color = { bg = colors.green }},
                },
    lualine_z = {
                    {
                        mixed_indent,
                        color = { bg = colors.purple, fg = colors.lightpurple }
                    },
                    {
                        function()
                            local space = vim.fn.search([[\s\+$]], 'nwc')
                            return space ~= 0 and "TW:"..space or ""
                        end,
                        color = { bg = colors.red, }
                    },
                }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
}

require('lualine').setup(config)
