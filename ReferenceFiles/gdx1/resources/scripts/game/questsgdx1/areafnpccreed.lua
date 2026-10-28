/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCCreed = {}


--
-- Lore notes that appear as creed moves around
-- 

local CreedNoteStates = { Default = 0, FortIkon = 1, Hideout = 2, Base = 3}

local CreedNote01Id = 0

local CreedNote01Spawned = false
local CreedNote02Spawned = false

-- Fort Ikon Note
local CreedNoteFortIkonStateObjects = orderedTable();
	CreedNoteFortIkonStateObjects["AREAE_NPCS"] = { state = CreedNoteStates.Hideout,  dbr = "records/items/loreobjects/loreobject_creedsjournala09.dbr" }
	CreedNoteFortIkonStateObjects["AREAE_INTRO"] = { state = CreedNoteStates.FortIkon,  dbr = "records/items/loreobjects/loreobject_creedsjournala09.dbr" }
	CreedNoteFortIkonStateObjects[""] = { state = CreedNoteStates.Default, dbr = nil }
	
function gd.quests.areaFNPCCreed.CreedNoteDCOnAddToWorld(objectId)

	if Server then

		if (CreedNote01Spawned == false) then
			CreedNote01Id = objectId

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CreedNoteFortIkonStateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned already
			if (newState != CreedNoteStates.Default) then
				CreedNote01Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaFNPCCreed.CreedNoteDCOnDestroy = ClearObjectUserdata

-- Spawn Fort Ikon Lore Note
local fortIkonNote = false

function gd.quests.areaFNPCCreed.spawnFortIkonNote()
	
	if Server && not fortIkonNote && not CreedNote01Spawned then
		fortIkonNote = true
		CreedNote01Spawned = true
		
		local note = Entity.Get(CreedNote01Id)
		
		if (note != nil) then
			UpdateObjectSwap(CreedNote01Id, CreedNoteFortIkonStateObjects)
			
		end

	end

end

-- Rebel Hideout Note
local CreedNoteHideoutStateObjects = orderedTable();
	CreedNoteHideoutStateObjects["AREAF_NPCCREED_BASE"] = { state = CreedNoteStates.Base,  dbr = "records/items/loreobjects/loreobject_creedsjournala10.dbr" }
	CreedNoteHideoutStateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = CreedNoteStates.Hideout,  dbr = "records/items/loreobjects/loreobject_creedsjournala10.dbr" }
	CreedNoteHideoutStateObjects[""] = { state = CreedNoteStates.Default, dbr = nil }
	
function gd.quests.areaFNPCCreed.CreedNoteHideoutOnAddToWorld(objectId)

	if Server then
	
		if (CreedNote02Spawned == false) then

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CreedNoteHideoutStateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned already
			if (newState != CreedNoteStates.Default) then
				CreedNote02Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaFNPCCreed.CreedNoteHideoutOnDestroy = ClearObjectUserdata

--
-- Area F - Creed Transitions
--- 

local CreedBridgeId = 0
local CreedHideoutId = 0
local CreedBaseId = 0


local CreedState = { Default = 0, Bridge = 1, Hideout = 2, Base = 3}

-- Creed at the malmouth bridge.
local BridgeCreedStateObjects = orderedTable();
	BridgeCreedStateObjects["AREAF_NPCCREED_BASE"] = { state = CreedState.Base,  dbr = nil }
	BridgeCreedStateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = CreedState.Hideout,  dbr = nil }
	BridgeCreedStateObjects["AREAF_NPCCREED_BRIDGE"] = { state = CreedState.Bridge,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_inquisitorcreed_04.dbr" }
	BridgeCreedStateObjects[""] = { state = CreedState.Default, dbr = nil }
	
function gd.quests.areaFNPCCreed.bridgeOnAddToWorld(objectId)

	if Server then

		CreedBridgeId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, BridgeCreedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCCreed.bridgeOnDestroy = ClearObjectUserdata

-- Creed in the rebel hideout.
local HideoutCreedStateObjects = orderedTable();
	HideoutCreedStateObjects["AREAF_NPCCREED_BASE"] = { state = CreedState.Base,  dbr = nil }
	HideoutCreedStateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = CreedState.Hideout,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_inquisitorcreed_05.dbr" }
	HideoutCreedStateObjects[""] = { state = CreedState.Default, dbr = nil }
	
function gd.quests.areaFNPCCreed.hideoutOnAddToWorld(objectId)

	if Server then

		CreedHideoutId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, HideoutCreedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCCreed.hideoutOnDestroy = ClearObjectUserdata

-- Creed in the rebel base.
local BaseCreedStateObjects = orderedTable();
	BaseCreedStateObjects["AREAF_NPCCREED_BASE"] = { state = CreedState.Base,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_inquisitorcreed_06.dbr" }
	BaseCreedStateObjects[""] = { state = CreedState.Default, dbr = nil }
	
function gd.quests.areaFNPCCreed.baseOnAddToWorld(objectId)

	if Server then

		CreedBaseId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, BaseCreedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCCreed.baseOnDestroy = ClearObjectUserdata


-- Activated by quest transition when the player lowers the bridge
local creedAtBridge = false

function gd.quests.areaFNPCCreed.bridgeTransition()
	
	if Server && not creedAtBridge then
		creedAtBridge = true
		
		local creedBridge = Entity.Get(CreedBridgeId)
		
		--Take Creed out of the core game 
		gd.quests.areaCNPCInquisitorCreed.areaFTransition()
		
		if (creedBridge != nil) then
		
			local coords = creedBridge:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end

			UpdateObjectSwap(CreedBridgeId, BridgeCreedStateObjects)
			
		end

	end

end

-- Activated by quest transition after the player has spoken to creed at the bridge
local creedAtHideout = false

function gd.quests.areaFNPCCreed.hideoutTransition()
	
	if Server && not creedAtHideout then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCCREED_HIDEOUT") then
			creedAtHideout = true
			
			local creedHideout = Entity.Get(CreedHideoutId)
			
			if (creedHideout != nil) then
			
				local coords = creedHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(CreedHideoutId, HideoutCreedStateObjects)
			
			end
			
			local creedBridge = Entity.Get(CreedBridgeId)
			
			if (creedBridge != nil) then
			
				local coords = creedBridge:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(CreedBridgeId, BridgeCreedStateObjects)			
		
			end
			
			-- transition Outcast from Fort Ikon to the Hideout
			gd.quests.areaFNPCOutcast.hideoutTransition()
		
		end
	
	end
	
end

-- Activated by quest transition when the player takes back the original surface hideout
local creedAtBase = false

function gd.quests.areaFNPCCreed.baseTransition()
	
	if Server && not creedAtBase then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCCREED_BASE") then
			creedAtBase = true
			
			local creedBase = Entity.Get(CreedBaseId)
			
			if (creedBase != nil) then
			
				local coords = creedBase:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(CreedBaseId, BaseCreedStateObjects)		
			
			end
			
			local creedHideout = Entity.Get(CreedHideoutId)
			
			if (creedHideout != nil) then
			
				local coords = creedHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(CreedHideoutId, HideoutCreedStateObjects)

			end
			
			-- transition Outcast to the base
			gd.quests.areaFNPCOutcast.baseTransition()
			
		end

	end	
	
end

