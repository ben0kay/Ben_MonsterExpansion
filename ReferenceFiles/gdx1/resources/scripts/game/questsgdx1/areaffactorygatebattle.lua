/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFFactoryGatebattle = {}



--
-- Rebel Base Actors and Ambient Stuff
--

local FactoryFightState = { NotFighting = 0, Fighting = 1 }

local FactoryDoorFight01 = false
local FactoryDoorFight02 = false
local MeleeFighter01Id = 0
local MeleeFighter02Id = 0
local MeleeFighter03Id = 0
local Ranger01Id = 0

local AetherialAttack01Id = 0
local AetherialAttack02Id = 0

--
-- Proxy spawns for the battle
--

--Left side attack.
local AetherialAttack01StateObjects = orderedTable();
	AetherialAttack01StateObjects["AREAF_FACTORY_FIGHTING"] = { state = FactoryFightState.Fighting, dbr = "records/proxies/boss&questgdx1/proxy_areaf_factorygate_horde01.dbr" }
	AetherialAttack01StateObjects[""] = { state = FactoryFightState.NotFighting, dbr = nil }
	
local function Attack01CharacterCreateArgs()

	return Entity.Get(AetherialAttack01Id):GetCoords().origin
	
end

function gd.quests.areaFFactoryGatebattle.aetherialAttack01OnAddToWorld(objectId)

	if Server then
	
		if (not FactoryDoorFight01) then
			
			AetherialAttack01Id = objectId
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, AetherialAttack01StateObjects, Proxy, Attack01CharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == FactoryFightState.Fighting) then
				FactoryDoorFight01 = true
			end
			
		end
		
	end
	
end

function gd.quests.areaFFactoryGatebattle.aetherialAttack01FollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_AetherialFactory01")
	
	end

end

gd.quests.areaFFactoryGatebattle.aetherialAttack01OnDestroy = ClearObjectUserdata

--Right side attack.
local AetherialAttack02StateObjects = orderedTable();
	AetherialAttack02StateObjects["AREAF_FACTORY_FIGHTING"] = { state = FactoryFightState.Fighting, dbr = "records/proxies/boss&questgdx1/proxy_areaf_factorygate_horde01.dbr" }
	AetherialAttack02StateObjects[""] = { state = FactoryFightState.NotFighting, dbr = nil }
	
local function Attack02CharacterCreateArgs()

	return Entity.Get(AetherialAttack02Id):GetCoords().origin
	
end

function gd.quests.areaFFactoryGatebattle.aetherialAttack02OnAddToWorld(objectId)

	if Server then
	
		if (not FactoryDoorFight02) then
			
			AetherialAttack02Id = objectId
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, AetherialAttack02StateObjects, Proxy, Attack02CharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == FactoryFightState.Fighting) then
				FactoryDoorFight02 = true
			end
			
		end
		
	end
	
end

function gd.quests.areaFFactoryGatebattle.aetherialAttack02FollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_AetherialFactory02")
	
	end

end

gd.quests.areaFFactoryGatebattle.aetherialAttack02OnDestroy = ClearObjectUserdata

--
--  Rebels for the factory gate battle.
--
local function RebelCharacterCreateArgs()

	local maxLevel = 0
	local playerLevel = Game.GetAveragePlayerLevel()

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 120
	end
	
	if (playerLevel < maxLevel) then
		if playerLevel < 45 then
			maxLevel = 45
			
		else
			maxLevel = 0
		
		end
		
	end

	return maxLevel, nil
	
end

-- Rebel melee 01
local RebelMelee01StateObjects = orderedTable();
	RebelMelee01StateObjects["AREAF_FACTORY_FIGHTING"] = { state = FactoryFightState.Fighting, dbr = "records/creatures/enemies/faction/malmouth_script_melee_b01.dbr" }
	RebelMelee01StateObjects[""] = { state = FactoryFightState.NotFighting, dbr = nil }
	
function gd.quests.areaFFactoryGatebattle.rebelMelee01OnAddToWorld(objectId)

	if Server then
		
		MeleeFighter01Id = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelMelee01StateObjects, Character, RebelCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);

		
	end
	
end

gd.quests.areaFFactoryGatebattle.rebelMelee01OnDestroy = ClearObjectUserdata

-- Rebel melee 02
local RebelMelee02StateObjects = orderedTable();
	RebelMelee02StateObjects["AREAF_FACTORY_FIGHTING"] = { state = FactoryFightState.Fighting, dbr = "records/creatures/enemies/faction/malmouth_script_meleef_a01.dbr" }
	RebelMelee02StateObjects[""] = { state = FactoryFightState.NotFighting, dbr = nil }
	
function gd.quests.areaFFactoryGatebattle.rebelMelee02OnAddToWorld(objectId)

	if Server then

		MeleeFighter02Id = objectId;

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelMelee02StateObjects, Character, RebelCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
		
	
	end
	
end

gd.quests.areaFFactoryGatebattle.rebelMelee02OnDestroy = ClearObjectUserdata

-- Rebel melee 03
local RebelMelee03StateObjects = orderedTable();
	RebelMelee03StateObjects["AREAF_FACTORY_FIGHTING"] = { state = FactoryFightState.Fighting, dbr = "records/creatures/enemies/faction/malmouth_script_melee_a01.dbr" }
	RebelMelee03StateObjects[""] = { state = FactoryFightState.NotFighting, dbr = nil }
	
function gd.quests.areaFFactoryGatebattle.rebelMelee03OnAddToWorld(objectId)

	if Server then

		MeleeFighter03Id = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelMelee03StateObjects, Character, RebelCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFFactoryGatebattle.rebelMelee03OnDestroy = ClearObjectUserdata

-- Rebel Base Fight Ranger 01
local RebelRanger01StateObjects = orderedTable();
	RebelRanger01StateObjects["AREAF_FACTORY_FIGHTING"] = { state = FactoryFightState.Fighting, dbr = "records/creatures/enemies/faction/malmouth_script_casterf_b01.dbr" }
	RebelRanger01StateObjects[""] = { state = FactoryFightState.NotFighting, dbr = nil }
	
function gd.quests.areaFFactoryGatebattle.rebelRanger01OnAddToWorld(objectId)

	if Server then

		Ranger01Id = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelRanger01StateObjects, Character, RebelCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFFactoryGatebattle.rebelRanger01OnDestroy = ClearObjectUserdata

-- Activated by quest, the player destroys all 3 factory vents
local factoryFightTransition = false

function gd.quests.areaFFactoryGatebattle.factoryGateTransition()

	if Server && not factoryFightTransition then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAF_FACTORY_FIGHTING")) then
			factoryFightTransition = true
			
			--melee 01
			local MeleeFighter01 = Entity.Get(MeleeFighter01Id)
			
			if (MeleeFighter01 != nil) then
			
				local coords = MeleeFighter01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(MeleeFighter01Id, RebelMelee01StateObjects, Character, RebelCharacterCreateArgs)
			
			end
			
			--melee 02
			local MeleeFighter02 = Entity.Get(MeleeFighter02Id)
			
			if (MeleeFighter02 != nil) then
			
				local coords = MeleeFighter02:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(MeleeFighter02Id, RebelMelee02StateObjects, Character, RebelCharacterCreateArgs)
			
			end
			
			--melee 03
			local MeleeFighter03 = Entity.Get(MeleeFighter02Id)
			
			if (MeleeFighter03 != nil) then
			
				local coords = MeleeFighter03:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(MeleeFighter03Id, RebelMelee03StateObjects, Character, RebelCharacterCreateArgs)
			
			end
			
			--Ranged 01
			local Ranger01 = Entity.Get(Ranger01Id)
			
			if (Ranger01 != nil) then
			
				local coords = Ranger01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(Ranger01Id, RebelRanger01StateObjects, Character, RebelCharacterCreateArgs)	
			
			end
		
		 	local Attack01 = Entity.Get(AetherialAttack01Id)
			
			if (Attack01 != nil) then
				UpdateObjectSwap(AetherialAttack01Id, AetherialAttack01StateObjects, Proxy, Attack01CharacterCreateArgs)
				FactoryDoorFight01 = true
			
			end	

			local Attack02 = Entity.Get(AetherialAttack02Id)
			
			if (Attack02 != nil) then
				UpdateObjectSwap(AetherialAttack02Id, AetherialAttack02StateObjects, Proxy, Attack02CharacterCreateArgs)
				FactoryDoorFight02 = true
				
			end
		
		end
		
	end
	
end
