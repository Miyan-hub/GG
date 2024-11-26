require('Il2cppApi')
Il2cpp({il2cppVersion = 29})

method = Il2cpp.FindMethods({
"CanEquip",
"IsSkillEnableWithWeapon"
})
t = {}
for x = 1,#method do
for i,v in ipairs(method[x]) do
t[i] = {}
t[i].address = "0x"..v.AddressInMemory
t[i].value = "200080D2C0035FD6r"
t[i].flags = 32
end
gg.setValues(t)
gg.addListItems(t)
end
method = Il2cpp.FindMethods({
"IsMember"
})
t = {}
for x = 1,#method do
for i,v in ipairs(method[x]) do
t[i] = {}
t[i].address = "0x"..v.AddressInMemory
t[i].flags = 32
end
gg.addListItems(t)
end