local w_nothing = (GetModConfigData("winter") == "w_nothing")
local w_basic = (GetModConfigData("winter") == "w_basic")
local w_normal = (GetModConfigData("winter") == "w_normal")
local w_lot = (GetModConfigData("winter") == "w_lot")
local w_plenty = (GetModConfigData("winter") == "w_plenty")

local sp_nothing = (GetModConfigData("spring") == "sp_nothing")
local sp_basic = (GetModConfigData("spring") == "sp_basic")
local sp_normal = (GetModConfigData("spring") == "sp_normal")
local sp_lot = (GetModConfigData("spring") == "sp_lot")
local sp_plenty = (GetModConfigData("spring") == "sp_plenty")

local su_nothing = (GetModConfigData("summer") == "su_nothing")
local su_basic = (GetModConfigData("summer") == "su_basic")
local su_normal = (GetModConfigData("summer") == "su_normal")
local su_lot = (GetModConfigData("summer") == "su_lot")
local su_plenty = (GetModConfigData("summer") == "su_plenty")

local inspect = require('inspect')
local _G = _G or GLOBAL

---@class NSI_Players
local nsi_players = {}


-- local io = require("io")
local fileName = "nsi_players.txt"

local function CreateStartingItems(player)
	print("[CreateStartingItems] called")
	local start_items = {}

	if _G.TheWorld.state.iswinter or (_G.TheWorld.state.isautumn and _G.TheWorld.state.remainingdaysinseason < 1) then
		if w_nothing then
		elseif w_basic then
			table.insert(start_items, "hotchili")
		elseif w_normal then
			table.insert(start_items, "hotchili")
			table.insert(start_items, "torch")
		elseif w_lot then
			table.insert(start_items, "hotchili")
			table.insert(start_items, "torch")
			table.insert(start_items, "earmuffshat")
		elseif w_plenty then
			table.insert(start_items, "hotchili")
			table.insert(start_items, "torch")
			table.insert(start_items, "earmuffshat")
			table.insert(start_items, "heatrock")
		end
	end

	if _G.TheWorld.state.isspring or (_G.TheWorld.state.iswinter and _G.TheWorld.state.remainingdaysinseason < 1) then
		if sp_nothing then
		elseif sp_basic then
			table.insert(start_items, "grass_umbrella")
		elseif sp_normal then
			table.insert(start_items, "grass_umbrella")
			table.insert(start_items, "torch")
		elseif sp_lot then
			table.insert(start_items, "umbrella")
			table.insert(start_items, "torch")
		elseif sp_plenty then
			table.insert(start_items, "umbrella")
			table.insert(start_items, "torch")
			table.insert(start_items, "rainhat")
		end
	end

	if _G.TheWorld.state.issummer or (_G.TheWorld.state.isspring and _G.TheWorld.state.remainingdaysinseason < 1) then
		if su_nothing then
		elseif su_basic then
			table.insert(start_items, "minifan")
		elseif su_normal then
			table.insert(start_items, "grass_umbrella")
			table.insert(start_items, "minifan")
		elseif su_lot then
			table.insert(start_items, "grass_umbrella")
			table.insert(start_items, "minifan")
			table.insert(start_items, "strawhat")
		elseif su_plenty then
			table.insert(start_items, "grass_umbrella")
			table.insert(start_items, "minifan")
			table.insert(start_items, "icehat")
		end
	end

	for _, v in pairs(start_items) do
		local item = _G.SpawnPrefab(v)
		print("[CreateStartingItems] item " .. item.name)
		player.components.inventory:GiveItem(item)
	end
	print("[CreateStartingItems] return")
end
local function ClearStartingItems(player)
	print("[ClearStartingItems] called")
	local inventory = player and player.components.inventory or nil
	local inventorySlotCount = inventory and inventory:GetNumSlots() or 0

	for i = 1, inventorySlotCount do
		-- print("[ClearStartingItems] i = " .. i)
		local item = inventory:GetItemInSlot(i) or nil
		inventory:RemoveItem(item, true)
		if item ~= nil then
			print("[ClearStartingItems] Remove Item: " .. item.name)
			item:Remove()
		end
	end
	print("[ClearStartingItems] return")
end
local function NewPlayerCharacterSpawned(player)
	print("[NewPlayerCharacterSpawned] called")
	-- ClearStartingItems(player)
	print("[NewPlayerCharacterSpawned] return")
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


-- function SavePlayers()
-- 	print("[SavePlayers] called")
-- 	_G.TheSim:SetPersistentString("nsi_players.txt", nsi_players)
-- end


-- function LoadPlayers()
-- 	print("[LoadPlayers] called")
--     nsi_players = {}
-- 	_G.TheSim:GetPersistentString("nsi_players.txt", function(load_sucess, data)
-- 		if load_success == true and data ~= nil then
-- 			nsi_players = data
-- 		end
-- 	end)
-- end

function MapToJson()
	print("[MapToJson]")

	local players = { "return {", }
	local s = ""
	for i = 1, #nsi_players do
		if i == 1 then
			s = s .. "\t\"players\" : ["
		end
		s = s .. "\"" .. nsi_players[i] .. "\""
		if i < #nsi_players then
			s = s .. ", "
		else
			s = s .. "]"
		end
	end
	print("[MapToJson] s: " .. s)
	table.insert(players, s)
	table.insert(players, "}")
	local out = table.concat(players, "\n")

	print("[json] return : " .. out)

	return out
end

function LoadJSON(load_success, data)
	print("[LoadJSON] called")
	if load_success == true and data ~= nil then
		local json = _G.json.decode(data)
		print("json: " .. json)
		nsi_players = _JsonToMap(json)
	end
end

function JsonToMap(fileName)
	print("[JsonToMap] called")
	_G.TheSim:GetPersistentString(fileName, LoadJSON)
end

function _JsonToMap(json_string)
	print("[_JsonToMap] called: " .. json_string)
	local players_table = {}
	local start_index = json_string:find("{")
	local end_index = json_string:find("}")
	local players_string = json_string:sub(start_index + 1, end_index - 1)
	local player_entries = {}
	for entry in players_string:gmatch("%b{}") do
		table.insert(player_entries, entry)
	end
	for _, entry in ipairs(player_entries) do
		local key, value = entry:match("%s*(%w+)%s*=%s*(%w+)%s*,")
		players_table[key] = value
	end
	return players_table
end

local function OnPlayerSpawn(inst, player)
	player.prev_OnNewSpawn = player.OnNewSpawn
	player.OnNewSpawn = function()
		-- LoadPlayers()

		-- print(type(inst))
		-- print(type(player))
		-- print(type(_G.TheWorld))

		-- JsonToMap(fileName)
		-- CreateStartingItems(player)

		local _data = {}

		GLOBAL.TheSim:GetPersistentString(fileName, function(load_success, data)
			if load_success == true and data ~= nil then
				nsi_players = _G.json.decode(data)
				-- -- print("data: " .. data)
				-- for key, value in pairs(_data) do
				-- 	table.insert(nsi_players, value)
				-- end
			end
		end)

		print("nsi_players = " .. inspect(nsi_players))

		local spawn = false
		if _G.TheWorld.components.playerspawner ~= nil
			and _G.TheWorld.components.playerspawner:IsPlayersInitialSpawn(inst) then
			spawn = true
		end

		if player.prev_OnNewSpawn ~= nil then
			-- print("players: " .. inspect(nsi_players))
			player:prev_OnNewSpawn()

			-- print("_G.TheWorld: " .. inspect(_G.TheWorld))
			-- print("_G.TheWorld.components.playerspawner: " .. inspect(_G.TheWorld.components.playerspawner))
			-- print("_G.TheWorld.components.playerspawner:IsPlayersInitialSpawn(player): " .._G.TheWorld.components.playerspawner:IsPlayersInitialSpawn(player))
			-- if _G.TheWorld.components.playerspawner ~= nil then
			-- 	print("_G.TheWorld.components.playerspawner")
			-- 	if _G.TheWorld.components.playerspawner:IsPlayersInitialSpawn(inst) then
			-- 		print("[CHECK] true")
			-- 	else
			-- 		print("[CHECK] false")
			-- 	end
			-- end

			if spawn and contains(nsi_players, player.name) then
				print("Player already spawned")
				ClearStartingItems(player)
			else
				print("New Player: " .. player.name)
				table.insert(nsi_players, player.name)
				-- print("inserted : " .. player.name)
			end
			-- print("players: " .. inspect(nsi_players))

			-- SavePlayers()

			-- _G.TheSim:SetPersistentString(fileName, MapToJson())
			_G.TheSim:SetPersistentString(fileName, _G.json.encode(nsi_players))

			player.prev_OnNewSpawn = nil
		end
	end
end



local function ListenForPlayers(inst)
	if _G.TheWorld.ismastersim then
		inst:ListenForEvent("ms_playerspawn", OnPlayerSpawn)
		inst:ListenForEvent("ms_newplayercharacterspawned", NewPlayerCharacterSpawned)
	end
end

AddPrefabPostInit("world", ListenForPlayers)
