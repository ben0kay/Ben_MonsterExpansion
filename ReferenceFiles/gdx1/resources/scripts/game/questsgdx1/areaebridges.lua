/*
	
	GRIM DAWN
	scripts/quests/areaEBridges.lua
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEBridges = {}

-- Possible bridge states
local BridgeState = { Destroyed = 0, Repaired = 1}

--
-- Area E Roguelike Bridge
--

local areaERoguelike = {}

local areaERoguelikeBridgeStateObjects = orderedTable();
	areaERoguelikeBridgeStateObjects["AREAE_ROGUELIKEBRIDGE_REPAIRED"]	= { state = BridgeState.Repaired,  dbr = "records/storyelements/questassets/areae_bridgeroguelike_repaired01.dbr"};
	areaERoguelikeBridgeStateObjects[""] 								= { state = BridgeState.Destroyed, dbr = "records/storyelements/questassets/areae_bridgeroguelike_broken01.dbr" };

function gd.quests.areaEBridges.areaERoguelikeBridgeOnAddToWorld(objectId)

	if Server then
	
		areaERoguelike.bridgeId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaERoguelikeBridgeStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end

gd.quests.areaEBridges.areaERoguelikeBridgeOnDestroy = ClearObjectUserdata

-- Site
local areaERoguelikeBridgeSiteStateObjects = orderedTable();
	areaERoguelikeBridgeSiteStateObjects["AREAE_ROGUELIKEBRIDGE_REPAIRED"]	= { state = BridgeState.Repaired,  dbr = nil };
	areaERoguelikeBridgeSiteStateObjects[""] 								= { state = BridgeState.Destroyed, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_roguelikebridge_01.dbr" };

function gd.quests.areaEBridges.areaERoguelikeBridgeSiteOnAddToWorld(objectId)

	if Server then
	
		areaERoguelike.siteId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaERoguelikeBridgeSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEBridges.areaERoguelikeBridgeSiteOnDestroy = ClearObjectUserdata

-- Blockers
local areaERoguelikeBridgeBlockerStateObjects = orderedTable();
	areaERoguelikeBridgeBlockerStateObjects["AREAE_ROGUELIKEBRIDGE_REPAIRED"	] = { state = BridgeState.Repaired,  dbr = nil };
	areaERoguelikeBridgeBlockerStateObjects[""					 	] = { state = BridgeState.Destroyed, dbr = "records/level art/quests/dynamicblockerlarge_invisible.dbr"  }

function gd.quests.areaEBridges.areaERoguelikeBridgeBlockerOneOnAddToWorld(objectId)

	if Server then
	
		areaERoguelike.blockerOneId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaERoguelikeBridgeBlockerStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEBridges.areaERoguelikeBridgeBlockerOneOnDestroy = ClearObjectUserdata


--areaERoguelike Bridge Repair
function gd.quests.areaEBridges.areaERoguelikeBridgeRepairGlobalMP()

GiveTokenToLocalPlayer("AREAE_ROGUELIKEBRIDGE_REPAIRED")

end

function gd.quests.areaEBridges.areaERoguelikeBridgeRepair()

	if Server then
		local blocker = Entity.Get(areaERoguelike.blockerOneId)
		
		QuestGlobalEvent("roguelikeBridgeToken")

		if (blocker != nil) then
			
			local coords = blocker:GetCoords()
			local pfx = Entity.Create("records/fx/general/bridgerepair_fxpak01.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
		end
		
		UpdateObjectSwap(areaERoguelike.bridgeId, areaERoguelikeBridgeStateObjects)
		UpdateObjectSwap(areaERoguelike.blockerOneId, areaERoguelikeBridgeBlockerStateObjects)
		
	end
	
end
