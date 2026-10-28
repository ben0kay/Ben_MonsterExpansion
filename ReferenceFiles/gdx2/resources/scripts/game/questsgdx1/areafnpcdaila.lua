/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCDaila = {}

local DailaState = { InHomestead = 0, AetherCrags = 1, KorvanValley = 2, QuestComplete = 3}

local DailaInHomesteadId = 0
local DailaInAetherCragsId = 0


--
-- Daila in Homestead
--
local DailaHomesteadStateObjects = orderedTable();
	DailaHomesteadStateObjects["AREAG_DAILAQUESTCOMPLETE"] = { state = DailaState.QuestComplete, dbr = nil }
	DailaHomesteadStateObjects["AREAG_DAILATRANSITION"] = { state = DailaState.KorvanValley, dbr = nil }
	DailaHomesteadStateObjects["AREAF_DAILATRANSITION"] = { state = DailaState.AetherCrags, dbr = nil }
	DailaHomesteadStateObjects[""] = { state = DailaState.InHomestead, dbr = "records/creatures/npcs/flavornpcs/gdareac/npc_homestead_female_01.dbr" }
	
function gd.quests.areaFNPCDaila.inHomesteadOnAddToWorld(objectId)

	if Server then

		DailaInHomesteadId = objectId;
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x1CE68AC0
		local taskId01 = 0x639E4B80
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
	
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if questTaskState01 != QuestState.Complete then

			MPOverrideDbr = "records/creatures/npcs/flavornpcs/gdareac/npc_homestead_female_01.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, DailaHomesteadStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaFNPCDaila.inHomesteadOnDestroy = ClearObjectUserdata

--
-- Daila In The Aether Crags
--
local DailaAetherCragsStateObjects = orderedTable();
	DailaAetherCragsStateObjects["AREAG_DAILAQUESTCOMPLETE"] = { state = DailaState.QuestComplete, dbr = nil }
	DailaAetherCragsStateObjects["AREAG_DAILATRANSITION"] = { state = DailaState.KorvanValley, dbr = nil }
	DailaAetherCragsStateObjects["AREAF_DAILATRANSITION"] = { state = DailaState.AetherCrags, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_daila_02.dbr" }
	DailaAetherCragsStateObjects[""] = { state = DailaState.InHomestead, dbr = nil}
	
function gd.quests.areaFNPCDaila.inAetherCragsOnAddToWorld(objectId)

	if Server then
	
		DailaInAetherCragsId = objectId;
		
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x1CE68AC0
		local taskId01 = 0x639E4B80
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		local questId02 = 0x6F1FFE80
		local taskId02 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)

		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if questTaskState01 != QuestState.Complete then

			MPOverrideState = true
			
		elseif (player:HasToken("AREAG_DAILATRANSITION") || player:HasToken("AREAG_DAILAQUESTCOMPLETE")) && (questTaskState02 != QuestState.Complete) then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareaf/npc_daila_02.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, DailaAetherCragsStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaFNPCDaila.inAetherCragsOnDestroy = ClearObjectUserdata

-- Daila Transition
local dailaTransition = false

function gd.quests.areaFNPCDaila.dailaAreaFTransition()

	if Server && not dailaTransition then
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x1CE68AC0
		local taskId01 = 0x639E4B80
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if player:HasToken("AREAF_DAILATRANSITION") && (questTaskState01 == QuestState.Complete) then
			dailaTransition = true
			
			local dailaAetherCrags = Entity.Get(DailaInAetherCragsId)
	
			if (dailaAetherCrags != nil) then
		
				local coords = dailaAetherCrags:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(DailaInAetherCragsId, DailaAetherCragsStateObjects)
			
			end
		
			local dailaHomestead = Entity.Get(DailaInHomesteadId)
				
			if (dailaHomestead != nil) then
		
				local coords = dailaHomestead:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(DailaInHomesteadId, DailaHomesteadStateObjects)
			
			end
		
		end
		
	end
	
end

-- Daila GDX2 Transition
local dailaGDX2Transition = false

function gd.quests.areaFNPCDaila.dailaAreaGTransition()

	if Server && not dailaGDX2Transition then
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x6F1FFE80
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if player:HasToken("AREAG_DAILATRANSITION") && (questTaskState01 == QuestState.Complete) then
			dailaGDX2Transition = true
			
			local dailaAetherCrags = Entity.Get(DailaInAetherCragsId)
	
			if (dailaAetherCrags != nil) then
		
				local coords = dailaAetherCrags:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(DailaInAetherCragsId, DailaAetherCragsStateObjects)
			
			end
		
		end
		
	end
	
end

-- Daila Quest 01 - Dravis' Thralls
function gd.quests.areaFNPCDaila.killedBoss()
	
	GiveTokenToLocalPlayer("AREAF_DRAVISMINION_KILLED")

end
