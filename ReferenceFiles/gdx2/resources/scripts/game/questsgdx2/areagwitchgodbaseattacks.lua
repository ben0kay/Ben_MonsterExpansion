/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGWitchGodBaseAttacks = {}



--
-- Attacks on Witch God Bases
--
local DoorState = { GateLocked = 0, GateUnlocked = 1 }

-- Proxy spawns for Witch God Base Attacks after gate is unlocked
local Attack01Spawned = false
local GateAttack01Id = 0

local GateAttack01StateObjects = orderedTable();
	GateAttack01StateObjects["AREAG_COVENBASE_UNLOCKED"] = { state = DoorState.GateUnlocked, dbr = "records/proxies/boss&questgdx2/proxy_areag_witchgodbase_attack_01.dbr" }
	GateAttack01StateObjects[""] = { state = DoorState.GateLocked, dbr = nil }
	
local function Attack01CharacterCreateArgs()

	return Entity.Get(GateAttack01Id):GetCoords().origin
	
end

function gd.quests.areaGWitchGodBaseAttacks.gateAttack01OnAddToWorld(objectId)

	if Server then
	
		if (not Attack01Spawned) then
			Attack01Spawned = true
			
			GateAttack01Id = objectId
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, GateAttack01StateObjects, Proxy, Attack01CharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
		end
		
	end
	
end

function gd.quests.areaGWitchGodBaseAttacks.gateAttack01FollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_WitchGodBaseAttack01")
	
	end

end

gd.quests.areaGWitchGodBaseAttacks.gateAttacksOnDestroy = ClearObjectUserdata


-- Proxy spawns for Witch God Forward Camp Attacks after gate is unlocked
local Attack02Spawned = false
local Attack03Spawned = false
local GateAttack02Id = 0
local GateAttack03Id = 0

local GateAttack02StateObjects = orderedTable();
	GateAttack02StateObjects["AREAG_FORWARDCAMP_KORVAAKUNLOCKED"] = { state = DoorState.GateUnlocked, dbr = "records/proxies/boss&questgdx2/proxy_areag_witchgodforwardcamp_attack_01.dbr" }
	GateAttack02StateObjects[""] = { state = DoorState.GateLocked, dbr = nil }
	
local function Attack02CharacterCreateArgs()

	return Entity.Get(GateAttack02Id):GetCoords().origin
	
end

function gd.quests.areaGWitchGodBaseAttacks.gateAttack02OnAddToWorld(objectId)

	if Server then
	
		if (not Attack02Spawned) then
			Attack02Spawned = true
			
			GateAttack02Id = objectId
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, GateAttack02StateObjects, Proxy, Attack02CharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
		end
		
	end
	
end

function gd.quests.areaGWitchGodBaseAttacks.gateAttack02FollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_WitchGodForwardCampAttack01")
	
	end

end

local GateAttack03StateObjects = orderedTable();
	GateAttack03StateObjects["AREAG_FORWARDCAMP_KORVAAKUNLOCKED"] = { state = DoorState.GateUnlocked, dbr = "records/proxies/boss&questgdx2/proxy_areag_witchgodforwardcamp_attack_02.dbr" }
	GateAttack03StateObjects[""] = { state = DoorState.GateLocked, dbr = nil }
	
local function Attack03CharacterCreateArgs()

	return Entity.Get(GateAttack03Id):GetCoords().origin
	
end

function gd.quests.areaGWitchGodBaseAttacks.gateAttack03OnAddToWorld(objectId)

	if Server then
	
		if (not Attack03Spawned) then
			Attack03Spawned = true
			
			GateAttack03Id = objectId
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, GateAttack03StateObjects, Proxy, Attack03CharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
		end
		
	end
	
end

function gd.quests.areaGWitchGodBaseAttacks.gateAttack03FollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_WitchGodForwardCampAttack02")
	
	end

end


