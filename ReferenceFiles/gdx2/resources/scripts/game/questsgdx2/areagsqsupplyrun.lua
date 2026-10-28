/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGSQSupplyRun = {}

--
-- Side Quest 02 - Lost Witches
-- 

local Lost01Ids = {0, 0}
local Lost01StateObjects = { }
local rescued01Ids = {0, 0}
local rescued01StateObjects = { }
local suppliesLostId = 0
local suppliesRecoveredId = 0


-- Rescued witches
local WitchRescueState = { Lost = 0, Base = 1}

-- Witch Lost 01
local Witch01LostStateObjects = orderedTable();
	Witch01LostStateObjects["AREAG_WITCHES_RESCUED"] = { state = WitchRescueState.Base, dbr = nil}
	Witch01LostStateObjects[""] = { state = WitchRescueState.Lost, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_witchlost_01.dbr" }

function gd.quests.areaGSQSupplyRun.Witch01LostOnAddToWorld(objectId)

	if Server then
		Lost01Ids[1] = objectId
		Lost01StateObjects[1] = Witch01LostStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch01LostStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaGSQSupplyRun.Witch01LostOnDestroy = ClearObjectUserdata

-- Witch Rescued 01
local Witch01RescuedStateObjects = orderedTable();
	Witch01RescuedStateObjects["AREAG_WITCHES_RESCUED"] = { state = WitchRescueState.Base, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_witchreturned_01.dbr" }
	Witch01RescuedStateObjects[""] = { state = WitchRescueState.Lost, dbr = nil }

function gd.quests.areaGSQSupplyRun.Witch01RescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[1] = objectId
		rescued01StateObjects[1] = Witch01RescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch01RescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaGSQSupplyRun.Witch01RescuedOnDestroy = ClearObjectUserdata

-- Witch Lost 02
local Witch02LostStateObjects = orderedTable();
	Witch02LostStateObjects["AREAG_WITCHES_RESCUED"] = { state = WitchRescueState.Base, dbr = nil }
	Witch02LostStateObjects[""] = { state = WitchRescueState.Lost, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_witchlost_02.dbr" }

function gd.quests.areaGSQSupplyRun.Witch02LostOnAddToWorld(objectId)

	if Server then
		Lost01Ids[2] = objectId
		Lost01StateObjects[2] = Witch02LostStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch02LostStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end


gd.quests.areaGSQSupplyRun.Witch02LostOnDestroy = ClearObjectUserdata

-- Witch Rescued 02
local Witch02RescuedStateObjects = orderedTable();
	Witch02RescuedStateObjects["AREAG_WITCHES_RESCUED"] = { state = WitchRescueState.Base, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_witchreturned_02.dbr" }
	Witch02RescuedStateObjects[""] = { state = WitchRescueState.Lost, dbr = nil }

function gd.quests.areaGSQSupplyRun.Witch02RescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[2] = objectId
		rescued01StateObjects[2] = Witch02RescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, Witch02RescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaGSQSupplyRun.Witch02RescuedOnDestroy = ClearObjectUserdata

--Supplies Lost
local SuppliesLostStateObjects = orderedTable();
	SuppliesLostStateObjects["AREAG_WITCHES_RESCUED"] = { state = WitchRescueState.Base, dbr = nil }
	SuppliesLostStateObjects[""] = { state = WitchRescueState.Lost, dbr = "records/storyelementsgdx2/questassets/areag_witchsupplies_01.dbr" }

function gd.quests.areaGSQSupplyRun.suppliesLostOnAddToWorld(objectId)
	
	if Server then
		suppliesLostId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, SuppliesLostStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaGSQSupplyRun.suppliesLostOnDestroy = ClearObjectUserdata

--Supplies Recovered
local SuppliesRecoveredStateObjects = orderedTable();
	SuppliesRecoveredStateObjects["AREAG_WITCHES_RESCUED"] = { state = WitchRescueState.Base, dbr = "records/storyelementsgdx2/questassets/areag_witchsupplies_01.dbr" }
	SuppliesRecoveredStateObjects[""] = { state = WitchRescueState.Lost, dbr = nil }

function gd.quests.areaGSQSupplyRun.suppliesRecoveredOnAddToWorld(objectId)
	
	if Server then
		suppliesRecoveredId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, SuppliesRecoveredStateObjects);
		Shared.setUserdata(objectId, userdata);

	
	end
	
end

gd.quests.areaGSQSupplyRun.suppliesRecoveredOnDestroy = ClearObjectUserdata


--Activated by conversation, teleports Lost witches back to safety
local WitchRescuePortal01 = false

function gd.quests.areaGSQSupplyRun.WitchesRescued01GlobalMP()
	
	GiveTokenToLocalPlayer("AREAG_WITCHES_RESCUED")

end

function gd.quests.areaGSQSupplyRun.WitchesRescue()

	if Server then
		GiveTokenToLocalPlayer("AREAG_WITCHES_RESCUED")
		
		QuestGlobalEvent("AreaGWitchesFoundToken")

		if not WitchRescuePortal01 then
			WitchRescuePortal01 = true

			-- teleport aspirants
			local LostsTotal = table.getn(Lost01Ids)
			local rescuedTotal = table.getn(rescued01Ids)
		
			for id = 1, LostsTotal do
				local NPCEntity = Entity.Get(Lost01Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(Lost01Ids[id], Lost01StateObjects[id])
					
				end
			
			end

			for id = 1, rescuedTotal do
				local NPCEntity = Entity.Get(rescued01Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(rescued01Ids[id], rescued01StateObjects[id])
				
				end
			
			end
			
			-- teleport supplies
			local suppliesLost = Entity.Get(suppliesLostId)
			local suppliesRecovered = Entity.Get(suppliesRecoveredId)
			
			if (suppliesLost != nil) then
		
				local coords = suppliesLost:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(suppliesLostId, SuppliesLostStateObjects)
			
			end
			
			if (suppliesRecovered != nil) then
		
				local coords = suppliesRecovered:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(suppliesRecoveredId, SuppliesRecoveredStateObjects)
			
			end
			
		end
		
	end
	
end




