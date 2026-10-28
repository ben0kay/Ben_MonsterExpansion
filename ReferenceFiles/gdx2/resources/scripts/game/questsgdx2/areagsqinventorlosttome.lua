/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGInventorLostTome = {}


local InventorState = { Default = 0, TomeReturned = 1} 

-- The inventor starts as a quest NPC and swaps to a merchant after the player has completed the quest.
local InventorStateObjects = orderedTable();
	InventorStateObjects["AREAG_INVENTOR_TOMERETURNED"] = { state = InventorState.TomeReturned, dbr = "records/creatures/npcs/merchants/areag_inventora01.dbr"}
	InventorStateObjects[""] = { state = InventorState.Default, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_inventor_01.dbr"}
	
function gd.quests.areaGInventorLostTome.InventorOnAddToWorld(objectId)
	
	if Server then
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, InventorStateObjects)
		Shared.setUserdata(objectId, userdata)
	
	end
	
end
	
gd.quests.areaGInventorLostTome.InventorOnDestroy = ClearObjectUserdata
