/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestMadRamblings = {}

local NoteChestState = {NotSpawned = 0, Spawned = 1}
local noteChestId = 0
local noteChestSpawned = false
local noteLooted = false

-- The mad woman's note chest
local NoteChestStateObjects = orderedTable();
	NoteChestStateObjects["AREAF_MADRAMBLINGS_CHESTSPAWN"] = { state = NoteChestState.Spawned, dbr = "records/items/lootchests/questchests/areaf_madramblings_notechest.dbr" }
	NoteChestStateObjects[""] = { state = NoteChestState.NotSpawned, dbr = nil }
	
function gd.quests.areaFQuestMadRamblings.noteChestOnAddToWorld(objectId)

	if Server && not noteChestSpawned then
		local player = Game.GetLocalPlayer()
		noteChestId = objectId;
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		

		if player:HasToken("AREAF_MADRAMBLINGS_CHESTSPAWN") == false && (player:AnyoneHasToken("AREAF_MADRAMBLINGS_CHESTSPAWN") && ((player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") == false) && (player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == false))) then
			MPOverrideDbr = "records/items/lootchests/questchests/areaf_madramblings_notechest.dbr"
			MPOverrideState = true
		elseif player:HasToken("AREAF_MADRAMBLINGS_CHESTSPAWNED") == false && (player:AnyoneHasToken("AREAF_MADRAMBLINGS_CHESTSPAWNED") && ((player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") == false) && (player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == false))) then
			MPOverrideDbr = "records/items/lootchests/questchests/areaf_madramblings_notechest.dbr"
			MPOverrideState = true
		elseif player:HasToken("AREAF_MADRAMBLINGS_CHESTSPAWNED") then
			MPOverrideDbr = "records/items/lootchests/questchests/areaf_madramblings_notechest.dbr"
			MPOverrideState = true
		end
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, NoteChestStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as chest
		if (newState == NoteChestState.Spawned) then
			noteChestSpawned = true
		end
		
	end
	
end

gd.quests.areaFQuestMadRamblings.chestOnDestroy = ClearObjectUserdata

-- Transition the note chest
function gd.quests.areaFQuestMadRamblings.noteChestTransition()
	
	if Server && not noteChestSpawned then
			
		local player = Game.GetLocalPlayer()
		local entity = Entity.Get(noteChestId)
		
		if (entity != nil) && ((player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") == false) && (player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == false)) then
			UpdateObjectSwap(noteChestId, NoteChestStateObjects)
			noteChestSpawned = true
			
		end
		
	end
	
end

-- The note is picked up
function gd.quests.areaFQuestMadRamblings.noteLooted()

	local player = Game.GetLocalPlayer()
	
	if noteLooted == false && (player != nil) && (player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") == false && player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == false && player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") == false && player:HasToken("AREAF_MADRAMBLINGS_REWARDLOOTED") == false) then
		noteLooted = true
		
		player:GiveItem("records/items/loreobjects/loreobject_areaf_madramblings_01.dbr", 1, false)
		player:GiveToken("AREAF_MADRAMBLINGS_NOTEFOUND")
		player:RemoveToken("AREAF_MADRAMBLINGS_CHESTSPAWN")
		
		-- unlock the lever, if necessary
		QuestEvent("unlockMadRamblingsLever")
	
	end
	
end

-- The note is dropped
function gd.quests.areaFQuestMadRamblings.noteDropped()

	local player = Game.GetLocalPlayer()
	
	if (player != nil) && (player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") && player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == false && player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") == false && player:HasToken("AREAF_MADRAMBLINGS_REWARDLOOTED") == false) then
		local questId01 = 0xA8DA7100
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (questTaskState01 == QuestState.InProgress) then
			noteLooted = false
			
			player:GiveToken("AREAF_MADRAMBLINGS_CHESTSPAWN")
			player:RemoveToken("AREAF_MADRAMBLINGS_NOTEFOUND")
		end

	end
	
end


--
-- Door Control to Ivonda's secret room
--
local secretDoorId = 0
local dungeonDoorId = 0
local leverId = 0
local leverUsed = false
local secretDoorOpened = false
local dungeonDoorOpened = false


-- Secret Door
function gd.quests.areaFQuestMadRamblings.secretDoorOnAddToWorld(objectId)

	if Server then
	
		secretDoorId = objectId
		local door = Door.Get(objectId)
		
		if leverUsed && not secretDoorOpened then
			secretDoorOpened = true
			door:SetLocked(false)
			door:Open()
		end
		
	end
	
end

-- UG Door, Hidden Behind Secret Door
function gd.quests.areaFQuestMadRamblings.dungeonDoorOnAddToWorld(objectId)

	if Server then
		dungeonDoorId = objectId
		local door = Door.Get(objectId)
		
		if leverUsed && not dungeonDoorOpened then
			dungeonDoorOpened = true
			door:SetLocked(false)
			door:Open()
		end
		
	end
	
end

-- The lever
function gd.quests.areaFQuestMadRamblings.leverOnAddToWorld(objectId)

	if Server then
		leverId = objectId;

		local lever = Lever.Get(objectId)
		local player = Game.GetLocalPlayer()

		if player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") == false && (player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") == true || player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == true || player:HasItem("records/items/questitems/quest_areaf_madramblings.dbr", 1, false)) then
			lever:SetLocked(false)
			
		elseif (player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") == true) then
			lever:SetLocked(true)
			
		end
		
	end
	
end

-- Unlock the lever
function gd.quests.areaFQuestMadRamblings.unlockLever()

	if Server then
		local lever = Lever.Get(leverId)
		local player = Game.GetLocalPlayer()
		
		if ((lever != nil) && (lever:IsLocked())) then
			if (player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND") == true || player:HasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == true) then
				lever:SetLocked(false)
			
			end
			
		end
		
	end
	
end

-- Lock the lever
function gd.quests.areaFQuestMadRamblings.lockLever()

	if Server then
		local lever = Lever.Get(leverId)
		local player = Game.GetLocalPlayer()

		if lever != nil && (player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") == true) then
			lever:SetLocked(true)
			
		end
		
	end
	
end

-- Lever used
function gd.quests.areaFQuestMadRamblings.openDungeon()
	if Server then
		-- open secret door
		if not secretDoorOpened then
			secretDoorOpened = true
			local door = Door.Get(secretDoorId)
			
			UI.Notify("tagNotification_AreaF_MadRamblingsDoorOpened")

			if ((door != nil) && (door:IsLocked())) then
				door:SetLocked(false)
				door:Open()
				
			end
		
		end
		
		-- open dungeon door behind secret door
		if not dungeonDoorOpened then
			dungeonDoorOpened = true
			local door = Door.Get(dungeonDoorId)
		
			if ((door != nil) && (door:IsLocked())) then
				door:SetLocked(false)
				door:Open()
				
			end
		
		end

	end
	
end

-- Player enters Loot Room
local lootRoomEntered = false

function gd.quests.areaFQuestMadRamblings.enterLootRoomGlobalMP()
	lootRoomEntered = true
	
	local player = Game.GetLocalPlayer()
	
	if (player != nil) && (player:HasToken("AREAF_MADRAMBLINGS_NOTEFOUND")) then
		player:GiveToken("AREAF_MADRAMBLINGS_LOOTEDROOM")
		player:RemoveToken("AREAF_MADRAMBLINGS_NOTEFOUND")
	
	end

end

function gd.quests.areaFQuestMadRamblings.enterLootRoom(triggererId)
	
	if not lootRoomEntered then
		lootRoomEntered = true
		-- Give out Token for opening secret stash
		QuestGlobalEvent("madRamblingsEnteredLootRoomToken")
	
	end
	
end

-- The mad woman
local ivondaId = 0
local ivondaSpawned = false

local IvondaState = { BaseNotTaken = 0, BaseTaken = 1 }

local ivondaStateObjects = orderedTable();
	ivondaStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = IvondaState.BaseTaken, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ivonda_01.dbr" }
	ivondaStateObjects[""] = { state = IvondaState.BaseNotTaken, dbr = nil }
	
function gd.quests.areaFQuestMadRamblings.ivondaOnAddToWorld(objectId)

	if Server then
		ivondaId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, ivondaStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestMadRamblings.ivondaOnDestroy = ClearObjectUserdata

function gd.quests.areaFQuestMadRamblings.ivondaTransition()
	
	if Server && not ivondaSpawned then
	
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_RETAKEINDUSTRIALDISTRICT") then
			ivondaSpawned = true
			local entity = Entity.Get(ivondaId)
			
			if (entity != nil) then
				local coords = entity:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(ivondaId, ivondaStateObjects)
			
			end
						
		end

	end	
	
end

--
-- The Reward Chest
--
local MadRamblingsRewardState = { NotSpawned = 0, Spawned = 1, Looted = 2, Stolen = 3}
local rewardChestSpawned =  false

-- Reward Chest
local MadRamblingsRewardStateObjects = orderedTable();
	MadRamblingsRewardStateObjects["AREAF_MADRAMBLINGS_LOOTEDROOM"] = { state = MadRamblingsRewardState.Stolen, dbr = nil }
	MadRamblingsRewardStateObjects["AREAF_MADRAMBLINGS_REWARDLOOTED"] = { state = MadRamblingsRewardState.Looted, dbr = nil }
	MadRamblingsRewardStateObjects["AREAF_MADRAMBLINGS_NOTERETURNED"] = { state = MadRamblingsRewardState.Spawned, dbr = "records/items/lootchests/questchests/areaf_madramblings_rewardchest_01.dbr" }
	MadRamblingsRewardStateObjects[""] = { state = MadRamblingsRewardState.NotSpawned, dbr = nil }
	
function gd.quests.areaFQuestMadRamblings.rewardChestOnAddToWorld(objectId)

	if Server && not rewardChestSpawned then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") && (player:AnyoneHasToken("AREAF_MADRAMBLINGS_REWARDLOOTED") == false && (player:AnyoneHasToken("AREAF_MADRAMBLINGS_LOOTEDROOM") == false)) then
			rewardChestId = objectId;
			
			local userdata = {};
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, MadRamblingsRewardStateObjects);
			Shared.setUserdata(objectId, userdata);
			
			-- Don't respawn if spawned as hostile
			if (newState == MadRamblingsRewardState.Spawned) then
				rewardChestSpawned = true
			end
		
		end
		
	end

end

-- The chest is looted
function gd.quests.areaFQuestMadRamblings.rewardChestLooted()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("AREAF_MADRAMBLINGS_NOTERETURNED") == true) then
		player:GiveToken("AREAF_MADRAMBLINGS_REWARDLOOTED")
		player:RemoveToken("AREAF_MADRAMBLINGS_NOTERETURNED")
	
	end
	
end

--
-- Loot Room Chests
--
local LootState = { NotLooted = 0, Looted = 1, Given = 2, Stolen = 3}
local chestSpawned = {false, false, false, false, false} 

-- Chest 01
local MadRamblingsLoot01StateObjects = orderedTable();
	MadRamblingsLoot01StateObjects["AREAF_MADRAMBLINGS_REWARDLOOTED"] = { state = LootState.Stolen, dbr = nil }
	MadRamblingsLoot01StateObjects["AREAF_MADRAMBLINGS_NOTERETURNED"] = { state = LootState.Given, dbr = "records/items/lootchests/b01_chestmetal01.dbr" }
	MadRamblingsLoot01StateObjects["AREAF_MADRAMBLINGS_LOOTEDROOM"] = { state = LootState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr" }
	MadRamblingsLoot01StateObjects[""] = { state = LootState.NotLooted, dbr = "records/items/lootchests/questchests/areaf_madramblings_lootchest_01.dbr" }
	
function gd.quests.areaFQuestMadRamblings.lootChest01OnAddToWorld(objectId)

	if Server && not chestSpawned[1] then
		chestSpawned[1] = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MadRamblingsLoot01StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end

-- Chest 02
local MadRamblingsLoot02StateObjects = orderedTable();
	MadRamblingsLoot02StateObjects["AREAF_MADRAMBLINGS_REWARDLOOTED"] = { state = LootState.Stolen, dbr = nil }
	MadRamblingsLoot02StateObjects["AREAF_MADRAMBLINGS_NOTERETURNED"] = { state = LootState.Given, dbr = "records/items/lootchests/b01_chestmetal01.dbr" }
	MadRamblingsLoot02StateObjects["AREAF_MADRAMBLINGS_LOOTEDROOM"] = { state = LootState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr" }
	MadRamblingsLoot02StateObjects[""] = { state = LootState.NotLooted, dbr = "records/items/lootchests/questchests/areaf_madramblings_lootchest_01.dbr" }
	
function gd.quests.areaFQuestMadRamblings.lootChest02OnAddToWorld(objectId)

	if Server && not chestSpawned[2] then
		chestSpawned[2] = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MadRamblingsLoot02StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end

gd.quests.areaFQuestMadRamblings.lootChest02OnDestroy = ClearObjectUserdata

-- Chest 03
local MadRamblingsLoot03StateObjects = orderedTable();
	MadRamblingsLoot03StateObjects["AREAF_MADRAMBLINGS_REWARDLOOTED"] = { state = LootState.Stolen, dbr = nil }
	MadRamblingsLoot03StateObjects["AREAF_MADRAMBLINGS_NOTERETURNED"] = { state = LootState.Given, dbr = nil }
	MadRamblingsLoot03StateObjects["AREAF_MADRAMBLINGS_LOOTEDROOM"] = { state = LootState.Looted, dbr = nil }
	MadRamblingsLoot03StateObjects[""] = { state = LootState.NotLooted, dbr = "records/items/lootchests/questchests/areaf_madramblings_lootchest_01.dbr" }
	
function gd.quests.areaFQuestMadRamblings.lootChest03OnAddToWorld(objectId)

	if Server && not chestSpawned[3] then
		chestSpawned[3] = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MadRamblingsLoot03StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end

gd.quests.areaFQuestMadRamblings.lootChest03OnDestroy = ClearObjectUserdata

-- Chest 04
local MadRamblingsLoot04StateObjects = orderedTable();
	MadRamblingsLoot04StateObjects["AREAF_MADRAMBLINGS_REWARDLOOTED"] = { state = LootState.Stolen, dbr = nil }
	MadRamblingsLoot04StateObjects["AREAF_MADRAMBLINGS_NOTERETURNED"] = { state = LootState.Given, dbr = nil }
	MadRamblingsLoot04StateObjects["AREAF_MADRAMBLINGS_LOOTEDROOM"] = { state = LootState.Looted, dbr = nil }
	MadRamblingsLoot04StateObjects[""] = { state = LootState.NotLooted, dbr = "records/items/lootchests/questchests/areaf_madramblings_lootchest_01.dbr" }
	
function gd.quests.areaFQuestMadRamblings.lootChest04OnAddToWorld(objectId)

	if Server && not chestSpawned[4] then
		chestSpawned[4] = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MadRamblingsLoot04StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end

-- Chest 05
local MadRamblingsLoot05StateObjects = orderedTable();
	MadRamblingsLoot05StateObjects["AREAF_MADRAMBLINGS_REWARDLOOTED"] = { state = LootState.Stolen, dbr = nil }
	MadRamblingsLoot05StateObjects["AREAF_MADRAMBLINGS_NOTERETURNED"] = { state = LootState.Given, dbr = nil }
	MadRamblingsLoot05StateObjects["AREAF_MADRAMBLINGS_LOOTEDROOM"] = { state = LootState.Looted, dbr = nil }
	MadRamblingsLoot05StateObjects[""] = { state = LootState.NotLooted, dbr = "records/items/lootchests/questchests/areaf_madramblings_lootchest_01.dbr"}
	
function gd.quests.areaFQuestMadRamblings.lootChest05OnAddToWorld(objectId)

	if Server && not chestSpawned[5] then
		chestSpawned[5] = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MadRamblingsLoot05StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end


