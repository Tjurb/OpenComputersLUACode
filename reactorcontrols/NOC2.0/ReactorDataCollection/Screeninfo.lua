local term =require ("term")
local component = require ("component")
local c = component.computer
local gpu = component.gpu
local s = component.screen

local w, h = gpu.getResolution()

print(w)
print(h)

local sw, sh = s.getAspectRatio()

print(sw)
print(sh)