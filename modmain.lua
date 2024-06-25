-- N(o) S(tarting) I(items) Options!
local NSI_OPTIONS = GetModConfigData("NSI_OPTION", true)

local nsi_players = {}
local fileName = "nsi_players.txt"

local function ClearStartingItems(player)
	local inventory = player and player.components.inventory or nil
	local inventorySlotCount = inventory and inventory:GetNumSlots() or 0

	for i = 1, inventorySlotCount do
		local item = inventory:GetItemInSlot(i) or nil
		inventory:RemoveItem(item, true)
		if item ~= nil then
			item:Remove()
		end
	end
end


local function contains(list, item)
	-- name and prefab
	if type(item) == "table" then
		for k, v in ipairs(list) do
			if v.name == item.name and v.prefab == item.prefab then
				return true
			end
		end
	else -- name only
		for k, v in ipairs(list) do
			if v == item then
				return true
			end
		end
	end
	return false
end

local function LoadPlayers()
	GLOBAL.TheSim:GetPersistentString(fileName, function(load_success, data)
		if load_success == true and data ~= nil then
			nsi_players = GLOBAL.json.decode(data)
		end
	end)
end

local function IsInitialSpawn(inst)
	if GLOBAL.TheWorld.components.playerspawner ~= nil
		and GLOBAL.TheWorld.components.playerspawner:IsPlayersInitialSpawn(inst) then
		return true
	end
	return false
end

local function SavePlayers()
	GLOBAL.TheSim:SetPersistentString(fileName, GLOBAL.json.encode(nsi_players))
end

local function HandlePlayerSpawn(inst, player)
	LoadPlayers()
	local spawn = IsInitialSpawn(inst)
	if NSI_OPTIONS == "NSI_ANY_CHARACTER" then
		ClearStartingItems(player)
	else
		if NSI_OPTIONS == "NSI_SWP_CHARACTER" then
			if spawn and contains(nsi_players, player.name) then
				ClearStartingItems(player)
			end
		else
			if NSI_OPTIONS == "NSI_OLD_CHARACTER" then
				if spawn and contains(nsi_players, player) then
					ClearStartingItems(player)
				end
			end
		end
	end
	
	local playerData = {
		name = player.name,
		prefab = player.prefab,
		-- Add any other player-specific data here
	}

	if not contains(nsi_players, playerData) then
		table.insert(nsi_players, playerData)
	end

	SavePlayers()
end

local function OnPlayerSpawn(inst, player)
	player.prev_OnNewSpawn = player.OnNewSpawn
	player.OnNewSpawn = function()
		if player.prev_OnNewSpawn ~= nil then
			player:prev_OnNewSpawn()

			HandlePlayerSpawn(inst, player)

			player.prev_OnNewSpawn = nil
		end
	end
end

local function ListenForPlayers(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
	end
end

AddPrefabPostInit("world", ListenForPlayers)
