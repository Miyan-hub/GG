function table.find(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

require('Il2cppApi')
Il2cpp({il2cppVersion = 29})

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

local results = {}
local t = {}
local index = 1

for _, group in ipairs(methodGroups) do
    for _, methodName in ipairs(group.methodName) do
        local method = Il2cpp.FindMethods({methodName})
        local offsets = {}

        for x = 1, #method do
            for _, v in ipairs(method[x]) do
                if not group.className or table.find(group.className, v.ClassName) then
                    table.insert(offsets, v.Offset)
                    
                    t[index] = {
                        address = "0x" .. v.AddressInMemory,
                        value = group.value,
                        flags = 32,
                        name = [[
ClassName: ]]..v.ClassName..[[

MethodName: ]]..v.MethodName..[[

Offset: ]]..v.Offset
                    }
                    index = index + 1
                end
            end
        end

        if #offsets > 0 then
            table.insert(results, {
                methodName = methodName,
                offsets = offsets,
                value = group.value
            })
        end
    end
end

local file = io.open("gng_offset.txt", "w")

for _, result in ipairs(results) do
    file:write("MethodName: " .. result.methodName .. "\n")
    file:write("Value: " .. result.value .. "\n")
    file:write("Offsets: " .. table.concat(result.offsets, ", ") .. "\n\n")
end

file:close()

gg.setValues(t)
gg.addListItems(t)