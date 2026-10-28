/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com

*/


gd.quests.areaEWendigoVillageFlavor = {}

--
--Village flavor NPCS
-- 
local Villager01Id  = 0
local Villager02Id  = 0
local Villager03Id  = 0
local Villager04Id  = 0
local VendorId  = 0
local Villager01Hostile = false
local Villager02Hostile = false
local Villager03Hostile = false
local Villager04Hostile = false
local VendorHostile = false

local VillagerState = {Friendly = 0, Hostile = 1}

--Villager 01
local Villager01StateObjects = orderedTable();
	Villager01StateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/creatures/enemies/faction/cult_flavor01_hostile.dbr" }
	Villager01StateObjects[""] = { state = VillagerState.Friendly, dbr = "records/creatures/npcs/flavornpcs/gdareae/npc_wendigoflavor_01.dbr" }

local function Villager01CreateArgs()

	return 0, Entity.Get(Villager01Id):GetCoords().origin
	
end
	
function gd.quests.areaEWendigoVillageFlavor.villager01OnAddToWorld(objectId)

	if Server then

		if (Villager01Hostile == false) then
			Villager01Id = objectId;
		
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Villager01StateObjects, Character, Villager01CreateArgs)
			Shared.setUserdata(objectId, userdata)

			--Don't respawn if spawned as hostile
			if (newState == VillagerState.Hostile) then
				Villager01Hostile = true
			end
		
		end
		
	end
	
end

gd.quests.areaEWendigoVillageFlavor.villager01OnDestory = ClearObjectUserdata

--Villager 02
local Villager02StateObjects = orderedTable();
	Villager02StateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/creatures/enemies/faction/cult_flavor02_hostile.dbr" }
	Villager02StateObjects[""] = { state = VillagerState.Friendly, dbr = "records/creatures/npcs/flavornpcs/gdareae/npc_wendigoflavor_02.dbr" }
	
local function Villager02CreateArgs()

	return 0, Entity.Get(Villager02Id):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villager02OnAddToWorld(objectId)

	if Server then
	
		if (Villager02Hostile == false) then
			Villager02Id = objectId;
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Villager02StateObjects, Character, Villager02CreateArgs)
			Shared.setUserdata(objectId, userdata)

			-- Don't respawn if spawned as hostile
			if (newState == VillagerState.Hostile) then
				Villager02Hostile = true
			end
			
		end
	
	end
	
end

gd.quests.areaEWendigoVillageFlavor.villager02OnDestory = ClearObjectUserdata

--Villager 03
local Villager03StateObjects = orderedTable();
	Villager03StateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/creatures/enemies/faction/cult_flavor03_hostile.dbr" }
	Villager03StateObjects[""] = { state = VillagerState.Friendly, dbr = "records/creatures/npcs/flavornpcs/gdareae/npc_wendigoflavor_03.dbr" }

local function Villager03CreateArgs()

	return 0, Entity.Get(Villager03Id):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villager03OnAddToWorld(objectId)

	if Server then
	
		if (Villager03Hostile == false) then
			
			Villager03Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Villager03StateObjects, Character, Villager03CreateArgs)
			Shared.setUserdata(objectId, userdata)

			-- Don't respawn if spawned as hostile
			if (newState == VillagerState.Hostile) then
				Villager03Hostile = true
			end
		
		end 
	end
	
end

gd.quests.areaEWendigoVillageFlavor.villager03OnDestory = ClearObjectUserdata

--Villager 04
local Villager04StateObjects = orderedTable();
	Villager04StateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/creatures/enemies/faction/cult_flavor04_hostile.dbr" }
	Villager04StateObjects[""] = { state = VillagerState.Friendly, dbr = "records/creatures/npcs/flavornpcs/gdareae/npc_wendigoflavor_04.dbr" }

local function Villager04CreateArgs()

	return 0, Entity.Get(Villager04Id):GetCoords().origin
	
end
	
function gd.quests.areaEWendigoVillageFlavor.villager04OnAddToWorld(objectId)

	if Server then

		if (Villager04Hostile == false) then
			
			Villager04Id = objectId;	

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Villager04StateObjects, Character, Villager04CreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == VillagerState.Hostile) then
				Villager04Hostile = true
			end
		
		end
		
	end
	
end

gd.quests.areaEWendigoVillageFlavor.villager04OnDestory = ClearObjectUserdata

--Vendor
local VendorStateObjects = orderedTable();
	VendorStateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/creatures/enemies/faction/cult_merchant_hostile.dbr" }
	VendorStateObjects[""] = { state = VillagerState.Friendly, dbr = "records/creatures/npcs/merchants/areae_merchanta102.dbr" }

local function VendorCreateArgs()

	return 0, Entity.Get(VendorId):GetCoords().origin
	
end
	
function gd.quests.areaEWendigoVillageFlavor.vendorOnAddToWorld(objectId)

	if Server then
	
		if (VendorHostile == false) then
		
			VendorId = objectId;
		
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, VendorStateObjects, Character, VendorCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == VillagerState.Hostile) then
				VendorHostile = true
			end
			
		end
		
	end
	
end

gd.quests.areaEWendigoVillageFlavor.vendorOnDestory = ClearObjectUserdata

--
-- the major villagers go hostile - activate by dialogue
-- 
local villageFlavorHostileSwap = false

function gd.quests.areaEWendigoVillageFlavor.VillageFlavorHostileTransition()

	if Server && not villageFlavorHostileSwap then
	
		local player = Game.GetLocalPlayer()
		local MPOverrideState = false
		local MPOverrideDbrVillager01 = nil
		local MPOverrideDbrVillager02 = nil
		local MPOverrideDbrVillager03 = nil
		local MPOverrideDbrVillager04 = nil
		local MPOverrideDbrVendor = nil
		
		if (player:HasToken("AREAE_VILLAGEHOSTILE") == false) then
			MPOverrideState = true
			MPOverrideDbrVillager01 = "records/creatures/enemies/faction/cult_flavor01_hostile.dbr"
			MPOverrideDbrVillager02 = "records/creatures/enemies/faction/cult_flavor02_hostile.dbr"
			MPOverrideDbrVillager03 = "records/creatures/enemies/faction/cult_flavor03_hostile.dbr"
			MPOverrideDbrVillager04 = "records/creatures/enemies/faction/cult_flavor04_hostile.dbr"
			MPOverrideDbrVendor = "records/creatures/enemies/faction/cult_flavor04_hostile.dbr"
			
		end
		
		villageFlavorHostileSwap = true

		-- Villager 01

		if not Villager01Hostile then
		
			local villager01 = Entity.Get (Villager01Id)
				
			if (villager01 != nil) then
				Villager01Hostile = true
			
				local coords = villager01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(Villager01Id, Villager01StateObjects, Character, Villager01CreateArgs, MPOverrideState, MPOverrideDbrVillager01)
			
			end

		end
		
		-- Villager 02
		if not Villager02Hostile then
		
			local villager02 = Entity.Get (Villager02Id)
			
			if (villager02 != nil) then
				Villager02Hostile = true
			
				local coords = villager02:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(Villager02Id, Villager02StateObjects, Character, Villager02CreateArgs, MPOverrideState, MPOverrideDbrVillager02)
			
			end

		end
		
		-- Villager 03
		if not Villager03Hostile then
			
			local villager03 = Entity.Get (Villager03Id)
			
			if (villager03 != nil) then
				Villager03Hostile = true
			
				local coords = villager03:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(Villager03Id, Villager03StateObjects, Character, Villager03CreateArgs, MPOverrideState, MPOverrideDbrVillager03)
			
			end

		end
		
		-- Villager 04
		if not Villager04Hostile then
			
			local villager04 = Entity.Get (Villager04Id)
			
			if (villager04 != nil) then
				Villager04Hostile = true
			
				local coords = villager04:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(Villager04Id, Villager04StateObjects, Character, Villager04CreateArgs, MPOverrideState, MPOverrideDbrVillager04)
			
			end

		end
		
		-- Vendor
		if not VendorHostile then
			
			local Vendor = Entity.Get (VendorId)
			
			if (Vendor != nil) then
				VendorHostile = true
			
				local coords = Vendor:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(VendorId, VendorStateObjects, Character, VendorCreateArgs, MPOverrideState, MPOverrideDbrVendor)
			
			end

		end
		
	end
	
end

--
-- Proxies for when the player returns to the village
--
local VillageProxyId = {0, 0, 0, 0, 0, 0, 0, 0}
local VillageProxySpawned = {false, false, false, false, false, false, false, false}

local VillageProxyCannibalStateObjects = orderedTable();
	VillageProxyCannibalStateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/proxies/factionspawnsgdx1/faction_wendigocannibal_n_norep.dbr" }
	VillageProxyCannibalStateObjects[""] = { state = VillagerState.Friendly, dbr = nil}	

local VillageProxyMixStateObjects = orderedTable();
	VillageProxyMixStateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillagerState.Hostile,  dbr = "records/proxies/factionspawnsgdx1/faction_wendigomix_n_norep.dbr" }
	VillageProxyMixStateObjects[""] = { state = VillagerState.Friendly, dbr = nil}	
	
--01
local function VillageProxy01CharacterCreateArgs()

	return Entity.Get(VillageProxyId[1]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy01OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[1] then
		VillageProxySpawned[1] = true
		
		VillageProxyId[1] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyCannibalStateObjects, Proxy, VillageProxy01CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEWendigoVillageFlavor.villageProxyOnDestroy = ClearObjectUserdata

--02
local function VillageProxy02CharacterCreateArgs()

	return Entity.Get(VillageProxyId[2]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy02OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[2] then
		VillageProxySpawned[2] = true
		
		VillageProxyId[2] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyMixStateObjects, Proxy, VillageProxy02CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

--03
local function VillageProxy03CharacterCreateArgs()

	return Entity.Get(VillageProxyId[3]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy03OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[3] then
		VillageProxySpawned[3] = true
		
		VillageProxyId[3] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyCannibalStateObjects, Proxy, VillageProxy03CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

--04
local function VillageProxy04CharacterCreateArgs()

	return Entity.Get(VillageProxyId[4]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy04OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[4] then
		VillageProxySpawned[4] = true
		
		VillageProxyId[4] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyMixStateObjects, Proxy, VillageProxy04CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

--05
local function VillageProxy05CharacterCreateArgs()

	return Entity.Get(VillageProxyId[5]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy05OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[5] then
		VillageProxySpawned[5] = true
		
		VillageProxyId[5] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyCannibalStateObjects, Proxy, VillageProxy05CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEWendigoVillageFlavor.villageProxyOnDestroy = ClearObjectUserdata

--06
local function VillageProxy06CharacterCreateArgs()

	return Entity.Get(VillageProxyId[6]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy06OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[6] then
		VillageProxySpawned[6] = true
		
		VillageProxyId[6] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyMixStateObjects, Proxy, VillageProxy06CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

--07
local function VillageProxy07CharacterCreateArgs()

	return Entity.Get(VillageProxyId[7]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy07OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[7] then
		VillageProxySpawned[7] = true
		
		VillageProxyId[7] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyCannibalStateObjects, Proxy, VillageProxy07CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

--08
local function VillageProxy08CharacterCreateArgs()

	return Entity.Get(VillageProxyId[8]):GetCoords().origin
	
end

function gd.quests.areaEWendigoVillageFlavor.villageProxy08OnAddToWorld(objectId)

	if Server && not VillageProxySpawned[8] then
		VillageProxySpawned[8] = true
		
		VillageProxyId[8] = objectId
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageProxyMixStateObjects, Proxy, VillageProxy08CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end


