local term = require ("term")
local component = require ("component")
local He = component.nc_heat_exchanger
local c = component.computer

print("Obtaining Heat Exchanger Data")
  c.beep(200,1)
  HeO = He.isHeatExchangerOn()
  HeX = He.getLengthX()
  HeY = He.getLengthY()
  HeZ = He.getLengthZ()
  print("")
  c.beep(200,1)
  HeTA = He.getFractionOfTubesActive()
  HeNT = He.getNumberOfExchangerTubes()
  c.beep(800)
print("Displaying Data")
  c.beep(800)
print("")
  if (HeO == true) then
  print("Heat Exchanger Online")
  else
  print("Heat Exchanger Offline")
  end
print("")
print("Lenght / Height / Depth")
print(HeX,HeY,HeZ)
print("")
print("Number of Tubes vs Active Percentage")
print(HeNT,HeTA*100)

  