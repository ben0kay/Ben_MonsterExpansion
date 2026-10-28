/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFRebelBase = {}

--
-- Resistance upper base fighters and guards spawned during/after event to retake the resistance base
--
local RebelBaseState = { Default = 0, Fighting = 1, BaseTaken = 2 }

--
-- Static base guards, spawned after reload if base is retaken
--
local guardSpawned = {false, false, false, false, false, false, false, false}

local function GuardCharacterCreateArgs()

	local maxLevel = 0
	local playerLevel = Game.GetAveragePlayerLevel()

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 110
	end
	
	if (playerLevel < maxLevel) then
		if playerLevel < 50 then
			maxLevel = 50
			
		else
			maxLevel = 0
		
		end
		
	end

	return maxLevel, nil
	
end

-- Rebel Base Gate Guard 01
local Guard01StateObjects = orderedTable();
	Guard01StateObjects["AREAF_REBELBASE_UNLOCKDOORS"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr" }
	Guard01StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard01OnAddToWorld(objectId)

	if Server && not guardSpawned[1] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard01StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[1] = true
		end
		
	end
	
end

gd.quests.areaFRebelBase.resistanceNPCOnDestroy = ClearObjectUserdata

-- Rebel Base Gate Guard 02
local Guard02StateObjects = orderedTable();
	Guard02StateObjects["AREAF_REBELBASE_UNLOCKDOORS"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr" }
	Guard02StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard02OnAddToWorld(objectId)

	if Server && not guardSpawned[2] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard02StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[2] = true
		end
		
	end
	
end

-- Rebel Base Gate Guard 03
local Guard03StateObjects = orderedTable();
	Guard03StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_ranged01.dbr" }
	Guard03StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard03OnAddToWorld(objectId)

	if Server && not guardSpawned[3] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard03StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[3] = true
		end
		
	end
	
end

-- Rebel Base Gate Guard 04
local Guard04StateObjects = orderedTable();
	Guard04StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_ranged_female01.dbr" }
	Guard04StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard04OnAddToWorld(objectId)

	if Server && not guardSpawned[4] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard04StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[4] = true
		end
		
	end
	
end

-- Rebel Base Gate Guard 05
local Guard05StateObjects = orderedTable();
	Guard05StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_ranged_female01.dbr" }
	Guard05StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard05OnAddToWorld(objectId)

	if Server && not guardSpawned[5] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard05StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[5] = true
		end
		
	end
	
end

-- Rebel Base Gate Guard 06
local Guard06StateObjects = orderedTable();
	Guard06StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_ranged_female01.dbr" }
	Guard06StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard06OnAddToWorld(objectId)

	if Server && not guardSpawned[6] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard06StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[6] = true
		end
		
	end
	
end

-- Rebel Base Gate Guard 07
local Guard07StateObjects = orderedTable();
	Guard07StateObjects["AREAF_REBELBASE_UNLOCKDOORS"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr" }
	Guard07StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard07OnAddToWorld(objectId)

	if Server && not guardSpawned[7] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard07StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[7] = true
		end
		
	end
	
end

-- Rebel Base Gate Guard 08
local Guard08StateObjects = orderedTable();
	Guard08StateObjects["AREAF_REBELBASE_UNLOCKDOORS"] = { state = RebelBaseState.BaseTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr" }
	Guard08StateObjects[""] = { state = RebelBaseState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.guard08OnAddToWorld(objectId)

	if Server && not guardSpawned[8] then
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Guard08StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)

		--Don't respawn if spawned as guard
		if (newState == RebelBaseState.BaseTaken) then
			guardSpawned[8] = true
		end
		
	end
	
end

--
-- Resistance fighters for the base fight
--
local fighterProxy01Id = 0
local fighterProxy02Id = 0
local fighterProxy01Spawned = false
local fighterProxy02Spawned = false
	
local fighterProxy01StateObjects = orderedTable();
	fighterProxy01StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelBaseState.BaseTaken,  dbr = nil}
	fighterProxy01StateObjects["AREAF_REBELBASE_FIGHTING"] = { state = RebelBaseState.Fighting, dbr = "records/proxies/boss&questgdx1/questproxy_malmouthbase_fighters_01.dbr" }
	fighterProxy01StateObjects[""] = { state = RebelBaseState.Default, dbr = nil}
	
local function FighterProxy01CharacterCreateArgs()

	return Entity.Get(fighterProxy01Id):GetCoords().origin
	
end
	
function gd.quests.areaFRebelBase.fighterProxy01OnAddToWorld(objectId)

	if Server && not fighterProxy01Spawned then
		fighterProxy01Id = objectId
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, fighterProxy01StateObjects, Proxy, FighterProxy01CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		--Don't respawn if spawned as fighter
		if (newState == RebelBaseState.Fighting) then
			fighterProxy01Spawned = true
		end
		
	end
	
end

local fighterProxy02StateObjects = orderedTable();
	fighterProxy02StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = RebelBaseState.BaseTaken,  dbr = nil}
	fighterProxy02StateObjects["AREAF_REBELBASE_FIGHTING"] = { state = RebelBaseState.Fighting, dbr = "records/proxies/boss&questgdx1/questproxy_malmouthbase_fighters_02.dbr" }
	fighterProxy02StateObjects[""] = { state = RebelBaseState.Default, dbr = nil}
	
local function FighterProxy02CharacterCreateArgs()

	return Entity.Get(fighterProxy02Id):GetCoords().origin
	
end
	
function gd.quests.areaFRebelBase.fighterProxy02OnAddToWorld(objectId)

	if Server && not fighterProxy02Spawned then
		fighterProxy02Id = objectId
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, fighterProxy02StateObjects, Proxy, FighterProxy02CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		--Don't respawn if spawned as fighter
		if (newState == RebelBaseState.Fighting) then
			fighterProxy02Spawned = true
		end
		
	end
	
end

-- Activated by quest, to turn on the rebel fighters if they are already loaded.
local spawnResistance = false

function gd.quests.areaFRebelBase.fightersTransition()
	
	if Server && not spawnResistance then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_REBELBASE_FIGHTING") then
			spawnResistance = true

			local Proxy01 = Entity.Get(fighterProxy01Id)
			
			if (Proxy01 != nil) then
				UpdateObjectSwap(fighterProxy01Id, fighterProxy01StateObjects, Proxy, FighterProxy01CharacterCreateArgs)
				
			end
			
			local Proxy02 = Entity.Get(fighterProxy02Id)
			
			if (Proxy02 != nil) then
				UpdateObjectSwap(fighterProxy02Id, fighterProxy02StateObjects, Proxy, FighterProxy02CharacterCreateArgs)
				
			end
			
		end

	end
	
end


--Injured Guard (He appears in the sewers before the base is retaken)
local InjuredGuardBaseId = 0
local InjuredGuardSewerId = 0

local InjuredGuardState = { BaseNotTaken = 0, Helped = 1, BaseTaken = 2 }

local injuredGuardSewerStateObjects = orderedTable();
	injuredGuardSewerStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = InjuredGuardState.BaseTaken,  dbr = nil }
	injuredGuardSewerStateObjects["AREAF_INJUREDGUARDHELPED"] = { state = InjuredGuardState.Helped, dbr = nil }
	injuredGuardSewerStateObjects[""] = { state = InjuredGuardState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareaf/npc_injuredguard_01.dbr" }
	
function gd.quests.areaFRebelBase.injuredGuardSewersOnAddToWorld(objectId)

	if Server then

		InjuredGuardSewerId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, injuredGuardSewerStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.injuredGuardOnDestroy = ClearObjectUserdata

local injuredGuardBaseStateObjects = orderedTable();
	injuredGuardBaseStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = InjuredGuardState.BaseTaken,  dbr = "records/creatures/npcs/flavornpcs/gdareaf/npc_rebelgateguard_01.dbr" }
	injuredGuardBaseStateObjects["AREAF_INJUREDGUARDHELPED"] = { state = InjuredGuardState.Helped, dbr = nil }
	injuredGuardBaseStateObjects[""] = { state = InjuredGuardState.Default, dbr = nil }
	
function gd.quests.areaFRebelBase.injuredGuardBaseOnAddToWorld(objectId)

	if Server then

		InjuredGuardBaseId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, injuredGuardBaseStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Transition guard to base, whether player helped or not
local injuredGuardTransition = false

function gd.quests.areaFRebelBase.rebelBaseGateGuardTransition()
	
	if Server && not injuredGuardTransition then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_RETAKEINDUSTRIALDISTRICT") then
			injuredGuardTransition = true
			
			local injuredGuardBase = Entity.Get(InjuredGuardBaseId)
			
			if (injuredGuardBase != nil) then
			
				local coords = injuredGuardBase:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(InjuredGuardBaseId, injuredGuardBaseStateObjects)
			
			end
		
			local injuredGuardSewer = Entity.Get(InjuredGuardSewerId)
			
			if (injuredGuardSewer != nil) then
			
				local coords = injuredGuardSewer:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(InjuredGuardSewerId, injuredGuardSewerStateObjects)
			
			end
		
		end
		
	end
	
end

-- Aetherial Proxies spawned if player ends up there prior to attack in MP
local aetherialProxy01Id = 0
local aetherialProxy02Id = 0
local aetherialSentry01Id = 0
local aetherialProxy01Spawned = false
local aetherialProxy02Spawned = false
local sentry01Spawned = false

local AetherialState = { Default = 0, Finished = 1 }
	
local AetherialProxy01StateObjects = orderedTable();
	AetherialProxy01StateObjects["AREAF_INDUSTRIALUNLOCKED"] = { state = AetherialState.Finished, dbr = nil }
	AetherialProxy01StateObjects[""] = { state = AetherialState.Default, dbr = "records/proxies/boss&questgdx1/questproxy_malmouthbase_aetherialhorde_01.dbr" }
	
local function AetherialProxy01CharacterCreateArgs()

	return Entity.Get(aetherialProxy01Id):GetCoords().origin
	
end

local function AetherialProxy02CharacterCreateArgs()

	return Entity.Get(aetherialProxy02Id):GetCoords().origin
	
end
	
function gd.quests.areaFRebelBase.aetherialProxy01OnAddToWorld(objectId)

	if Server && not aetherialProxy01Spawned then
		aetherialProxy01Spawned = true
		aetherialProxy01Id = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, AetherialProxy01StateObjects, Proxy, AetherialProxy01CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

function gd.quests.areaFRebelBase.aetherialProxy02OnAddToWorld(objectId)

	if Server && not aetherialProxy02Spawned then
		aetherialProxy02Spawned = true
		aetherialProxy02Id = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, AetherialProxy01StateObjects, Proxy, AetherialProxy02CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaFRebelBase.aetherialsOnDestroy = ClearObjectUserdata

local AetherialSentry01StateObjects = orderedTable();
	AetherialSentry01StateObjects["AREAF_INDUSTRIALUNLOCKED"] = { state = AetherialState.Finished, dbr = nil }
	AetherialSentry01StateObjects[""] = { state = AetherialState.Default, dbr = "records/creatures/enemies/aetherialsentry_b01.dbr" }
	
local function Sentry01CreateArgs()

	return 0, Entity.Get(aetherialSentry01Id):GetCoords().origin
	
end
	
function gd.quests.areaFRebelBase.aetherialSentry01OnAddToWorld(objectId)

	if Server && not sentry01Spawned then
		sentry01Spawned = true
		aetherialSentry01Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, AetherialSentry01StateObjects, Character, Sentry01CreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

-------------------------------
-- Rebel Base Updates ---------
-------------------------------

-- Caravan -- In hideout initially then appears in the base when it is retaken.

local CaravanState = { Hideout = 0, Base = 1}
local CaravanHideoutId = 0
local CaravanBaseID = 0

-- Caravan Hideout
local CaravanHideoutStateObjects = orderedTable();
	CaravanHideoutStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = CaravanState.Base, dbr = nil }
	CaravanHideoutStateObjects[""] = { state = CaravanState.Hideout, dbr = "records/creatures/npcs/merchants/caravana05.dbr" }

function gd.quests.areaFRebelBase.CaravanHideoutOnAddToWorld(objectId)

	if Server then
	
		CaravanHideoutId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, CaravanHideoutStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.CaravanHideoutOnDestroy = ClearObjectUserdata

-- Caravan Base
local CaravanBaseStateObjects = orderedTable();
	CaravanBaseStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = CaravanState.Base, dbr = "records/creatures/npcs/merchants/caravana05.dbr" }
	CaravanBaseStateObjects[""] = { state = CaravanState.Hideout, dbr = nil }

function gd.quests.areaFRebelBase.CaravanBaseOnAddToWorld(objectId)

	if Server then
	
		CaravanBaseId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, CaravanBaseStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.CaravanBaseOnDestroy = ClearObjectUserdata

-- Faction Vendor Base --

local factionVendorState = { Default = 0, Base = 1}
local factionVendorBaseID = 0

-- factionVendor Base
local factionVendorBaseStateObjects = orderedTable();
	factionVendorBaseStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = factionVendorState.Base, dbr = "records/creatures/npcs/merchants/merchantfaction_malmouth_01.dbr" }
	factionVendorBaseStateObjects[""] = { state = factionVendorState.Default, dbr = nil }

function gd.quests.areaFRebelBase.factionVendorBaseOnAddToWorld(objectId)

	if Server then
	
		factionVendorBaseId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, factionVendorBaseStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.factionVendorBaseOnDestroy = ClearObjectUserdata

--
-- Merchant Areas - Activated after the player completes the "rescue the resistance" quest
-- 

local merchantArea01Id = 0

local merchantAreaStates = { Wrecked = 0, Repaired = 1}

local merchantArea01StatesObjects = orderedTable();
	merchantArea01StatesObjects["AREAF_RESCUETHERESISTANCE"] = { state = merchantAreaStates.Repaired, dbr = "records/storyelements/questassets/areaf_merchantarea01.dbr"}
	merchantArea01StatesObjects[""] = { state = merchantAreaStates.Wrecked, dbr = "records/storyelements/questassets/areaf_merchantarea01_wrecked.dbr" }
	
function gd.quests.areaFRebelBase.merchantarea01OnAddToWorld(objectId)
	
	if Server then
		merchantArea01Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, merchantArea01StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.merchantarea01OnDestroy = ClearObjectUserdata

--
-- Smuggler Area
--
local smugglerArea01Id = 0

local smugglerAreaStates = { Wrecked = 0, Repaired = 1}

local smugglerArea01StatesObjects = orderedTable();
	smugglerArea01StatesObjects["AREAF_RESCUETHERESISTANCE"] = { state = smugglerAreaStates.Repaired, dbr = "records/storyelements/questassets/areaf_smugglerarea01.dbr"}
	smugglerArea01StatesObjects[""] = { state = smugglerAreaStates.Wrecked, dbr = "records/storyelements/questassets/areaf_smugglerarea01_wrecked.dbr" }
	
function gd.quests.areaFRebelBase.smugglerarea01OnAddToWorld(objectId)
	
	if Server then
		smugglerArea01Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, smugglerArea01StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.smugglerarea01OnDestroy = ClearObjectUserdata

--
-- Refugee Area - Activated after the player completes the "rescue the resistance" quest
--
local refugeeArea01Id = 0

local refugeeAreaStates = { Wrecked = 0, Repaired = 1}

local refugeeArea01StatesObjects = orderedTable();
	refugeeArea01StatesObjects["AREAF_RESCUETHERESISTANCE"] = { state = refugeeAreaStates.Repaired, dbr = "records/storyelements/questassets/areaf_refugeearea01.dbr"}
	refugeeArea01StatesObjects[""] = { state = refugeeAreaStates.Wrecked, dbr = "records/storyelements/questassets/areaf_refugeearea01_wrecked.dbr"}
	
function gd.quests.areaFRebelBase.refugeeArea01OnAddToWorld(objectId)
	
	if Server then
		refugeeArea01Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, refugeeArea01StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.refugeeArea01OnDestroy = ClearObjectUserdata

--
-- Cannons - Activated after the player initially liberates the base
-- 

local cannons01Id = 0
local cannons02Id = 0
local cannons02Id = 0

local cannonStates = { Wrecked = 0, Repaired = 1}

-- Upper 01
local cannons01StatesObjects = orderedTable();
	cannons01StatesObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = cannonStates.Repaired, dbr = "records/storyelements/questassets/areaf_cannonupper01.dbr"}
	cannons01StatesObjects[""] = { state = cannonStates.Wrecked, dbr = "records/storyelements/questassets/areaf_cannonupper01_wrecked.dbr"}
	
function gd.quests.areaFRebelBase.cannons01OnAddToWorld(objectId)
	
	if Server then
		cannons01Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, cannons01StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.cannons01OnDestroy = ClearObjectUserdata

-- Upper 02
local cannons02StatesObjects = orderedTable();
	cannons02StatesObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = cannonStates.Repaired, dbr = "records/storyelements/questassets/areaf_cannonupper02.dbr"}
	cannons02StatesObjects[""] = { state = cannonStates.Wrecked, dbr = "records/storyelements/questassets/areaf_cannonupper02_wrecked.dbr"}

function gd.quests.areaFRebelBase.cannons02OnAddToWorld(objectId)
	
	if Server then
		cannons02Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, cannons02StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.cannons02OnDestroy = ClearObjectUserdata

-- Lower
local cannons03StatesObjects = orderedTable();
	cannons03StatesObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = cannonStates.Repaired, dbr = "records/storyelements/questassets/areaf_cannonslower01.dbr"}
	cannons03StatesObjects[""] = { state = cannonStates.Wrecked, dbr = "records/storyelements/questassets/areaf_cannonslower01_wrecked.dbr"}

function gd.quests.areaFRebelBase.cannons03OnAddToWorld(objectId)
	
	if Server then
		cannons03Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, cannons03StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.cannons03OnDestroy = ClearObjectUserdata

--
-- Quest NPC Area - Activated after the player initially liberates the base
-- 
local npcArea01Id = 0

local NpcAreaStates = { Wrecked = 0, Repaired = 1}

local npcArea01StatesObjects = orderedTable();
	npcArea01StatesObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = NpcAreaStates.Repaired, dbr = "records/storyelements/questassets/areaf_questarea01.dbr"}
	npcArea01StatesObjects[""] = { state = NpcAreaStates.Wrecked, dbr = "records/storyelements/questassets/areaf_questarea01_wrecked.dbr"}
	
function gd.quests.areaFRebelBase.npcArea01OnAddToWorld(objectId)
	
	if Server then
		npcArea01Id = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, npcArea01StatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFRebelBase.npcArea01OnDestroy = ClearObjectUserdata

-- Bounty Table only spawn after the base is liberated
local tableId = 0

-- Table
local TableStateObjects = orderedTable();
	TableStateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = NpcAreaStates.Repaired,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_bountytable_malmouth_01.dbr" }
	TableStateObjects[""] = { state = NpcAreaStates.Wrecked, dbr = "records/level art/factions/malmouth_table01a_light.dbr" }
	
function gd.quests.areaFRebelBase.tableOnAddToWorld(objectId)

	if Server then

		tableId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, TableStateObjects)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFRebelBase.tableOnDestroy = ClearObjectUserdata

