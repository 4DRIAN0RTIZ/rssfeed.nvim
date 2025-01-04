vim.api.nvim_create_user_command("RSSFeed", function(opts)
    require("rssfeed").select_feed()
end, {})

-- Keybindings

vim.api.nvim_set_keymap("n", "<leader>rss", ":RSSFeed<CR>", { noremap = true, silent = true })
