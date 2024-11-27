require('Il2cppApi')
Il2cpp({il2cppVersion = 29})

function table.find(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

local methodGroups = {
    {
        methodName = {"CanEquip", "IsSkillEnableWithWeapon", "get_CanJump", "CheckCanStandUp"},
        value = "200080D2C0035FD6r"
    },
    {
        methodName = {"get_NeedCondition"},
        value = "000080D2C0035FD6r"
    },
    {
        methodName = {"get_AirJumpCount"},
        value = "E0CF8952C0035FD6r"
    },
    {
        className = {"ChestBoxLogic", "MechanismChestLogic", "InteractMimicLogic"},
        methodName = {"get_IsOpen"},
        value = "200080D2C0035FD6r"
    }
}

local t = {}
local index = 1

for _, group in ipairs(methodGroups) do
    for _, methodName in ipairs(group.methodName) do
        local method = Il2cpp.FindMethods({methodName})

        for x = 1, #method do
            for _, v in ipairs(method[x]) do
                if not group.className or table.find(group.className, v.ClassName) then
                    t[index] = {
                        address = "0x" .. v.AddressInMemory,
                        value = group.value,
                        flags = 32,
                        name = [[
ClassName: ]]..v.ClassName..[[

Name: ]]..v.MethodName..[[

Offset: ]]..v.Offset
                    }
                    index = index + 1
                end
            end
        end
    end
end

gg.setValues(t)
gg.addListItems(t)