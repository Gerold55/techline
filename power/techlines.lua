-- TechLines Mod for Wastelands: Survival

-- Helper function to update techline state
local function update_techline_state(pos, is_powered)
    local node = minetest.get_node(pos)
    if is_powered then
        if node.name == "techlines:techline" then
            minetest.set_node(pos, {name = "techlines:techline_powered", param2 = node.param2})
        end
    else
        if node.name == "techlines:techline_powered" then
            minetest.set_node(pos, {name = "techlines:techline", param2 = node.param2})
        end
    end
end

-- Unpowered TechLine (Cable)
minetest.register_node("techlines:techline", {
    description = "TechLine Cable",
    drawtype = "nodebox",
    tiles = {"techlines_techline_off.png"}, -- Unpowered texture
    paramtype = "light",
    paramtype2 = "facedir",
    light_source = 0,
    node_box = {
        type = "fixed",
        fixed = {
            -- Cable shape: thinner to appear like a wire or cable
            {-0.1, -0.5, -0.1, 0.1, -0.4, 0.1}, -- Thin wire-like shape
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.1, 0.1, -0.4, 0.1},
        },
    },
    groups = {cracky = 2, techlines_cable = 1},
    sounds = (ws_core and ws_core.node_sound_metal_defaults()) or (default and default.node_sound_metal_defaults()),
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        -- Toggle state for debugging
        minetest.set_node(pos, {name = "techlines:techline_powered", param2 = node.param2})
    end,
})

-- Powered TechLine (Cable)
minetest.register_node("techlines:techline_powered", {
    description = "Powered TechLine Cable",
    drawtype = "nodebox",
    tiles = {"techlines_techline_on.png"}, -- Powered texture
    paramtype = "light",
    paramtype2 = "facedir",
    light_source = 5,
    node_box = {
        type = "fixed",
        fixed = {
            -- Same thin shape for powered cable
            {-0.1, -0.5, -0.1, 0.1, -0.4, 0.1},
        },
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.1, -0.5, -0.1, 0.1, -0.4, 0.1},
        },
    },
    groups = {cracky = 2, techlines_cable = 1, not_in_creative_inventory = 1},
    sounds = (ws_core and ws_core.node_sound_metal_defaults()) or (default and default.node_sound_metal_defaults()),
    drop = "techlines:techline", -- Drop the unpowered version
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        -- Toggle state for debugging
        minetest.set_node(pos, {name = "techlines:techline", param2 = node.param2})
    end,
})
