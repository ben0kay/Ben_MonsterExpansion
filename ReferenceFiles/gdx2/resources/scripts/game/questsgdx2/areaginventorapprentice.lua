/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGInventorApprentice = {}

local CorpseState = { Default = 0, Looted = 1}
local CorpseId = 0
local apprenticeChestsSpawned = false

local CorpseStateObjects = orderedTable();
	CorpseStateObjects["AREAG_INVENTOR_TOMERETURNED"] = { state = CorpseState.Looted, dbr = "records/level art/debris&rubble/bonepilehuman01.dbr" }
	CorpseStateObjects[""] = { state = CorpseState.Default, dbr = "records/items/lootchests/questchests/questchest_areag_inventorsapprentice.dbr"}
	
function gd.quests.areaGInventorApprentice.corpseOnAddToWorld(objectId)

	if Server && not apprenticeChestsSpawned then
	
		CorpseId = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CorpseStateObjects)
		Shared.setUserdata(objectId, userdata)
			
		-- Don't respawn if spawned as chest
		if (newState == CorpseState.Default) then
			apprenticeChestsSpawned = true
		end
		
	end
	
end

gd.quests.areaGInventorApprentice.corpseOnDestroy = ClearObjectUserdata

