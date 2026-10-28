/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFAmbientFighters = {}

--
-- Ambient BL Guards
--

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

-- 2x BL guards With Creed in sewers.
local BLSewerGuardStates = { NoCreed = 0, CreedInSewer = 1, CreedInBase = 2}
local BlSewerGuard01ID = 0
local BlSewerGuard01Spawned = 0
local BlSEwerGuard02ID = 0
local BlSEwerGuard02Spawned = 0

local BLSewerGuard01StateObjects = orderedTable();
	BLSewerGuard01StateObjects["AREAF_NPCCREED_BASE"] = { state = BLSewerGuardStates.CreedInBase,  dbr = nil}
	BLSewerGuard01StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLSewerGuardStates.CreedInSewer,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr"}
	BLSewerGuard01StateObjects[""] = { state = BLSewerGuardStates.NoCreed, dbr = nil}

function gd.quests.areaFAmbientFighters.BLGuardSewer01OnAddToWorld(objectId)
	
	if Server then
	
		BlSewerGuard01ID = objectId
		
		if (not BlSewerGuard01Spawned) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BLSewerGuard01StateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == BLSewerGuardStates.CreedInSewer) then
				BlSewerGuard01Spawned = true
			end
			
		end
	
	end
	
end

local BLSewerGuard02StateObjects = orderedTable();
	BLSewerGuard02StateObjects["AREAF_NPCCREED_BASE"] = { state = BLSewerGuardStates.CreedInBase,  dbr = nil}
	BLSewerGuard02StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLSewerGuardStates.CreedInSewer,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr"}
	BLSewerGuard02StateObjects[""] = { state = BLSewerGuardStates.NoCreed, dbr = nil}

function gd.quests.areaFAmbientFighters.BLGuardSewer02OnAddToWorld(objectId)
	
	if Server then
	
		BlSewerGuard02ID = objectId
		
		if (not BlSewerGuard02Spawned) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BLSewerGuard02StateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == BLSewerGuardStates.CreedInSewer) then
				BlSewerGuard02Spawned = true
			end
			
		end
	
	end
	
end

-- Sewer Guards Transition
function gd.quests.areaFAmbientFighters.BLGuardsSewerTransition()
	
	if Server then
	
		if not BlSewerGuard01Spawned then
		
			local BLSewerGuard01 = Entity.Get(BlSewerGuard01ID)
			
			if (BLSewerGuard01 != nil) then
			
				local coords = BLSewerGuard01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(BlSewerGuard01ID, BLSewerGuard01StateObjects)
				
				BlSewerGuard01Spawned = true
				
			end

		end
	
		if not BlSewerGuard02Spawned then
		
			local BLSewerGuard02 = Entity.Get(BlSewerGuard02ID)
			
			if (BLSewerGuard02 != nil) then
			
				local coords = BLSewerGuard02:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(BlSewerGuard02ID, BLSewerGuard02StateObjects)
				
				BlSewerGuard02Spawned = true
				
			end

		end

	end
	
end

-- Guarding Crown Hill Riftgate
local BLCrownHillGuardStates = { RiftNotTaken = 0, RiftTaken = 1,}

local BLCrownHillGuard01ID = 0
local BLCrownHillGuard01Spawned = false
local BLCrownHillGuard02ID = 0
local BLCrownHillGuard02Spawned = false
local BLCrownHillGuard03ID = 0
local BLCrownHillGuard03Spawned = false

local BLCrownHillGuard01StateObjects = orderedTable();
	BLCrownHillGuard01StateObjects["AREAF_INNERCITYRIFTGATECLAIMED"] = { state = BLCrownHillGuardStates.RiftTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr"}
	BLCrownHillGuard01StateObjects[""] = { state = BLCrownHillGuardStates.RiftNotTaken, dbr = nil}

function gd.quests.areaFAmbientFighters.BLGuardCrownHill01OnAddToWorld(objectId)
	
	if Server then
	
		BLCrownHillGuard01ID = objectId
		
		if (not BLCrownHillGuard01Spawned) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BLCrownHillGuard01StateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == BLCrownHillGuardStates.RiftTaken) then
				BLCrownHillGuard01Spawned = true
			end
			
		end
	
	end
	
end

local BLCrownHillGuard02StateObjects = orderedTable();
	BLCrownHillGuard02StateObjects["AREAF_INNERCITYRIFTGATECLAIMED"] = { state = BLCrownHillGuardStates.RiftTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr"}
	BLCrownHillGuard02StateObjects[""] = { state = BLCrownHillGuardStates.RiftNotTaken, dbr = nil}

function gd.quests.areaFAmbientFighters.BLGuardCrownHill02OnAddToWorld(objectId)
	
	if Server then
	
		BLCrownHillGuard02ID = objectId
		
		if (not BLCrownHillGuard02Spawned) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BLCrownHillGuard02StateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == BLCrownHillGuardStates.RiftTaken) then
				BLCrownHillGuard02Spawned = true
			end
			
		end
	
	end
	
end

local BLCrownHillGuard03StateObjects = orderedTable();
	BLCrownHillGuard03StateObjects["AREAF_INNERCITYRIFTGATECLAIMED"] = { state = BLCrownHillGuardStates.RiftTaken,  dbr = "records/creatures/npcs/guard/guard_blacklegion_ranged_female01.dbr"}
	BLCrownHillGuard03StateObjects[""] = { state = BLCrownHillGuardStates.RiftNotTaken, dbr = nil}

function gd.quests.areaFAmbientFighters.BLGuardCrownHill03OnAddToWorld(objectId)
	
	if Server then

		BLCrownHillGuard03ID = objectId
		
		if (not BLCrownHillGuard03Spawned) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BLCrownHillGuard03StateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == BLCrownHillGuardStates.RiftTaken) then
				BLCrownHillGuard03Spawned = true
			end
			
		end
		
	
	end
	
end

-- Crown Hill Rift Guards Transition
function gd.quests.areaFAmbientFighters.BLGuardsCrownHillTransition()
	
	if Server then
	
		if not BLCrownHillGuard01Spawned then

			local BLCrownHillGuard01 = Entity.Get(BLCrownHillGuard01ID)
			
			if (BLCrownHillGuard01 != nil) then
			
				local coords = BLCrownHillGuard01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(BLCrownHillGuard01ID, BLCrownHillGuard01StateObjects)
				
				BLCrownHillGuard01Spawned = true
				
			end

		end
	
		if not BLCrownHillGuard02Spawned then

			local BLCrownHillGuard02 = Entity.Get(BLCrownHillGuard02ID)
			
			if (BLCrownHillGuard02 != nil) then
			
				local coords = BLCrownHillGuard02:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(BLCrownHillGuard02ID, BLCrownHillGuard02StateObjects)
				
				BLCrownHillGuard02Spawned = true
				
			end

		end
	
		if not BLCrownHillGuard03Spawned then
		
			local BLCrownHillGuard03 = Entity.Get(BLCrownHillGuard03ID)
			
			if (BLCrownHillGuard03 != nil) then
			
				local coords = BLCrownHillGuard03:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(BLCrownHillGuard03ID, BLCrownHillGuard03StateObjects)
				
				BLCrownHillGuard03Spawned = true
				
			end

		end

	end

end


--
-- Ambient fighters for Malmouth
--

-- Candle District AREAF_MALMOUTHBRIDGELOWERED

local CandleProxy01Spawned = false
local CandleProxy02Spawned = false
local CandleProxy03Spawned = false

function gd.quests.areaFAmbientFighters.candleProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_MALMOUTHBRIDGELOWERED") && not CandleProxy01Spawned then
			CandleProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/area001/faction_blacklegion_n_always.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaFAmbientFighters.candleProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_MALMOUTHBRIDGELOWERED") && not CandleProxy02Spawned then
			CandleProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/area001/faction_blacklegion_n_always.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaFAmbientFighters.candleProxy03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_MALMOUTHBRIDGELOWERED") && not CandleProxy03Spawned then
			CandleProxy03Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/area001/faction_blacklegion_n_always.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

-- Steelcap District AREAF_INNERCITYGATEDESTROYED
local SteelcapProxy01Spawned = false
local SteelcapProxy02Spawned = false
local SteelcapProxy03Spawned = false

function gd.quests.areaFAmbientFighters.steelcapProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_INNERCITYGATEDESTROYED") && not SteelcapProxy01Spawned then
			SteelcapProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx1/faction_malmouthandbl_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaFAmbientFighters.steelcapProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_INNERCITYGATEDESTROYED") && not SteelcapProxy02Spawned then
			SteelcapProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx1/faction_malmouthandbl_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaFAmbientFighters.steelcapProxy03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_INNERCITYGATEDESTROYED") && not SteelcapProxy03Spawned then
			SteelcapProxy03Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx1/faction_malmouthandbl_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

-- Crown Hill AREAF_FACTORY_FIGHTING
local CrownHillProxy01Spawned = false
local CrownHillProxy02Spawned = false

function gd.quests.areaFAmbientFighters.crownHillProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_FACTORY_FIGHTING") && not CrownHillProxy01Spawned then
			CrownHillProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx1/faction_malmouthandbl_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaFAmbientFighters.crownHillProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_FACTORY_FIGHTING") && not CrownHillProxy02Spawned then
			CrownHillProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx1/faction_malmouthandbl_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

--
-- Creed's retinue south of the bridge
--

-- A retinue of BL soldiers appears at malmouth bridge with creed.
--records/creatures/npcs/guard/guard_blacklegion_ranged_female01
--records/creatures/npcs/guard/guard_blacklegion_melee_female01
--records/creatures/npcs/guard/guard_blacklegion_melee01
--records/creatures/npcs/guard/guard_blacklegion_ranged01
local BLSoldiersAtBridge = false

local BLBridgeSoldierIDs = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local BLBridgeSoldierSpawned = {false, false, false, false, false, false, false, false, false, false, false}
local BLBridgeSoldierStateObjects = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local BLBridgeSoldierState = { CreedNotAtBridge = 0, CreedAtBridge = 1, CreedInHideout = 2}

-- Soldier 01
local BridgeSoldier01StateObjects = orderedTable();
	BridgeSoldier01StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier01StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_ranged_female01.dbr"}
	BridgeSoldier01StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier01OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[1] then
		BLBridgeSoldierIDs[1] = objectId
		BLBridgeSoldierStateObjects[1] = BridgeSoldier01StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier01StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[1] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier01OnDestroy = ClearObjectUserdata


-- Soldier 02
local BridgeSoldier02StateObjects = orderedTable();
	BridgeSoldier02StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier02StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_ranged01.dbr"}
	BridgeSoldier02StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier02OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[2] then
		BLBridgeSoldierIDs[2] = objectId
		BLBridgeSoldierStateObjects[2] = BridgeSoldier02StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier02StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[2] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier02OnDestroy = ClearObjectUserdata

-- Soldier 03
local BridgeSoldier03StateObjects = orderedTable();
	BridgeSoldier03StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier03StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_ranged01.dbr"}
	BridgeSoldier03StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier03OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[3] then
		BLBridgeSoldierIDs[3] = objectId
		BLBridgeSoldierStateObjects[3] = BridgeSoldier03StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier03StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[3] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier03OnDestroy = ClearObjectUserdata

-- Soldier 04
local BridgeSoldier04StateObjects = orderedTable();
	BridgeSoldier04StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier04StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr"}
	BridgeSoldier04StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier04OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[4] then
		BLBridgeSoldierIDs[4] = objectId
		BLBridgeSoldierStateObjects[4] = BridgeSoldier04StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier04StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[4] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier04OnDestroy = ClearObjectUserdata

-- Soldier 05
local BridgeSoldier05StateObjects = orderedTable();
	BridgeSoldier05StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier05StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr"}
	BridgeSoldier05StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier05OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[5] then
		BLBridgeSoldierIDs[5] = objectId
		BLBridgeSoldierStateObjects[5] = BridgeSoldier05StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier05StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[5] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier05OnDestroy = ClearObjectUserdata

-- Soldier 06
local BridgeSoldier06StateObjects = orderedTable();
	BridgeSoldier06StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier06StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr"}
	BridgeSoldier06StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier06OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[6] then
		BLBridgeSoldierIDs[6] = objectId
		BLBridgeSoldierStateObjects[6] = BridgeSoldier06StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier06StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[6] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier06OnDestroy = ClearObjectUserdata

-- Soldier 07
local BridgeSoldier07StateObjects = orderedTable();
	BridgeSoldier07StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier07StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr"}
	BridgeSoldier07StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier07OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[7] then
		BLBridgeSoldierIDs[7] = objectId
		BLBridgeSoldierStateObjects[7] = BridgeSoldier07StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier07StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[7] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier07OnDestroy = ClearObjectUserdata

-- Soldier 08
local BridgeSoldier08StateObjects = orderedTable();
	BridgeSoldier08StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier08StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr"}
	BridgeSoldier08StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier08OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[8] then
		BLBridgeSoldierIDs[8] = objectId
		BLBridgeSoldierStateObjects[8] = BridgeSoldier08StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier08StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[8] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier08OnDestroy = ClearObjectUserdata

-- Soldier 09
local BridgeSoldier09StateObjects = orderedTable();
	BridgeSoldier09StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier09StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr"}
	BridgeSoldier09StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier09OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[9] then
		BLBridgeSoldierIDs[9] = objectId
		BLBridgeSoldierStateObjects[9] = BridgeSoldier09StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier09StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[9] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier09OnDestroy = ClearObjectUserdata

-- Soldier 10
local BridgeSoldier10StateObjects = orderedTable();
	BridgeSoldier10StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier10StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr"}
	BridgeSoldier10StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier10OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[10] then
		BLBridgeSoldierIDs[10] = objectId
		BLBridgeSoldierStateObjects[10] = BridgeSoldier10StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier10StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[10] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier10OnDestroy = ClearObjectUserdata

-- Soldier 11
local BridgeSoldier11StateObjects = orderedTable();
	BridgeSoldier11StateObjects["AREAF_NPCCREED_HIDEOUT"] = { state = BLBridgeSoldierState.CreedInHideout, dbr = nil }
	BridgeSoldier11StateObjects["AREAF_NPCCREED_BRIDGE"] = { state = BLBridgeSoldierState.CreedAtBridge, dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr"}
	BridgeSoldier11StateObjects[""] = { state = BLBridgeSoldierState.CreedNotAtBridge, dbr = nil }

function gd.quests.areaFAmbientFighters.BridgeSoldier11OnAddToWorld(objectId)

	if Server && not BLSoldiersAtBridge && not BLBridgeSoldierSpawned[11] then
		BLBridgeSoldierIDs[11] = objectId
		BLBridgeSoldierStateObjects[11] = BridgeSoldier11StateObjects
	
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BridgeSoldier11StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		-- Don't respawn if spawned as hostile
		if (newState == BLBridgeSoldierState.CreedAtBridge) then
			BLBridgeSoldierSpawned[11] = true
		end
		
	end
	
end

gd.quests.areaFAmbientFighters.BridgeSoldier11OnDestroy = ClearObjectUserdata

--Activated when Creed is moved to Malmouth bridge
function gd.quests.areaFAmbientFighters.BLBridgeSoldiersTransition()

	if Server && not BLSoldiersAtBridge then
		
		local BLSoldiersTotal = table.getn(BLBridgeSoldierIDs)

		for id = 1, BLSoldiersTotal do
			local NPCEntity = Entity.Get(BLBridgeSoldierIDs[id])
			
			if (NPCEntity != nil) then
				local coords = NPCEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
		
				UpdateObjectSwap(BLBridgeSoldierIDs[id], BLBridgeSoldierStateObjects[id])
				
				BLSoldiersAtBridge = true
				
			end
		
		end

	end
	
end
