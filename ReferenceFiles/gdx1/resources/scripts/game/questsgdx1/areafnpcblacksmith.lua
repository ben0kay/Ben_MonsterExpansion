/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCBlacksmith = {}

--
-- The smith starts out in the rebel hideout (no dialogue)
-- Moves to the rebel base (simple dialogue, needs supplies)
-- Becomes the smith after the rebel quest is complete
--

local rebelSmithId = 0
local rebelSmithAreaId = 0

local RebelSmithState = { Default = 0, Spawned = 1, Service = 2 }

--
-- The smith in the rebel hideout
--

local RebelSmithHideoutStateObjects = orderedTable();
	RebelSmithHideoutStateObjects["AREAF_ARMINGTHERESISTANCE"] = { state = RebelSmithState.Service, dbr = nil}
	RebelSmithHideoutStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelSmithState.Spawned, dbr = nil}
	RebelSmithHideoutStateObjects[""] = { state = RebelSmithState.Default, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_blacksmithsewerhideout_01.dbr" }

function gd.quests.areaFNPCBlacksmith.rebelSmithHideoutOnAddToWorld(objectId)
	
	if Server then
		rebelSmithId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelSmithHideoutStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCBlacksmith.rebelSmithHideoutOnDestroy = ClearObjectUserdata


--
-- The smith's workstation in the base
--

local RebelSmithStateObjects = orderedTable();
	RebelSmithStateObjects["AREAF_ARMINGTHERESISTANCE"] = { state = RebelSmithState.Service, dbr = "records/creatures/npcs/merchants/areaf_blacksmitha01.dbr"}
	RebelSmithStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelSmithState.Spawned, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_blacksmithprerepair_01.dbr"}
	RebelSmithStateObjects[""] = { state = RebelSmithState.Default, dbr = nil }

function gd.quests.areaFNPCBlacksmith.rebelSmithOnAddToWorld(objectId)
	
	if Server then
		rebelSmithId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelSmithStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCBlacksmith.rebelSmithOnDestroy = ClearObjectUserdata


local SmithAreaStateObjects = orderedTable();
	
	SmithAreaStateObjects["AREAF_ARMINGTHERESISTANCE"] = { state = RebelSmithState.Service,  dbr = "records/storyelements/questassets/areaf_blacksmitharea.dbr" }
	SmithAreaStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelSmithState.Spawned, dbr = "records/storyelements/questassets/areaf_blacksmitharea_wrecked.dbr"}
	SmithAreaStateObjects[""] = { state = RebelSmithState.Default, dbr = "records/storyelements/questassets/areaf_blacksmitharea_wrecked.dbr" }

function gd.quests.areaFNPCBlacksmith.smithAreaOnAddToWorld(objectId)

	if Server then
		rebelSmithAreaId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, SmithAreaStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCBlacksmith.smithAreaOnDestroy = ClearObjectUserdata

-- Supply recovery quest ends - rebuilding the blacksmith's station
local SmithAreaRebuilt = false

function gd.quests.areaFNPCBlacksmith.smithAreaRebuild()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAF_ARMINGTHERESISTANCE") && SmithAreaRebuilt == false) then
			
			SmithAreaRebuilt = true
			
			local RebelSmithArea = Entity.Get(rebelSmithAreaId)
		
			if (RebelSmithArea != nil) then
				local coords = RebelSmithArea:GetCoords()
				local pfx = Entity.Create("records/fx/general/genericrepair_fxpak01.dbr")
			
				if (pfx != nil) then
					pfx:NetworkEnable()
					pfx:SetCoords(coords)
					
				end
				
				UpdateObjectSwap(rebelSmithAreaId, SmithAreaStateObjects)
			
			end
			
			local RebelSmith = Entity.Get(rebelSmithId)
		
			if (RebelSmith != nil) then
				UpdateObjectSwap(rebelSmithId, RebelSmithStateObjects)
			
			end
			
		end
	
	end

end


	