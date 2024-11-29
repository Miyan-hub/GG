local function find_library_base(lib_name, state_filter)
    local ranges = gg.getRangesList(lib_name)
    for _, range in ipairs(ranges) do
        if range.state == state_filter then
            return range.start
        end
    end
    error("Library not found or matching state not available")
end

local function generate_method_table(lib_base, method_list)
    local t = {}
    local index = 1

    for _, method in ipairs(method_list) do
        for _, offset in ipairs(method.offsets) do
            t[index] = {
                address = lib_base + offset,
                flags = 32,
                value = "h" .. method.value,
                name = method.name
            }
            index = index + 1
        end
    end

    return t
end

local lib_name = "libil2cpp.so"
local lib_base = find_library_base(lib_name, "Xa")

local method_list = {
    {name = "CanEquip", offsets = {0x1C83178}, value = "200080D2C0035FD6"},
    {name = "CheckItemSearched", offsets = {0x1C869E8}, value = "200080D2C0035FD6"},
    {name = "get_AirJumpCount", offsets = {0x1B8AF40}, value = "E0CF8952C0035FD6"},
    {name = "IsSkillMemoryEnable", offsets = {0x1C72174}, value = "200080D2C0035FD6"},
    {name = "IsSkillEnableWithWeapon", offsets = {0x1C722A8}, value = "200080D2C0035FD6"},
    {name = "IsSkillCanBeCancelled", offsets = {0x1C732F0}, value = "200080D2C0035FD6"},
    {name = "CheckChangeWeaponTimeAllow", offsets = {0x1C74588}, value = "200080D2C0035FD6"},
    {name = "get_IsLocked", offsets = {0x1B9F8C8}, value = "000080D2C0035FD6"},
    {name = "IsAllowChangeWeapon", offsets = {0x1BA415C}, value = "200080D2C0035FD6"},
    {name = "IsValidLocation", offsets = {0x37baf98}, value = "200080D2C0035FD6"},
    {name = "get_IsOpen", offsets = {0x1B9389C, 0x1B97CAC}, value = "200080D2C0035FD6"}
}

local method_table = generate_method_table(lib_base, method_list)

gg.setValues(method_table)
gg.addListItems(method_table)