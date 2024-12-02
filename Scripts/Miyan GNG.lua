local function fetch_and_execute_script(url)
    local content = gg.makeRequest(url).content
    if not content then
        gg.alert("Failed to fetch script from URL.")
        return
    end
    local func, err = pcall(load(content))
    if not func then
        gg.alert("Error loading script: " .. err)
    end
end

local script_url = "https://pastebin.com/raw/itsHS0BJ"
fetch_and_execute_script(script_url)