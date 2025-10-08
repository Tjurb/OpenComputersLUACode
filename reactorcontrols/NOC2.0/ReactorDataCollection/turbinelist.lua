local term = require ("term")
local component = require ("component")

local tlist = {}

print(component.it_steam_turbine == component.getPrimary('it_steam_turbine'))
print(component.list('it_steam_turbine'))

for address in component.list('it_steam_turbine') do
  local turb = component.proxy(address)
  table.insert(tlist, turb)
end

print(#tlist)