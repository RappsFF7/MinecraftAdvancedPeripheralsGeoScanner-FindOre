-- This is a script for bookmarking resources found by Advanced Peripherals Geo Scanner
-- Run in Geo Scanner: wget https://raw.githubusercontent.com/RappsFF7/MinecraftAdvancedPeripheralsGeoScanner-FindOre/refs/heads/master/FindOre.lua
-- Loosely based on toastonrye's BrCKkttY script (https://pastebin.com/BrCKkttY, https://www.youtube.com/watch?v=9PRjpd4lUDk)

term.clear()
local geo = peripheral.find("geoScanner")
if not geo then error("geo scanner peripheral not found") end

-- Define base ores and their variants
local base_ores = {
    "ancient_debris",
    "diamond_ore",
    "emerald_ore",
    "redstone_ore",
    "lapis_ore",
    "gold_ore",
    "copper_ore",
    "iron_ore"
}

-- Generate full ore list with variants
local ores_to_find = {}
for _, ore in ipairs(base_ores) do
    table.insert(ores_to_find, "minecraft:" .. ore)
    table.insert(ores_to_find, "minecraft:deepslate_" .. ore)
    table.insert(ores_to_find, "minecraft:nether_" .. ore)
end

local scan = geo.scan(16)
print("Starting search.")
for i, data in ipairs(scan) do
    for _, ore in ipairs(ores_to_find) do
        if data.name == ore then
            print(data.name .. ", X: " .. data.x .. "  Y: " .. data.y .. "  Z: " .. data.z)
        end
    end
end
print("Search done.")
