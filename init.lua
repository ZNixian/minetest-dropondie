



local drop = function(pos, istack)
	--for i=1, istack:get_count() do
		local obj = minetest.env:add_item(pos, istack:get_name() .. " " .. istack:get_count())
		if obj ~= nil then
			obj:get_luaentity().collect = true
			local x = math.random(1, 5)
			if math.random(1,2) == 1 then
				x = -x
			end
			local z = math.random(1, 5)
			if math.random(1,2) == 1 then
				z = -z
			end
			obj:setvelocity({x=1/x, y=5, z=1/z})
			
			-- FIXME this doesnt work for deactiveted objects
			if minetest.setting_get("remove_items") and tonumber(minetest.setting_get("remove_items")) then
				minetest.after(tonumber(minetest.setting_get("remove_items")), function(obj)
					obj:remove()
				end, obj)
			end
		end
	--end
end



minetest.register_on_dieplayer(function(player)
	if minetest.setting_getbool("creative_mode") then
		return
	end
	
	local pos = player:getpos()
	pos.x = math.floor(pos.x+0.5)
	pos.y = math.floor(pos.y+0.5)
	pos.z = math.floor(pos.z+0.5)
	local param2 = minetest.dir_to_facedir(player:get_look_dir())
	
	local player_inv = player:get_inventory()
	
	for i=1,player_inv:get_size("main") do
		drop(pos, player_inv:get_stack("main", i))
		player_inv:set_stack("main", i, nil)
	end
	for i=1,player_inv:get_size("craft") do
		drop(pos, player_inv:get_stack("craft", i))
		player_inv:set_stack("craft", i, nil)
	end
end)
