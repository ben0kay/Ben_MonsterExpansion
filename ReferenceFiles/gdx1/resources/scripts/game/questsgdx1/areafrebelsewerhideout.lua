/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFRebelSewerHideout = {}

--
-- Rebel Hideout Actors and Ambient Stuff
--

local SewerHideoutState = { InSewers = 0, InBase = 1}

local GateGuardId = 0

-- Rebel Hideout Gate Guard.
local SewerGateGuardStateObjects = orderedTable();
	SewerGateGuardStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = SewerHideoutState.InBase, dbr = nil }
	SewerGateGuardStateObjects[""] = { state = SewerHideoutState.InSewers, dbr = "records/creatures/npcs/flavornpcs/gdareaf/npc_sewergateguard_01.dbr" }
	
function gd.quests.areaFRebelSewerHideout.sewerGateGuardOnAddToWorld(objectId)

	if Server then

		GateGuardId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, SewerGateGuardStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelSewerHideout.sewerGateGuardOnDestroy = ClearObjectUserdata