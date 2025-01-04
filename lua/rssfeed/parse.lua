local parse = {}

function parse.parse_rss_feed(rss_content)
    local entries = {}
    for title, link in rss_content:gmatch("<item>.-<title><!%[CDATA%[(.-)%]%]></title>.-<link>(.-)</link>.-</item>") do
        table.insert(entries, { title = title, link = link })
    end
    return entries
end

function parse.parse_rss_feed_alternative(rss_content)
    local entries = {}
    for title, link in rss_content:gmatch("<item>.-<title>(.-)</title>.-<link>(.-)</link>.-</item>") do
        table.insert(entries, { title = title, link = link })
    end
    return entries
end

function parse.parse_rss_html_feed(rss_content)
    local entries = {}
    for title, link in rss_content:gmatch("<a href=\"(.-)\".-<h2>(.-)</h2>") do
        table.insert(entries, { title = title, link = link })
    end
    return entries
end

return parse
