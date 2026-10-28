/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCIllusionist = {}


local HideoutIllusionistId = 0
local BaseIllusionistId = 0

local IllusionistState = { Hideout = 0, Base = 1}


-- Illusionist in the hideout
local HideoutIllusionistStateObjects = orderedTable();
	HideoutIllusionistStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = IllusionistState.Base, dbr = nil}
	HideoutIllusionistStateObjects[""] = { state = IllusionistState.Hideout, dbr = "records/creatures/npcs/merchants/illusionista04.dbr" }
	
function gd.quests.areaFNPCIllusionist.HideoutIllusionistOnAddToWorld(objectId)
	
	if Server then
		HideoutIllusionistId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, HideoutIllusionistStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCIllusionist.HideoutIllusionistOnDestroy = ClearObjectUserdata

-- Illusionist in the base
local BaseIllusionistStateObjects = orderedTable();
	BaseIllusionistStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = IllusionistState.Base, dbr = "records/creatures/npcs/merchants/illusionista04.dbr"}
	BaseIllusionistStateObjects[""] = { state = IllusionistState.Hideout, dbr = nil }
	
function gd.quests.areaFNPCIllusionist.BaseIllusionistOnAddToWorld(objectId)
	
	if Server then
		BaseIllusionistId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, BaseIllusionistStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCIllusionist.BaseIllusionistOnDestroy = ClearObjectUserdata

-- The payer captures the resistance base, moving the illusions up to the surface.
local SmithAreaRebuilt = false

function gd.quests.areaFNPCIllusionist.illusionisttransition()

	if Server then
		
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAF_RETAKEINDUSTRIALDISTRICT")) then
			
			local HideoutIllusionist = Entity.Get(HideoutIllusionistId)
		
			if (HideoutIllusionist != nil) then
				local coords = HideoutIllusionist:GetCoords()
				local pfx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (pfx != nil) then
					pfx:NetworkEnable()
					pfx:SetCoords(coords)
					
				end
				
				UpdateObjectSwap(HideoutIllusionistId, HideoutIllusionistStateObjects)
			
			end
			
			local BaseIllusionist = Entity.Get(BaseIllusionistId)
		
			if (BaseIllusionist != nil) then
				local coords = BaseIllusionist:GetCoords()
				local pfx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (pfx != nil) then
					pfx:NetworkEnable()
					pfx:SetCoords(coords)
					
				end
				
				UpdateObjectSwap(BaseIllusionistId, BaseIllusionistStateObjects)
			
			end
			
			
		end
	
	end

end


	