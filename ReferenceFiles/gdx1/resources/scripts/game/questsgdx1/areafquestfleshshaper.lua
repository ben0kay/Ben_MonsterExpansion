/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFFleshshaper = {}


--
-- The final boss of GDX1, additional spawns occur in all 3 phases, depending on difficulty
--
local bossKilled = false
local bossExitShortcutId = 0
local shortcutOpen = false

local bossChestId = 0
local lootChestId = 0
local lootChest02Id = 0

local phase02Spawned = false
local phase03Spawned = false

local eventSpawner01Id = 0
local eventSpawner02Id = 0
local eventSpawner01Coords = nil
local eventSpawner02Coords = nil

local proxyInitialSpawn = false
local proxySpawn01 = nil
local proxySpawn02 = nil
local proxyDBR = "records/proxies/boss&questgdx1/questproxy_waveevent_finalboss_01.dbr"

local heroSpawn01Id = 0
local heroSpawn02Id = 0
local heroSpawn01Dead = true
local heroSpawn02Dead = true
local heroSpawn01Dbrs = { "records/creatures/enemies/waveevents/finalboss_aetherialbloater_h01.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialbloater_h02.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialcolossus_h01.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialcolossus_h02.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialcorruption_h01.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialcorruption_h02.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialfleshshaper_h01.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialfleshshaper_h02.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialimp_h01.dbr", "records/creatures/enemies/waveevents/finalboss_aetherialimp_h02.dbr" }
local heroSpawn02Dbrs = { "records/creatures/enemies/waveevents/finalboss2_aetherialbloater_h01.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialbloater_h02.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialcolossus_h01.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialcolossus_h02.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialcorruption_h01.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialcorruption_h02.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialfleshshaper_h01.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialfleshshaper_h02.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialimp_h01.dbr", "records/creatures/enemies/waveevents/finalboss2_aetherialimp_h02.dbr" }

local waveTimer = 0
local waveFrequency = 0
local waveCooldown = 0
local waveChance = 80

local function endAddSpawnEvent(objectId)
	Script.UnregisterForUpdate(objectId, "gd.quests.areaFFleshshaper.updateStatus")
	
	local heroAdd01 = Character.Get(heroSpawn01Id)
	local heroAdd02 = Character.Get(heroSpawn02Id)
	
	if (heroAdd01 != nil) then
		heroAdd01:Kill()
		
	end
	
	if (heroAdd02 != nil) then
		heroAdd02:Kill()
		
	end

end

function gd.quests.areaFFleshshaper.bossPhase03Killed()
	
	GiveTokenToLocalPlayer("AREAF_SHAPEROFFLESH_KILLED")
	
	if Server then
		local chest = Chest.Get(bossChestId);
		local lootChest = Chest.Get(lootChestId);
		local lootChest02 = Chest.Get(lootChest02Id);
		local door = Door.Get(bossExitShortcutId)
		
		bossKilled = true
	
		-- Unlock chest if present
		if (chest ~= nil) then
			chest:SetLocked(false)
		end

		if (lootChest ~= nil) then
			lootChest:SetLocked(false)
		end
		
		if (lootChest02 ~= nil) then
			lootChest02:SetLocked(false)
		end
		
		-- Unlock Shortcut out
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			shortcutOpen = true
		end
	
	end
	
end


-- Wave Event for Boss, Runs for Phase 01 on Normal difficulty and through all Phases in Elite/Ultimate
-- Spawners
function gd.quests.areaFFleshshaper.bossEventSpawner01OnAddToWorld(objectId)
	
	if Server then
		eventSpawner01Id = objectId
		eventSpawner01Coords = Entity.Get(objectId):GetCoords()
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			waveFrequency = 48
			waveCooldown = 30
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			waveFrequency = 42
			waveCooldown = 28
		else
			waveFrequency = 30
			waveCooldown = 22
		end

		Shared.setUserdata(objectId, userdata)
		Script.RegisterForUpdate(objectId, "gd.quests.areaFFleshshaper.updateStatus", 1000)
		
	end

end

function gd.quests.areaFFleshshaper.bossEventSpawner02OnAddToWorld(objectId)
	
	if Server then
		eventSpawner02Id = objectId
		eventSpawner02Coords = Entity.Get(objectId):GetCoords()
		
	end

end

-- hero spawns in Phase 02/03 on Elite/Ult
local heroTargetId = 0
local heroTargetCoords = nil

function gd.quests.areaFFleshshaper.heroTarget01OnAddToWorld(objectId)

	if Server then
		heroTargetId = objectId
		heroTargetCoords = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaFFleshshaper.heroSpawn01AvatarOnAddToWorld(objectId)
	
	if Server then
		heroSpawn01Id = objectId
		
	end

end

function gd.quests.areaFFleshshaper.heroSpawn01Killed()
	
	if Server then
		heroSpawn01Dead = true
		
	end

end

function gd.quests.areaFFleshshaper.heroSpawn02AvatarOnAddToWorld(objectId)
	
	if Server then
		heroSpawn02Id = objectId
		
	end

end

function gd.quests.areaFFleshshaper.heroSpawn02Killed()
	
	if Server then
		heroSpawn02Dead = true
		
	end

end

function gd.quests.areaFFleshshaper.bossEventOnRemoveFromWorld(objectId)

	if Server then
		Shared.setUserdata(objectId, nil)
		Script.UnregisterForUpdate(objectId, "gd.quests.areaFFleshshaper.updateStatus")

	end
	
end

-- Spawn regular adds in phase 01 on all difficulties. Spawn Heroes on Elite/Ult in Phase 02/03
local function SpawnProxies()
	local entity01 = Entity.Get(eventSpawner01Id)
	local entity02 = Entity.Get(eventSpawner02Id)
	
	if entity01 != nil then
		proxySpawn01 = Proxy.Create(proxyDBR, eventSpawner01Coords.origin)
		proxySpawn01:SetCoords(eventSpawner01Coords)
		proxySpawn01:LinkPatrolPointGroup("PatrolPoint_RegF_FinalBoss_01")
	
	end
	
	if entity02 != nil then
		proxySpawn02 = Proxy.Create(proxyDBR, eventSpawner02Coords.origin)
		proxySpawn02:SetCoords(eventSpawner02Coords)
		proxySpawn02:LinkPatrolPointGroup("PatrolPoint_RegF_FinalBoss_02")
	
	end

end

local function SpawnHeroes()
	local entity01 = Entity.Get(eventSpawner01Id)
	local entity02 = Entity.Get(eventSpawner02Id)
	
	math.randomseed(Time.Now())

	if entity01 != nil then
		local totalSpawns01 = table.getn(heroSpawn01Dbrs)
		local randomizer01 = random(1,totalSpawns01)
		
		local spawn = Character.Create (heroSpawn01Dbrs[randomizer01], 0, nil)
		spawn:SetCoords(eventSpawner01Coords)
		heroSpawn01Dead = false
		
		spawn:MoveAction(heroTargetId, heroTargetCoords, true)

	end
	
	if entity02 != nil then
		local totalSpawns02 = table.getn(heroSpawn02Dbrs)
		local randomizer02 = random(1,totalSpawns02)
		
		local spawn = Character.Create (heroSpawn02Dbrs[randomizer02], 0, nil)
		spawn:SetCoords(eventSpawner02Coords)
		heroSpawn02Dead = false
		
		spawn:MoveAction(heroTargetId, heroTargetCoords, true)
		
	end
	
end

-- increment timer every event update if spawns are dead, increment chance if timer is less than max timer
local function incrementTimer()

	waveTimer = waveTimer + 1

	-- if timer surpasses maximum time between waves, increase chance to 100%
	if waveTimer >= waveFrequency then
		waveChance = 100
	
	end
	
	-- if timer surpasses minimum cooldown between spawns, increase the chance to spawn
	if waveTimer >= waveCooldown then		
		if waveChance < 100 then
			if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
				waveChance = waveChance + 1
			else
				waveChance = waveChance + 3
				
				if waveChance > 100 then
					waveChance = 100
				end
				
			end

		end
	
	end

end


function gd.quests.areaFFleshshaper.updateStatus(objectId)
	if Server then
		if not bossKilled then
			if phase02Spawned && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
				if heroSpawn01Dead && heroSpawn02Dead then
					print "HERO TIMER GOING OFF"
					-- increment the timer and chance to spawn
					incrementTimer()
					
					-- if timer has surpassed the minimum cooldown between spawns, try to spawn phase 02/03 spawns		
					if waveTimer >= waveCooldown then
						math.randomseed(Time.Now())
						local randomizer = random(1,100)
					
						if randomizer <= waveChance then
							print "SPAWN HERO"
							SpawnHeroes()
							waveChance = 10
							waveTimer = 0
						
						end
					
					end			
				
				end
				
			elseif not phase02Spawned then
				if not proxyInitialSpawn then
					-- increment the timer and chance to spawn
					print "TIMER GOING OFF"
					incrementTimer()
					
					-- if timer has surpassed the minimum cooldown between spawns, try to spawn phase 01 spawns
					if waveTimer >= waveCooldown then
						math.randomseed(Time.Now())
						local randomizer = random(1,100)
					
						if randomizer <= waveChance then
							proxyInitialSpawn = true
							print "SPAWNING PROXY 01"
							SpawnProxies()
							waveChance = 20
							waveTimer = 0
						
						end
					
					end
				
				elseif proxySpawn01 != nil && proxySpawn02 != nil then
					if proxySpawn01:AllKilled() && proxySpawn02:AllKilled() then
						print "PROXY TIMER GOING OFF"
						-- increment the timer and chance to spawn
						incrementTimer()
						
						-- if timer has surpassed the minimum cooldown between spawns, try to spawn phase 01 spawns
						if waveTimer >= waveCooldown then
							math.randomseed(Time.Now())
							local randomizer = random(1,100)
						
							if randomizer <= waveChance then
								print "SPAWNING PROXY 02"
								SpawnProxies()
								waveChance = 15
								waveTimer = 0
							
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


-- Boss Reward Chests
function gd.quests.areaFFleshshaper.bossChestOnAddToWorld(objectId)
	
	if Server then
		local chestEntity = Entity.Get(objectId)
		bossChestId = objectId
		player = Game.GetLocalPlayer()
	
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHEST_FLESHSHAPERBOSS")) then
			print "Destroying Chest"
			chestEntity:Destroy()
			
		end
		
	end
	
end

function gd.quests.areaFFleshshaper.bossChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHEST_FLESHSHAPERBOSS");
	
end

function gd.quests.areaFFleshshaper.lootChestOnAddToWorld(objectId)
	
	if Server then
		lootChestId = objectId
		
	end
	
end

function gd.quests.areaFFleshshaper.lootChest02OnAddToWorld(objectId)
	
	if Server then
		lootChest02Id = objectId
		
	end
	
end

-- Shortcut back to the surface after boss is killed
function gd.quests.areaFFleshshaper.bossExitShortcutOnAddToWorld(objectId)
	
	if Server then
		bossExitShortcutId = objectId
		
		if (bossKilled && shortcutOpen == false) then
			local door = Door.Get(objectId)
			shortcutOpen = true
			
			door:SetLocked(false)
			door:Open()
			
		end
		
	end
	
end


--
-- Final Boss Phases
-- in phase 02, boss stops spawning adds on Normal. On Elite/Ult, switches to spawning heroes
--

function gd.quests.areaFFleshshaper.bossPhase02OnAddToWorld(objectId)
	
	if Server then
		if not phase02Spawned then
			phase02Spawned = true
		
		end
		
	end
	
end




-- Final Boss VO
local finalBossVO = false

function gd.quests.areaFFleshshaper.finalBossVO01GlobalMP()

	finalBossVO = true

end

function gd.quests.areaFFleshshaper.finalBossVO01(triggererId)
	
	if (not finalBossVO) then
		finalBossVO = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/aetherialfinalbossvo_01.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("aetherialFinalBossVO01")

end