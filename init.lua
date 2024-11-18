-- techlines/init.lua

-- Define sounds for the techline switch and wire
local sounds = {
    footstep = {name = "default_tool_wood", gain = 0.5},
    dig = {name = "default_tool_wood", gain = 0.5},
    place = {name = "default_tool_wood", gain = 0.5},
}

-- Techline Switch Node
minetest.register_node("techlines:techline_switch", {
    description = "Techline Switch",
    tiles = {"techline_switch.png"},
    groups = {cracky = 2},
    sounds = sounds,
    on_punch = function(pos, node, player, pointed_thing)
        -- Get the current state from the meta
        local meta = minetest.get_meta(pos)
        local is_on = meta:get_string("is_on") == "true"  -- Check current state (on or off)
        
        -- Toggle the switch state
        if is_on then
            meta:set_string("is_on", "false")  -- Turn off
            minetest.chat_send_all("Techline Switch is OFF")
        else
            meta:set_string("is_on", "true")  -- Turn on
            minetest.chat_send_all("Techline Switch is ON")
        end
        
        -- Trigger signal to nearby connected techline wires
        update_techlines(pos)
    end,
})

-- Function to propagate signal to connected techlines and lamps
function update_techlines(pos)
    local meta = minetest.get_meta(pos)
    local switch_state = meta:get_string("is_on")
    
    -- If the switch is on, power the wires
    if switch_state == "true" then
        power_wire(pos, 5)  -- Max strength is 5 blocks
    else
        power_wire(pos, 0)  -- Turn off the wires if switch is off
    end
end

-- Function to power the techline wire with a specified strength
function power_wire(pos, strength)
    -- Propagate the signal along the wire with decreasing strength
    local current_pos = pos
    local signal_strength = strength
    for i = 1, 5 do
        if signal_strength > 0 then
            -- Power the wire and connected lamps
            minetest.set_node(current_pos, {name = "techlines:techline_on"})
            power_adjacent(current_pos, signal_strength)
        else
            minetest.set_node(current_pos, {name = "techlines:techline_off"})  -- Reset to unpowered state
        end

        -- Move to the next block in the X direction (for simplicity)
        current_pos = vector.add(current_pos, vector.new(1, 0, 0))
        signal_strength = signal_strength - 1  -- Signal strength decays by 1 each block
    end
end

-- Function to power adjacent blocks (like lamps) based on signal strength
function power_adjacent(pos, strength)
    -- Search for adjacent techline lamps
    local adjacent_nodes = minetest.find_nodes_in_area(
        vector.subtract(pos, vector.new(1, 0, 1)),  -- Search around the wire
        vector.add(pos, vector.new(1, 0, 1)),      -- Search around the wire
        {"techlines:techline_lamp_off"}
    )

    for _, node_pos in ipairs(adjacent_nodes) do
        -- Power the lamp by changing to the "on" state if the strength is sufficient
        if strength > 0 then
            minetest.set_node(node_pos, {name = "techlines:techline_lamp_on"})
        end
    end
end

-- Techline Wire (Off State)
minetest.register_node("techlines:techline_off", {
    description = "Techline Wire (Off)",
    tiles = {"techline_off.png"},
    groups = {cracky = 2},
    sounds = sounds,
})

-- Techline Wire (On State, Powered)
minetest.register_node("techlines:techline_on", {
    description = "Techline Wire (On)",
    tiles = {"techline_on.png"},
    groups = {cracky = 2},
    sounds = sounds,
    light_source = 14,  -- Emit light when powered
})

-- Techline Lamp (Off State)
minetest.register_node("techlines:techline_lamp_off", {
    description = "Techline Lamp (Off)",
    tiles = {"techline_lamp_off.png"},
    groups = {cracky = 2},
})

-- Techline Lamp (On State, Powered)
minetest.register_node("techlines:techline_lamp_on", {
    description = "Techline Lamp (On)",
    tiles = {"techline_lamp_on.png"},
    groups = {cracky = 2},
    light_source = 14,  -- Emit light when powered
})

-- Add a timer to the switch and wires to ensure they update every 0.5 seconds
minetest.register_abm({
    nodenames = {"techlines:techline_switch", "techlines:techline_off", "techlines:techline_on"},
    interval = 0.5,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
        -- Check the state of the switch and update the wire accordingly
        local meta = minetest.get_meta(pos)
        local switch_state = meta:get_string("is_on")
        
        if switch_state == "true" then
            -- If the switch is on, ensure the wire is powered
            if node.name == "techlines:techline_off" then
                minetest.set_node(pos, {name = "techlines:techline_on"})
                power_adjacent(pos, 5)  -- Max signal strength to connected blocks (like lamps)
            end
        else
            -- If the switch is off, revert the wire to unpowered state
            if node.name == "techlines:techline_on" then
                minetest.set_node(pos, {name = "techlines:techline_off"})
                -- Also turn off any connected lamps
                power_adjacent(pos, 0)
            end
        end
    end
})
