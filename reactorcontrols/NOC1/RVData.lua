local term = require ("term")
local component = require ("component")
local c = component.computer
local Re = component.nc_salt_fission_reactor

print("Obtaining Reactor Data")
  ReO = Re.isReactorOn()
  c.beep(1500)
  ReNV = Re.getNumberOfVessels()
  ReVS = Re.getVesselStats()
  ReNH = Re.getNumberOfHeaters()
  ReHS = Re.getHeaterStats()
  c.beep(1500)
print("")
print("Displaying Data")
print("")
  if (ReO == true) then
    print("Reactor is Online")
  else
    print("Reactor is Offline")
  end
print("")
  c.beep(800)
print("Current Vessel Stats")
  for n,e in pairs(ReVS[1]) do
    print(n,e)
  end
print("")
print("Current Cooler Stats")
  for k,v in pairs(ReHS[1]) do
    print(k,v)
  end
c.beep()
c.beep()