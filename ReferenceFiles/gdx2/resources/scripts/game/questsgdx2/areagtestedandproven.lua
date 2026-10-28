/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGTestedAndProven = {}

--
-- Waved battle to prove yourself to the witch coven. 
--
local WitchGodTestWaveObjectId = 0
local WitchGodTestWaveEventStarted = false
local WitchGodTestWaveEventKey = "AREAG_WITCHGODTEST_WAVEEVENT"

local eventActive = false
local questFix = false

--NPC at the ritual
local NPCId = 0

local NPCState = {Default = 0, Finished = 1}

local NPCStateObjects = orderedTable()
	NPCStateObjects["AREAG_COVENTEST_FINISHED"] = { state = NPCState.Finished,  dbr = "records/creatures/npcs/questnpcs/gdareag/npc_testedandproven_01.dbr"}
	NPCStateObjects[""] = { state = NPCState.Default,   dbr = "records/creatures/npcs/questnpcs/gdareag/npc_testedandproven_01.dbr" }
	
function gd.quests.areaGTestedAndProven.NPCOnAddToWorld(objectId)

	-- get player quest progress unstuck if they completed the basket quests in MP and still had unfinished faction quests
	if not questFix then
		questFix = true
		local player = Game.GetLocalPlayer()
			
		-- bysmiel
		local questId01 = 0x6201B380
		local taskId01 = 0x77FD5600
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		local questId02 = 0x73516780
		local taskId02 = 0xA2F0D500
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		local questId03 = 0x0A798C70
		local taskId03 = 0xAC3CCE00
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		if questTaskState01 == QuestState.Complete then
			player:GrantQuest(0x73516780, 0xA2F0D500)
			player:CompleteQuest(0x73516780, 0xA2F0D500)
			
			player:GrantQuest(0x0A798C70, 0xAC3CCE00)
			player:CompleteQuest(0x0A798C70, 0xAC3CCE00)
		
		end
		
		-- dreeg
		local questId04 = 0x99652E00
		local taskId04 = 0x9145A400
		local questTaskState04 = player:GetQuestTaskState(questId04, taskId04)
		
		local questId05 = 0x9641A900
		local taskId05 = 0xBF320900
		local taskId05b = 0xAC3CCE00
		local questTaskState05 = player:GetQuestTaskState(questId05, taskId05)
		local questTaskState05b = player:GetQuestTaskState(questId05, taskId05b)
		
		local questId06 = 0x8632B200
		local taskId06 = 0xEC4C5000
		local taskId06b = 0x1501C060
		local questTaskState06 = player:GetQuestTaskState(questId06, taskId06)
		local questTaskState06b = player:GetQuestTaskState(questId06, taskId06b)
		
		if questTaskState04 == QuestState.Complete then
			player:GrantQuest(0x9641A900, 0xBF320900)
			player:CompleteQuest(0x9641A900, 0xBF320900)
			player:CompleteQuest(0x9641A900, 0xAC3CCE00)
			
			player:GrantQuest(0x8632B200, 0xEC4C5000)
			player:CompleteQuest(0x8632B200, 0xEC4C5000)
			player:CompleteQuest(0x8632B200, 0x1501C060)
		
		end
		
		-- solael
		local questId07 = 0x36D56200
		local taskId07 = 0xE25E1F00
		local questTaskState07 = player:GetQuestTaskState(questId07, taskId07)
		
		local questId08 = 0x547B6100
		local taskId08 = 0xA2F0D500
		local questTaskState08 = player:GetQuestTaskState(questId08, taskId08)
		
		local questId09 = 0x5F806100
		local taskId09 = 0xEC4C5000
		local taskId09b = 0x1501C060
		local questTaskState09 = player:GetQuestTaskState(questId09, taskId09)
		local questTaskState09b = player:GetQuestTaskState(questId09, taskId09b)
		
		if questTaskState07 == QuestState.Complete then
			player:GrantQuest(0x547B6100, 0xA2F0D500)
			player:CompleteQuest(0x547B6100, 0xA2F0D500)
			
			player:GrantQuest(0x5F806100, 0xEC4C5000)
			player:CompleteQuest(0x5F806100, 0xEC4C5000)
			player:CompleteQuest(0x5F806100, 0x1501C060)
		
		end
	
	end
	
	if Server then
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		NPCId = objectId
		
		if eventActive then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_testedandproven_02.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, NPCStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGTestedAndProven.NPCOnDestroy = ClearObjectUserdata

-- swap NPC during ritual
local NPCSwap = false

function gd.quests.areaGTestedAndProven.swapNPC()

	if Server then
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
	
		if not NPCSwap then
			if player:HasToken("AREAG_COVENTEST_FINISHED") || ritualFinished then
				NPCSwap = true
				eventActive = false
			end
			
			if eventActive then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_testedandproven_02.dbr"
				MPOverrideState = true
				
			end
			
			local NPCEntity = Entity.Get(NPCId)
		
			if (NPCEntity != nil) then
				UpdateObjectSwap(NPCId, NPCStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
		
		end
	
	end

end

--Wave Object 
function gd.quests.areaGTestedAndProven.waveEventOnAddToWorld(objectId)

	if Server then
		WitchGodTestWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, WitchGodTestWaveEventKey)
	
	end

end

function gd.quests.areaGTestedAndProven.waveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end

--Wave event ends
function gd.quests.areaGTestedAndProven.endEventMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xC8E3D500
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
	
		GiveTokenToLocalPlayer("AREAG_COVENTEST_FINISHED")
		
	end
	
end

function gd.quests.areaGTestedAndProven.endWitchGodTestWaveEvent(objectId)

	if Server then
		-- MP end wave event
		QuestGlobalEvent("WitchGodTestEndEventToken")
		UI.Notify("tagNotification_AreaG_WitchGodTestWaveEventFinished")
		
		-- swap NPC back to dialogue state
		gd.quests.areaGTestedAndProven.swapNPC()
		
	end
	
end

--Wave event
local WitchGodTestWaveParameters = { }
	WitchGodTestWaveParameters.waves = {"records/proxies/boss&questgdx2/questproxy_waveevent_witchgodtest_wave01.dbr", "records/proxies/boss&questgdx2/questproxy_waveevent_witchgodtest_wave02.dbr", "records/proxies/boss&questgdx2/questproxy_waveevent_witchgodtest_wave03.dbr"}
	WitchGodTestWaveParameters.endCallback = gd.quests.areaGTestedAndProven.endWitchGodTestWaveEvent
	WitchGodTestWaveParameters.key = WitchGodTestWaveEventKey

function gd.quests.areaGTestedAndProven.startEvent()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENTEST_UNLOCKED") then
			GiveTokenToLocalPlayer("AREAG_COVENTEST_STARTED")
		end
		
		if (not WitchGodTestWaveEventStarted) then
			WitchGodTestWaveEventStarted = true
			WaveEvent_Start(WitchGodTestWaveObjectId, WitchGodTestWaveParameters)

			UI.Notify("tagNotification_AreaG_WitchGodTestWaveEvent")
			
			-- swap quest giver to ritual NPC
			eventActive = true
			gd.quests.areaGTestedAndProven.swapNPC()
			
		end
		
	end

end

