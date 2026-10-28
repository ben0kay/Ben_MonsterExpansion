/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestUgdenbog = {}


--
-- Locked chaos riftgate
--
local riftFXId = 0
local interactiveSiteId = 0
local VoidRiftState = { Default = 0, Active = 1}
local lockedVoidRiftId = 0
local riftOpened = false


-- fX for the rift
local riftFXStateObjects = orderedTable();
	riftFXStateObjects["AREAE_BOGVOIDRIFT_OPENED"] = { state = VoidRiftState.Active, dbr = "records/fx/ambient/altarrattosh01_active_fx01.dbr" }
	riftFXStateObjects[""] = { state = VoidRiftState.Default, dbr = nil }

function gd.quests.areaEQuestUgdenbog.voidFX01OnAddToWorld(objectId)
	
	if Server then
		riftFXId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if riftOpened then
			MPOverrideDbr = "records/fx/ambient/altarrattosh01_active_fx01.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, riftFXStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaEQuestUgdenbog.voidFX01OnDestroy = ClearObjectUserdata


-- Interaction Site
local interactionSiteStateObjects = orderedTable();
	interactionSiteStateObjects["AREAE_BOGVOIDRIFT_OPENED"] = { state = VoidRiftState.Active,  dbr = nil }
	interactionSiteStateObjects[""] = { state = VoidRiftState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_bogvoidrift.dbr" }

function gd.quests.areaEQuestUgdenbog.bogVoidInteractionSiteOnAddToWorld(objectId)
	
	if Server && not riftOpened then
	
		interactiveSiteId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, interactionSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaEQuestUgdenbog.bogVoidInteractionSiteOnDestroy = ClearObjectUserdata

-- Rift
function gd.quests.areaEQuestUgdenbog.lockedChaosRiftOnAddToWorld(objectId)
	
	if Server then
		
		local player = Game.GetLocalPlayer()
		lockedVoidRiftId = objectId
				
		if (player:HasToken("AREAE_BOGVOIDRIFT_OPENED") || riftOpened) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

-- Open The Rift
function gd.quests.areaEQuestUgdenbog.bogVoidRiftOpened()

	if Server then
		local player = Game.GetLocalPlayer()
		riftOpened= true
		
		local door = Door.Get(lockedVoidRiftId)
			
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/skillsother/fxpak_attackradius_riftblast01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
		-- spawn FX and despawn NPC
		local MPOverrideDbrSite = nil
		local MPOverrideDbrFX = nil
		local MPOverrideState = false
		
		if (player != nil) && (player:HasToken("AREAE_BOGVOIDRIFT_OPENED") == false) then
			MPOverrideDbrSite = nil
			MPOverrideDbrFX = "records/fx/ambient/altarrattosh01_active_fx01.dbr"
			MPOverrideState =  true
		end
		
		local siteEntity = Entity.Get(interactiveSiteId)
		
		if (siteEntity != nil) then
			local coords = siteEntity:GetCoords()
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
	
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(interactiveSiteId, interactionSiteStateObjects, nil, nil, MPOverrideState, MPOverrideDbrSite)
		
		end
		
		local FXEntity = Entity.Get(riftFXId)
		
		if (FXEntity != nil) then
			UpdateObjectSwap(riftFXId, riftFXStateObjects, nil, nil, MPOverrideState, MPOverrideDbrFX)
		
		end
		
	end
	
end


-- Kraken Boss Control
local bossChestId = 0
local bossChest02Id = 0
local bossKilled = false
local tentacleIDs = {0, 0, 0, 0, 0, 0}

-- Boss Door Control
local krakenDoorIDs = { 0, 0, 0 }

function gd.quests.areaEQuestUgdenbog.krakenDoor01OnAddToWorld(objectId)
	
	if Server then
		krakenDoorIDs[1] = objectId
		
	end
	
end

function gd.quests.areaEQuestUgdenbog.krakenDoor02OnAddToWorld(objectId)
	
	if Server then
		krakenDoorIDs[2] = objectId
		
	end
	
end

function gd.quests.areaEQuestUgdenbog.krakenDoor03OnAddToWorld(objectId)
	
	if Server then
		krakenDoorIDs[3] = objectId
		
	end
	
end

function gd.quests.areaEQuestUgdenbog.krakenKilled()

	GiveTokenToLocalPlayer("GDX1_KRAKENSLAIN")
	
	if Server then
		local chest = Chest.Get(bossChestId);
		local chest02 = Chest.Get(bossChest02Id);
		
		bossKilled = true
	
		-- Unlock chests if present
		if (chest ~= nil) then
			chest:SetLocked(false)
		end
		
		if (chest02 ~= nil) then
			chest02:SetLocked(false)
		end
		
		-- destroy turrets
		local tentaclesTotal = table.getn(tentacleIDs)
		
		for id = 1, tentaclesTotal do
			local character = Character.Get(tentacleIDs[id])
			
			if (character != nil) then
				character:Kill()
				
			end
		
		end
		
		-- open doors
		local doorsTotal = table.getn(krakenDoorIDs)
		
		for id = 1, doorsTotal do
			local door = Door.Get(krakenDoorIDs[id])
			
			if door ~= nil then
				door:Open()
			
			end
		
		end
		
	end
	
end

function gd.quests.areaEQuestUgdenbog.krakenChestOnAddToWorld(objectId)

	if Server then
		bossChestId = objectId
		
	end
	
end

function gd.quests.areaEQuestUgdenbog.krakenChest02OnAddToWorld(objectId)
	
	if Server then
		local chestEntity = Entity.Get(objectId)
		bossChest02Id = objectId
		player = Game.GetLocalPlayer()
	
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHEST_KRAKEN")) then
			print "Destroying Chest"
			chestEntity:Destroy()
			
		end
		
	end
	
end

function gd.quests.areaEQuestUgdenbog.krakenChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHEST_KRAKEN");
	
end

function gd.quests.areaEQuestUgdenbog.krakenTentacleOnAddToWorld(objectId)

	if Server then
		local found = false
		local tentaclesTotal = table.getn(tentacleIDs)
		
		for id = 1, tentaclesTotal do
			if (tentacleIDs[id] == 0 && not found) then
				tentacleIDs[id] = objectId
				found = true
				
			end
			
		end
		
	end
	
end


-- Aetherfire Obelisks Scripted Sequence
local sequenceStarted = false
local sequenceStarted02 = false
local sequenceTriggered = false
local sequenceTriggered02 = false
local obelisk01Id = 0
local obelisk02Id = 0

local obelisk01TargetIds = { 0, 0, 0, 0 }
local obelisk01TargetCoords = { nil, nil, nil, nil }
local obelisk01SequenceTriggerStarted = { false, false, false, false }
local obelisk01SequenceTriggerFinished = { false, false, false, false }

local obelisk02TargetIds = { 0, 0, 0, 0, 0 }
local obelisk02TargetCoords = { nil, nil, nil, nil, nil }
local obelisk02SequenceTriggerStarted = { false, false, false, false, false }
local obelisk02SequenceTriggerFinished = { false, false, false, false, false }

function gd.quests.areaEQuestUgdenbog.obelisk01OnAddToWorld(objectId)

	if Server then
		obelisk01Id = objectId
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02OnAddToWorld(objectId)

	if Server then
		obelisk02Id = objectId
	
	end

end

-- Obelisk 1 Controls
function gd.quests.areaEQuestUgdenbog.obelisk01Target01OnAddToWorld(objectId)

	if Server then
		obelisk01TargetIds[1] = objectId
		obelisk01TargetCoords[1] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01Target02OnAddToWorld(objectId)

	if Server then
		obelisk01TargetIds[2] = objectId
		obelisk01TargetCoords[2] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01Target03OnAddToWorld(objectId)

	if Server then
		obelisk01TargetIds[3] = objectId
		obelisk01TargetCoords[3] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01Target04OnAddToWorld(objectId)

	if Server then
		obelisk01TargetIds[4] = objectId
		obelisk01TargetCoords[4] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01_Trigger01()

	if Server then
		local obelisk01 = Character.Get(obelisk01Id)
		
		if not obelisk01SequenceTriggerFinished[1] then
			if obelisk01 != nil && not obelisk01SequenceTriggerStarted[1] then
				obelisk01SequenceTriggerStarted[1] = true
				obelisk01SequenceTriggerStarted[2] = false
				obelisk01SequenceTriggerFinished[2] = false
				
				obelisk01:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk01TargetIds[1], false)
				
			elseif obelisk01 != nil && obelisk01SequenceTriggerStarted[1] then
				obelisk01:MoveAction(obelisk01TargetIds[2], obelisk01TargetCoords[2], true)
				obelisk01SequenceTriggerFinished[1] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01_Trigger02()

	if Server then
		local obelisk01 = Character.Get(obelisk01Id)

		if not obelisk01SequenceTriggerFinished[2] then
			if obelisk01 != nil && not obelisk01SequenceTriggerStarted[2] then
				obelisk01SequenceTriggerStarted[2] = true
				obelisk01SequenceTriggerStarted[3] = false
				obelisk01SequenceTriggerFinished[3] = false
				
				obelisk01:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk01TargetIds[2], false)
				
			elseif obelisk01 != nil && obelisk01SequenceTriggerStarted[2] then
				obelisk01:MoveAction(obelisk01TargetIds[3], obelisk01TargetCoords[3], true)
				obelisk01SequenceTriggerFinished[2] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01_Trigger03()

	if Server then
		local obelisk01 = Character.Get(obelisk01Id)
		
		if not obelisk01SequenceTriggerFinished[3] then
			if obelisk01 != nil && not obelisk01SequenceTriggerStarted[3] then
				obelisk01SequenceTriggerStarted[3] = true
				obelisk01SequenceTriggerStarted[4] = false
				obelisk01SequenceTriggerFinished[4] = false
				
				obelisk01:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk01TargetIds[3], false)
				
			elseif obelisk01 != nil && obelisk01SequenceTriggerStarted[3] then
				obelisk01:MoveAction(obelisk01TargetIds[4], obelisk01TargetCoords[4], true)
				obelisk01SequenceTriggerFinished[3] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk01_Trigger04()

	if Server then
		local obelisk01 = Character.Get(obelisk01Id)
		
		if not obelisk01SequenceTriggerFinished[4] then
			if obelisk01 != nil && not obelisk01SequenceTriggerStarted[4] then
				obelisk01SequenceTriggerStarted[4] = true
				obelisk01SequenceTriggerStarted[1] = false
				obelisk01SequenceTriggerFinished[1] = false
				
				obelisk01:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk01TargetIds[4], false)
				
			elseif obelisk01 != nil && obelisk01SequenceTriggerStarted[4] then
				obelisk01:MoveAction(obelisk01TargetIds[1], obelisk01TargetCoords[1], true)
				obelisk01SequenceTriggerFinished[4] = true
			
			end
		
		end
		
	end

end


-- Obelisk 1 Controls
function gd.quests.areaEQuestUgdenbog.obelisk02Target01OnAddToWorld(objectId)

	if Server then
		obelisk02TargetIds[1] = objectId
		obelisk02TargetCoords[1] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02Target02OnAddToWorld(objectId)

	if Server then
		obelisk02TargetIds[2] = objectId
		obelisk02TargetCoords[2] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02Target03OnAddToWorld(objectId)

	if Server then
		obelisk02TargetIds[3] = objectId
		obelisk02TargetCoords[3] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02Target04OnAddToWorld(objectId)

	if Server then
		obelisk02TargetIds[4] = objectId
		obelisk02TargetCoords[4] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02Target05OnAddToWorld(objectId)

	if Server then
		obelisk02TargetIds[5] = objectId
		obelisk02TargetCoords[5] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02_Trigger01()

	if Server then
		local obelisk02 = Character.Get(obelisk02Id)
		
		if not obelisk02SequenceTriggerFinished[1] then
			if obelisk02 != nil && not obelisk02SequenceTriggerStarted[1] then
				obelisk02SequenceTriggerStarted[1] = true
				obelisk02SequenceTriggerStarted[2] = false
				obelisk02SequenceTriggerFinished[2] = false
				
				obelisk02:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk02TargetIds[1], false)
				
			elseif obelisk02 != nil && obelisk02SequenceTriggerStarted[1] then
				obelisk02:MoveAction(obelisk02TargetIds[2], obelisk02TargetCoords[2], true)
				obelisk02SequenceTriggerFinished[1] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02_Trigger02()

	if Server then
		local obelisk02 = Character.Get(obelisk02Id)

		if not obelisk02SequenceTriggerFinished[2] then
			if obelisk02 != nil && not obelisk02SequenceTriggerStarted[2] then
				obelisk02SequenceTriggerStarted[2] = true
				obelisk02SequenceTriggerStarted[3] = false
				obelisk02SequenceTriggerFinished[3] = false
				
				obelisk02:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk02TargetIds[2], false)
				
			elseif obelisk02 != nil && obelisk02SequenceTriggerStarted[2] then
				obelisk02:MoveAction(obelisk02TargetIds[3], obelisk02TargetCoords[3], true)
				obelisk02SequenceTriggerFinished[2] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02_Trigger03()

	if Server then
		local obelisk02 = Character.Get(obelisk02Id)
		
		if not obelisk02SequenceTriggerFinished[3] then
			if obelisk02 != nil && not obelisk02SequenceTriggerStarted[3] then
				obelisk02SequenceTriggerStarted[3] = true
				obelisk02SequenceTriggerStarted[4] = false
				obelisk02SequenceTriggerFinished[4] = false
				
				obelisk02:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk02TargetIds[3], false)
				
			elseif obelisk02 != nil && obelisk02SequenceTriggerStarted[3] then
				obelisk02:MoveAction(obelisk02TargetIds[4], obelisk02TargetCoords[4], true)
				obelisk02SequenceTriggerFinished[3] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02_Trigger04()

	if Server then
		local obelisk02 = Character.Get(obelisk02Id)
		
		if not obelisk02SequenceTriggerFinished[4] then
			if obelisk02 != nil && not obelisk02SequenceTriggerStarted[4] then
				obelisk02SequenceTriggerStarted[4] = true
				obelisk02SequenceTriggerStarted[5] = false
				obelisk02SequenceTriggerFinished[5] = false
				
				obelisk02:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk02TargetIds[4], false)
				
			elseif obelisk02 != nil && obelisk02SequenceTriggerStarted[4] then
				obelisk02:MoveAction(obelisk02TargetIds[5], obelisk02TargetCoords[5], true)
				obelisk02SequenceTriggerFinished[4] = true
			
			end
		
		end
		
	end

end

function gd.quests.areaEQuestUgdenbog.obelisk02_Trigger05()

	if Server then
		local obelisk02 = Character.Get(obelisk02Id)
		
		if not obelisk02SequenceTriggerFinished[5] then
			if obelisk02 != nil && not obelisk02SequenceTriggerStarted[5] then
				obelisk02SequenceTriggerStarted[5] = true
				obelisk02SequenceTriggerStarted[1] = false
				obelisk02SequenceTriggerFinished[1] = false
				
				obelisk02:UseSkillAction("records/skills/nonplayerskillsgdx1/quest/obeliskscripted_flamewave.dbr", obelisk02TargetIds[5], false)
				
			elseif obelisk02 != nil && obelisk02SequenceTriggerStarted[5] then
				obelisk02:MoveAction(obelisk02TargetIds[1], obelisk02TargetCoords[1], true)
				obelisk02SequenceTriggerFinished[5] = true
			
			end
		
		end
		
	end

end

-- Start Obelisk Sequence 01
function gd.quests.areaEQuestUgdenbog.triggerSequenceEvent()

	if Server then
		if not sequenceStarted then
			sequenceStarted = true
			
			local obelisk01 = Character.Get(obelisk01Id)
			obelisk01:MoveAction(obelisk01TargetIds[1], obelisk01TargetCoords[1], true)
			
		end
	
	end
	
end

function gd.quests.areaEQuestUgdenbog.triggerSequence(triggererId)

	if not sequenceTriggered then
		sequenceTriggered = true
		QuestEvent("startBogObeliskSequence")
		
	end
	
end

-- Start Obelisk Sequence 02
function gd.quests.areaEQuestUgdenbog.triggerSequenceEvent02()

	if Server then
		if not sequenceStarted02 then
			sequenceStarted02 = true
			
			local obelisk02 = Character.Get(obelisk02Id)
			obelisk02:MoveAction(obelisk02TargetIds[1], obelisk02TargetCoords[1], true)
			
		end
	
	end
	
end

function gd.quests.areaEQuestUgdenbog.triggerSequence02(triggererId)

	if not sequenceTriggered02 then
		sequenceTriggered02 = true
		QuestEvent("startBogObeliskSequence02")
		
	end
	
end
