local config = {}

config.default = {
    open_cmd = "xdg-open",
    feeds = {
        { name = "Dotfyle", url = "https://dotfyle.com/neovim/plugins/rss.xml" },
        { name = "La Cueva del NeanderTech", url = "https://neandertech.netlify.app/blog/rss.xml" },
        { name = "HackerNews", url = "https://hnrss.org/frontpage" },
        { name = "Dev.to", url = "https://dev.to/feed" },
        { name = "El Financiero", url = "https://www.elfinanciero.com.mx/arc/outboundfeeds/rss/?outputType=xml" },
        { name = "GenBeta", url = "https://www.genbeta.com/tag/desarrollo/rss2.xml" },
        { name = "TechCrunch", url = "https://techcrunch.com/feed/" },
        { name = "Smashing Magazine", url = "https://www.smashingmagazine.com/feed/" },
        { name = "CSS Tricks", url = "https://css-tricks.com/feed/" },
        { name = "HiperTextual", url = "https://hipertextual.com/feed" },
        { name = "UnoCero", url = "https://www.unocero.com/feed/" },
    }
}

config.options = {}

function config.setup(opts)
    config.options = vim.tbl_deep_extend("force", {}, config.default, opts or {})
end

return config
