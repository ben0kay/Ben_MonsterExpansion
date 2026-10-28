/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGBysmielFaction = {}


--
-- The player must find the kymon's chosen soldiers who have fled the battlefield. If the player has alrady sided with Kymon's chosen he can let them go. If not he must fight them and retrieve an item they're supposedly trying to escape with.
--

-- Kymon's chosen soldiers
local KymonSoldier01Id = 0
local KymonSoldier02Id = 0
local KymonSoldier03Id = 0
local KymonSoldier01Hostile = false
local KymonSoldier02Hostile = false
local KymonSoldier03Hostile = false

local KymonSoldierState = { Default = 0, Spawned = 1, Hostile = 2, Killed = 3, Friendly = 4}

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 200
	end
	
	if (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+2)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+3)

	end

	return monsterLevel, nil
	
end

local KymonSoldier01IdStateObjects = orderedTable();
	KymonSoldier01IdStateObjects["AREAG_BYSMIEL_KYMONFRIENDLY"] = { state = KymonSoldierState.Friendly, dbr = nil }
	KymonSoldier01IdStateObjects["AREAG_BYSMIEL_KYMONKILLED"] = { state = KymonSoldierState.Killed, dbr = nil }
	KymonSoldier01IdStateObjects["AREAG_BYSMIEL_KYMONATTACKED"] = { state = KymonSoldierState.Hostile, dbr = "records/creatures/enemies/faction/kymonsoldier_01.dbr"}
	KymonSoldier01IdStateObjects["AREAG_BYSMIEL_KYMONSPAWNED"] = { state = KymonSoldierState.Spawned, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_01.dbr"}
	KymonSoldier01IdStateObjects[""] = { state = KymonSoldierState.Default, dbr = nil }

function gd.quests.areaGBysmielFaction.KymonSoldier01OnAddToWorld(objectId)
	
	if Server then
		if (not KymonSoldier01Hostile) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local kQuest = 0x02852988
			local kTask = 0xA2F0D500
			local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
			if player:AnyoneHasToken("AREAG_BYSMIEL_KYMONSPAWNED") && questTaskState != QuestState.Complete && player:HasToken("AREAG_BYSMIEL_KYMONATTACKED") == false then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_01.dbr"
				MPOverrideState = true
			
			end
			
			KymonSoldier01Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, KymonSoldier01IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn next time. If spawned as hostile, will be saved into the world
			if (newState == KymonSoldierState.Hostile) then
				KymonSoldier01Hostile = true
				
			end
			
		end
	
	end
	
end

gd.quests.areaGBysmielFaction.KymonSoldier01OnDestroy = ClearObjectUserdata

local KymonSoldier02IdStateObjects = orderedTable();
	KymonSoldier02IdStateObjects["AREAG_BYSMIEL_KYMONFRIENDLY"] = { state = KymonSoldierState.Friendly, dbr = nil }
	KymonSoldier02IdStateObjects["AREAG_BYSMIEL_KYMONKILLED"] = { state = KymonSoldierState.Killed, dbr = nil }
	KymonSoldier02IdStateObjects["AREAG_BYSMIEL_KYMONATTACKED"] = { state = KymonSoldierState.Hostile, dbr = "records/creatures/enemies/faction/kymonsoldier_02.dbr"}
	KymonSoldier02IdStateObjects["AREAG_BYSMIEL_KYMONSPAWNED"] = { state = KymonSoldierState.Spawned, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_02.dbr"}
	KymonSoldier02IdStateObjects[""] = { state = KymonSoldierState.Default, dbr = nil }

function gd.quests.areaGBysmielFaction.KymonSoldier02OnAddToWorld(objectId)
	
	if Server then
		if (not KymonSoldier02Hostile) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local kQuest = 0x02852988
			local kTask = 0xA2F0D500
			local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
			if player:AnyoneHasToken("AREAG_BYSMIEL_KYMONSPAWNED") && questTaskState != QuestState.Complete && player:HasToken("AREAG_BYSMIEL_KYMONATTACKED") == false then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_02.dbr"
				MPOverrideState = true
			
			end
			
			KymonSoldier02Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, KymonSoldier02IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn next time. If spawned as hostile, will be saved into the world
			if (newState == KymonSoldierState.Hostile) then
				KymonSoldier02Hostile = true
				
			end
			
		end
	
	end
	
end

gd.quests.areaGBysmielFaction.KymonSoldier02OnDestroy = ClearObjectUserdata

local KymonSoldier03IdStateObjects = orderedTable();
	KymonSoldier03IdStateObjects["AREAG_BYSMIEL_KYMONFRIENDLY"] = { state = KymonSoldierState.Friendly, dbr = nil }
	KymonSoldier03IdStateObjects["AREAG_BYSMIEL_KYMONKILLED"] = { state = KymonSoldierState.Killed, dbr = nil }
	KymonSoldier03IdStateObjects["AREAG_BYSMIEL_KYMONATTACKED"] = { state = KymonSoldierState.Hostile, dbr = "records/creatures/enemies/faction/kymonsoldier_03.dbr"}
	KymonSoldier03IdStateObjects["AREAG_BYSMIEL_KYMONSPAWNED"] = { state = KymonSoldierState.Spawned, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_03.dbr"}
	KymonSoldier03IdStateObjects[""] = { state = KymonSoldierState.Default, dbr = nil }

function gd.quests.areaGBysmielFaction.KymonSoldier03OnAddToWorld(objectId)
	
	if Server then
		if (not KymonSoldier03Hostile) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local kQuest = 0x02852988
			local kTask = 0xA2F0D500
			local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
			if player:AnyoneHasToken("AREAG_BYSMIEL_KYMONSPAWNED") && questTaskState != QuestState.Complete && player:HasToken("AREAG_BYSMIEL_KYMONATTACKED") == false then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_03.dbr"
				MPOverrideState = true
			
			end
			
			KymonSoldier03Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, KymonSoldier03IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn next time. If spawned as hostile, will be saved into the world
			if (newState == KymonSoldierState.Hostile) then
				KymonSoldier03Hostile = true
				
			end
			
		end
	
	end
	
end

gd.quests.areaGBysmielFaction.KymonSoldier03OnDestroy = ClearObjectUserdata

-- Spawn Kymon's Deserters
function gd.quests.areaGBysmielFaction.kymonDeserterSpawn()

	if Server then
		local player = Game.GetLocalPlayer()

		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_BYSMIEL_KYMONSPAWNED") == false) then
			MPOverrideDbr01 = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_01.dbr"
			MPOverrideDbr02 = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_02.dbr"
			MPOverrideDbr03 = "records/creatures/npcs/questnpcs/gdareag/npc_kymonsoldier_03.dbr"
			MPOverrideState = true
		end
		
		local entity01 = Entity.Get(KymonSoldier01Id)
		local entity02 = Entity.Get(KymonSoldier02Id)
		local entity03 = Entity.Get(KymonSoldier03Id)
		
		if entity01 != nil then
			UpdateObjectSwap(KymonSoldier01Id, KymonSoldier01IdStateObjects, Character, nil, MPOverrideState, MPOverrideDbr01)
			
			local coords = entity01:GetCoords();
			local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
			
			if rift ~= nil then
				rift:NetworkEnable()
				rift:SetCoords(coords)
				
			end
		
		end
		
		if entity02 != nil then
			UpdateObjectSwap(KymonSoldier02Id, KymonSoldier02IdStateObjects, Character, nil, MPOverrideState, MPOverrideDbr02)
			
			local coords = entity02:GetCoords();
			local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
			
			if rift ~= nil then
				rift:NetworkEnable()
				rift:SetCoords(coords)
				
			end
		
		end
		
		if entity03 != nil then
			UpdateObjectSwap(KymonSoldier03Id, KymonSoldier03IdStateObjects, Character, nil, MPOverrideState, MPOverrideDbr03)
			
			local coords = entity03:GetCoords();
			local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
			
			if rift ~= nil then
				rift:NetworkEnable()
				rift:SetCoords(coords)
				
			end
		
		end
		
	end
	
end

-- Hostile Transition
function gd.quests.areaGBysmielFaction.kymonDeserterFriendlyTokenGlobalMP()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)

	if questTaskState == QuestState.InProgress && player:HasToken("AREAG_BYSMIEL_KYMONFRIENDLY") == false then
		player:GiveToken("AREAG_BYSMIEL_KYMONATTACKED")
	
	end

end

function gd.quests.areaGBysmielFaction.bysmielKymonDeserterHostile()

	if Server then
		local player = Game.GetLocalPlayer()

		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_BYSMIEL_KYMONATTACKED") == false) then
			MPOverrideDbr01 = "records/creatures/enemies/faction/kymonsoldier_01.dbr"
			MPOverrideDbr02 = "records/creatures/enemies/faction/kymonsoldier_02.dbr"
			MPOverrideDbr03 = "records/creatures/enemies/faction/kymonsoldier_03.dbr"
			MPOverrideState = true
		end
		
		local entity01 = Entity.Get(KymonSoldier01Id)
		local entity02 = Entity.Get(KymonSoldier02Id)
		local entity03 = Entity.Get(KymonSoldier03Id)

		if (not KymonSoldier01Hostile) then
			UpdateObjectSwap(KymonSoldier01Id, KymonSoldier01IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr01)
			
			KymonSoldier01Hostile = true
			
		end
		
		if (not KymonSoldier02Hostile) then
			UpdateObjectSwap(KymonSoldier02Id, KymonSoldier02IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr02)
			
			KymonSoldier02Hostile = true
			
		end
		
		if (not KymonSoldier03Hostile) then
			UpdateObjectSwap(KymonSoldier03Id, KymonSoldier03IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr03)
			
			KymonSoldier03Hostile = true
			
		end
		
		QuestGlobalEvent("kymonDeserterHostileTokenGlobalMP")
		
	end
	
end

-- Friendly token for dealing with the deserters peacefully
function gd.quests.areaGBysmielFaction.kymonDeserterFriendlyTokenGlobalMP()
	local player = Game.GetLocalPlayer()
	
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)

	if questTaskState == QuestState.InProgress && player:HasToken("AREAG_BYSMIEL_KYMONATTACKED") == false && player:HasToken("AREAG_BYSMIEL_KYMONFRIENDLY") == false then
		player:GiveToken("AREAG_BYSMIEL_KYMONFRIENDLY")
		player:GiveItem("records/items/questitems/quest_areag_kymonrelic.dbr", 1, false)
	
	end

end




