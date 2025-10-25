-- This is a script for bookmarking resources found by Advanced Peripherals Geo Scanner
-- Run in Geo Scanner: wget https://raw.githubusercontent.com/RappsFF7/MinecraftAdvancedPeripheralsGeoScanner-FindOre/refs/heads/master/FindOre.lua
-- Loosely based on toastonrye's BrCKkttY script (https://pastebin.com/BrCKkttY, https://www.youtube.com/watch?v=9PRjpd4lUDk)

term.clear()
local geo = peripheral.find("geoScanner")
if not geo then error("geo scanner peripheral not found") end

local scan = geo.scan(16)
print("Starting search.")
for i, data in ipairs(scan) do
 if data.name == "minecraft:ancient_debris" then
  print(data.name + ", X: ",data.x,"  Y: ",data.y,"  Z:", data.z)
 end
end
print("Search done.")
