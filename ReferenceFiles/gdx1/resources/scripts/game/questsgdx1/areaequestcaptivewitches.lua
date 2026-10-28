/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestCaptiveWitches = {}

--
-- Side Quest 02 - Witch Captives
-- areaEQuestCaptiveWitches

local captive01Ids = {0, 0, 0}
local captive01StateObjects = { }
local rescued01Ids = {0, 0, 0}
local rescued01StateObjects = { }


-- Rescued witches
local WitchRescueState = { Captive = 0, Coven = 1}

-- Witch Captive 01
local Witch01CaptiveStateObjects = orderedTable();
	Witch01CaptiveStateObjects["AREAE_WITCHES01_RESCUED"] = { state = WitchRescueState.Coven, dbr = nil}
	Witch01CaptiveStateObjects[""] = { state = WitchRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchcaptive_01.dbr" }

function gd.quests.areaEQuestCaptiveWitches.Witch01CaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[1] = objectId
		captive01StateObjects[1] = Witch01CaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch01CaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestCaptiveWitches.Witch01CaptiveOnDestroy = ClearObjectUserdata

local Witch01RescuedStateObjects = orderedTable();
	Witch01RescuedStateObjects["AREAE_WITCHES01_RESCUED"] = { state = WitchRescueState.Coven, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchrescued_01.dbr" }
	Witch01RescuedStateObjects[""] = { state = WitchRescueState.Captive, dbr = nil }

function gd.quests.areaEQuestCaptiveWitches.Witch01RescuedOnAddToWorld(objectId)

	if Server then
	
		rescued01Ids[1] = objectId
		rescued01StateObjects[1] = Witch01RescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch01RescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestCaptiveWitches.Witch01RescuedOnDestroy = ClearObjectUserdata

-- Witch Captive 02
local Witch02CaptiveStateObjects = orderedTable();
	Witch02CaptiveStateObjects["AREAE_WITCHES01_RESCUED"] = { state = WitchRescueState.Coven, dbr = nil }
	Witch02CaptiveStateObjects[""] = { state = WitchRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchcaptive_02.dbr" }

function gd.quests.areaEQuestCaptiveWitches.Witch02CaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[2] = objectId
		captive01StateObjects[2] = Witch02CaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch02CaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestCaptiveWitches.Witch02CaptiveOnDestroy = ClearObjectUserdata

local Witch02RescuedStateObjects = orderedTable();
	Witch02RescuedStateObjects["AREAE_WITCHES01_RESCUED"] = { state = WitchRescueState.Coven, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchrescued_02.dbr" }
	Witch02RescuedStateObjects[""] = { state = WitchRescueState.Captive, dbr = nil }

function gd.quests.areaEQuestCaptiveWitches.Witch02RescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[2] = objectId
		rescued01StateObjects[2] = Witch02RescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch02RescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestCaptiveWitches.Witch02RescuedOnDestroy = ClearObjectUserdata


-- Witch Captive 03
local Witch03CaptiveStateObjects = orderedTable();
	Witch03CaptiveStateObjects["AREAE_WITCHES01_RESCUED"] = { state = WitchRescueState.Coven, dbr = nil }
	Witch03CaptiveStateObjects[""] = { state = WitchRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchcaptive_03.dbr"}

function gd.quests.areaEQuestCaptiveWitches.Witch03CaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[3] = objectId
		captive01StateObjects[3] = Witch03CaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch03CaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestCaptiveWitches.Witch03CaptiveOnDestroy = ClearObjectUserdata

local Witch03RescuedStateObjects = orderedTable();
	Witch03RescuedStateObjects["AREAE_WITCHES01_RESCUED"] = { state = WitchRescueState.Coven, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchrescued_03.dbr" }
	Witch03RescuedStateObjects[""] = { state = WitchRescueState.Captive, dbr = nil }

function gd.quests.areaEQuestCaptiveWitches.Witch03RescuedOnAddToWorld(objectId)

	if Server then
		QuestGlobalEvent("covenBountyReset")
		
		rescued01Ids[3] = objectId
		rescued01StateObjects[3] = Witch03RescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch03RescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestCaptiveWitches.Witch03RescuedOnDestroy = ClearObjectUserdata


--Activated by conversation, teleports captive witches back to safety
local WitchRescuePortal01 = false

function gd.quests.areaEQuestCaptiveWitches.WitchesRescued01GlobalMP()
	
	GiveTokenToLocalPlayer("AREAE_WITCHES01_RESCUED")

end

function gd.quests.areaEQuestCaptiveWitches.WitchesGroup01Rescue()

	if Server then
		GiveTokenToLocalPlayer("AREAE_WITCHES01_RESCUED")
		
		QuestGlobalEvent("Witches01RescuedToken")

		if not WitchRescuePortal01 then
			WitchRescuePortal01 = true

			
			local captivesTotal = table.getn(captive01Ids)
			local rescuedTotal = table.getn(rescued01Ids)
		
			for id = 1, captivesTotal do
				local NPCEntity = Entity.Get(captive01Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(captive01Ids[id], captive01StateObjects[id])
					
				end
			
			end

			for id = 1, rescuedTotal do
				local NPCEntity = Entity.Get(rescued01Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(rescued01Ids[id], rescued01StateObjects[id])
				
				end
			
			end
		
		end
		
	end
	
end
