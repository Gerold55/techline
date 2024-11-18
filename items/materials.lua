-- Utility to check if an item exists
local function item_exists(item_name)
    return minetest.registered_items[item_name] ~= nil
end

-- Define materials dynamically, prioritizing `ws_core` items
local steel_ingot = "ws_core:steel_ingot"
local glass_plate = "ws_core:glass"
local circuit_board = "ws_core:circuit_board"

-- Fallback for steel ingot
if not item_exists(steel_ingot) then
    steel_ingot = "techlines:steel_ingot"
    minetest.register_craftitem("techlines:steel_ingot", {
        description = "Steel Ingot",
        inventory_image = "techlines_steel_ingot.png",
    })
end

-- Fallback for glass plate
if not item_exists(glass_plate) then
    glass_plate = "techlines:glass_plate"
    minetest.register_craftitem("techlines:glass_plate", {
        description = "Glass Plate",
        inventory_image = "techlines_glass_plate.png",
    })
end

-- Fallback for circuit board
if not item_exists(circuit_board) then
    circuit_board = "techlines:circuit_board"
    minetest.register_craftitem("techlines:circuit_board", {
        description = "Circuit Board",
        inventory_image = "techlines_circuit_board.png",
    })
end

-- Export resolved items
techlines.steel_ingot = steel_ingot
techlines.glass_plate = glass_plate
techlines.circuit_board = circuit_board
