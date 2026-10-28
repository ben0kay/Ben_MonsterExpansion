/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestMalmouthBridge = {};

--
-- Waved battle to unlock the bridge rift gate outside malmouth
--
local OuterBridgeWaveObjectId = 0
local OuterBridgeWaveEventStarted = false
local OuterBridgeWaveEventKey = "AREAF_OUTERBRIDGE_WAVEEVENT"
local outerBridgeRiftgate = nil
local bridgeDoorID = 0

--Wave Object 
function gd.quests.areaFQuestMalmouthBridge.waveEventOnAddToWorld(objectId)

	if Server then
		OuterBridgeWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, OuterBridgeWaveEventKey)
	
	end

end

function gd.quests.areaFQuestMalmouthBridge.waveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end

--Wave event ends
local OuterBridgeEndedMP = false

function gd.quests.areaFQuestMalmouthBridge.endEventMP()
	
	if not OuterBridgeEndedMP then
		OuterBridgeEndedMP = true
		
		GiveTokenToLocalPlayer("AREAF_CITYGATESFOUND")
		
		if outerBridgeRiftgate != nil then
			outerBridgeRiftgate:SetLocked(false)
			
		end
		
	end
	
end

function gd.quests.areaFQuestMalmouthBridge.endOuterBridgeWaveEvent(objectId)

	if Server then
		-- MP end wave event
		QuestGlobalEvent("MalmouthOuterBridgeEndEvent")
		UI.Notify("tagNotification_AreaF_OuterBridgeRiftGateEventClear")
		
	end
	
end

--Wave event
local outerBridgeWaveParameters = { }
	outerBridgeWaveParameters.waves = {"records/proxies/boss&questgdx1/questproxy_waveevent_malmouthouterbridge_wave01.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthouterbridge_wave02.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthouterbridge_wave03.dbr"}
	outerBridgeWaveParameters.endCallback = gd.quests.areaFQuestMalmouthBridge.endOuterBridgeWaveEvent
	outerBridgeWaveParameters.key = OuterBridgeWaveEventKey

--Player touches the event start trigger
local eventStarted = false

function gd.quests.areaFQuestMalmouthBridge.triggerWaveEvent(triggererId)
	
	if not eventStarted then
		local player = Player.Get(triggererId)

		if (player:HasToken("AREAF_CITYGATESFOUND") == false) then
		
			if (player:GetLevel() > 10) then
				eventStarted = true
				
				UI.Notify("tagNotification_AreaF_OuterBridgeRiftgateEvent")
				QuestEvent("MalmouthOuterBridgeStartEvent")
				
			end	
		
		end

	end
	
end
	
function gd.quests.areaFQuestMalmouthBridge.startEventMP()

	if Server then
		if (not OuterBridgeWaveEventStarted) then
			OuterBridgeWaveEventStarted = true
			
			WaveEvent_Start(OuterBridgeWaveObjectId, outerBridgeWaveParameters)
		
		end
		
	end

end

--
-- Controls the state of the outer bridge rift gate
-- 
function gd.quests.areaFQuestMalmouthBridge.RiftgateOnAddToWorld(objectId)

	-- This function is run locally on all clients to set the variable and unlock the gate. Riftgates are not spawned by the server
	local player = Game.GetLocalPlayer()
	outerBridgeRiftgate = Riftgate.Get(objectId)

	if player:HasToken("AREAF_CITYGATESFOUND") then
		outerBridgeRiftgate:SetLocked(false)
	
	end

end

-- Lowering the Bridge
-- The lever
local leverId = 0
local bossKilled = false
local MalmouthBridgeOpened = false

function gd.quests.areaFQuestMalmouthBridge.leverOnAddToWorld(objectId)

	if Server then
		leverId = objectId;

		local lever = Lever.Get(objectId)
		local player = Game.GetLocalPlayer()

		if bossKilled == true then
			lever:SetLocked(false)
			
		end
		
	end
	
end

-- Unlock the lever
function gd.quests.areaFQuestMalmouthBridge.unlockLeverMP()

	if Server then
	
		local player = Game.GetLocalPlayer()
	
		if (player:HasToken("AREAF_MALMOUTHBRIDGELOWERED") == false) then
			local lever = Lever.Get(leverId)
		
			if ((lever != nil) && (lever:IsLocked())) then
				lever:SetLocked(false)
			
			end
		
		end
		
	end
	
end

function gd.quests.areaFQuestMalmouthBridge.unlockLever()

	bossKilled = true

	QuestEvent("unlockMalmouthBridgeLever")
	
end

function gd.quests.areaFQuestMalmouthBridge.loweredBridge()

	QuestEvent("loweredMalmouthBridge")
	
end


-- The bridge door object
function gd.quests.areaFQuestMalmouthBridge.BridgeDoorOnAddToWorld(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		bridgeDoorID = objectId
		
		if (player:HasToken("AREAF_MALMOUTHBRIDGELOWERED")) then

			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()
			end
		
		end
		
	end
	
end

 
local bridgeFightersSpawned = false
local BridgeBLFighterIDs = {0, 0, 0}
local captive01Ids = {0, 0}
local BridgeBLFighterCoords = {0, 0, 0}
local BridgeBLFighterTargetIDs = {0, 0, 0}
local BridgeBLFighterTargetCoords = {nil, nil, nil}

-- global to bestow the bridge lowering token - spawn and move
function gd.quests.areaFQuestMalmouthBridge.loweredMalmouthBridge()

	GiveTokenToLocalPlayer("AREAF_MALMOUTHBRIDGELOWERED")
	
	if Server then

		local door01 = Door.Get(bridgeDoorID)
		door01:SetLocked(false)
		door01:Open()
		
	end	

	-- Fighters spawn to cross the bridge, if the server is on the quest	
	if Server && not bridgeFightersSpawned then
		
		local bridgeFightersTotal = table.getn(BridgeBLFighterIDs)

		local questId01 = 0x3C42F000
		local taskId01 = 0x093EA120
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)

		if (questTaskState01 == QuestState.InProgress) then
		
			for id = 1, bridgeFightersTotal do
			
				if (BridgeBLFighterIDs[id] != nil) && (BridgeBLFighterCoords[id] != nil) then
					
					local spawn = Character.Create("records/creatures/enemies/faction/blacklegion_meleehelmet_a01.dbr")
					spawn:SetCoords(BridgeBLFighterCoords[id])
					
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(BridgeBLFighterCoords[id])
					end
					
					if spawn != nil && BridgeBLFighterTargetIDs[id] != 0 && BridgeBLFighterTargetCoords[id] != nil then
						
						spawn:MoveAction(BridgeBLFighterTargetIDs[id], BridgeBLFighterTargetCoords[id], true)
				
					end
					
					bridgeFightersSpawned = true
				
				end
				
			end
			
		end
	
	end
	
end

-- Bl soldiers to cross the bridge

local function CharacterCreateArgs()

	local maxLevel = 0
	local playerLevel = Game.GetAveragePlayerLevel()

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 65
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 110
	end
	
	if (playerLevel < maxLevel) then
		if playerLevel < 50 then
			maxLevel = 50
			
		else
			maxLevel = 0
		
		end
		
	end

	return maxLevel, nil
	
end


--01
function gd.quests.areaFQuestMalmouthBridge.Fighter01OnAddToWorld(objectId)

	if Server then
		
		BridgeBLFighterIDs[1] = objectId
		BridgeBLFighterCoords[1] = Entity.Get(objectId):GetCoords()
		
	end
	
end

function gd.quests.areaFQuestMalmouthBridge.fighter01TargetOnAddToWorld(objectId)

	if Server then
		BridgeBLFighterTargetIDs[1] = objectId
		BridgeBLFighterTargetCoords[1] = Entity.Get(objectId):GetCoords()
	
	end

end

--02
function gd.quests.areaFQuestMalmouthBridge.Fighter02OnAddToWorld(objectId)

	if Server then
		
		BridgeBLFighterIDs[2] = objectId
		BridgeBLFighterCoords[2] = Entity.Get(objectId):GetCoords()
		
	end
	
end

function gd.quests.areaFQuestMalmouthBridge.fighter02TargetOnAddToWorld(objectId)

	if Server then
		BridgeBLFighterTargetIDs[2] = objectId
		BridgeBLFighterTargetCoords[2] = Entity.Get(objectId):GetCoords()
	
	end

end

--03
function gd.quests.areaFQuestMalmouthBridge.Fighter03OnAddToWorld(objectId)

	if Server then
		
		BridgeBLFighterIDs[3] = objectId
		BridgeBLFighterCoords[3] = Entity.Get(objectId):GetCoords()
		
	end
	
end

function gd.quests.areaFQuestMalmouthBridge.fighter03TargetOnAddToWorld(objectId)

	if Server then
		BridgeBLFighterTargetIDs[3] = objectId
		BridgeBLFighterTargetCoords[3] = Entity.Get(objectId):GetCoords()
	
	end

end

--- Creed's retinue south of the bridge.



