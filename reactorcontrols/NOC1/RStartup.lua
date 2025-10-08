local term = require ("term")
local component = require ("component")
local c = component.computer
local Re = component.nc_salt_fission_reactor
local He = component.nc_heat_exchanger

print("Beginning Reactor Startup")
print("Please Wait...")

  He.activate()
  c.beep()
  print("")
  Re.activate()
  c.beep()
  print("")

print("Reactor Online")
