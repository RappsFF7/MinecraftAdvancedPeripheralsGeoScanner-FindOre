-- This is a script for bookmarking resources found by Advanced Peripherals Geo Scanner
-- Run in Geo Scanner: wget https://raw.githubusercontent.com/RappsFF7/MinecraftAdvancedPeripheralsGeoScanner-FindOre/refs/heads/master/FindOre.lua
-- Loosely based on toastonrye's BrCKkttY script (https://pastebin.com/BrCKkttY, https://www.youtube.com/watch?v=9PRjpd4lUDk)

-- Configuration
--   Range of the scan in blocks
local scanRange = 16
--   Max size to consider ore in same vein
local veinSize = 10

-- Define base ores
local base_ores = {
  "ancient_debris",
  "lapis_ore",
  "redstone_ore",
  "emerald_ore",
  "diamond_ore",
  "gold_ore  ",
  "copper_ore",
  "iron_ore"
}

term.clear()
local geo = peripheral.find("geoScanner")
if not geo then error("geo scanner peripheral not found") end

-- Generate full ore list with variants
local ores_to_find = {}
for _, ore in ipairs(base_ores) do
    table.insert(ores_to_find, "minecraft:" .. ore)
    table.insert(ores_to_find, "minecraft:deepslate_" .. ore)
    table.insert(ores_to_find, "minecraft:nether_" .. ore)
end

-- Try to get computer's absolute position
local computerX, computerY, computerZ = gps.locate()
local usingRelative = false

-- If GPS fails, ask for manual input
if not computerX then
    print("GPS position not available.")
    print("Would you like to enter your coordinates manually? (y/n)")
    local response = read():lower()
    
    if response == "y" then
        print("Enter X coordinate (or press enter to skip):")
        computerX = tonumber(read()) or 0
        print("Enter Y coordinate (or press enter to skip):")
        computerY = tonumber(read()) or 0
        print("Enter Z coordinate (or press enter to skip):")
        computerZ = tonumber(read()) or 0
        
        if computerX == 0 and computerY == 0 and computerZ == 0 then
            print("No coordinates provided. Using relative coordinates.")
            usingRelative = true
        else
            print(string.format("Using provided position: X:%d Y:%d Z:%d", computerX, computerY, computerZ))
        end
    else
        print("Using relative coordinates.")
        computerX, computerY, computerZ = 0, 0, 0
        usingRelative = true
    end
end

print("Computer position:", computerX, computerY, computerZ)

-- Function to check if a position is within vein range of any known position
local function isWithinVeinRange(knownPositions, x, y, z)
    for _, pos in ipairs(knownPositions) do
        local dx = pos.x - x
        local dy = pos.y - y
        local dz = pos.z - z
        local distance = math.sqrt(dx*dx + dy*dy + dz*dz)
        if distance <= veinSize then
            return true
        end
    end
    return false
end

-- Table to store discovered ore positions
local discoveredVeins = {}

local scan = geo.scan(scanRange)
print("Starting search.")
for i, data in ipairs(scan) do
    for _, ore in ipairs(ores_to_find) do
        if data.name == ore then
            -- Initialize table for this ore type if it doesn't exist
            discoveredVeins[data.name] = discoveredVeins[data.name] or {}
            
            -- Check if this ore is part of an existing vein
            if not isWithinVeinRange(discoveredVeins[data.name], data.x, data.y, data.z) then
                -- Calculate coordinates
                local displayX = computerX + data.x
                local displayY = computerY + data.y
                local displayZ = computerZ + data.z
                
                -- Add to discovered veins
                table.insert(discoveredVeins[data.name], {x = data.x, y = data.y, z = data.z})
                
                -- Print the location
                if usingRelative then
                    print(string.format("%s: \nX:%d Y:%d Z:%d",
                        data.name, displayX, displayY, displayZ))
                end
            end
        end
    end
end

if usingRelative then
  print("(Coordinates are relative)")
else 
  print("(Coordinates are absolute)")
end

print("Search done.")
