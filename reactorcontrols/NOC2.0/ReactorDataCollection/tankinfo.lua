local term = require ("term")
local component = require ("component")

tc = component.tank_controller

print(tc.getTankCapacity(1))
print(tc.getTankCapacity(2))
print(tc.getTankCapacity(3))
print(tc.getTankCapacity(4))
print(tc.getTankCapacity(5))