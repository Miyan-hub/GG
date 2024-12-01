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

local function generate_method_table(lib_base, method, active)
    local t = {}
    local value = active and "h" .. method.value or original_values[method.name][1].value
    
    for _, offset in ipairs(method.offsets) do
        table.insert(t, {
            address = lib_base + offset,
            flags = 32,
            value = value,
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
    {name = "Skip Search Loot", offsets = {0x1C869E8}, value = "200080D2C0035FD6"}
}

local method_list_32bit = {
    {name = "Unlimited Jump", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Equip All Armor", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Use Skill Without Weapon", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "See Items Color in Chest", offsets = {0x0000000}, value = "0000000000000000"},
    {name = "Skip Search Loot", offsets = {0x0000000}, value = "0000000000000000"}
}

local method_list = is64bit and method_list_64bit or method_list_32bit

local feature_states = {
    ["Unlimited Jump"] = false,
    ["Equip All Armor"] = false,
    ["Use Skill Without Weapon"] = false,
    ["See Items Color in Chest"] = false,
    ["Skip Search Loot"] = false
}

local original_values = {}

local function save_original_values()
    for _, method in ipairs(method_list) do
        local values = {}
        for _, offset in ipairs(method.offsets) do
            table.insert(values, {address = lib_base + offset, flags = 32})
        end
        original_values[method.name] = gg.getValues(values)
    end
end

save_original_values()

local function show_menu()
    local choices = {}
    for _, method in ipairs(method_list) do
        table.insert(choices, method.name .. (feature_states[method.name] and " (ON)" or " (OFF)"))
    end

    local selected = gg.multiChoice(choices, nil, "Select features to toggle")

    if selected then
        for i, _ in pairs(selected) do
            local feature_name = method_list[i].name
            feature_states[feature_name] = not feature_states[feature_name]
            local method_table = generate_method_table(lib_base, method_list[i], feature_states[feature_name])
            gg.setValues(method_table)
            gg.toast(feature_name .. (feature_states[feature_name] and " active" or " nonactive"))
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