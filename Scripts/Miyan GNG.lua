local function find_library_base(lib_name, state_filter)
    local ranges = gg.getRangesList(lib_name)
    for _, range in ipairs(ranges) do
        if range.state == state_filter then
            return range.start
        end
    end
    gg.alert("Library not found or matching state not available")
    return nil
end

local function generate_method_table(lib_base, method)
    local t = {}
    local value = method.value

    for _, offset in ipairs(method.offsets) do
        table.insert(t, {
            address = lib_base + offset,
            flags = 32,
            value = "h" .. value,
            name = method.name
        })
    end

    return t
end

local target_info = gg.getTargetInfo()
local is64bit = target_info.x64
local arch = is64bit and "64-bit" or "32-bit"
gg.toast("Detected architecture: " .. arch)

local lib_name = "libil2cpp.so"
local lib_base = find_library_base(lib_name, "Xa")
if not lib_base then return end

local method_list_64bit = {
    {name = "Unlimited Jump", offsets = {0x1B8AF40}, value = "E0CF8952C0035FD6"},
    {name = "Equip All Armor", offsets = {0x1C83178}, value = "200080D2C0035FD6"},
    {name = "Use Skill Without Weapon", offsets = {0x1C722A8}, value = "200080D2C0035FD6"},
    {name = "See Items Color in Chest", offsets = {0x1B9389C, 0x1B97CAC}, value = "200080D2C0035FD6"},
    {name = "Skip Search Loot", offsets = {0x1C869E8}, value = "200080D2C0035FD6"},
    {name = "Attack Team", offsets = {0x1BAE180}, value = "000080D2C0035FD6"}
}

local method_list_32bit = {
    {name = "Unlimited Jump", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Equip All Armor", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Use Skill Without Weapon", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "See Items Color in Chest", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Skip Search Loot", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Attack Team", offsets = {0x0000000}, value = "0000000000000000"}
}

local method_list = is64bit and method_list_64bit or method_list_32bit

local method_status = {}
local original_values = {}

for _, method in ipairs(method_list) do
    method_status[method.name] = false
    original_values[method.name] = {}
end

local function show_menu()
    local choices = {}
    local default_choices = {}

    for i, method in ipairs(method_list) do
        table.insert(choices, method.name .. (method_status[method.name] and " [ON]" or " [OFF]"))
        table.insert(default_choices, method_status[method.name])
    end

    local selected = gg.multiChoice(choices, nil, "Select features to toggle")

    if selected then
        for i, _ in pairs(selected) do
            local method_table = generate_method_table(lib_base, method_list[i])
            if method_status[method_list[i].name] then
                -- Restore original values
                gg.setValues(original_values[method_list[i].name])
                gg.toast(method_list[i].name .. " disabled")
            else
                -- Save current values
                for _, entry in ipairs(method_table) do
                    table.insert(original_values[method_list[i].name], gg.getValues({entry})[1])
                end
                -- Apply new values
                gg.setValues(method_table)
                gg.toast(method_list[i].name .. " enabled")
            end
            method_status[method_list[i].name] = not method_status[method_list[i].name]
        end
    else
        gg.toast("No feature selected")
    end
end

while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        show_menu()
    end
end
