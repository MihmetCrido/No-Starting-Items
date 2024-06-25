local nsi_players = {}
local fileName = "nsi_players.txt"

-- N(o) S(tarting) I(items) Options!
local NSI_OPTIONS = GetModConfigData("NSI_OPTIONS", true)

local function ClearStartingItems(player)
	print("[ClearStartingItems] called")
	local inventory = player and player.components.inventory or nil
	local inventorySlotCount = inventory and inventory:GetNumSlots() or 0

	for i = 1, inventorySlotCount do
		print("[ClearStartingItems] i = " .. i)
		local item = inventory:GetItemInSlot(i) or nil
		inventory:RemoveItem(item, true)
		if item ~= nil then
			print("[ClearStartingItems] Remove Item: " .. item.name)
			item:Remove()
		end
	end
	print("[ClearStartingItems] return")
end


local function contains(list, item)
	for k, v in ipairs(list) do
		print("[Contains] i: " .. k)
		if v == item then
			return true
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
		print("[NSI_ANY_CHARACTER]")
		ClearStartingItems(player)

		-- Will break when map is updated
	else
		if NSI_OPTIONS == "NSI_SWP_CHARACTER" then
			print("[NSI_SWP_CHARACTER]")
			if spawn and contains(nsi_players, player.name) then
				ClearStartingItems(player)
			end
			-- Broken logic until map is updated
		else
			if NSI_OPTIONS == "NSI_OLD_CHARACTER" then
				print("[NSI_OLD_CHARACTER]")
				if spawn and not contains(nsi_players, player.name) then
					ClearStartingItems(player)
				end
			end
		end
	end

	print("player: ")
	for k,v in pairs(player) do
		print("\tkey : " .. k .. " value : " .. tostring(v))
		if type(v) == "table" then
			for k2,v2 in pairs(v) do
                print("\t\tkey : " .. tostring(k2) .. " value : " .. tostring(v2))
            end
		end
	end
	print("inst :")
	for k,v in pairs(inst) do
		print("\tkey : " .. k .. " value : " .. tostring(v))
		if type(v) == "table" then
			for k2,v2 in pairs(v) do
                print("\t\tkey : " .. tostring(k2) .. " value : " .. tostring(v2))
            end
		end
	end

	if not contains(nsi_players, player.name) then
		table.insert(nsi_players, player.name)
	end

	SavePlayers()
end

-- globals.lua
-- show all global variables

local seen = {}

function dump(t, i)
	seen[t] = true
	local s = {}
	local n = 0
	for k in pairs(t) do
		n = n + 1
		s[n] = k
	end
	table.sort(s)
	for k, v in ipairs(s) do
		print(i, v)
		v = t[v]
		if type(v) == "table" and not seen[v] then
			dump(v, i .. "\t")
		end
	end
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
