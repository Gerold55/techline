-- Refinery Crafting Recipe
minetest.register_craft({
    output = "techlines:refinery",
    recipe = {
        {techlines.steel_ingot, techlines.steel_ingot, techlines.steel_ingot},
        {techlines.glass_plate, techlines.circuit_board, techlines.glass_plate},
        {techlines.steel_ingot, techlines.steel_ingot, techlines.steel_ingot},
    },
})

-- Solar Panel Crafting Recipe
minetest.register_craft({
    output = "techlines:solar_panel",
    recipe = {
        {techlines.glass_plate, techlines.circuit_board, techlines.glass_plate},
        {techlines.steel_ingot, techlines.steel_ingot, techlines.steel_ingot},
        {"", techlines.steel_ingot, ""},
    },
})
