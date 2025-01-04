local M = {}
local config = require("rssfeed.config")
local fetch = require("rssfeed.fetch")
local parse = require("rssfeed.parse")
local ui = require("rssfeed.ui")

function M.setup(opts)
    config.setup(opts)
end

function M.get_rss_feed(url)
    local rss_content = fetch.fetch_rss_feed(url)
    if not rss_content or rss_content == "" then
        vim.notify("Failed to fetch RSS feed", vim.log.levels.ERROR)
        return
    end

    local entries = parse.parse_rss_feed(rss_content)
    if #entries == 0 then
        entries = parse.parse_rss_feed_alternative(rss_content)
    end
    if #entries == 0 then
        entries = parse.parse_rss_html_feed(rss_content)
    end
    if #entries == 0 then
        vim.notify("No entries found in the RSS feed", vim.log.levels.INFO)
        return
    end

    ui.display_in_floating_window(entries)
end

function M.select_feed()
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    pickers.new({}, {
        prompt_title = "Select RSS Feed",
        finder = finders.new_table({
            results = config.options.feeds,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry.name,
                    ordinal = entry.name,
                }
            end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                if selection then
                    M.get_rss_feed(selection.value.url)
                end
            end)
            map("n", "q", function()
                actions.close(prompt_bufnr)
            end)
            return true
        end,
    }):find()
end

return M
