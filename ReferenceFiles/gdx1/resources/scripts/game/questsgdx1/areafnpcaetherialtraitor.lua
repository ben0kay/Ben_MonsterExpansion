/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCAetherialTraitor = {}

--
-- Three defectors are imprisoned in Cronley's area. Can be talked to and released, if so, they despawn later and give PC information. Otherwise, can go hostile and be killed
--

local aetherial01Id = 0
local doorId = 0

--Toggles state of extortionists based on dialogue choices
local AetherialState = { Default = 0, Hostile = 1, Dead = 2, Freed = 3 }

-- Frankie, only conversation NPC in script
local aetherial01StateObjects = orderedTable();
	aetherial01StateObjects["AREAF_AETHERIALTRAITOR_FREED"] = { state = AetherialState.Freed, dbr = nil }
	aetherial01StateObjects["AREAF_AETHERIALTRAITOR_DEAD"] = { state = AetherialState.Dead, dbr = nil }
	aetherial01StateObjects["AREAF_AETHERIALTRAITOR_HOSTILE"] = { state = AetherialState.Hostile, dbr = nil }
	aetherial01StateObjects[""	                    ] = { state = AetherialState.Default,  dbr = "records/creatures/npcs/flavornpcs/gdareaf/npc_aetherialtraitor_01.dbr"}

function gd.quests.areaFNPCAetherialTraitor.aetherial01OnAddToWorld(objectId)
	if Server then
		aetherial01Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, aetherial01StateObjects);
		Shared.setUserdata(objectId, userdata)
	
	end
	
end

gd.quests.areaFNPCAetherialTraitor.aetherial01OnDestroy = ClearObjectUserdata

function gd.quests.areaFNPCAetherialTraitor.onDie()

	local player = Game.GetLocalPlayer()
	
	if player:HasToken("AREAF_AETHERIALTRAITOR_HOSTILE") then
		GiveTokenToLocalPlayer("AREAF_AETHERIALTRAITOR_DEAD")
		player:RemoveToken("AREAF_AETHERIALTRAITOR_HOSTILE")
	
	end

end

-- Door to Aetherial Traitor
function gd.quests.areaFNPCAetherialTraitor.doorOnAddToWorld(objectId)
	if Server then
		doorId = objectId
	
	end
	
end

local function openDoor()
	if Server then
		local player = Game.GetLocalPlayer()
		riftOpened= true
		
		local door = Door.Get(doorId)
			
		if door ~= nil then
			door:Open()
			
		end
		
	end
	
end

--Triggered by conversation. Hostile Swap: non-standard hostile swap as the NPC does not remain hostile on subsequent playthroughs. One-shot hostile NPC that never spawns again.
local hostileSwap = false

function gd.quests.areaFNPCAetherialTraitor.hostileTokenGlobalMP()

	local player = Game.GetLocalPlayer()
	
	if not player:HasToken("AREAF_AETHERIALTRAITOR_FREED") && not player:HasToken("AREAF_AETHERIALTRAITOR_DEAD") then
		GiveTokenToLocalPlayer("AREAF_AETHERIALTRAITOR_HOSTILE")
	
	end

end

function gd.quests.areaFNPCAetherialTraitor.hostileSwitch()

	if Server && not hostileSwap then
		hostileSwap = true

		GiveTokenToLocalPlayer("AREAF_AETHERIALTRAITOR_HOSTILE")
		QuestGlobalEvent("aetherialTraitorHostileToken")

		local coords01 = Entity.Get(aetherial01Id):GetCoords()
		
		UpdateObjectSwap(aetherial01Id, aetherial01StateObjects)

		local entity = Character.Create("records/creatures/enemies/boss&quest/humanascendant_aetherialtraitor.dbr", 0, coords01.origin)			

		if entity != nil then
			entity:SetCoords(coords01)
			
		end
		
		openDoor()
	
	end

end


--Activated by conversation, teleports the aetherial to freedom
local aetherialFreed = false

function gd.quests.areaFNPCAetherialTraitorfreedTokenGlobalMP()

	local player = Game.GetLocalPlayer()
	
	if not player:HasToken("AREAF_AETHERIALTRAITOR_HOSTILE") && not player:HasToken("AREAF_AETHERIALTRAITOR_DEAD") then
		GiveTokenToLocalPlayer("AREAF_AETHERIALTRAITOR_FREED")
	
	end

end

function gd.quests.areaFNPCAetherialTraitor.freedSwitch()

	if Server && not aetherialFreed then
		aetherialFreed = true
		
		GiveTokenToLocalPlayer("AREAF_AETHERIALTRAITOR_FREED")
		
		QuestGlobalEvent("aetherialTraitorFreedToken")

		local entity = Entity.Get(aetherial01Id)
		
		if (entity != nil) then
			local coords = entity:GetCoords()
			local rift = entity.Create("records/fx/ui/riftgateaetherialopen_fxpak.dbr")
	
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
	
			UpdateObjectSwap(aetherial01Id, aetherial01StateObjects)
			
		end
		
		openDoor()

	end
	
end


