/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGSQMawOfEnaht = {}

-- Trigger for finding the Mawh of Enaht
function gd.quests.areaGSQMawOfEnaht.MawOfEnahtFound(triggererId)

	local player = Player.Get(triggererId)
	
	local kQuest1 = 0x17168060
	local kTask1 = 0x1501C060
	local kTask2 = 0x31C15500
	
	local questTaskState1 = player:GetQuestTaskState(kQuest1, kTask1)
	local questTaskState2 = player:GetQuestTaskState(kQuest1, kTask2)
	
	if player:HasToken("AREAG_SEARCHFORTHEMAW") && questTaskState1 != QuestState.InProgress && questTaskState1 != QuestState.Complete && questTaskState2 != QuestState.InProgress && questTaskState2 != QuestState.Complete then
		player:GrantQuest(0x17168060, 0x1501C060)
	elseif questTaskState2 != QuestState.InProgress && questTaskState2 != QuestState.Complete && questTaskState1 != QuestState.InProgress && questTaskState1 != QuestState.Complete then
		player:GrantQuest(0x17168060, 0x31C15500)
	
	end
	
end

-- The Flavor NPC Carmac leaves the Bysmiel camp after the player returns from finding the Maw of Enaht
local noteSpawned = false
local note02Spawned = false

local CarmacState = { PreQuest = 0, MawFound = 1}

-- Carmac
local CarmacStateObjects = orderedTable();
	CarmacStateObjects["AREAG_CARMACLEFT"] = { state = CarmacState.MawFound, dbr = nil}
	CarmacStateObjects[""] = { state = CarmacState.PreQuest, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_bysmielflavor_02.dbr"}

function gd.quests.areaGSQMawOfEnaht.carmac01OnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, CarmacStateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGSQMawOfEnaht.carmac01OnDestroy = ClearObjectUserdata

-- Carmac's lore note. Appears after carmac goes to investigate the maw.
local CarmacLoreNote01StateObjects = orderedTable();
	CarmacLoreNote01StateObjects["AREAG_CARMACLEFT"] = { state = CarmacState.MawFound, dbr = "records/items/loreobjects/loreobject_areag_carmacsnotes_01.dbr"}
	CarmacLoreNote01StateObjects[""] = { state = CarmacState.PreQuest, dbr = nil}

function gd.quests.areaGSQMawOfEnaht.carmacNote01OnAddToWorld(objectId)
	
	if Server && not noteSpawned then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CarmacLoreNote01StateObjects)
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as item
		if (newState == CarmacState.MawFound) then
			noteSpawned = true
		end
	
	end
	
end

gd.quests.areaGSQMawOfEnaht.carmacNote01OnDestroy = ClearObjectUserdata


-- Carmac's lore note inside the maw. Appears after carmac goes to investigate the maw.
local CarmacLoreNote02StateObjects = orderedTable();
	CarmacLoreNote02StateObjects["AREAG_CARMACLEFT"] = { state = CarmacState.MawFound, dbr = "records/items/loreobjects/loreobject_areag_roguelike_a01.dbr"}
	CarmacLoreNote02StateObjects[""] = { state = CarmacState.PreQuest, dbr = nil}

function gd.quests.areaGSQMawOfEnaht.carmacNote02OnAddToWorld(objectId)
	
	if Server && not note02Spawned then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CarmacLoreNote02StateObjects)
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as item
		if (newState == CarmacState.MawFound) then
			note02Spawned = true
		end
	
	end
	
end

gd.quests.areaGSQMawOfEnaht.carmacNote02OnDestroy = ClearObjectUserdata


