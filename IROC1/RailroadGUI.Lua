local term = require ("term")
local component = require ("component")
local gpu = component.gpu
local c = component.computer
local De = component.ir_augment_detector
local Co = component.ir_augment_control
local RC = component.ir_remote_control
local g = component.geolyzer
local r = component.redstone
local m = component.modem
local event = require ("event")
count = 0
gpu.setResolution(160,50)
local w,h = gpu.getResolution()

--Set Train Addresses
for address in component.list('ir_remote_control') do
    
end

--Get Number of Consists
function getNumCon()
    local cList = {}
    local value = 0
    for address in component.list('ir_remote_control') do
        local con = component.proxy(address)
        table.insert(cList,con)
    end
    value = #cList
    return (value)
end

--Set Consist Tag
function setTags(value,int)
end

--Get Consist Tag
function getTag(value,int)
end

--Draw GUI
local function drawGUI()
end

--Draw Locomotive Positions in Block
local function drawBlocks()
end

--Draw Consist Stats
local function drawConsist()
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

--Main loop
gpu.setBackground(0x000000)
gpu.fill(1, 1, w, h, " ")  -- Clear the screen
while true do
    -- Variables Used in GUI and Functions
    BlockS = 0
    blockA = 1 
    blockB = 2
    blockC = 3
    blockD = 4

    drawGUI()
    drawLocoPositions()
    drawConsist()

    local _, _, x, y, button, player = event.pull(1,"touch")
    if x and y then
        handleClick(x, y)
    end
    count = count + 1
end