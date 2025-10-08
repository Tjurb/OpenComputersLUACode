local term = require ("term")
local component = require ("component")
local gpu = component.gpu
local Re = component.nc_salt_fission_reactor
local c = component.computer
local event = require ("event")
local w, h = gpu.getResolution()
count = 0


print("Beginning to Monitor Reactor Temp")
print("")
print("Displaying Heat Information")
print("")
  
  repeat
    ReT = Re.getHeatStored()
    ReTM = Re.getHeatCapacity()
    print("Max Temp / Current Temp")
    print(ReTM.. "/" ..ReT)
    count = count + 1
    print(count)
    if(ReT == 0) then
      gpu.setForeground(0x000000)
      gpu.setBackground(0x009200)
      print("Status OK")
    end
    if(ReT > 300) then
      gpu.setForeground(0x000000)
      gpu.setBackground(0xCCB600)
      print("Temp Rising, Continuing to Monitor")
    end
    if(ReT > (ReTM/2)) then
      gpu.setForeground(0x000000)
      gpu.setBackground(0x990000)
      print("TEMP CRITICAL, INITIATING EMERGENCY SHUTDOWN")
      os.execute("RDeact.lua")
      break
    end        
  until event.pull(1) == "interrupted"