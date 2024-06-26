-- N(o) S(tarting) I(items) Options!
local NSI_OPTIONS = GetModConfigData("NSI_OPTION", true)

local nsi_players = {}
local fileName = "nsi_players.txt"

-- Clear all starting items from a player's inventory
local function ClearStartingItems(player)
	local inventory = player and player.components.inventory or nil
	if not inventory then return end

	local inventorySlotCount = inventory:GetNumSlots()
	for i = 1, inventorySlotCount do
		local item = inventory:GetItemInSlot(i)
		if item then
			inventory:RemoveItem(item, true)
			item:Remove()
		end
	end
end

-- Check if a list contains an item (with optional table comparison)
local function contains(list, item)
	for _, v in ipairs(list) do
		if type(item) == "table" then
			if v.name == item.name and v.prefab == item.prefab then
				return true
			end
		else
			if v == item then
				return true
			end
		end
	end
	return false
end

-- Load the list of players from persistent storage
local function LoadPlayers()
	GLOBAL.TheSim:GetPersistentString(fileName, function(load_success, data)
		if load_success and data then
			nsi_players = GLOBAL.json.decode(data)
		end
	end)
end

-- Save the list of players to persistent storage
local function SavePlayers()
	GLOBAL.TheSim:SetPersistentString(fileName, GLOBAL.json.encode(nsi_players))
end

-- Check if the player is spawning for the first time
local function IsInitialSpawn(inst)
	local playerSpawner = GLOBAL.TheWorld.components.playerspawner
	return playerSpawner and playerSpawner:IsPlayersInitialSpawn(inst)
end

-- Handle the player spawning event based on configuration
local function HandlePlayerSpawn(inst, player)
	LoadPlayers()
	local isInitialSpawn = IsInitialSpawn(inst)

	local playerData = { name = player.name, prefab = player.prefab }

	if NSI_OPTIONS == "NSI_ANY_CHARACTER" then
		ClearStartingItems(player)
	elseif NSI_OPTIONS == "NSI_SWP_CHARACTER" and isInitialSpawn and contains(nsi_players, playerData.name) then
		ClearStartingItems(player)
	elseif NSI_OPTIONS == "NSI_OLD_CHARACTER" and isInitialSpawn and contains(nsi_players, playerData) then
		ClearStartingItems(player)
	end

	if not contains(nsi_players, playerData) then
		table.insert(nsi_players, playerData)
	end

	SavePlayers()
end

-- Modify the player's OnNewSpawn function to handle custom spawning logic
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

-- Set up event listeners for player spawning events
local function ListenForPlayers(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
	end
end

AddPrefabPostInit("world", ListenForPlayers)
