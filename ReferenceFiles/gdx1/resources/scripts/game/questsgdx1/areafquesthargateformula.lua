/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestHargateFormula = {}


local hargateCrystalId = 0
local kasparovCrystalId = 0

local CrystalState = { Default = 0, Active = 1, Finished = 2}

-- Hargate Crystal
local hargateCrystalStateObjects = orderedTable();
	hargateCrystalStateObjects["GD_SLITHNOTES_KEPTFINISHED"]	= { state = CrystalState.Finished,  dbr = nil }
	hargateCrystalStateObjects["GD_SLITHNOTES_KEPT"]	= { state = CrystalState.Active,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_hargateaethercrystal.dbr" }
	hargateCrystalStateObjects[""] 								= { state = CrystalState.Default, dbr = nil }

function gd.quests.areaFQuestHargateFormula.hargateCrystalOnAddToWorld(objectId)

	if Server && not crystalSwapped then
			hargateCrystalId = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, hargateCrystalStateObjects);
			Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestHargateFormula.hargateCrystalOnDestroy = ClearObjectUserdata

-- Destroy Crystal
local crystalSwapped = false

function gd.quests.areaFQuestHargateFormula.hargateCrystalDestructibleOnAddToWorld(objectId)
	
	if Server then
		local crystal = Destructible.Get(objectId)
		local coords = Entity.Get(objectId):GetCoords()
		
		local pfx = Entity.Create("records/fx/skillsother/attackradius/detonate_fxpak01.dbr")
		if pfx != nil then
			pfx:NetworkEnable()
			pfx:SetCoords(coords)
			
		end
		
		crystal:Destroy(Vec(0,1,0), 10, true)
	
	end

end

function gd.quests.areaFQuestHargateFormula.hargateCrystalSwap()

	if Server && not crystalSwapped then
		local player = Game.GetLocalPlayer()
		crystalSwapped = true
		
		local MPOverrideDbr = nil
		local MPOverrideState = true
		
		UpdateObjectSwap(hargateCrystalId, hargateCrystalStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		
		if hargateCrystalId != 0 then
			local coords = Entity.Get(hargateCrystalId):GetCoords()
			local crystal = nil
			
			crystal = Destructible.Create("records/storyelements/questassets/areaf_hargatecrystal_break.dbr")
			
			crystal:SetCoords(coords)
			
		end
	
	end
	
end

-- Kasparov Crystal
-- The quest can only be started if the host gave Kasparov the formula, no MPOverrides necessary
local kasparovCrystalStateObjects = orderedTable();
	kasparovCrystalStateObjects["GD_SLITHNOTES_KASPAROVFINISHED"]	= { state = CrystalState.Finished,  dbr = "records/storyelements/questassets/areaf_kasparovcrystal_active.dbr" }
	kasparovCrystalStateObjects["GD_SLITHNOTES_KASPAROV"]	= { state = CrystalState.Active,  dbr = "records/storyelements/questassets/areaf_kasparovcrystal_default.dbr" }
	kasparovCrystalStateObjects[""] 								= { state = CrystalState.Default, dbr = nil }

function gd.quests.areaFQuestHargateFormula.kasparovCrystalOnAddToWorld(objectId)

	if Server then
			kasparovCrystalId = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, kasparovCrystalStateObjects);
			Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestHargateFormula.kasparovCrystalOnDestroy = ClearObjectUserdata


-- Spawn Crystal
local kasparovCrystalSpawned = false

function gd.quests.areaFQuestHargateFormula.kasparovCrystalSpawn()

	if Server && not kasparovCrystalSpawned then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("GD_SLITHNOTES_KASPAROV")) then
			kasparovCrystalSpawned = true
			
			local crystal = Entity.Get(kasparovCrystalId)
			
			if (crystal != nil) then
				UpdateObjectSwap(kasparovCrystalId, kasparovCrystalStateObjects)
			
			end
		
		end
	
	end
	
end

-- Swap Crystal
local kasparovCrystalSwapped = false

function gd.quests.areaFQuestHargateFormula.kasparovCrystalSwap()

	if Server && not kasparovCrystalSwapped then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("GD_SLITHNOTES_KASPAROV")) then
			kasparovCrystalSwapped = true
			UpdateObjectSwap(kasparovCrystalId, kasparovCrystalStateObjects)
		
		end
	
	end
	
end

