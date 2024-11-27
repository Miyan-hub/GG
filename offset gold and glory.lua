local lib = gg.getRangesList("libil2cpp.so")[2].start

local methodList = {
    {name = "CanEquip", offsets = {0x1C83178, 0x1C831EC, 0x1F7B6D4, 0x1F7B954}, value = "200080D2C0035FD6r"},
    {name = "IsSkillEnableWithWeapon", offsets = {0x1C722A8}, value = "200080D2C0035FD6r"},
    {name = "get_CanJump", offsets = {0x1B91030}, value = "200080D2C0035FD6r"},
    {name = "CheckCanStandUp", offsets = {0x1B91048}, value = "200080D2C0035FD6r"},
    {name = "get_NeedCondition", offsets = {0x1B93934, 0x1B95034}, value = "000080D2C0035FD6r"},
    {name = "get_AirJumpCount", offsets = {0x1B8AF40}, value = "E0CF8952C0035FD6r"},
    {name = "get_IsOpen", offsets = {0x1B9389C, 0x1B97CAC, 0x1B99474}, value = "200080D2C0035FD6r"}
}

local t = {}

local index = 1  -- To ensure unique keys for each entry

for i, method in pairs(methodList) do
    for j, offset in ipairs(method.offsets) do
        local address = lib + offset
        t[index] = {
            address = address,
            flags = 32,  -- Assuming this is for 32-bit values
            value = method.value,
            name = method.name
        }
        index = index + 1
    end
end

gg.setValues(t)  -- Apply the changes to memory
gg.addListItems(t)  -- Add the items to the saved list