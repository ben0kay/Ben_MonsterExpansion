/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.endlessDungeon.specialFloors = {}


--
-- Arkovian Prison Level
--
local doorsUnlocked = false
local door01Id = 0
local door02Id = 0
local leverIds = { 0, 0, 0, 0, 0 }
local leversTriggered = { false, false, false, false, false }
local leverCounter = 0
local bossDBR = nil

local monsterSpawnerIds = { 0, 0, 0, 0, 0, 0 }
local monsterSpawnerCoords = { nil, nil, nil, nil, nil, nil }

-- Monster Spawners
function gd.endlessDungeon.specialFloors.spawner01OnAddToWorld(objectId)
	
	if Server then
		 monsterSpawnerIds[1] = objectId
		 monsterSpawnerCoords[1] = Entity.Get(objectId):GetCoords()
	
	end
	
end

function gd.endlessDungeon.specialFloors.spawner02OnAddToWorld(objectId)
	
	if Server then
		 monsterSpawnerIds[2] = objectId
		 monsterSpawnerCoords[2] = Entity.Get(objectId):GetCoords()
	
	end
	
end

function gd.endlessDungeon.specialFloors.spawner03OnAddToWorld(objectId)
	
	if Server then
		 monsterSpawnerIds[3] = objectId
		 monsterSpawnerCoords[3] = Entity.Get(objectId):GetCoords()
	
	end
	
end

function gd.endlessDungeon.specialFloors.spawner04OnAddToWorld(objectId)
	
	if Server then
		 monsterSpawnerIds[4] = objectId
		 monsterSpawnerCoords[4] = Entity.Get(objectId):GetCoords()
	
	end
	
end

function gd.endlessDungeon.specialFloors.spawner05OnAddToWorld(objectId)
	
	if Server then
		 monsterSpawnerIds[5] = objectId
		 monsterSpawnerCoords[5] = Entity.Get(objectId):GetCoords()
	
	end
	
end

function gd.endlessDungeon.specialFloors.bossSpawnerOnAddToWorld(objectId)
	
	if Server then
		 monsterSpawnerIds[6] = objectId
		 monsterSpawnerCoords[6] = Entity.Get(objectId):GetCoords()
	
	end
	
end

-- Door Control
function gd.endlessDungeon.specialFloors.doorInitialUpdate(objectId)
	
	if Server && doorsUnlocked then
		local door = Door.Get(objectId)
		door:Open()
	
	end
	
end

function gd.endlessDungeon.specialFloors.door01OnAddToWorld(objectId)
	
	if Server then
		door01Id = objectId
	
	end
	
end

function gd.endlessDungeon.specialFloors.door02OnAddToWorld(objectId)
	
	if Server then
		door02Id = objectId
	
	end
	
end

local function openDoors()
	if Server && doorsUnlocked then
		local door01 = Door.Get(door01Id)
		door01:Open()
		
		local door02 = Door.Get(door02Id)
		door02:Open()
		
		UI.Notify("tagGDX2Notification_ArkovianPrison_01")
		
	end
	
end

-- Lever Control
local function destroyLevers()

	if Server then
		local totalLevers = table.getn(leverIds)
			
		for id = 1, totalLevers do
			if leverIds[id] != 0 then
				local lever = Destructible.Get(leverIds[id])
				lever:Destroy(Vec(0,1,0), 10, false)
				leverIds[id] = 0
				
			end
		
		end
		
	end

end

local function leverCheck(leverId)

	if Server && not doorsUnlocked then
	
		if not leversTriggered[leverId] then
			leversTriggered[leverId] = true
			leverCounter = leverCounter + 1
			
			if leverCounter >= 3 then
				doorsUnlocked = true
				
				if leversTriggered[1] && leversTriggered[2] && leversTriggered[3] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_aetherialcommander_01.dbr"
				elseif leversTriggered[1] && leversTriggered[2] && leversTriggered[4] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_banditleader_darius.dbr"
				elseif leversTriggered[1] && leversTriggered[2] && leversTriggered[5] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_cultistdungeon_sectleader.dbr"
				elseif leversTriggered[1] && leversTriggered[3] && leversTriggered[4] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_aetherialcolossus_gatekeeper.dbr"
				elseif leversTriggered[1] && leversTriggered[3] && leversTriggered[5] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_aetherialfleshshaper_hinissius.dbr"
				elseif leversTriggered[2] && leversTriggered[3] && leversTriggered[4] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_witchgod_finalboss.dbr"
				elseif leversTriggered[2] && leversTriggered[3] && leversTriggered[5] then
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_theoutcast_03.dbr"
				else
					bossDBR = "records/endlessdungeon/creatures/enemies/special/boss_chthonianrylok_ekketzul.dbr"
				end
				
				openDoors()
				
				destroyLevers()
			
			end
			
		end
		
	end
	
end

-- Spawn Trigger
local monstersSpawned = false

local function BossCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0

	monsterLevel = ((averageLevel+(averageLevel/50))+3)

	return monsterLevel, nil
	
end

function gd.endlessDungeon.specialFloors.spawnMonsters()
	if Server && not monstersSpawned && doorsUnlocked then
		monstersSpawned = true
		
		-- spawn minions based on levers pulled		
		if leversTriggered[1] then
			local proxy = Proxy.Create("records/endlessdungeon/proxies/proxy_special/proxy_arkoviaprison_01.dbr", monsterSpawnerCoords[1].origin)
			proxy:SetCoords(monsterSpawnerCoords[1])
		end
		
		if leversTriggered[2] then
			local proxy = Proxy.Create("records/endlessdungeon/proxies/proxy_special/proxy_arkoviaprison_02.dbr", monsterSpawnerCoords[2].origin)
			proxy:SetCoords(monsterSpawnerCoords[2])
		end
		
		if leversTriggered[3] then
			local proxy = Proxy.Create("records/endlessdungeon/proxies/proxy_special/proxy_arkoviaprison_03.dbr", monsterSpawnerCoords[3].origin)
			proxy:SetCoords(monsterSpawnerCoords[3])
		end
		
		if leversTriggered[4] then
			local proxy = Proxy.Create("records/endlessdungeon/proxies/proxy_special/proxy_arkoviaprison_04.dbr", monsterSpawnerCoords[4].origin)
			proxy:SetCoords(monsterSpawnerCoords[4])
		end
		
		if leversTriggered[5] then
			local proxy = Proxy.Create("records/endlessdungeon/proxies/proxy_special/proxy_arkoviaprison_05.dbr", monsterSpawnerCoords[5].origin)
			proxy:SetCoords(monsterSpawnerCoords[5])
		end
		
		-- spawn Boss based on levers pulled
		 local boss = Character.Create (bossDBR, BossCreateArgs())
		 boss:SetCoords(monsterSpawnerCoords[6])
		 
	end
	
end

function gd.endlessDungeon.specialFloors.triggerMonsterSpawns()
	
	QuestEvent("endlessDungeonSpecialArkovianPrisonSpawn")

end

-- Red Lever
function gd.endlessDungeon.specialFloors.lever01OnAddToWorld(objectId)
	
	if Server then
		leverIds[1] = objectId
	
	end
	
end

function gd.endlessDungeon.specialFloors.lever01Destroyed()

	if Server && not doorsUnlocked then
		 leverCheck(1)
		 
	end
	
end

-- Green Lever
function gd.endlessDungeon.specialFloors.lever02OnAddToWorld(objectId)
	
	if Server then
		leverIds[2] = objectId
	
	end
	
end

function gd.endlessDungeon.specialFloors.lever02Destroyed()

	if Server && not doorsUnlocked then
		leverCheck(2)
		 
	end
	
end

-- Blue Lever
function gd.endlessDungeon.specialFloors.lever03OnAddToWorld(objectId)
	
	if Server then
		leverIds[3] = objectId
	
	end
	
end

function gd.endlessDungeon.specialFloors.lever03Destroyed()

	if Server && not doorsUnlocked then
		 leverCheck(3)
		 
	end
	
end

-- Yellow Lever
function gd.endlessDungeon.specialFloors.lever04OnAddToWorld(objectId)
	
	if Server then
		leverIds[4] = objectId
	
	end
	
end

function gd.endlessDungeon.specialFloors.lever04Destroyed()

	if Server && not doorsUnlocked then
		 leverCheck(4)
		 
	end
	
end

-- Purple Lever
function gd.endlessDungeon.specialFloors.lever05OnAddToWorld(objectId)
	
	if Server then
		leverIds[5] = objectId
	
	end
	
end

function gd.endlessDungeon.specialFloors.lever05Destroyed()

	if Server && not doorsUnlocked then
		 leverCheck(5)
		 
	end
	
end


--
-- Sentry Level
--
local bossKilled = false
local bossSpawned = false

local eventSpawnerId = {0, 0, 0, 0}
local eventSpawnerCoords = {nil, nil, nil, nil}

local proxyInitialSpawn = false
local proxySpawn = {nil, nil, nil, nil}
local proxyActive = { true, true, true, true }
local proxyDBR = "records/endlessdungeon/proxies/proxy_special/proxy_sentry_01.dbr"

local waveTimer = { 0, 0, 0, 0 }
local waveChance = { 50, 50, 50, 50 }
local waveFrequency = 40
local waveCooldown = 28

local function endAddSpawnEvent(objectId)
	Script.UnregisterForUpdate(objectId, "gd.endlessDungeon.specialFloors.updateStatus")

end

-- Wave Event for Boss
-- Spawners
function gd.endlessDungeon.specialFloors.sentrySpawner01OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[1] = objectId
		eventSpawnerCoords[1] = Entity.Get(objectId):GetCoords()
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			waveFrequency = 48
			waveCooldown = 30
			proxyActive[3] = false
			proxyActive[4] = false
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			waveFrequency = 35
			waveCooldown = 24
		else
			waveFrequency = 22
			waveCooldown = 16
		end

		Shared.setUserdata(objectId, userdata)
		Script.RegisterForUpdate(objectId, "gd.endlessDungeon.specialFloors.updateStatus", 1000)
		
	end

end

function gd.endlessDungeon.specialFloors.sentrySpawner02OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[2] = objectId
		eventSpawnerCoords[2] = Entity.Get(objectId):GetCoords()
		
	end

end

function gd.endlessDungeon.specialFloors.sentrySpawner03OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[3] = objectId
		eventSpawnerCoords[3] = Entity.Get(objectId):GetCoords()
		
	end

end

function gd.endlessDungeon.specialFloors.sentrySpawner04OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[4] = objectId
		eventSpawnerCoords[4] = Entity.Get(objectId):GetCoords()
		
	end

end

function gd.endlessDungeon.specialFloors.bossEventOnRemoveFromWorld(objectId)

	if Server then
		Shared.setUserdata(objectId, nil)
		Script.UnregisterForUpdate(objectId, "gd.endlessDungeon.specialFloors.updateStatus")

	end
	
end

-- Dispense Spawns
local function SpawnProxy(proxyID)
		local totalSpawns = table.getn(proxyActive)
		
		local entity = Entity.Get(eventSpawnerId[proxyID])
		
		if entity != nil && proxyID <= totalSpawns && proxyActive[proxyID] then
			proxySpawn[proxyID] = Proxy.Create(proxyDBR, eventSpawnerCoords[proxyID].origin)
			proxySpawn[proxyID]:SetCoords(eventSpawnerCoords[proxyID])
			proxySpawn[proxyID]:LinkPatrolPointGroup("zEG_PatrolPoint_Sentry")
			
		end
		
end

-- increment timer every event update if spawns are dead, increment chance if timer is less than max timer
local function incrementTimer(timerID)
	local totalSpawns = table.getn(waveTimer)
	
	if timerID <= totalSpawns then
		waveTimer[timerID] = waveTimer[timerID] + 1

		-- if timer surpasses maximum time between waves, increase chance to 100%
		if waveTimer[timerID] >= waveFrequency then
			waveChance[timerID] = 100
		
		end
		
		-- if timer surpasses minimum cooldown between spawns, increase the chance to spawn
		if waveTimer[timerID] >= waveCooldown then		
			if waveChance[timerID] < 100 then
				waveChance[timerID] = waveChance[timerID] + 4
				
				if waveChance[timerID] > 100 then
					waveChance[timerID] = 100
				end

			end
		
		end
	
	end

end

function gd.endlessDungeon.specialFloors.updateStatus(objectId)
	if Server then
		if bossSpawned then
			if not bossKilled then
				local totalSpawns = table.getn(proxyActive)
				
				if not proxyInitialSpawn then
					-- spawn initial proxies, based on proxy 1's timer
					-- increment the timer and chance to spawn
					print "TIMER GOING OFF"
					incrementTimer(1)					

					-- if timer has surpassed the minimum cooldown between spawns, try to spawn proxies
					if waveTimer[1] >= waveCooldown then
						math.randomseed(Time.Now())
						local randomizer = random(1,100)
					
						if randomizer <= waveChance[1] then
							for id = 1, totalSpawns do
								proxyInitialSpawn = true
								SpawnProxy(id)
								
								waveChance[id] = 20
								waveTimer[id] = 0
								
							end
						
						end
					
					end
				
				else
					for id = 1, totalSpawns do
						if proxySpawn[id] != nil && proxyActive[id] then
							if proxySpawn[id]:AllKilled() then
								print "PROXY TIMER GOING OFF"
								-- increment the timer and chance to spawn
								incrementTimer(id)
								
								-- if timer has surpassed the minimum cooldown between spawns, try to spawn proxy
								if waveTimer[id] >= waveCooldown then
									math.randomseed(Time.Now())
									local randomizer = random(1,100)
								
									if randomizer <= waveChance[id] then
										SpawnProxy(id)
										waveChance[id] = 15
										waveTimer[id] = 0
									
									end
								
								end
							
							end
						
						end
						
					end
					
				end
			
			else
				endAddSpawnEvent(objectId)
				
			end
		
		end
	
	end

end

function gd.endlessDungeon.specialFloors.sentryBossOnAddToWorld(objectId)
	
	if Server then
		-- Starts the spawning of adds
		bossSpawned = true
		
	end

end

function gd.endlessDungeon.specialFloors.sentryBossKilled()
	if Server then
		bossKilled = true
	
	end
	
end


--
-- Treasure Traps
--
local treasureTrapProxies = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil }
local treasureTrapCoords = { nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil }
local treasureTrapOpened = { false, false, false, false, false, false, false, false, false, false, false }
local treasureTrapProxyDBRs = { "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_01.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_02.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_03.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_04.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_05.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_06.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_07.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_08.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_09.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_10.dbr", "records/endlessdungeon/proxies/proxy_special/proxy_treasuretrap_11.dbr" }
local treasureTrapCheck = false
local treasureTrapFinished = false
local treasureTrapSoulCoords = nil
local trapChestsTriggered = 0

function gd.endlessDungeon.specialFloors.treasureTrapSoulSpawnOnAddToWorld(objectId)

	treasureTrapSoulCoords = Entity.Get(objectId):GetCoords()
	
end

function gd.endlessDungeon.specialFloors.isTreasureTrapClearedMP()
	
	if Server then
		if treasureTrapCheck && not treasureTrapFinished then
			local totalProxies = table.getn(treasureTrapProxyDBRs)
			local proxiesClearedTest = true
			
			for id = 1, totalProxies do
				if treasureTrapProxies[id] != nil then
					if not treasureTrapProxies[id]:AllKilled() then
						proxiesClearedTest = false
						print "treasure trap proxy failed"
					end
				
				end
			
			end
			
			if proxiesClearedTest then
				treasureTrapFinished = true
				
				-- spawn soul drop to clear floor
				local soulDrop = Entity.Create ("records/endlessdungeon/items/endlessdungeon_essence_special.dbr")
				soulDrop:SetCoords(treasureTrapSoulCoords)
				
				UI.Notify("tagGDX2Notification_TreasureTrap_01")
			
			end
		
		end
		
	end
	
end

function gd.endlessDungeon.specialFloors.isTreasureTrapCleared(triggererId)

	-- have host check if treasure trap room is cleared
	QuestEvent("endlessDungeonSpecialTreasureTrapTrigger")
	
end

local function spawnTreasureTrap(treasureID)
	if Server && not treasureTrapOpened[treasureID] && not treasureTrapFinished then
		treasureTrapOpened[treasureID] = true
		
		trapChestsTriggered = trapChestsTriggered + 1
		
		if trapChestsTriggered >= 7 then
			treasureTrapCheck = true
		
		end
		
		local fx = Entity.Create("records/fx/skillsothergdx1/attackradius/ghostnova_blue_radius_fxpak01.dbr")
		
		if (fx != nil) then
			fx:NetworkEnable()
			fx:SetCoords(treasureTrapCoords[treasureID])
		end	

		treasureTrapProxies[treasureID] = Proxy.Create(treasureTrapProxyDBRs[treasureID], treasureTrapCoords[treasureID].origin)
		treasureTrapProxies[treasureID]:SetCoords(treasureTrapCoords[treasureID])
		
	end

end

function gd.endlessDungeon.specialFloors.treasureTrap01OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[1] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap01OpenMP()
	
	if Server && not treasureTrapOpened[1] && not treasureTrapFinished then
		spawnTreasureTrap(1)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap01Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap01")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap02OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[2] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap02OpenMP()
	
	if Server && not treasureTrapOpened[2] && not treasureTrapFinished then
		spawnTreasureTrap(2)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap02Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap02")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap03OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[3] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap03OpenMP()
	
	if Server && not treasureTrapOpened[3] && not treasureTrapFinished then
		spawnTreasureTrap(3)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap03Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap03")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap04OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[4] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap04OpenMP()
	
	if Server && not treasureTrapOpened[4] && not treasureTrapFinished then
		spawnTreasureTrap(4)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap04Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap04")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap05OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[5] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap05OpenMP()
	
	if Server && not treasureTrapOpened[5] && not treasureTrapFinished then
		spawnTreasureTrap(5)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap05Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap05")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap06OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[6] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap06OpenMP()
	
	if Server && not treasureTrapOpened[6] && not treasureTrapFinished then
		spawnTreasureTrap(6)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap06Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap06")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap07OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[7] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap07OpenMP()
	
	if Server && not treasureTrapOpened[7] && not treasureTrapFinished then
		spawnTreasureTrap(7)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap07Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap07")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap08OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[8] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap08OpenMP()
	
	if Server && not treasureTrapOpened[8] && not treasureTrapFinished then
		spawnTreasureTrap(8)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap08Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap08")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap09OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[9] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap09OpenMP()
	
	if Server && not treasureTrapOpened[9] && not treasureTrapFinished then
		spawnTreasureTrap(9)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap09Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap09")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap10OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[10] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap10OpenMP()
	
	if Server && not treasureTrapOpened[10] && not treasureTrapFinished then
		spawnTreasureTrap(10)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap10Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap10")
	
end

function gd.endlessDungeon.specialFloors.treasureTrap11OnAddToWorld(objectId)

	if Server then
		local entity = Entity.Get(objectId)
		treasureTrapCoords[11] = entity:GetCoords()
		
	end
	
end

function gd.endlessDungeon.specialFloors.treasureTrap11OpenMP()
	
	if Server && not treasureTrapOpened[11] && not treasureTrapFinished then
		spawnTreasureTrap(11)

	end

end

function gd.endlessDungeon.specialFloors.treasureTrap11Opened()

	QuestEvent("endlessDungeonSpecialTreasureTrap11")
	
end


--
-- Loghorrean
--
local loghorreanBossesEntity = { nil, nil, nil}
local logghoreanFinished = false
local loghorreanSoulCoords = nil

function gd.endlessDungeon.specialFloors.isLoghorreanClearedMP()
	
	if Server && not logghoreanFinished then
		if loghorreanBossesEntity[1] != nil && loghorreanBossesEntity[2] != nil && loghorreanBossesEntity[3] != nil then
			if Character.IsAlive(loghorreanBossesEntity[1]) == false && Character.IsAlive(loghorreanBossesEntity[2]) == false && Character.IsAlive(loghorreanBossesEntity[3]) == false then
				logghoreanFinished = true
				
				-- spawn soul drop to clear floor
				local soulDrop = Entity.Create ("records/endlessdungeon/items/endlessdungeon_essence_special.dbr")
				soulDrop:SetCoords(loghorreanSoulCoords)
			
			end
		
		end
	
	end

end

function gd.endlessDungeon.specialFloors.isLoghorreanCleared(triggererId)

	-- have host check if logghorean room is cleared
	QuestEvent("endlessDungeonSpecialLogghoreanPlayerTrigger")
	
end


function gd.endlessDungeon.specialFloors.loghorreanSoulSpawnOnAddToWorld(objectId)
	
	if Server then
		loghorreanSoulCoords = Entity.Get(objectId):GetCoords()
	end
	
end

function gd.endlessDungeon.specialFloors.loghorreanBoss01Check(triggererId)
	
	if Server then
		loghorreanBossesEntity[1] = Character.Get(triggererId)
		
	end
	
end

function gd.endlessDungeon.specialFloors.loghorreanBoss02Check(triggererId)
	
	if Server then
		loghorreanBossesEntity[2] = Character.Get(triggererId)
		
	end
	
end

function gd.endlessDungeon.specialFloors.loghorreanBoss03Check(triggererId)
	
	if Server then
		loghorreanBossesEntity[3] = Character.Get(triggererId)
		
	end
	
end


