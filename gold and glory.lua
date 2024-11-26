require('Il2cppApi')
Il2cpp({il2cppVersion = 29})

-- Define and process methods
local methodGroups = {
    {
        methods = {"CanEquip", "IsSkillEnableWithWeapon", "get_CanJump", "CheckCanStandUp", "get_IsOpen"},
        value = "200080D2C0035FD6r"
    },
    {
        methods = {"get_NeedCondition"},
        value = "000080D2C0035FD6r"
    },
    {
        methods = {"get_AirJumpCount"},
        value = "E0CF8952C0035FD6r"
    }
}

local t = {}
local index = 1

for _, group in ipairs(methodGroups) do
    for _, methodName in ipairs(group.methods) do
        local method = Il2cpp.FindMethods({methodName})

        for x = 1, #method do
            for _, v in ipairs(method[x]) do
                t[index] = {
                    address = "0x" .. v.AddressInMemory,
                    value = group.value,
                    flags = 32,
                    name = methodName .. "\n" .. v.Offset
                }
                index = index + 1
            end
        end
    end
end

gg.setValues(t)
gg.addListItems(t)