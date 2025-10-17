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

--Functions to be used in future requirements
--Function to serialize a table into a string
function serializeTable(tbl, indent)
    indent = indent or ""
    local str = "{\n"
    local next_indent = indent .. "  "
    for k, v in pairs(tbl) do
        str = str .. next_indent
        -- Handle keys (strings or numbers)
        if type(k) == "string" then
            str = str .. '["' .. k .. '"] = '
        else
            str = str .. '[' .. tostring(k) .. '] = '
        end

        -- Handle values
        if type(v) == "table" then
            str = str .. serializeTable(v, next_indent)
        elseif type(v) == "string" then
            str = str .. '"' .. v .. '"'
        elseif type(v) == "number" or type(v) == "boolean" then
            str = str .. tostring(v)
        else
            str = str .. "nil -- Unsupported type: " .. type(v)
        end
        str = str .. ",\n"
    end
    str = str .. indent .. "}"
    return str
end

--Function to write a table to a file
function writeTableToFile(filename, tbl)
    local file = io.open(filename, "w")
    if file then
        local serialized_data = serializeTable(tbl)
        file:write("return " .. serialized_data)
        io.close(file)
        print("Table successfully written to " .. filename)
    else
        print("Error: Could not open file " .. filename .. " for writing.")
    end
end

-- Function to handle button click (From ReactorGUI)
local function handleClick(x, y)
    if x >= 8 and x <= 34 and y >= 7 and y <= 9 then
        -- Write Loco 1 Info
        writeLocoInfo(1)
        c.beep()
        writeConsistInfo(1)
        c.beep()
    elseif x >= 38 and x <= 64 and y >= 7 and y <= 9 then
        --emptybutton
    elseif x >= 8 and x <= 34 and y >= 11 and y <= 13 then
        -- Write Loco 2 Info
        writeLocoInfo(2)
        c.beep()
        writeConsistInfo(2)
        c.beep()
    elseif x >= 38 and x <= 64 and y >= 11 and y <= 13 then
        --emptybutton
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
    consist = locomotives[i].proxy.consist()
    return (consist)
end

--Function to get locomotive info
local function getLocoInfo(i)
    info = locomotives[i].proxy.info()
    return (info)
end

--Function to calulate fluid levels
local function getFuelPercent(i)
    currentfuel = getLocoInfo(i).fuel
    maxfuel = getLocoInfo(i).maxfuel
    fuelPercent = (currentfuel/maxfuel)
    return(fuelPercent)
end

--Function to Write Consist Info
local function writeConsistInfo(i)
    consist = locomotives[i].proxy.consist()
    writeTableToFile("Consist".. tostring(i) .." Table",consist)
end

--Function to Write Locomotive Info
local function writeLocoInfo(i)
    info = locomotives[i].proxy.info()
    writeTableToFile("Locomotive".. tostring(i) .." Table",info)
end

--Function for drawingGUI
local function drawGUI()
    --UpdateLocoList
    scanLocomotives()

    -- Draw a button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(8, 7, 26, 3, " ")  -- Button area
    gpu.set(9, 8,  "Write Loco1 Info to File")  -- Button label

    -- Draw a button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(38, 7, 26, 3, " ")  -- Button area
    gpu.set(39, 8, "   Reactor  ShutDown!   ")  -- Button label
    
    -- Draw a button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(8, 11, 26, 3, " ")  -- Button area
    gpu.set(9, 12, "Write Loco2 Info to File")  -- Button label
 
    -- Draw a button
    gpu.setForeground(0x000000)
    gpu.setBackground(0xFFFFFF)
    gpu.fill(38, 11, 26, 3, " ")  -- Button area
    gpu.set(39, 12, "Heat Exchanger ShutDown!")  -- Button label

    -- Draw Consist/Locomotive Data
    gpu.set(10, 28, "Locomotive Name:      " ..locomotives[1].name)
    gpu.set(10, 30, "Locomotive Model:     " getLocoInfo(1).model)
    gpu.set(10, 31, "Locomotive Fuel Level:" )
    gpu.set(10, 32, "Locomotive Weight:    " )
    gpu.set(10, 33, "Consist Weight:       " )
    gpu.set(10, 34, "Current Speed:        " )
    gpu.set(10, 35, "Current Block:        " )
    
    -- Draw Consist/Locomotive Data
    gpu.set(45, 28, "Locomotive Name:      " ..locomotives[2].name)
    gpu.set(45, 30, "Locomotive Model:     " )
    gpu.set(45, 31, "Locomotive Fuel Level:" )
    gpu.set(45, 32, "Locomotive Weight:    " )
    gpu.set(45, 33, "Consist Weight:       " )
    gpu.set(45, 34, "Current Speed:        " )
    gpu.set(45, 35, "Current Block:        " )

	-- Draw Program Exit button
    gpu.setForeground(0xFFFFFF)
    gpu.setBackground(0xFF0000)
    gpu.fill(w-27, h-4, 26, 3, " ")  -- Button area
    gpu.set(w-26, h-3, " E x i t  P r o g r a m ")  -- Button label
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
    if (#locomotives > 0) 
        drawGUI()
        drawRoute()
    elseif (#locomotives == 0)
        gpu.setForeground(0xFFFFFF)
        gpu.setBackground(0xFF0000)
        gpu.set(66, 29, "E R R O R :   L C - 0 0 1")
        gpu.set(56, 30, "N O - L O C O M O T I V E S - D E T E C T E D")
        gpu.set(55, 31, "P L E A S E - I N S E R T - R A D I O - C A R D")
    end

    local _, _, x, y, button, player = event.pull(1,"touch")
    if x and y then
        handleClick(x, y)
    end
    count = count + 1
end