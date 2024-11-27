lib = gg.getRangesList("libil2cpp.so")

for index, range in ipairs(lib) do
    if range.state == "Xa" then
        lib = range.start
        break
    end
end

methodList = {
    {name = "CanEquip", offsets = {0x1C83178}, value = "200080D2C0035FD6r"},
    {name = "CheckItemSearched", offsets = {0x1C869E8}, value = "200080D2C0035FD6r"},
    {name = "get_AirJumpCount", offsets = {0x1B8AF40}, value = "E0CF8952C0035FD6r"},
    {name = "IsSkillMemoryEnable", offsets = {0x1C72174}, value = "200080D2C0035FD6r"},
    {name = "IsSkillEnableWithWeapon", offsets = {0x1C722A8}, value = "200080D2C0035FD6r"},
    {name = "IsSkillCanBeCancelled", offsets = {0x1C732F0}, value = "200080D2C0035FD6r"},
    {name = "CheckChangeWeaponTimeAllow", offsets = {0x1C74588}, value = "200080D2C0035FD6r"},
    {name = "get_IsLocked", offsets = {0x1B9F8C8}, value = "000080D2C0035FD6r"},
    {name = "IsAllowChangeWeapon", offsets = {0x1BA415C}, value = "200080D2C0035FD6r"},
    {name = "get_IsOpen", offsets = {0x1B9389C, 0x1B97CAC}, value = "200080D2C0035FD6r"}
}

t = {}

index = 1

for i, method in pairs(methodList) do
    for j, offset in ipairs(method.offsets) do
        address = lib + offset
        t[index] = {
            address = address,
            flags = 32,
            value = method.value,
            name = method.name
        }
        index = index + 1
    end
end

gg.setValues(t)
gg.addListItems(t)