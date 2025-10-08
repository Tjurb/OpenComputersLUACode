local term = require ("term")
local component = require ("component")
local gpu = component.gpu
local c = component.computer
local Re = component.nc_salt_fission_reactor
local He = component.nc_heat_exchanger
local Tu = component.it_steam_turbine
local Ta = component.tank_controller
local event = require ("event")
count = 0
gpu.setResolution(160,50)
local w,h = gpu.getResolution()

-- Function to draw bars
local function drawBars()
    --Bar Math ReO==True
    if(ReO==true) then
        ReHE = Re.getHeaterStats()
        ReVS = Re.getVesselStats()
        ReHC = Re.getHeatCapacity()
        ReHS = Re.getHeatStored()
        ReNH = Re.getNumberOfHeaters()
        ReNV = Re.getNumberOfVessels()

        --Fuel Math
        countF = getProcessingPercentVessels()
        if(countF ~= 0) then
            fx = math.floor(38*countF)
        else
            fx = 0
        end
		
        --Heat Math
        hmax = (ReHC/2)
        if(hmax >= ReHS) then
            s1 = (hmax-ReHS)
            s2 = (s1/hmax)
            resultH = math.floor(s2* 38)
            hx = resultH
        else
            hx = 0
        end

        --Internal Coolant Math
        countC = getProcessingPercentHeaters()
        if(countC ~= 0) then
            cx = math.floor(38*countC)
        else
            cx = 0
        end
		
        --External Coolant Math
        countEC = TaTL
        if(countEC ~= 0) then
            ecx = math.floor(38*countEC)
        else
            ecx = 0
        end
    end

    --Bar Math ReO==False
    if(ReO==false) then
        ReHE = Re.getHeaterStats()
        ReVS = Re.getVesselStats()
        ReHC = Re.getHeatCapacity()
        ReHS = Re.getHeatStored()
        ReNH = Re.getNumberOfHeaters()
        ReNV = Re.getNumberOfVessels()


        --Fuel Math
        countF = getProcessingPercentVessels()
        if(countF ~= 0) then
            fx = math.floor(38*countF)
        end
		
        --Heat Math
        hmax = (ReHC/2)
        if(ReHS <= temphold) then
            s1 = (hmax-ReHS)
            s2 = (s1/hmax)
            resultH = math.floor(s2* 38)
            hx = resultH
        end

        --Internal Coolant Math
        countC = getProcessingPercentHeaters()
        if(countC ~= 0) then
            cx = math.floor(38*countC)
        end

		--External Coolant Math
        countEC = TaTL
        if(countEC ~= 0) then
            ecx = math.floor(38*countEC)
        end
    end

    --Draw Bars
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0x000000)
    gpu.set(100, 2, "   Fuel   ")
    gpu.set(115, 2, "   Heat   ")
    gpu.set(130, 2, " ICoolent ")
    gpu.set(145, 2, " ECoolent ")
    gpu.setBackground(0xFFFFFF)
    gpu.fill(100, 5, 10, 40, " ")
    gpu.fill(115, 5, 10, 40, " ")
    gpu.fill(130, 5, 10, 40, " ")
    gpu.fill(145, 5, 10, 40, " ")
    --Draw Bar Fills
    gpu.setBackground(0x006D40)
    gpu.fill(102, 6, 6, 38, " ")
    gpu.setBackground(0xCC0000)
    gpu.fill(117, 6, 6, 38, " ")
    gpu.setBackground(0x00DBFF)
    gpu.fill(132, 6, 6, 38, " ")
    gpu.setBackground(0x66B6FF)
    gpu.fill(147, 6, 6, 38, " ")

    gpu.setBackground(0x000000)
    --Fuel Bar Fill
    gpu.fill(102, 6, 6, fx, " ")
    --Heat Bar Fill
    gpu.fill(117, 6, 6, hx, " ")
    --Internal Cooling Bar Fill
    gpu.fill(132, 6, 6, cx, " ")
    --External Cooling Bar Fill
    gpu.fill(147, 6, 6, ecx, " ")
end 

-- Function for getting Vessel Data
function getProcessingPercentVessels()
    ReVS = Re.getVesselStats()
    ReNV = Re.getNumberOfVessels()
    -- Clear the previous values in the table
    isprocessing = 0
    value = 0
    for i = ReNV,1,-1 do
        for _, e in pairs(ReVS[i]) do
            if(e == true) then
                isprocessing = isprocessing + 1
            end
        end
    end
    value = (ReNV-isprocessing)
    return (value/ReNV)
end

-- Function for getting Heater Data
function getProcessingPercentHeaters()
    ReHE = Re.getHeaterStats()
    ReNH = Re.getNumberOfHeaters()
    -- Clear the previous values in the table
    isprocessing = 0
    value = 0
    for i = ReNH,1,-1 do
        for _, e in pairs(ReHE[i]) do
            if(e == true) then
                isprocessing = isprocessing + 1
            end
        end
    end
    value = (ReNH-isprocessing)
    return (value/ReNH)
end

-- Function to Calculate Energy Production
function getEnergyProduction()
    value = ((12288/1800)*TuSp)
    if (tnum == 0) then
        return (value)
    else
        value = value * tnum
        return (value)
    end
end

-- Function to Get the Total Number of Turbines
function getNumTurbines()
    local tlist= {}
    local value = 0
    for address in component.list('it_steam_turbine') do
        local turb = component.proxy(address)
        table.insert(tlist, turb)
    end
    value = #tlist
    return (value)
end

-- Function to draw the GUI
local function drawGUI()
    local REO = ("")
    local HEO = ("")
    local TUO = ("")
    local Energy = getEnergyProduction()

    if (ReO==true) then
        REO = ("Online")
    else
        REO = ("Offline")
    end

    if (HeO==true) then
        HEO = ("Online")
    else
        HEO = ("Offline")
    end

    if (TuSp>0) then
        TUO = ("Online")
    else
        TUO = ("Offline")
    end

    -- Draw R Startup button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(8, 7, 26, 3, " ")  -- Button area
    gpu.set(9, 8,  "    Reactor Startup!    ")  -- Button label

    -- Draw R Shutdown button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(38, 7, 26, 3, " ")  -- Button area
    gpu.set(39, 8, "   Reactor  ShutDown!   ")  -- Button label
    
    -- Draw H Startup button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(8, 11, 26, 3, " ")  -- Button area
    gpu.set(9, 12, " Heat Exchanger Startup!")  -- Button label
 
    -- Draw H Shutdown button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(38, 11, 26, 3, " ")  -- Button area
    gpu.set(39, 12, "Heat Exchanger ShutDown!")  -- Button label
	
	-- Draw Program Exit button
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0xFF0000)
    gpu.fill(w-27, h-4, 26, 3, " ")  -- Button area
    gpu.set(w-26, h-3, " E x i t  P r o g r a m ")  -- Button label

    
    -- Draw Reactor Data
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0x000000)
    gpu.fill(9, 14, 88, 50, " ")

    --Draw Warning
    if(ReHS > temphold) then
        gpu.setForeground(0x000000)
        gpu.setBackground(0xFFB600)
        gpu.fill(10, 23, 26, 3, " ")
        gpu.set(11, 24, "REACTOR TEMP: INCREASING")
        temphold = ReHS
    elseif (ReHS < temphold) then
        gpu.setForeground(0x000000)
        gpu.setBackground(0x00B6FF)
        gpu.fill(10, 23, 26, 3, " ")
        gpu.set(11, 24, "REACTOR TEMP: DECREASING")
        temphold = ReHS
    else
        gpu.setForeground(0xFFFFFF)
        gpu.setBackground(0x000000)
        gpu.fill(10, 23, 26, 3, " ")
        gpu.set(11, 24, "REACTOR TEMP:  STABLE   ")
        temphold = ReHS
    end

    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0x000000)
    --Reactor Data
    gpu.set(10, 28, "Reactor Status:       " ..REO)
    gpu.set(10, 30, "Reactor X:            " ..ReX)
    gpu.set(10, 31, "Reactor Y:            " ..ReY)
    gpu.set(10, 32, "Reactor Z:            " ..ReZ)
    gpu.set(10, 33, "Number of Vessels:    " ..ReNV)
    gpu.set(10, 34, "Number of Coolers:    " ..ReNH)
    gpu.set(10, 35, "Number of Moderators: " ..ReNM)
    gpu.set(10, 36, "Reactor Max Temp:     " ..ReHC)
    gpu.set(10, 37, "Reactor Current Temp: " ..ReHS)
    gpu.set(10, 38, "Cooling Rate:         " ..(ReCR*20))
    gpu.set(10, 39, "Raw Heating Rate:     " ..(ReRHR*20))
    gpu.set(10, 40, "Net Heating Rate:     " ..(ReNHR*20))

    --Heat Exhanger Data
    gpu.set(45, 28, "Heat Exchanger Status: " ..HEO)
    gpu.set(45, 30, "Exchanger X:           " ..HeX)
    gpu.set(45, 31, "Exchanger Y:           " ..HeY)
    gpu.set(45, 32, "Exchanger Z:           " ..HeZ)
    gpu.set(45, 33, "Exchanger Tubes:       " ..HeNe)

    --Turbine Data
    gpu.set(45, 35, "Main Turbine Status:   " ..TUO)
    gpu.set(45, 36, "Main Turbine Speed:    " ..TuSp)
    gpu.set(45, 37, "Number of Turbines:    " ..tnum)

    --Excess Coolant Data
    gpu.set(45, 39, "Excess Coolant Cap:    " ..TaTC)
    gpu.set(45, 40, "Excess Coolant Level:  " ..TaTL)

    --Energy Output
    gpu.set(10, 45, "Energy Output:        " ..Energy)

    if(ReNHR > 0 ) then
        gpu.setForeground(0x000000)
        gpu.setBackground(0xFF0000)
        gpu.fill(10, 19, 51, 3, " ")
        gpu.set(11, 20, "Raw Heating Rate higher than Cooling Rate")
        if(ReO == true) then
            c.beep(500, 0.1)
            c.beep(500, 0.1)
        end
    end
end

-- Function to draw the Warning
local function temptest()
    if ReHS > (ReHC / 2) then
        switchA = 1
        switchB = 1
        Re.deactivate()
        gpu.setForeground(0x000000)
        gpu.setBackground(0xFF0000)
        gpu.fill(0, 23, w, 6, " ")
        gpu.set(53, 25,  " REACTOR TEMP CRITICAL : EMERGENCY SHUTDOWN INITIATED ")
        gpu.set(53, 26,  " REACTOR TEMP CRITICAL : EMERGENCY SHUTDOWN INITIATED ")
        c.beep(500, 0.5)
        c.beep(500, 0.5)
        c.beep(500, 0.5)
    end

    if (switchA == 1) then
        gpu.setForeground(0xFFFFFF)
        gpu.setBackground(0x000000)
        gpu.fill(0, 23, w, 6, " ")
        switchA = 0
    end

    --Draw Alert
    if (switchB == 1)then
        gpu.setForeground(0x000000)
        gpu.setBackground(0xFF0000)
        gpu.fill(50, 23, 27, 3, " ")
        gpu.set(51, 24, "REACTOR EMERGENCY SHUTDOWN")
    end

    if (ReHS == 0) then
        if(switchB == 1) then
            gpu.setForeground(0xFFFFFF)
            gpu.setBackground(0x000000)
            gpu.fill(0, 0, w, h, " ")  -- Clear the screen
            switchB = 0
        end
    end
end

-- Function to handle button click
local function handleClick(x, y)
    if x >= 8 and x <= 34 and y >= 7 and y <= 9 then
        -- " R H Startup!" button clicked
        He.activate()
        c.beep()
        Re.activate()
        c.beep()
    elseif x >= 38 and x <= 64 and y >= 7 and y <= 9 then
        -- "R Shutdown!" button clicked
        Re.deactivate()
        c.beep(500, 0.5)
    elseif x >= 8 and x <= 34 and y >= 11 and y <= 13 then
        -- "H Startup!" button clicked
        He.activate()
        c.beep(500, 0.5)
    elseif x >= 38 and x <= 64 and y >= 11 and y <= 13 then
        -- "H Shutdown!" button clicked
        He.deactivate()
        c.beep(500, 0.5)
    elseif x >= w-27 and x <= w-1 and y >= h-4 and y <= h-1 then
        -- "Exit Program" button clicked
		Re.deactivate()
		c.beep(500, 0.5)
        He.deactivate()
        c.beep(500, 0.5)
		gpu.fill(1, 1, w, h, " ")  -- Clear the screen
		os.exit()
    end
end

-- Main loop
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")  -- Clear the screen
while true do
    -- Aquire Status
    ReO = Re.isReactorOn()
    HeO = He.isHeatExchangerOn()

    -- Aquire Reactor Info
    ReX = Re.getLengthX()
    ReY = Re.getLengthY()
    ReZ = Re.getLengthZ()
    ReHS = Re.getHeatStored()
    ReHC = Re.getHeatCapacity()
    ReCR = Re.getCoolingRate()
    ReRHR = Re.getRawHeatingRate()
    ReNHR = Re.getNetHeatingRate()
    ReNV = Re.getNumberOfVessels()
    ReNH = Re.getNumberOfHeaters()
    ReNM = Re.getNumberOfModerators()
    ReVS = Re.getVesselStats()
    ReHE = Re.getHeaterStats()

    -- Aquire Heat Exchanger Info
    HeX = He.getLengthX()
    HeY = He.getLengthY()
    HeZ = He.getLengthZ()
    HeNe = He.getNumberOfExchangerTubes()

    -- Aquire Turbine Data
    TuSp = Tu.getSpeed()
    tnum = getNumTurbines()

    -- Aquire Excess Coolant Tank Info
    TaTC = Ta.getTankCapacity(4)
    TaTL = Ta.getTankLevel(4)

    -- Variables Used in GUI and Functions
    temphold = 0 
    switchA = 0
    switchB = 0
    countF = 0
    countC = 0
    hx = 0
    cx = 0
    ecx = 0
    fx = 0

    drawGUI()
    drawBars()
    temptest()

    local _, _, x, y, button, player = event.pull(1,"touch")
    if x and y then
        handleClick(x, y)
    end
    count = count + 1
end