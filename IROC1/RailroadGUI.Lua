local term = require ("term")
local component = require ("component")
local gpu = component.gpu
local c = component.computer
local RC = component.ir_remote_control
local g = component.geolyzer
local re = component.redstone
local r = component.relay
local event = require ("event")
count = 0
gpu.setResolution(160,50)
local w,h = gpu.getResolution()
local locomotives = {}

--Register Locomotives
local function scanLocomotives()
    local found = {}
    for address in component.list("ir_remote_control") do
        table.insert(found, address)
    end

    -- Check for new locos and assign names
    for _, address in ipairs(found) do
        local alreadyExists = false
        for _, loco in ipairs(locomotives) do
            if loco.address == address then
                alreadyExists = true
                break
            end
        end

        if not alreadyExists then
            local name = "Loco" .. tostring(#locomotives + 1)
            table.insert(locomotives, { name = name, address = address, proxy = component.proxy(address) })
            print("Registered new locomotive: " .. name .. " (" .. address .. ")")
        end
    end

    -- Remove entries for missing locos (in case one was removed)
    for i = #locomotives, 1, -1 do
        local exists = false
        for _, address in ipairs(found) do
            if locomotives[i].address == address then
                exists = true
                break
            end
        end
        if not exists then
            print("Removed missing locomotive: " .. locomotives[i].name)
            table.remove(locomotives, i)
        end
    end
end

-- Function to handle button click (From ReactorGUI)
local function handleClick(x, y)
    if x >= 8 and x <= 34 and y >= 7 and y <= 9 then
        -- "Startup!" button clicked
        c.beep()
        c.beep()
    elseif x >= w-27 and x <= w-1 and y >= h-4 and y <= h-1 then
        -- "Exit Program" button clicked
		c.beep(500, 0.5)
        c.beep(500, 0.5)
		gpu.fill(1, 1, w, h, " ")  -- Clear the screen
		os.exit()
    end
end

--Function to identify and assign block sections
local function setBlock(i)
    --Station Block x,y
    --A Block x,y
    --B Block x,y
    --C Block x,y
    --D Block x,y
    pos = locomotives[i].proxy.getPos()
end

--Function to get consist info
local function getConsistInfo(i)
    table = locomotives[i].proxy.getConsist()
    print(table)
end

--Function to get locomotive info
local function getLocoInfo(i)
    table = locomotives[i].proxy.info()
	print(table)
end

--Function for drawingGUI
local function drawGUI()
	gpu.fill(w-27, h-4, w-1, h-1, "X")  -- Clear the screen
    --UpdateLocoList
    scanLocomotives()
    getLocoInfo(1)
    getLocoInfo(2)
end

--Function for drawing route and loco positions
local function drawRoute()
    --Need full map to scale and define positions
    --Rail route is a triangle with A ~400 meters away, B ~300 meters away, C ~200 meters away
    --Vertical is minimum 700 meters, horizontal is minimum 400 meters
    --Max GPU resolution 160wide, 50tall
    --Route Resolution 30wide, 40tall?
end


--Main loop
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")  -- Clear the screen
scanLocomotives()
while true do

    drawGUI()
    drawRoute()

    local _, _, x, y, button, player = event.pull(1,"touch")
    if x and y then
        handleClick(x, y)
    end
    count = count + 1
end