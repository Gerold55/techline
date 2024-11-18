-- Generators for TechLines

local coal_power_duration = 30 -- How long each coal lump powers the generator (seconds)
local coal_power_amount = 100 -- Power units generated per coal lump

local function update_generator_formspec(power)
    return "size[8,9]" ..
           "label[0,0;Coal Generator]" ..
           "list[current_name;fuel;3.5,1;1,1;]" ..
           "list[current_player;main;0,5;8,4;]" ..
           "label[3.5,2;Power: " .. power .. "]"
end

minetest.register_node("techlines:coal_generator", {
    description = "Coal Generator",
    tiles = {
        "techlines_coal_generator_top.png",
        "techlines_coal_generator_bottom.png",
        "techlines_coal_generator_side.png",
    },
    groups = {cracky = 2},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", update_generator_formspec(0))
        meta:set_int("power", 0)
        local inv = meta:get_inventory()
        inv:set_size("fuel", 1)
    end,
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local fuel_stack = inv:get_stack("fuel", 1)
        local power = meta:get_int("power")

        if power <= 0 and fuel_stack:get_name() == "ws_core:coal_lump" then
            fuel_stack:take_item(1)
            inv:set_stack("fuel", 1, fuel_stack)
            power = coal_power_amount
            meta:set_int("power", power)
        end

        if power > 0 then
            distribute_power(pos, 10, 1)
            power = power - 1
            meta:set_int("power", power)
            meta:set_string("formspec", update_generator_formspec(power))
            minetest.get_node_timer(pos):start(1)
        else
            meta:set_string("formspec", update_generator_formspec(0))
        end
    end,
    on_rightclick = function(pos, _, clicker)
        local meta = minetest.get_meta(pos)
        minetest.show_formspec(clicker:get_player_name(), "techlines:coal_generator", meta:get_string("formspec"))
        minetest.get_node_timer(pos):start(1)
    end,
})

local function distribute_power(pos, range, duration)
    for x = -range, range do
        for y = -range, range do
            for z = -range, range do
                local check_pos = vector.add(pos, {x = x, y = y, z = z})
                local node = minetest.get_node(check_pos)
                if node.name == "techlines:techline" then
                    minetest.swap_node(check_pos, {name = "techlines:techline_powered"})
                end
            end
        end
    end

    minetest.after(duration, function()
        for x = -range, range do
            for y = -range, range do
                for z = -range, range do
                    local check_pos = vector.add(pos, {x = x, y = y, z = z})
                    local node = minetest.get_node(check_pos)
                    if node.name == "techlines:techline_powered" then
                        minetest.swap_node(check_pos, {name = "techlines:techline"})
                    end
                end
            end
        end
    end)
end


-- Gas Generator
minetest.register_node("techlines:gas_generator", {
    description = "Gas Generator",
    tiles = {"techlines_gas_generator.png"},
    groups = {cracky = 2},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", "size[8,9]label[0,0;Gas Generator]")
    end,
})

-- Solar Generator
minetest.register_node("techlines:solar_generator", {
    description = "Solar Generator",
    tiles = {"techlines_solar_generator.png"},
    groups = {cracky = 2},
    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", "size[8,9]label[0,0;Solar Generator]")
    end,
})
