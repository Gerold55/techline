-- Refinery for TechLines

minetest.register_node("techlines:refinery", {
    description = "Oil Refinery",
    tiles = {"techlines_refinery_top.png", "techlines_refinery_side.png"},
    groups = {cracky = 2},
    on_rightclick = function(pos, _, clicker, itemstack)
        if itemstack:get_name() == "bucket:bucket_clay_oil" or itemstack:get_name() == "bucket:bucket_oil" then
            itemstack:take_item()
            clicker:set_wielded_item(itemstack)
            local inv = clicker:get_inventory()
            inv:add_item("main", "techlines:gas_canister")
            minetest.chat_send_player(clicker:get_player_name(), "Oil refined into gas!")
        else
            minetest.chat_send_player(clicker:get_player_name(), "Requires oil to refine.")
        end
    end,
})

minetest.register_craftitem("techlines:gas_canister", {
    description = "Gas Canister",
    inventory_image = "techlines_gas_canister.png",
})
