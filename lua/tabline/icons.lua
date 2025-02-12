local M = {}
local hl = require('tabline.highlights')
local config = require('tabline.config')
local utils = require('tabline.utils')

-- Return icon with fg color
M.get_left_separator = function(active, modified)
    if modified == 1 then
        return utils.get_item('TabLineModifiedSeparator', config.get('separator'), active)
    end
    return utils.get_item('TabLineSeparator', config.get('separator'), active)
end

M.get_devicon = function(active, filename, extension)
    local enabled = config.get('show_icon')
    local ok, web = pcall(require, 'nvim-web-devicons')
    if enabled and ok then
        local icon, icon_hl = web.get_icon(filename, extension, { default = true })

        icon = icon .. ' '
        local color = hl.get_color(icon_hl, 'fg')
        hl.highlight(icon_hl .. 'Active', { guifg = color, guibg = hl.c.active_bg })
        if not config.get('color_all_icons') then
            color = hl.c.inactive_text
        end
        hl.highlight(icon_hl .. 'Inactive', { guifg = color, guibg = hl.c.inactive_bg })
        return utils.get_item(icon_hl, icon, active)
    end
    return ''
end

M.get_modified_icon = function(hl_group, active, modified)
    if modified == 1 then
        return utils.get_item(hl_group, config.get('modified_icon') .. ' ', active)
    end
    return ''
end

M.get_close_icon = function(hl_group, index, modified)
    local close_icon = config.get('close_icon')
    if modified == 1 or close_icon == '' then
        return ''
    end
    local active = index == vim.fn.tabpagenr()
    local icon = utils.get_item(hl_group, close_icon .. ' ', active)
    return '%' .. index .. 'X' .. icon .. '%X'
end

M.get_right_separator = function(hl_group, index)
    if index == vim.fn.tabpagenr('$') and config.get('right_separator') then
        return utils.get_item(hl_group, config.get('separator'))
    end
    return ''
end

return M
