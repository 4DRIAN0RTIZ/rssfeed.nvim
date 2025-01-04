local ui = {}
local config = require("rssfeed.config")

local line_to_link = {}

function ui.display_in_floating_window(entries)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "modifiable", true)

    line_to_link = {}

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

    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<cmd>lua require('rssfeed.ui').open_line()<CR>", { noremap = true, silent = true })

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })
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
