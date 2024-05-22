
local custom_hybrid = require('lualine.themes.seoul256')

custom_hybrid.normal.a.bg = '#B5BD68'
-- custom_hybrid.normal.z.bg = '#B5BD68'
-- custom_hybrid.normal.a.bg = '#8C9440'
	local function mixed_indent()
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
		 return 'MI:'..mixed_same_line
	  end
	  local space_indent_cnt = vim.fn.searchcount({pattern=space_pat, max_count=1e3}).total
	  local tab_indent_cnt =  vim.fn.searchcount({pattern=tab_pat, max_count=1e3}).total
	  if space_indent_cnt > tab_indent_cnt then
		return 'MI:'..tab_indent
	  else
		return 'MI:'..space_indent
	  end
	end

local config = {
  options = {
    icons_enabled = true,
    -- theme = 'auto',
    theme = custom_hybrid,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {
                    {'filename', path = 1, }
                },
    lualine_x = {},
    lualine_y = {
                    {'filetype',
                        colored = true,
							icon = { align = 'right'}
                    },
                    'fileformat',
                    'encoding'
                },
    lualine_z = {'mixed_indent', 'progress', 'location'}
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

-- require('lualine').setup(config)
