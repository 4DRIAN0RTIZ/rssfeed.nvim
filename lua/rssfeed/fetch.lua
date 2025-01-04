local fetch = {}

function fetch.fetch_rss_feed(url)
    local handle = io.popen("curl -s -L " .. url)
    local result = handle:read("*a")
    handle:close()
    return result
end

return fetch
