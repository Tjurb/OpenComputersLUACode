local term = require ("term")
local component = require ("component")
local gpu = component.gpu
local c = component.computer
local Re = component.nc_salt_fission_reactor
local He = component.nc_heat_exchanger

print("Beginning Shutdown")
print("")
  Re.deactivate()
  c.beep(500, 0.5)
print("Reactor Shutdown Complete")

repeat
  ReSH =  Re.getHeatStored()
    if(ReSH > 0) then
      print("Reactor Cooling Down")
      print(ReSH)
      print("")
    end
    if(ReSH == 0) then
      print("Reactor Cooling Complete")
      print("Shutting Down Heat Exchanger")
      He.deactivate()
    end
until (ReSH == 0)

c.beep(1500, 0.1)
c.beep(1500, 0.1)

print("Full Shutdown Complete")
print("Please Void Fluids Manually")