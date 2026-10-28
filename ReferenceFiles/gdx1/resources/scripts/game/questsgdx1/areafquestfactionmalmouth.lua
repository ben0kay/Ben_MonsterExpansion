/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com

*/

gd.quests.areaFQuestFactionMalmouth = {};

--
--Capt. Wilfor Quests
-- 

-- The player must destroy the corpse wagons

function gd.quests.areaFQuestFactionMalmouth.corpseWagon01OnBreak()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_CORPSEWAGONS_ALLDESTROYED")) then
		if (player != nil) then
			player:GiveToken("AREAF_CORPSEWAGON01_DESTROYED")
			
		end
		
		if (player:HasToken("AREAF_CORPSEWAGON01_DESTROYED") && player:HasToken("AREAF_CORPSEWAGON02_DESTROYED") && player:HasToken("AREAF_CORPSEWAGON03_DESTROYED")) then
			player:GiveToken("AREAF_CORPSEWAGONS_ALLDESTROYED")
			
		end
		
	end
	
end

function gd.quests.areaFQuestFactionMalmouth.corpseWagon02OnBreak()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_CORPSEWAGONS_ALLDESTROYED")) then
		if (player != nil) then
			player:GiveToken("AREAF_CORPSEWAGON02_DESTROYED")
			
		end
		
		if (player:HasToken("AREAF_CORPSEWAGON01_DESTROYED") && player:HasToken("AREAF_CORPSEWAGON02_DESTROYED") && player:HasToken("AREAF_CORPSEWAGON03_DESTROYED")) then
			player:GiveToken("AREAF_CORPSEWAGONS_ALLDESTROYED")
			
		end
		
	end
	
end

function gd.quests.areaFQuestFactionMalmouth.corpseWagon03OnBreak()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_CORPSEWAGONS_ALLDESTROYED")) then
		if (player != nil) then
			player:GiveToken("AREAF_CORPSEWAGON03_DESTROYED")
			
		end
		
		if (player:HasToken("AREAF_CORPSEWAGON01_DESTROYED") && player:HasToken("AREAF_CORPSEWAGON02_DESTROYED") && player:HasToken("AREAF_CORPSEWAGON03_DESTROYED")) then
			player:GiveToken("AREAF_CORPSEWAGONS_ALLDESTROYED")
			
		end
		
	end
	
end


-- The player must destroy the corpse wagons

local corpseWagon01Id = 0
local corpseWagon02Id = 0
local corpseWagon03Id = 0
local wagon01Spawned = false

local WagonsState = { Spawned = 0, OneDestroyed = 1, AllDestroyed = 2}

--Wagon 01
local corpseWagon01StateObjects = orderedTable();
	corpseWagon01StateObjects["AREAF_CORPSEWAGONS_ALLDESTROYED"] = { state = WagonsState.AllDestroyed,  dbr = nil }
	corpseWagon01StateObjects["AREAF_CORPSEWAGON01_DESTROYED"] = { state = WagonsState.OneDestroyed,  dbr = nil }
	corpseWagon01StateObjects[""]= { state = WagonsState.Spawned, dbr = "records/storyelements/questassets/areaf_corpsewagon01_break.dbr" }

function gd.quests.areaFQuestFactionMalmouth.corpseWagon01OnAddToWorld(objectId)
	
	if Server then
		if (not wagon01Spawned) then
			wagon01Spawned = true
			corpseWagon01Id = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, corpseWagon01StateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaFQuestFactionMalmouth.corpseWagon01OnDestroy = ClearObjectUserdata

--Wagon 02
local corpseWagon02StateObjects = orderedTable();
	corpseWagon01StateObjects["AREAF_CORPSEWAGONS_ALLDESTROYED"] = { state = WagonsState.AllDestroyed,  dbr = nil }
	corpseWagon01StateObjects["AREAF_CORPSEWAGON02_DESTROYED"] = { state = WagonsState.OneDestroyed,  dbr = nil }
	corpseWagon02StateObjects[""]= { state = WagonsState.Spawned, dbr = "records/storyelements/questassets/areaf_corpsewagon02_break.dbr" }

function gd.quests.areaFQuestFactionMalmouth.corpseWagon02OnAddToWorld(objectId)
	
	if Server then
		if (not wagon01Spawned) then
			wagon01Spawned = true
			corpseWagon02Id = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, corpseWagon02StateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaFQuestFactionMalmouth.corpseWagon02OnDestroy = ClearObjectUserdata

--Wagon 03
local corpseWagon03StateObjects = orderedTable();
	corpseWagon01StateObjects["AREAF_CORPSEWAGONS_ALLDESTROYED"] = { state = WagonsState.AllDestroyed,  dbr = nil }
	corpseWagon01StateObjects["AREAF_CORPSEWAGON03_DESTROYED"] = { state = WagonsState.OneDestroyed,  dbr = nil }
	corpseWagon03StateObjects[""]= { state = WagonsState.Spawned, dbr = "records/storyelements/questassets/areaf_corpsewagon03_break.dbr" }

function gd.quests.areaFQuestFactionMalmouth.corpseWagon03OnAddToWorld(objectId)
	
	if Server then
		if (not wagon01Spawned) then
			wagon01Spawned = true
			corpseWagon03Id = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, corpseWagon03StateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaFQuestFactionMalmouth.corpseWagon03OnDestroy = ClearObjectUserdata

-- The player collects weapons/supplies (unlocks rebel smith)
local weaponSuppliesId = 0
local arcaneSuppliesId = 0
local weaponsClaimed = false
local arcaneClaimed = false

local WeaponsState = { Unclaimed = 0, Claimed = 1}

-- Supply Site 01
local rebelWeaponSiteStateObjects = orderedTable();
	rebelWeaponSiteStateObjects["AREAF_REBEL_WEAPONS_CLAIMED"]	= { state = WeaponsState.Claimed,  dbr = nil }
	rebelWeaponSiteStateObjects[""]= { state = WeaponsState.Unclaimed, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_rebelweaponsupplies.dbr" }

function gd.quests.areaFQuestFactionMalmouth.weaponSupplySiteOnAddToWorld(objectId)
	
	if Server then
		if (not weaponsClaimed) then

			weaponSuppliesId = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, rebelWeaponSiteStateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaFQuestFactionMalmouth.weaponSupplySiteOnDestroy = ClearObjectUserdata

-- Supply Site 02
local ArcaneState = { Unclaimed = 0, Claimed = 1}

local rebelArcaneSupplyStateObjects = orderedTable();
	rebelArcaneSupplyStateObjects["AREAF_REBEL_ARCANE_CLAIMED"]	= { state = ArcaneState.Claimed,  dbr = nil }
	rebelArcaneSupplyStateObjects[""] 								= { state = ArcaneState.Unclaimed, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_rebelarcanesupplies.dbr" }

function gd.quests.areaFQuestFactionMalmouth.arcaneSupplySiteOnAddToWorld(objectId)
	
	if Server then
		if (not arcaneClaimed) then

			arcaneSuppliesId = objectId
		
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, rebelArcaneSupplyStateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaFQuestFactionMalmouth.arcaneSupplySiteOnDestroy = ClearObjectUserdata

-- MP Events - Supplies claimed
function gd.quests.areaFQuestFactionMalmouth.weaponsClaimedGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xDD67A400
	local kTask = 0x0F756D40
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.complete) && (player:HasToken("AREAF_REBEL_WEAPONS_CLAIMED") == false) then
		GiveTokenToLocalPlayer("AREAF_REBEL_WEAPONS_CLAIMED")
		
	end

end

function gd.quests.areaFQuestFactionMalmouth.arcaneClaimedGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xDD67A400
	local kTask = 0x0F756D40
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.complete) && (player:HasToken("AREAF_REBEL_ARCANE_CLAIMED") == false) then
		GiveTokenToLocalPlayer("AREAF_REBEL_ARCANE_CLAIMED")
		
	end

end

-- Server Events - The player interacts with the supply piles
function gd.quests.areaFQuestFactionMalmouth.arcaneClaimed()

	if Server && not arcaneClaimed then
		
		GiveTokenToLocalPlayer("AREAF_REBEL_ARCANE_CLAIMED")
		
		local arcaneSupplies = Entity.Get(arcaneSuppliesId)
	
		if (arcaneSupplies != nil) then
			
			local coords = arcaneSupplies:GetCoords()
			local pfx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
			UpdateObjectSwap(arcaneSuppliesId, rebelArcaneSupplyStateObjects)

			arcaneClaimed = true

		
		end
	
	end

end

function gd.quests.areaFQuestFactionMalmouth.weaponsClaimed()

	if Server && not weaponsClaimed then
		weaponsClaimed = true
		
		GiveTokenToLocalPlayer("AREAF_REBEL_WEAPONS_CLAIMED")
			
		local weaponSupplies = Entity.Get(weaponSuppliesId)
	
		if (weaponSupplies != nil) then
			local coords = weaponSupplies:GetCoords()
			local pfx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
			UpdateObjectSwap(weaponSuppliesId, rebelWeaponSiteStateObjects)
		
		end
	
	end

end

-- The player must rescue captured rebels/survivors (unlocks vendor, spirit guide, inventor)
local captive01Ids = {0, 0, 0, 0}
local captive02Ids = {0, 0}
local captive01StateObjects = {nil, nil, nil, nil }
local captive02StateObjects = {nil, nil }
local rescued01Ids = {0, 0, 0, 0}
local rescued02Ids = {0, 0}
local rescued01StateObjects = {nil, nil, nil, nil }
local rescued02StateObjects = {nil, nil }

local RebelRescueState = { Captive = 0, Town = 1}
local RebelMerchRescueState = { Captive = 0, Town = 1, Merchant = 2}

-- Captive Rena - Spirit Guide
local renaRescuedStateObjects = orderedTable();
	renaRescuedStateObjects["AREAF_RESCUETHERESISTANCE"] = { state = RebelMerchRescueState.Merchant, dbr = "records/creatures/npcs/merchants/areaf_reallocatora01.dbr" }
	renaRescuedStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelMerchRescueState.Town, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_rena_02.dbr" }
	renaRescuedStateObjects[""] = { state = RebelMerchRescueState.Captive, dbr = nil }

function gd.quests.areaFQuestFactionMalmouth.RenaRescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[1] = objectId
		rescued01StateObjects[1] = renaRescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, renaRescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.RenaRescuedOnDestroy = ClearObjectUserdata

local renaCaptiveStateObjects = orderedTable();
	renaCaptiveStateObjects["AREAF_RESCUETHERESISTANCE"] = { state = RebelMerchRescueState.Merchant, dbr = nil }
	renaCaptiveStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelMerchRescueState.Town, dbr = nil }
	renaCaptiveStateObjects[""] = { state = RebelMerchRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_rena_01.dbr" }

function gd.quests.areaFQuestFactionMalmouth.RenaCaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[1] = objectId
		captive01StateObjects[1] = renaCaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, renaCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.RenaCaptiveOnDestroy = ClearObjectUserdata

-- Captive Hyram - Merchant
local HyramRescuedStateObjects = orderedTable();
	HyramRescuedStateObjects["AREAF_RESCUETHERESISTANCE"] = { state = RebelMerchRescueState.Merchant, dbr = "records/creatures/npcs/merchants/areaf_merchanta101.dbr" }
	HyramRescuedStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelMerchRescueState.Town, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_hyram_02.dbr" }
	HyramRescuedStateObjects[""] = { state = RebelMerchRescueState.Captive, dbr = nil }


function gd.quests.areaFQuestFactionMalmouth.HyramRescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[2] = objectId
		rescued01StateObjects[2] = HyramRescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, HyramRescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.HyramRescuedOnDestroy = ClearObjectUserdata

local HyramCaptiveStateObjects = orderedTable();
	HyramCaptiveStateObjects["AREAF_RESCUETHERESISTANCE"] = { state = RebelMerchRescueState.Merchant, dbr = nil }
	HyramCaptiveStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelMerchRescueState.Town, dbr = nil }
	HyramCaptiveStateObjects[""] = { state = RebelMerchRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_hyram_01.dbr" }

function gd.quests.areaFQuestFactionMalmouth.HyramCaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[2] = objectId
		captive01StateObjects[2] = HyramCaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, HyramCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.HyramCaptiveOnDestroy = ClearObjectUserdata

-- Captive Nadia - Inventor
local NadiaRescuedStateObjects = orderedTable();
	NadiaRescuedStateObjects["AREAF_RESCUETHERESISTANCE"] = { state = RebelMerchRescueState.Merchant, dbr = "records/creatures/npcs/merchants/areaf_inventora01.dbr" }
	NadiaRescuedStateObjects["AREAF_REBELS02_RESCUED"] = { state = RebelMerchRescueState.Town, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_nadia_02.dbr" }
	NadiaRescuedStateObjects[""] = { state = RebelMerchRescueState.Captive, dbr = nil }

function gd.quests.areaFQuestFactionMalmouth.NadiaRescuedOnAddToWorld(objectId)

	if Server then
		rescued02Ids[1] = objectId
		rescued02StateObjects[1] = NadiaRescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, NadiaRescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.NadiaRescuedOnDestroy = ClearObjectUserdata

local NadiaCaptiveStateObjects = orderedTable();
	NadiaCaptiveStateObjects["AREAF_RESCUETHERESISTANCE"] = { state = RebelMerchRescueState.Merchant, dbr = nil }
	NadiaCaptiveStateObjects["AREAF_REBELS02_RESCUED"] = { state = RebelMerchRescueState.Town, dbr = nil }
	NadiaCaptiveStateObjects[""] = { state = RebelMerchRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_nadia_01.dbr" }

function gd.quests.areaFQuestFactionMalmouth.NadiaCaptiveOnAddToWorld(objectId)

	if Server then
		captive02Ids[1] = objectId
		captive02StateObjects[1] = NadiaCaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, NadiaCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.NadiaCaptiveOnDestroy = ClearObjectUserdata

-- Captive Rivia -- Quest giver
local RiviaRescuedStateObjects = orderedTable();
	RiviaRescuedStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelRescueState.Town, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_rivia_02.dbr" }
	RiviaRescuedStateObjects[""] = { state = RebelRescueState.Captive, dbr = nil }

function gd.quests.areaFQuestFactionMalmouth.RiviaRescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[3] = objectId
		rescued01StateObjects[3] = RiviaRescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RiviaRescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.RiviaRescuedOnDestroy = ClearObjectUserdata

local RiviaCaptiveStateObjects = orderedTable();
	RiviaCaptiveStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelRescueState.Town, dbr = nil }
	RiviaCaptiveStateObjects[""] = { state = RebelRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_rivia_01.dbr" }

function gd.quests.areaFQuestFactionMalmouth.RiviaCaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[3] = objectId
		captive01StateObjects[3] = RiviaCaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RiviaCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.RiviaCaptiveOnDestroy = ClearObjectUserdata

-- Captive Markus - Random Survivor
local MarkusRescuedStateObjects = orderedTable();
	MarkusRescuedStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelRescueState.Town, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_markus_02.dbr" }
	MarkusRescuedStateObjects[""] = { state = RebelRescueState.Captive, dbr = nil }

function gd.quests.areaFQuestFactionMalmouth.MarkusRescuedOnAddToWorld(objectId)

	if Server then
		rescued01Ids[4] = objectId
		rescued01StateObjects[4] = MarkusRescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MarkusRescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.MarkusRescuedOnDestroy = ClearObjectUserdata

local MarkusCaptiveStateObjects = orderedTable();
	MarkusCaptiveStateObjects["AREAF_REBELS01_RESCUED"] = { state = RebelRescueState.Town, dbr = nil }
	MarkusCaptiveStateObjects[""] = { state = RebelRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_markus_01.dbr" }

function gd.quests.areaFQuestFactionMalmouth.MarkusCaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[4] = objectId
		captive01StateObjects[4] = MarkusCaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MarkusCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.MarkusCaptiveOnDestroy = ClearObjectUserdata

-- Captive Ferron - Random Survivor
local FerronRescuedStateObjects = orderedTable();
	FerronRescuedStateObjects["AREAF_REBELS02_RESCUED"] = { state = RebelRescueState.Town, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_ferron_02.dbr" }
	FerronRescuedStateObjects[""] = { state = RebelRescueState.Captive, dbr = nil }

function gd.quests.areaFQuestFactionMalmouth.FerronRescuedOnAddToWorld(objectId)

	if Server then
		rescued02Ids[2] = objectId
		rescued02StateObjects[2] = FerronRescuedStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, FerronRescuedStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.FerronRescuedOnDestroy = ClearObjectUserdata

local FerronCaptiveStateObjects = orderedTable();
	FerronCaptiveStateObjects["AREAF_REBELS02_RESCUED"] = { state = RebelRescueState.Town, dbr = nil }
	FerronCaptiveStateObjects[""] = { state = RebelRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_ferron_01.dbr" }

function gd.quests.areaFQuestFactionMalmouth.FerronCaptiveOnAddToWorld(objectId)

	if Server then
		captive02Ids[2] = objectId
		captive02StateObjects[2] = FerronCaptiveStateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, FerronCaptiveStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.FerronCaptiveOnADestroy = ClearObjectUserdata


--Activated by conversation with rescue group 01
local rebelRescuePortal01 = false
local rebels01Found = false

function gd.quests.areaFQuestFactionMalmouth.rebelsRescued01GlobalMP()

	GiveTokenToLocalPlayer("AREAF_REBELS01_RESCUED")

end

function gd.quests.areaFQuestFactionMalmouth.rebelGroup01Rescue()

	if Server && not rebelRescuePortal01 then
		rebelRescuePortal01 = true
		
		GiveTokenToLocalPlayer("AREAF_REBELS01_RESCUED")
		QuestGlobalEvent("rebel01Rescued")
			
		local captivesTotal = table.getn(captive01Ids)
		local rescuedTotal = table.getn(rescued01Ids)
	
		for id = 1, captivesTotal do
			local NPCEntity = Entity.Get(captive01Ids[id])
			
			if (NPCEntity != nil) then
				local coords = NPCEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
		
				UpdateObjectSwap(captive01Ids[id], captive01StateObjects[id])
				
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
	
	end
	
end

-- Activated by conversation with rescue group 02
local rebelRescuePortal02 = false
local rebels02Found = false

function gd.quests.areaFQuestFactionMalmouth.rebelsRescued02GlobalMP()

	GiveTokenToLocalPlayer("AREAF_REBELS02_RESCUED")

end

function gd.quests.areaFQuestFactionMalmouth.rebelGroup02Rescue()

	if Server && not rebelRescuePortal02 then
		rebelRescuePortal02 = true
		
		GiveTokenToLocalPlayer("AREAF_REBELS02_RESCUED")
		QuestGlobalEvent("rebel02Rescued")
		
		local captivesTotal = table.getn(captive02Ids)
		local rescuedTotal = table.getn(rescued02Ids)
	
		for id = 1, captivesTotal do
			local NPCEntity = Entity.Get(captive02Ids[id])
			
			if (NPCEntity != nil) then
				local coords = NPCEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
		
				UpdateObjectSwap(captive02Ids[id], captive02StateObjects[id])
				
			end
		
		end

		for id = 1, rescuedTotal do
			local NPCEntity = Entity.Get(rescued02Ids[id])
			
			if (NPCEntity != nil) then
				local coords = NPCEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
		
				UpdateObjectSwap(rescued02Ids[id], rescued02StateObjects[id])
			
			end
		
		end
	
	end
	
end



function gd.quests.areaFQuestFactionMalmouth.triggerLiberateRebels01(triggererId)
	
	if not rebels01Found then
		local player = Player.Get(triggererId)
		local kQuest = 0x971A1100
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)

		if (player != nil) && (questTaskState == QuestState.InProgress) && player:HasToken("AREAF_REBELS01_RESCUED") == false then
			UI.Notify("tagNotification_AreaF_LiberateRebels01Found")
			rebels01Found = true
		end
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouth.triggerLiberateRebels02(triggererId)
	
	if not rebels02Found then
		local player = Player.Get(triggererId)
		local kQuest = 0x971A1100
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)

		if (player != nil) && (questTaskState == QuestState.InProgress) && player:HasToken("AREAF_REBELS02_RESCUED") == false then
			UI.Notify("tagNotification_AreaF_LiberateRebels02Found")
			rebels02Found = true
		end
	
	end
	
end


--
-- The Fleshwrapped Council - Checking for kill events to bestow tokens
-- 

-- boss door initialization
local councilBossDoor01Id = 0
local councilBossDoor02Id = 0
local reanimatorsDead = { false, false, false }

function gd.quests.areaFQuestFactionMalmouth.councilBossDoorA01OnAddToWorld(objectId)
	
	if Server then
		councilBossDoor01Id = objectId
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouth.councilBossDoorA02OnAddToWorld(objectId)
	
	if Server then
		councilBossDoor02Id = objectId
	
	end
	
end

local function ReanimatorsKilled()

	if Server then
		local door01 = Door.Get(councilBossDoor01Id)
		local door02 = Door.Get(councilBossDoor02Id)
	
		if door01 != nil then
			door01:Open()
		
		end
	
		if door02 != nil then
			door02:Open()
		
		end
	
	end

end

function gd.quests.areaFQuestFactionMalmouth.enclaveBoss01OnKill()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_MALMOUTHENCLAVE_CLEARED")) then

		if (player != nil) then
			player:GiveToken("AREAF_ENCLAVEBOSS01_KILLED")
			
		end
	
		if (player:HasToken("AREAF_ENCLAVEBOSS01_KILLED") && player:HasToken("AREAF_ENCLAVEBOSS02_KILLED") && player:HasToken("AREAF_ENCLAVEBOSS03_KILLED")) then
			player:GiveToken("AREAF_MALMOUTHENCLAVE_CLEARED")
			
		end	
	
	end
	
	reanimatorsDead[1] = true
	
	if reanimatorsDead[1] && reanimatorsDead[2] && reanimatorsDead[3] then
		ReanimatorsKilled()
	
	end

end

function gd.quests.areaFQuestFactionMalmouth.enclaveBoss02OnKill()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_MALMOUTHENCLAVE_CLEARED")) then
		
		if (player != nil) then
			player:GiveToken("AREAF_ENCLAVEBOSS02_KILLED")
			
		end
		
		if (player:HasToken("AREAF_ENCLAVEBOSS01_KILLED") && player:HasToken("AREAF_ENCLAVEBOSS02_KILLED") && player:HasToken("AREAF_ENCLAVEBOSS03_KILLED")) then
			player:GiveToken("AREAF_MALMOUTHENCLAVE_CLEARED")
			
		end
		
	end
	
	reanimatorsDead[2] = true
	
	if reanimatorsDead[1] && reanimatorsDead[2] && reanimatorsDead[3] then
		ReanimatorsKilled()
	
	end

end

function gd.quests.areaFQuestFactionMalmouth.enclaveBoss03OnKill()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_MALMOUTHENCLAVE_CLEARED")) then
		
		if (player != nil) then
			player:GiveToken("AREAF_ENCLAVEBOSS03_KILLED")
			
		end
		
		if (player:HasToken("AREAF_ENCLAVEBOSS01_KILLED") && player:HasToken("AREAF_ENCLAVEBOSS02_KILLED") && player:HasToken("AREAF_ENCLAVEBOSS03_KILLED")) then
			player:GiveToken("AREAF_MALMOUTHENCLAVE_CLEARED")
			
		end
		
	end

	reanimatorsDead[3] = true
	
	if reanimatorsDead[1] && reanimatorsDead[2] && reanimatorsDead[3] then
		ReanimatorsKilled()
	
	end

end

-- Door to Enclave UG
local enclaveDoorOpened = false
local enclaveDoorId = 0

function gd.quests.areaFQuestFactionMalmouth.enclaveDoorOnAddToWorld(objectId)
	if Server && not enclaveDoorOpened then
		enclaveDoorId = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_ENCLAVE_OPEN")) then
			enclaveDoorOpened = true
			
			local door = Door.Get(objectId)
			door:SetLocked(false)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouth.enclaveDoorUnlock()

	if Server && not enclaveDoorOpened then		
		local door = Door.Get(enclaveDoorId)
		
		if door != nil then
			door:SetLocked(false)
			door:Open()
			enclaveDoorOpened = true
			
		end
		
	end
	
end

--
-- Can't leave them - Faction quest for Rivia the survivor woman. The player enters the birthing chamber.
--
local womenFound = false

function gd.quests.areaFQuestFactionMalmouth.cantLeaveThemTrigger()
	
	if not womenFound then
		local player = Game.GetLocalPlayer()

		local kQuest = 0x654BAA00
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)

		if (player != nil) && player:HasToken("AREAF_CANTLEAVETHEM_FOUND") == false then
			womenFound = true
			player:GiveToken("AREAF_CANTLEAVETHEM_FOUND")
			
			if questTaskState == QuestState.InProgress then
				UI.Notify("tagNotification_AreaF_CantLeaveThem")
				
			else
				UI.Notify("tagNotification_AreaF_CantLeaveThemNoQuest")
				
			end
			
		end
		
	end
	
end

-- In the birthing chamber the player finds Katrine.

local KatrineCorpseSpawned = false
local KatrineCorpseID = 0
local KatrineCorpseStateObjects = nil
local KatrineCorpseState = { NotTalkedTo = 0, TalkedTo = 1, LootedNote = 2}

-- Katrine's body
local KatrineCorpseStateObjects = orderedTable();
	KatrineCorpseStateObjects["AREAF_KATRINENOTE_FOUND"] = { state = KatrineCorpseState.LootedNote, dbr = nil }
	KatrineCorpseStateObjects["AldritchCaptive_RESCUED"] = { state = KatrineCorpseState.TalkedTo, dbr = "records/items/loreobjects/lorechest_areaf_katrinecorpse.dbr"}
	KatrineCorpseStateObjects[""] = { state = KatrineCorpseState.NotTalkedTo, dbr = nil }

function gd.quests.areaFQuestFactionMalmouth.KatrineCorpseOnAddToWorld(objectId)

	if Server then
		
		if not KatrineCorpseSpawned then
			
			KatrineCorpseSpawned = true
		
			KatrineCorpseID = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, KatrineCorpseStateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
		
	end
	
end

gd.quests.areaFQuestFactionMalmouth.KatrineCorpseOnDestroy = ClearObjectUserdata

function gd.quests.areaFQuestFactionMalmouth.KatrineNoteLooted()
	
	local player = Game.GetLocalPlayer()

		player:GiveToken("AREAF_KATRINENOTE_FOUND")

end


