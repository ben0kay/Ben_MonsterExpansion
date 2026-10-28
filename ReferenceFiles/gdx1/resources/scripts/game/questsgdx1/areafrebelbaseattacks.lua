/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFRebelBaseAttacks = {}



--
-- Rebel Base Actors and Ambient Stuff
--

local FactoryFightState = { PreBaseCap = 0, Attacking = 1 }

local RebelBaseAttack = false
local AetherialAttack01Id = 0

--
-- Proxy spawns for the battle
--

--Left side attack.
local AetherialAttack01StateObjects = orderedTable();
	AetherialAttack01StateObjects["AREAF_RETAKEINDUSTRIALDISTRICT"] = { state = FactoryFightState.Attacking, dbr = "records/proxies/boss&questgdx1/proxy_areaf_rebelbase_horde01.dbr" }
	AetherialAttack01StateObjects[""] = { state = FactoryFightState.PreBaseCap, dbr = nil }
	
local function Attack01CharacterCreateArgs()

	return Entity.Get(AetherialAttack01Id):GetCoords().origin
	
end

function gd.quests.areaFRebelBaseAttacks.aetherialAttack01OnAddToWorld(objectId)

	if Server then
	
		if (not RebelBaseAttack) then
			RebelBaseAttack = true
			
			AetherialAttack01Id = objectId
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, AetherialAttack01StateObjects, Proxy, Attack01CharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
		end
		
	end
	
end

function gd.quests.areaFRebelBaseAttacks.aetherialAttack01FollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_RebelBase01")
	
	end

end

gd.quests.areaFRebelBaseAttacks.aetherialAttack01OnDestroy = ClearObjectUserdata
