function table_find(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

require('Il2cppApi')
Il2cpp({il2cppVersion = 29})

local method_groups = {
    {
        class = {name = "InventoryService"},
        method = {
            {name = "CanEquip", value = "200080D2C0035FD6"},
            {name = "CheckItemSearched", value = "200080D2C0035FD6"}
        }
    },
    {
        class = {name = "CharacterLogic"},
        method = {
            {name = "get_AirJumpCount", value = "E0CF8952C0035FD6"}
        }
    },
    {
        class = {name = "InGameSkillService"},
        method = {
            {name = "IsSkillMemoryEnable", value = "200080D2C0035FD6"},
            {name = "IsSkillEnableWithWeapon", value = "200080D2C0035FD6"},
            {name = "IsSkillCanBeCancelled", value = "200080D2C0035FD6"},
            {name = "CheckChangeWeaponTimeAllow", value = "200080D2C0035FD6"}
        }
    },
    {
        class = {name = "SkillLogic"},
        method = {
            {name = "get_IsLocked", value = "000080D2C0035FD6"},
            {name = "IsAllowChangeWeapon", value = "200080D2C0035FD6"}
        }
    },
    {
        class = {name = "ChestBoxLogic"},
        method = {
            {name = "get_IsOpen", value = "200080D2C0035FD6"}
        }
    },
    {
        class = {name = "InteractMimicLogic"},
        method = {
            {name = "get_IsOpen", value = "200080D2C0035FD6"}
        }
    }
}

local function process_methods(group, results, t, index)
    for _, method in ipairs(group.method) do
        local methods = Il2cpp.FindMethods({method.name})
        local offsets = {}

        for x = 1, #methods do
            for _, v in ipairs(methods[x]) do
                if not group.class or group.class.name == v.ClassName then
                    table.insert(offsets, v.Offset)

                    t[index] = {
                        address = "0x" .. v.AddressInMemory,
                        value = method.name == "CanEquip" and method.value or "h" .. method.value,
                        flags = 32,
                        name = string.format([[
ClassName: %s
MethodName: %s
Offset: %s]], v.ClassName, method.name, v.Offset)
                    }
                    index = index + 1
                end
            end
        end

        if #offsets > 0 then
            table.insert(results, {
                methodName = method.name,
                offsets = offsets,
                value = "h" .. method.value
            })
        end
    end
    return index
end

local function write_results_to_file(results, file_name)
    local file = io.open(file_name, "w")
    for _, result in ipairs(results) do
        file:write("MethodName: " .. result.methodName .. "\n")
        file:write("Value: " .. result.value .. "\n")
        file:write("Offsets: " .. table.concat(result.offsets, ", ") .. "\n\n")
    end
    file:close()
end

local results = {}
local t = {}
local index = 1

for _, group in ipairs(method_groups) do
    index = process_methods(group, results, t, index)
end

write_results_to_file(results, "gng_offset.txt")

gg.setValues(t)
gg.addListItems(t)