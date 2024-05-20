vim.cmd[[
    if exists('g:loaded_indent_guides')
        " indent-guides
        let g:indent_guides_start_level = 2
        let g:indent_guides_guide_size = 1
        let g:indent_guides_color_change_percent = 5
        :IndentGuidesEnable
    endif
]]
