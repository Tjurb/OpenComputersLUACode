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

--Function for drawingGUI
local function drawGUI()
end

--Main loop
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")  -- Clear the screen
scanLocomotives()
while true do
    -- Variables Used in GUI and Functions
    BlockS = 0
    blockA = 1 
    blockB = 2
    blockC = 3
    blockD = 4

    drawGUI()

    local _, _, x, y, button, player = event.pull(1,"touch")
    if x and y then
        handleClick(x, y)
    end
    count = count + 1
end