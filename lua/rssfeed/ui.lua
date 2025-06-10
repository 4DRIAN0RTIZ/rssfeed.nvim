local ui = {}
local config = require("rssfeed.config")
local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local line_to_link = {}

function ui.display_in_floating_window(entries)
    line_to_link = {}

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
        },
        relative = "editor",
        position = "50%",
        size = {
            width = width,
            height = height,
        },
    })

    popup:mount()

    local buf = popup.bufnr
    vim.api.nvim_buf_set_option(buf, "modifiable", true)

    local lines = {}
    local line_num = 1

    for _, entry in ipairs(entries) do
        table.insert(lines, entry.title)
        line_num = line_num + 1

        table.insert(lines, entry.link)
        line_to_link[line_num] = entry.link
        line_num = line_num + 1

        table.insert(lines, "")
        line_num = line_num + 1
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    vim.keymap.set("n", "q", function()
        popup:unmount()
    end, { buffer = buf, noremap = true, silent = true })

    vim.keymap.set("n", "<CR>", function()
        ui.open_line()
    end, { buffer = buf, noremap = true, silent = true })

    popup:on(event.BufLeave, function()
        popup:unmount()
    end)
end

function ui.open_link(link)
    if not link or link == "" then
        vim.notify("No valid link to open", vim.log.levels.ERROR)
        return
    end
    os.execute(string.format("%s '%s'", config.options.open_cmd, link))
end

function ui.open_line()
    local current_line = vim.fn.line(".")
    local link = line_to_link[current_line]
    if link then
        ui.open_link(link)
        vim.cmd("close")
    else
        vim.notify("No link on this line", vim.log.levels.WARN)
    end
end

return ui
