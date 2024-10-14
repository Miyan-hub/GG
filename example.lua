require('Il2cppApi')
Il2cpp({il2cppVersion = 29})
gg.showUiButton()

function ClassByName()
local menu = gg.prompt({"Class Name"},{},{"text"})
if not menu then return end
if menu[1] == "" then return end
class = Il2cpp.FindClass({{Class = menu[1], FieldsDump = true, MethodsDump = true}})
print(class)
end

function FieldByName()
local menu = gg.prompt({"Field Name"},{},{"text"})
if not menu then return end
if menu[1] == "" then return end
field = Il2cpp.FindFields({menu[1]})
print(field)
end

function MethodByName()
local menu = gg.prompt({"Methods Name"},{},{"text"})
if not menu then return end
if menu[1] == "" then return end
method = Il2cpp.FindMethods({
menu[1]
})
t = {}
for x = 1,#method do
for i,v in ipairs(method[x]) do
t[i] = {}
t[i].address = "0x"..v.AddressInMemory
t[i].flags = 4
t[i].name = [[
ClassName: ]]..v.ClassName..[[

Name: ]]..v.MethodName..[[

Offset: ]]..v.Offset
end
gg.addListItems(t)
end

end

function Home()
local menu = gg.choice({"Class By Name","Field By Name","Method By Name"},nil,"Ｍｉｙａｎ")
if not menu then return end
if menu == 1 then
ClassByName()
end
if menu == 2 then
FieldByName()
end
if menu == 3 then
MethodByName()
end
end

while true do
if gg.isClickedUiButton() then
gg.setVisible(false)
Home()
end
end
