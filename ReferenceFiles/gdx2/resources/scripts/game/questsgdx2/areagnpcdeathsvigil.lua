/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGNPCDeathsVigil = {}

local DeathsVigilState = { Default=0, KorvanPlateau=1, InfernalWastes=2, TombActive = 3}

local DeathsVigil01Id = 0
local DeathsVigil01BId = 0
local DeathsVigil02Id = 0
local DeathsVigil02BId = 0
local DeathsVigil03Id = 0
local DeathsVigil03BId = 0

--
-- Deaths Vigil in KorvanPlateau
--

-- Flavor NPC
local Vigil01KorvanStateObjects = orderedTable();
	Vigil01KorvanStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DeathsVigilState.TombActive, dbr = nil }
	Vigil01KorvanStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DeathsVigilState.InfernalWastes, dbr = nil }
	Vigil01KorvanStateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DeathsVigilState.KorvanPlateau, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_deathsvigil_01.dbr"}
	Vigil01KorvanStateObjects[""] = { state = DeathsVigilState.Default, dbr = nil}
	
function gd.quests.areaGNPCDeathsVigil.vigil01KorvanOnAddToWorld(objectId)

	if Server then
	
		DeathsVigil01Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Vigil01KorvanStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDeathsVigil.vigil01KorvanOnDestroy = ClearObjectUserdata

local Vigil02KorvanStateObjects = orderedTable();
	Vigil02KorvanStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DeathsVigilState.TombActive, dbr = nil }
	Vigil02KorvanStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DeathsVigilState.InfernalWastes, dbr = nil }
	Vigil02KorvanStateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DeathsVigilState.KorvanPlateau, dbr = "records/creatures/npcs/flavornpcs/gdareag/guardnpc_deathsvigil_melee_female01.dbr" }
	Vigil02KorvanStateObjects[""] = { state = DeathsVigilState.Default, dbr = nil}
	
function gd.quests.areaGNPCDeathsVigil.vigil02KorvanOnAddToWorld(objectId)

	if Server then
	
		DeathsVigil02Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Vigil02KorvanStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDeathsVigil.vigil02KorvanOnDestroy = ClearObjectUserdata

local Vigil03KorvanStateObjects = orderedTable();
	Vigil03KorvanStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DeathsVigilState.TombActive, dbr = nil }
	Vigil03KorvanStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DeathsVigilState.InfernalWastes, dbr = nil }
	Vigil03KorvanStateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DeathsVigilState.KorvanPlateau, dbr = "records/creatures/npcs/flavornpcs/gdareag/guardnpc_deathsvigil_melee01.dbr" }
	Vigil03KorvanStateObjects[""] = { state = DeathsVigilState.Default, dbr = nil}
	
function gd.quests.areaGNPCDeathsVigil.vigil03KorvanOnAddToWorld(objectId)

	if Server then
	
		DeathsVigil03Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Vigil03KorvanStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDeathsVigil.vigil03KorvanOnDestroy = ClearObjectUserdata

--
-- Deaths Vigil in InfernalWastes
--
local Vigil01InfernalWastesStateObjects = orderedTable();
	Vigil01InfernalWastesStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DeathsVigilState.TombActive, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_deathsvigil_02.dbr"}
	Vigil01InfernalWastesStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DeathsVigilState.InfernalWastes, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_deathsvigil_02.dbr"}
	Vigil01InfernalWastesStateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DeathsVigilState.KorvanPlateau, dbr = nil }
	Vigil01InfernalWastesStateObjects[""] = { state = DeathsVigilState.Default, dbr = nil}
	
function gd.quests.areaGNPCDeathsVigil.vigil01InfernalWastesOnAddToWorld(objectId)

	if Server then
	
		DeathsVigil01BId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Vigil01InfernalWastesStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDeathsVigil.vigil01InfernalWastesOnDestroy = ClearObjectUserdata

local Vigil02InfernalWastesStateObjects = orderedTable();
	Vigil02InfernalWastesStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DeathsVigilState.TombActive, dbr = "records/creatures/npcs/flavornpcs/gdareag/guardnpc_deathsvigil_melee_female01.dbr"}
	Vigil02InfernalWastesStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DeathsVigilState.InfernalWastes, dbr = "records/creatures/npcs/flavornpcs/gdareag/guardnpc_deathsvigil_melee_female01.dbr"}
	Vigil02InfernalWastesStateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DeathsVigilState.KorvanPlateau, dbr = nil }
	Vigil02InfernalWastesStateObjects[""] = { state = DeathsVigilState.Default, dbr = nil}
	
function gd.quests.areaGNPCDeathsVigil.vigil02InfernalWastesOnAddToWorld(objectId)

	if Server then
	
		DeathsVigil02BId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Vigil02InfernalWastesStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDeathsVigil.vigil02InfernalWastesOnDestroy = ClearObjectUserdata

local Vigil03InfernalWastesStateObjects = orderedTable();
	Vigil03InfernalWastesStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DeathsVigilState.TombActive, dbr = "records/creatures/npcs/flavornpcs/gdareag/guardnpc_deathsvigil_melee01.dbr" }
	Vigil03InfernalWastesStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DeathsVigilState.InfernalWastes, dbr = "records/creatures/npcs/flavornpcs/gdareag/guardnpc_deathsvigil_melee01.dbr" }
	Vigil03InfernalWastesStateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DeathsVigilState.KorvanPlateau, dbr = nil }
	Vigil03InfernalWastesStateObjects[""] = { state = DeathsVigilState.Default, dbr = nil}
	
function gd.quests.areaGNPCDeathsVigil.vigil03InfernalWastesOnAddToWorld(objectId)

	if Server then
	
		DeathsVigil03BId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Vigil03InfernalWastesStateObjects, Character)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDeathsVigil.vigil03InfernalWastesOnDestroy = ClearObjectUserdata




