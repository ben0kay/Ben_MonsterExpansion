/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaDAldritchCaptive = {}

--
-- Captive woman below Altritch's Enclanve.
-- Removes her from the world if the player has already spoken to her.
--

local AldritchCaptiveState = { Captured = 0, Rescued = 1 }

local AldritchCaptiveStateObjects = orderedTable();
	AldritchCaptiveStateObjects["AldritchCaptive_RESCUED"] = { state = AldritchCaptiveState.Rescued,  dbr = nil };
	AldritchCaptiveStateObjects[""			  ] = { state = AldritchCaptiveState.Captured, dbr = "records/creatures/npcs/flavornpcs/gdaread/npc_AldritchCaptive_01.dbr" }

function gd.quests.areaDAldritchCaptive.AldritchCaptiveOnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, AldritchCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end
	
-- Common destructor
gd.quests.areaDAldritchCaptive.AldritchCaptiveOnDestroy = ClearObjectUserdata