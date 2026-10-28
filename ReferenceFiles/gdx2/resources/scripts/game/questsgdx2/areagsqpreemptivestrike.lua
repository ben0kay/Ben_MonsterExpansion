/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGSQPreemptiveStrike = {}

--
-- SQ 05 - The player must destroy all 3 conduits before he can enter the underground and kill the boss
--


-- Boss Setup
local bossId = 0
local BossSpawned = false

function gd.quests.areaGSQPreemptiveStrike.bossKill()

	GiveTokenToLocalPlayer("AREAG_PREEMPTIVESTRIKEBOSS_KILLED")
	
end

local BossState = {Default = 0, Spawned = 1}

local BossStateObjects = orderedTable();
	BossStateObjects["AREAG_CONDUITS_ALLDESTROYED"] = { state = BossState.Spawned,  dbr = "records/creatures/enemies/boss&quest/eldritchscorpion_preemptivestrike_01.dbr" }
	BossStateObjects[""] = { state = BossState.Default, dbr = nil }

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
	
function gd.quests.areaGSQPreemptiveStrike.bossOnAddToWorld(objectId)

	if Server && not BossSpawned then
		bossId = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BossStateObjects, Character, CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as hostile
		if (newState == BossState.Spawned) then
			BossSpawned = true
		end
		
	end
	
end

gd.quests.areaGSQPreemptiveStrike.bossOnDestroy = ClearObjectUserdata

-- Boss transition after the player destroys all 3 conduits
local bossTransition = false

function gd.quests.areaGSQPreemptiveStrike.spawnBoss()
	if Server && not BossSpawned && not bossTransition then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_CONDUITS_ALLDESTROYED") then
			bossTransition = true
			
			local boss = Entity.Get(bossId)
			
			if (boss != nil) then
				local coords = boss:GetCoords()	
				local riftEnd = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(bossId, BossStateObjects, Character, CharacterCreateArgs)
				
				BossSpawned = true
			
			end
			
		end
		
	end

end


function gd.quests.areaGSQPreemptiveStrike.conduit01OnBreak()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAG_CONDUITS_ALLDESTROYED")) then
		player:GiveToken("AREAG_CONDUIT01_DESTROYED")
		
		if (player:HasToken("AREAG_CONDUIT01_DESTROYED") && player:HasToken("AREAG_CONDUIT02_DESTROYED") && player:HasToken("AREAG_CONDUIT03_DESTROYED")) then
			
			player:GiveToken("AREAG_CONDUITS_ALLDESTROYED")
			
			if Server then
				gd.quests.areaGSQPreemptiveStrike.spawnBoss()

			end
			
		end
		
	end
	
end

function gd.quests.areaGSQPreemptiveStrike.conduit02OnBreak()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAG_CONDUITS_ALLDESTROYED")) then
		player:GiveToken("AREAG_CONDUIT02_DESTROYED")
		
		if (player:HasToken("AREAG_CONDUIT01_DESTROYED") && player:HasToken("AREAG_CONDUIT02_DESTROYED") && player:HasToken("AREAG_CONDUIT03_DESTROYED")) then
			player:GiveToken("AREAG_CONDUITS_ALLDESTROYED")
			
			if Server then
				gd.quests.areaGSQPreemptiveStrike.spawnBoss()

			end
			
		end
		
	end
	
end

function gd.quests.areaGSQPreemptiveStrike.conduit03OnBreak()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAG_CONDUITS_ALLDESTROYED")) then
		player:GiveToken("AREAG_CONDUIT03_DESTROYED")
		
		if (player:HasToken("AREAG_CONDUIT01_DESTROYED") && player:HasToken("AREAG_CONDUIT02_DESTROYED") && player:HasToken("AREAG_CONDUIT03_DESTROYED")) then
			player:GiveToken("AREAG_CONDUITS_ALLDESTROYED")
			
			if Server then
				gd.quests.areaGSQPreemptiveStrike.spawnBoss()

			end
			
		end
		
	end
	
end

-- conduit setup

local conduit01Id = 0
local conduit02Id = 0
local conduit03Id = 0
local conduit01Spawned = false
local conduit02Spawned = false
local conduit03Spawned = false
local bossTransition = false

local ConduitState = { Spawned = 0, OneDestroyed = 1, AllDestroyed = 2}

--Conduit 01
local conduit01StateObjects = orderedTable();
	conduit01StateObjects["AREAG_CONDUITS_ALLDESTROYED"] = { state = ConduitState.AllDestroyed,  dbr = nil }
	conduit01StateObjects["AREAG_CONDUIT01_DESTROYED"] = { state = ConduitState.OneDestroyed,  dbr = nil }
	conduit01StateObjects[""]= { state = ConduitState.Spawned, dbr = "records/storyelementsgdx2/questassets/areag_conduit01_break.dbr" }

function gd.quests.areaGSQPreemptiveStrike.conduit01OnAddToWorld(objectId)
	
	if Server then
		if (not conduit01Spawned) then
			conduit01Spawned = true
			conduit01Id = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, conduit01StateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaGSQPreemptiveStrike.conduit01OnDestroy = ClearObjectUserdata

--Conduit 02
local conduit02StateObjects = orderedTable();
	conduit02StateObjects["AREAG_CONDUITS_ALLDESTROYED"] = { state = ConduitState.AllDestroyed,  dbr = nil }
	conduit02StateObjects["AREAG_CONDUIT02_DESTROYED"] = { state = ConduitState.OneDestroyed,  dbr = nil }
	conduit02StateObjects[""]= { state = ConduitState.Spawned, dbr = "records/storyelementsgdx2/questassets/areag_conduit02_break.dbr" }

function gd.quests.areaGSQPreemptiveStrike.conduit02OnAddToWorld(objectId)
	
	if Server then
		if (not conduit02Spawned) then
			conduit02Spawned = true
			conduit02Id = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, conduit02StateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaGSQPreemptiveStrike.conduit02OnDestroy = ClearObjectUserdata

--Conduit 03
local conduit03StateObjects = orderedTable();
	conduit03StateObjects["AREAG_CONDUITS_ALLDESTROYED"] = { state = ConduitState.AllDestroyed,  dbr = nil }
	conduit03StateObjects["AREAG_CONDUIT03_DESTROYED"] = { state = ConduitState.OneDestroyed,  dbr = nil }
	conduit03StateObjects[""]= { state = ConduitState.Spawned, dbr = "records/storyelementsgdx2/questassets/areag_conduit03_break.dbr" }

function gd.quests.areaGSQPreemptiveStrike.conduit03OnAddToWorld(objectId)
	
	if Server then
		if (not conduit03Spawned) then
			conduit03Spawned = true
			conduit03Id = objectId
			
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, conduit03StateObjects);
			Shared.setUserdata(objectId, userdata);
		
		end
	
	end
	
end

gd.quests.areaGSQPreemptiveStrike.conduit03OnDestroy = ClearObjectUserdata



