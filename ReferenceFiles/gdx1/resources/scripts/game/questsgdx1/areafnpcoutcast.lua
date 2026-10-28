/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCOutcast = {}

local OutcastHideoutId = 0
local OutcastBaseId = 0

--
-- Area F - Anasteria Transitions
--- 

local OutcastState = { Default = 0, Hideout = 1, Base = 2}

-- Anasteria in the rebel hideout
local HideoutOutcastStateObjects = orderedTable();
	HideoutOutcastStateObjects["AREAF_NPCCREED_BASE"] = { state = OutcastState.Base,  dbr = nil }
	HideoutOutcastStateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = OutcastState.Hideout,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_theoutcast_02.dbr" }
	HideoutOutcastStateObjects[""] = { state = OutcastState.Default, dbr = nil }
	
function gd.quests.areaFNPCOutcast.hideoutOnAddToWorld(objectId)

	if Server then
		OutcastHideoutId = objectId;
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x90EB3600
		local taskId01 = 0x4244C780
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)

		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if questTaskState01 != QuestState.Complete then
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, HideoutOutcastStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaFNPCOutcast.hideoutOnDestroy = ClearObjectUserdata

-- Anasteria in the rebel base
local BaseOutcastStateObjects = orderedTable();
	BaseOutcastStateObjects["AREAF_NPCCREED_BASE"] = { state = OutcastState.Base,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_theoutcast_03.dbr" }
	BaseOutcastStateObjects[""] = { state = OutcastState.Default, dbr = nil }
	
function gd.quests.areaFNPCOutcast.baseOnAddToWorld(objectId)

	if Server then
		OutcastBaseId = objectId;
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x90EB3600
		local taskId01 = 0x4244C780
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)

		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if questTaskState01 != QuestState.Complete then
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, BaseOutcastStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaFNPCOutcast.baseOnDestroy = ClearObjectUserdata


-- Activated by Creed Transition after the player has spoken to creed at the bridge, if the player had done all her AreaD quests
local outcastAtHideout = false

function gd.quests.areaFNPCOutcast.hideoutTransition()
	
	if Server && not outcastAtHideout then
		outcastAtHideout = true
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x90EB3600
		local taskId01 = 0x4244C780
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if questTaskState01 == QuestState.Complete then
			local outcastHideout = Entity.Get(OutcastHideoutId)
			
			if (outcastHideout != nil) then
			
				local coords = outcastHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(OutcastHideoutId, HideoutOutcastStateObjects)
			
			end
			
			-- transition the Outcast out of Fort Ikon
			gd.quests.areaDQuestExile.areaFTransition()
		
		end
	
	end
	
end

-- Activated by Creed Transition when the player takes back the original surface hideout, if the player had done all her AreaD quests
local outcastAtBase = false

function gd.quests.areaFNPCOutcast.baseTransition()
	
	if Server && not outcastAtBase then
		outcastAtBase = true
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x90EB3600
		local taskId01 = 0x4244C780
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if questTaskState01 == QuestState.Complete then
			local outcastBase = Entity.Get(OutcastBaseId)
			
			if (outcastBase != nil) then
			
				local coords = outcastBase:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(OutcastBaseId, BaseOutcastStateObjects)		
			
			end
			
			local outcastHideout = Entity.Get(OutcastHideoutId)
			
			if (outcastHideout != nil) then
			
				local coords = outcastHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(OutcastHideoutId, HideoutOutcastStateObjects)

			end
		
		end
		
	end
	
end

