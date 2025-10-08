local component = require "component"
local event = require "event"
local term = require "term"
local computer = require "computer"
reactor = component.nc_salt_fission_reactor
gpu = component.gpu

computer.beep()
print("")

print("Gathering Reactor Data")

print("")

onoff = reactor.isReactorOn()
  if(onoff == true) then
  print("Reactor Online")
  else
  print("Reactor Offline")
  end

print("")

wl = reactor.getLengthX()
hl = reactor.getLengthY()
dl = reactor.getLengthZ()
print("Reactor Width / Height / Depth")
print(wl.. " * " ..hl.. " * " ..dl)

print("")

heaters = reactor.getNumberOfHeaters()
vessels = reactor.getNumberOfVessels()
print("Coolers vs Vessels")
print(heaters.. "/" ..vessels)

print("")

currentHeat = reactor.getHeatStored()
maxHeat = reactor.getHeatCapacity()
print("Current Reactor Temp & Max Temp")
print(currentHeat.. "/" ..maxHeat)

print("")

cooling = reactor.getCoolingRate()
eff = reactor.getCoolingEfficiency()*100
hgen = reactor.getNetHeatingRate()
print("Current Cooling Rate / % Efficiency / Net Heat Generation")
print(cooling.. "/" ..eff.. "/" ..hgen)

if (cooling < hgen) then
  computer.beep(1900, 0.1)
  computer.beep(1900, 0.1)
end

print("")

vst = reactor.getVesselStats()
hst = reactor.getHeaterStats()
mst = reactor.getModeratorStats()

computer.beep(1250, 0.1)
print("Current Vessel Stats")
for n,e in pairs(vst[1]) do
    print(n,e)
end
print("")

computer.beep(1000, 0.1)
print("Current Cooler Stats")
for k,v in pairs(hst[1]) do
    print(k,v)
end


computer.beep()

computer.beep()