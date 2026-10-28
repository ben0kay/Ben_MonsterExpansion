/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaCKymonSwap = {}

local AreaCKymonState = { Default = 0, InGDX2 = 1}
local AreaCKymonId = 0

local KymonAreaCStateObjects = orderedTable();
	KymonAreaCStateObjects["AREAG_COVENBASERIFT_OPENED"] = { state = AreaCKymonState.InGDX2, dbr = "records/creatures/npcs/questnpcs/gdareac/npc_kymonstandin_01.dbr" }
	KymonAreaCStateObjects[""] = { state = AreaCKymonState.Default, dbr = "records/creatures/npcs/questnpcs/gdareac/npc_fatherkymon_01.dbr"}
	
function gd.quests.areaCKymonSwap.areaCKymonOnAddToWorld(objectId)

	if Server then
	
		AreaCKymonId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, KymonAreaCStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaCKymonSwap.areaCKymonOnDestroy = ClearObjectUserdata