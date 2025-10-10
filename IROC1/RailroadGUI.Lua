local term = require ("term")
local component = require ("component")
local gpu = component.gpu
local c = component.computer
local De = component.ir_augment_detector
local Co = component.ir_augment_control
local RC = component.ir_remote_control
local event = require ("event")
count = 0
gpu.setResolution(160,50)
local w,h = gpu.getResolution()

--Start Locomotive
local function start()
    Co.setThrottle(0.7)
end

--Stop Locomotive
local function stop()
    Co.setThrottle(0)
    Co.setBrake(0.5)
end

--EStop Locomotive
local function eStop()
    Co.setThrottle(-1)
    Co.setBrake(1)
end

--Get Consist Information
local function getCon()
    return (De.consist())
end

--Set Consist Block Tag
local function setTag(value)
    return (De.setTag(value))
end

--Get Consist Block Tag
local function getTag()
    return (De.getTag())
end

--Draw GUI
local function drawGUI()
    return (De.getTag())
end

--Draw Locomotive Positions in Block
local function drawBlocks()
    return (De.getTag())
end

--Draw Consist Stats
local function drawConsist()
    return (De.getTag())
end

-- Function to handle button click (From ReactorGUI)
local function handleClick(x, y)
    if x >= 8 and x <= 34 and y >= 7 and y <= 9 then
        -- "Startup!" button clicked
        c.beep()
        c.beep()
    elseif x >= 38 and x <= 64 and y >= 11 and y <= 13 then
        -- "EMERGENCY STOP!" button clicked
        eStop()
        c.beep(500, 0.5)
    elseif x >= w-27 and x <= w-1 and y >= h-4 and y <= h-1 then
        -- "Exit Program" button clicked
		c.beep(500, 0.5)
        c.beep(500, 0.5)
		gpu.fill(1, 1, w, h, " ")  -- Clear the screen
		os.exit()
    end
end

--Main loop
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")  -- Clear the screen
while true do
    -- Variables Used in GUI and Functions
    blockA = 0 
    blockB = 0
    blockC = 0
    blockD = 0

    drawGUI()
    drawLocoPositions()
    drawConsist()

    local _, _, x, y, button, player = event.pull(1,"touch")
    if x and y then
        handleClick(x, y)
    end
    count = count + 1
end