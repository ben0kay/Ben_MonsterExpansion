/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestMalmouthIndustrial = {}

--Doors For Rebel Base Wave Event
--Door Setup
local rebelbaseDoor01Open = false
local rebelbaseDoor02Open = false
local rebelbaseDoor03Open = false
local rebelBaseDoor01Id = 0
local rebelBaseDoor02Id = 0
local rebelBaseDoor03Id = 0

function gd.quests.areaFQuestMalmouthIndustrial.RebelBaseDoor01OnAddToWorld(objectId)
	if Server && not rebelbaseDoor01Open then
		rebelBaseDoor01Id = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_REBELBASE_UNLOCKDOORS")) then
			rebelbaseDoor01Open = true
			
			local door = Door.Get(objectId)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaFQuestMalmouthIndustrial.RebelBaseDoor02OnAddToWorld(objectId)
	if Server && not rebelbaseDoor02Open then
		rebelBaseDoor02Id = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_REBELBASE_UNLOCKDOORS")) then
			rebelbaseDoor02Open = true
			
			local door = Door.Get(objectId)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaFQuestMalmouthIndustrial.RebelBaseDoor03OnAddToWorld(objectId)
	if Server && not rebelbaseDoor03Open then
		rebelBaseDoor03Id = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_REBELBASE_UNLOCKDOORS")) then
			rebelbaseDoor03Open = true
			
			local door = Door.Get(objectId)
			door:Open()

		end
	
	end
	
end

--The rebel base exits open after the player has spoken to Creed
function gd.quests.areaFQuestMalmouthIndustrial.rebelBaseUnlockDoors()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAF_REBELBASE_UNLOCKDOORS")) then			
			local door01 = Door.Get(rebelBaseDoor01Id)
			local door02 = Door.Get(rebelBaseDoor02Id)
			local door03 = Door.Get(rebelBaseDoor03Id)
			
			if door01 != nil && not rebelbaseDoor01Open then
				rebelbaseDoor01Open = true
				door01:Open()
				
			end
			
			if door02 != nil && not rebelbaseDoor02Open then
				rebelbaseDoor02Open = false
				door02:Open()
				
			end
			
			if door03 != nil && not rebelbaseDoor03Open then
				rebelbaseDoor03Open = false
				door03:Open()
				
			end
		
		end
		
	end
	
end


--
--Rebel Base Wave Event
--
local RebelBaseWaveObjectId = 0
local RebelBaseWaveEventStarted = false
local RebelBaseWaveEventKey = "AREAF_REBELBASE_WAVEEVENT"
local rebelBaseRiftgate = nil

--Wave Object 
function gd.quests.areaFQuestMalmouthIndustrial.waveEventOnAddToWorld(objectId)

	if Server then
		RebelBaseWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, RebelBaseWaveEventKey)
	
	end

end

function gd.quests.areaFQuestMalmouthIndustrial.waveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
		
	end
	
end

--Wave event ends
local eventEnded = false

function gd.quests.areaFQuestMalmouthIndustrial.endEventMP()

	if not eventEnded then
		local player = Game.GetLocalPlayer()
		local questId01 = 0xDD67A400
		local taskId01 = 0x0F756D40

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (questTaskState01 == QuestState.InProgress)  then
			GiveTokenToLocalPlayer("AREAF_RETAKEINDUSTRIALDISTRICT")
			eventEnded = true
		
			if rebelBaseRiftgate != nil then
				rebelBaseRiftgate:SetLocked(false)
			
			end
		
		end
	
	end
	
end

function gd.quests.areaFQuestMalmouthIndustrial.endRebelBaseWaveEvent()

	if Server then
		QuestGlobalEvent("MalmouthRebelBaseEndEvent")	
		UI.Notify("tagNotification_AreaF_RebelBaseRiftgateEventClear")
		
	end
	
end


--Wave event
local rebelBaseWaveParameters = { }
	rebelBaseWaveParameters.waves = {"records/proxies/boss&questgdx1/questproxy_waveevent_malmouthrebelbase_wave01.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthrebelbase_wave02.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthrebelbase_wave03.dbr"}
	rebelBaseWaveParameters.endCallback = gd.quests.areaFQuestMalmouthIndustrial.endRebelBaseWaveEvent
	rebelBaseWaveParameters.key = RebelBaseWaveEventKey

--Player touches the event start trigger
function gd.quests.areaFQuestMalmouthIndustrial.triggerWaveEvent(triggererId)

	local player = Player.Get(triggererId)
	local questId01 = 0xDD67A400
	local taskId01 = 0x0F756D40
	
	local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
	
	if (player:HasToken("AREAF_RETAKEINDUSTRIALDISTRICT") == false) && (questTaskState01 == QuestState.InProgress) && (RebelBaseWaveEventStarted == false) then
		
		if (player:GetLevel() > 10) then
	
			UI.Notify("tagNotification_AreaF_RebelBaseRiftgateEvent")
			QuestEvent("MalmouthRebelBaseStartEvent")
	
		end
	
	end
	
end

function gd.quests.areaFQuestMalmouthIndustrial.startEventMP()

	if Server then
		if (not RebelBaseWaveEventStarted) then
			RebelBaseWaveEventStarted = true

			WaveEvent_Start(RebelBaseWaveObjectId, rebelBaseWaveParameters)

		end
		
	end

end


-- Rebel Base Riftgate, unlocked after event ends
function gd.quests.areaFQuestMalmouthIndustrial.rebelBaseRiftgateOnAddToWorld(objectId)

	-- This function is run locally on all clients to set the variable and unlock the gate. Riftgates are not spawned by the server
	local player = Game.GetLocalPlayer()
	rebelBaseRiftgate = Riftgate.Get(objectId)

	if player:HasToken("AREAF_RETAKEINDUSTRIALDISTRICT") then
		rebelBaseRiftgate:SetLocked(false)
	
	end

end