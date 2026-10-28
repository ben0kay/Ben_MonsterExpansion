/*
	
	GRIM DAWN
	scripts/quests/areaGBridges.lua
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGBridges = {}

-- Possible bridge states
local BridgeState = { Destroyed = 0, Repaired = 1}

--
-- Area G Arkovian Docks Bridge
--

local areaGArkovianDocks = {}

local areaGArkovianDocksBridgeStateObjects = orderedTable();
	areaGArkovianDocksBridgeStateObjects["AREAG_ARKOVIANDOCKSBRIDGE_REPAIRED"]	= { state = BridgeState.Repaired,  dbr = "records/storyelementsgdx2/questassets/areag_arkoviandocksbridge_repaired01.dbr"};
	areaGArkovianDocksBridgeStateObjects[""] 								= { state = BridgeState.Destroyed, dbr = "records/storyelementsgdx2/questassets/areag_arkoviandocksbridge_broken01.dbr" };

function gd.quests.areaGBridges.areaGArkovianDocksBridgeOnAddToWorld(objectId)

	if Server then
	
		areaGArkovianDocks.bridgeId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaGArkovianDocksBridgeStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end

end

gd.quests.areaGBridges.areaGArkovianDocksOnDestroy = ClearObjectUserdata

-- Site
local areaGArkovianDocksBridgeSiteStateObjects = orderedTable();
	areaGArkovianDocksBridgeSiteStateObjects["AREAG_ARKOVIANDOCKSBRIDGE_REPAIRED"]	= { state = BridgeState.Repaired,  dbr = nil };
	areaGArkovianDocksBridgeSiteStateObjects[""] 								= { state = BridgeState.Destroyed, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_arkoviandocksbridge_01.dbr" };

function gd.quests.areaGBridges.areaGArkovianDocksBridgeSiteOnAddToWorld(objectId)

	if Server then
	
		areaGArkovianDocks.siteId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaGArkovianDocksBridgeSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Blockers
local areaGArkovianDocksBridgeBlockerStateObjects = orderedTable();
	areaGArkovianDocksBridgeBlockerStateObjects["AREAG_ARKOVIANDOCKSBRIDGE_REPAIRED"	] = { state = BridgeState.Repaired,  dbr = nil };
	areaGArkovianDocksBridgeBlockerStateObjects[""					 	] = { state = BridgeState.Destroyed, dbr = "records/level art/quests/dynamicblocker_invisible.dbr"  }

function gd.quests.areaGBridges.areaGArkovianDocksBridgeBlockerOneOnAddToWorld(objectId)

	if Server then
	
		areaGArkovianDocks.blockerOneId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaGArkovianDocksBridgeBlockerStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

function gd.quests.areaGBridges.areaGArkovianDocksBridgeBlockerTwoOnAddToWorld(objectId)

	if Server then
	
		areaGArkovianDocks.blockerTwoId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, areaGArkovianDocksBridgeBlockerStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end


--areaGArkovianDocks Bridge Repair
function gd.quests.areaGBridges.areaGArkovianDocksBridgeRepairGlobalMP()

GiveTokenToLocalPlayer("AREAG_ARKOVIANDOCKSBRIDGE_REPAIRED")

end

function gd.quests.areaGBridges.areaGArkovianDocksBridgeRepair()

	if Server then
		local blocker = Entity.Get(areaGArkovianDocks.blockerOneId)
		
		QuestGlobalEvent("arkovianDocksBridgeRepairedToken")

		if (blocker != nil) then
			
			local coords = blocker:GetCoords()
			local pfx = Entity.Create("records/fx/general/bridgerepair_fxpak01.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
		end
		
		UpdateObjectSwap(areaGArkovianDocks.bridgeId, areaGArkovianDocksBridgeStateObjects)
		UpdateObjectSwap(areaGArkovianDocks.blockerOneId, areaGArkovianDocksBridgeBlockerStateObjects)
		UpdateObjectSwap(areaGArkovianDocks.blockerTwoId, areaGArkovianDocksBridgeBlockerStateObjects)
		
	end
	
end
