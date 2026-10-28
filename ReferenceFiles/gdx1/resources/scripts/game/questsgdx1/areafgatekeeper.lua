/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFGatekeeper = {}

local bossId = 0
local KeeperSpawned = false

local GatekeeperStates = {AtGate = 0, InSlums = 1}


local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(bossId):GetCoords().origin

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 200
	end
	
	if (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+3)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+3)

	end
	
	if monsterLevel > maxLevel then
		originPoint = nil
	
	end

	return monsterLevel, originPoint
	
end

-- Gatekeeper at the gate
local KeeperAtGatesStateObjects = orderedTable();
	KeeperAtGatesStateObjects["AREAF_MALMOUTHBRIDGELOWERED"] = { state = GatekeeperStates.InSlums,  dbr = nil }
	KeeperAtGatesStateObjects[""] = { state = GatekeeperStates.AtGate, dbr = "records/creatures/enemies/boss&quest/aetherialcolossus_gatekeeper.dbr"}

function gd.quests.areaFGatekeeper.keeperAtGateOnAddToWorld(objectId)

	if Server && not KeeperSpawned then
		local player = Game.GetLocalPlayer()
		
		if not player:HasToken("AREAF_MALMOUTHBRIDGELOWERED") then
			bossId = objectId
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, KeeperAtGatesStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			KeeperSpawned = true
		
		end
		
	end
	
end

gd.quests.areaFGatekeeper.keeperAtGateOnDestroy = ClearObjectUserdata


-- Gatekeeper in the slums
local KeeperInSlumsStateObjects = orderedTable();
	KeeperInSlumsStateObjects["AREAF_MALMOUTHBRIDGELOWERED"] = { state = GatekeeperStates.InSlums,  dbr = "records/creatures/enemies/boss&quest/aetherialcolossus_gatekeeper.dbr"}
	KeeperInSlumsStateObjects[""] = { state = GatekeeperStates.AtGate, dbr = nil}	

function gd.quests.areaFGatekeeper.keeperSlumsOnAddToWorld(objectId)

	if Server && not KeeperSpawned then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_MALMOUTHBRIDGELOWERED") then
			bossId = objectId
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, KeeperInSlumsStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			KeeperSpawned = true
		
		end
		
	end
	
end

gd.quests.areaFGatekeeper.keeperSlumsOnDestroy = ClearObjectUserdata



