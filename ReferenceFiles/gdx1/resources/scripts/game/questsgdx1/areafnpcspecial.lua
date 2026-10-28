/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCSpecial = {}

--
-- secret boss encounter
--
local lootDoorId = 0
local exitShortcut = 0
local lootChestId = 0
local lootChest02Id = 0
local bossKilled = false
local bossSpawned = false

local eventSpawnerId = {0, 0, 0, 0}
local eventSpawnerCoords = {nil, nil, nil, nil}

local heroSpawnId = {0, 0, 0, 0}
local heroSpawnDead = {true, true, true, true}

local heroSpawn01Dbrs = { "records/creatures/enemies/special/clone_c01_summon1.dbr", "records/creatures/enemies/special/clone_c02_summon1.dbr", "records/creatures/enemies/special/clone_d01_summon1.dbr", "records/creatures/enemies/special/clone_d02_summon1.dbr", "records/creatures/enemies/special/clone_e01_summon1.dbr", "records/creatures/enemies/special/clone_e02_summon1.dbr" }
local heroSpawn02Dbrs = { "records/creatures/enemies/special/clone_c01_summon2.dbr", "records/creatures/enemies/special/clone_c02_summon2.dbr", "records/creatures/enemies/special/clone_d01_summon2.dbr", "records/creatures/enemies/special/clone_d02_summon2.dbr", "records/creatures/enemies/special/clone_e01_summon2.dbr", "records/creatures/enemies/special/clone_e02_summon2.dbr" }
local heroSpawn03Dbrs = { "records/creatures/enemies/special/clone_c01_summon3.dbr", "records/creatures/enemies/special/clone_c02_summon3.dbr", "records/creatures/enemies/special/clone_d01_summon3.dbr", "records/creatures/enemies/special/clone_d02_summon3.dbr", "records/creatures/enemies/special/clone_e01_summon3.dbr", "records/creatures/enemies/special/clone_e02_summon3.dbr" }
local heroSpawn04Dbrs = { "records/creatures/enemies/special/clone_c01_summon4.dbr", "records/creatures/enemies/special/clone_c02_summon4.dbr", "records/creatures/enemies/special/clone_d01_summon4.dbr", "records/creatures/enemies/special/clone_d02_summon4.dbr", "records/creatures/enemies/special/clone_e01_summon4.dbr", "records/creatures/enemies/special/clone_e02_summon4.dbr" }
local heroSpawnInfo = { heroSpawn01Dbrs, heroSpawn02Dbrs, heroSpawn03Dbrs, heroSpawn04Dbrs}

local waveTimer = 0
local waveFrequency = 40
local waveCooldown = 28
local waveChance = 50

local heroAliveTimer = 0
local heroMaxAliveTimer = 35
local forceHeroSpawn = false

local function endAddSpawnEvent(objectId)
	Script.UnregisterForUpdate(objectId, "gd.quests.areaFNPCSpecial.updateStatus")
	
	local totalHeroes = table.getn(heroSpawnId)
	
	for id = 1, totalHeroes do
		local hero = Character.Get(heroSpawnId[id])
		
		if (hero != nil) then
			hero:Kill()
			
		end
	
	end

end


-- Wave Event for Boss
-- Spawners
function gd.quests.areaFNPCSpecial.bossEventSpawner01OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[1] = objectId
		eventSpawnerCoords[1] = Entity.Get(objectId):GetCoords()

		Shared.setUserdata(objectId, userdata)
		Script.RegisterForUpdate(objectId, "gd.quests.areaFNPCSpecial.updateStatus", 1000)
		
	end

end

function gd.quests.areaFNPCSpecial.bossEventSpawner02OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[2] = objectId
		eventSpawnerCoords[2] = Entity.Get(objectId):GetCoords()
		
	end

end

function gd.quests.areaFNPCSpecial.bossEventSpawner03OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[3] = objectId
		eventSpawnerCoords[3] = Entity.Get(objectId):GetCoords()
		
	end

end

function gd.quests.areaFNPCSpecial.bossEventSpawner04OnAddToWorld(objectId)
	
	if Server then
		eventSpawnerId[4] = objectId
		eventSpawnerCoords[4] = Entity.Get(objectId):GetCoords()
		
	end

end

-- hero spawns
local heroTargetId = 0
local heroTargetCoords = nil

function gd.quests.areaFNPCSpecial.heroTarget01OnAddToWorld(objectId)

	if Server then
		heroTargetId = objectId
		heroTargetCoords = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn01AvatarOnAddToWorld(objectId)
	
	if Server then
		heroSpawnId[1] = objectId
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn01Killed()
	
	if Server then
		heroSpawnDead[1] = true
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn02AvatarOnAddToWorld(objectId)
	
	if Server then
		heroSpawnId[2] = objectId
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn02Killed()
	
	if Server then
		heroSpawnDead[2] = true
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn03AvatarOnAddToWorld(objectId)
	
	if Server then
		heroSpawnId[3] = objectId
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn03Killed()
	
	if Server then
		heroSpawnDead[3] = true
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn04AvatarOnAddToWorld(objectId)
	
	if Server then
		heroSpawnId[4] = objectId
		
	end

end

function gd.quests.areaFNPCSpecial.heroSpawn04Killed()
	
	if Server then
		heroSpawnDead[4] = true
		
	end

end

function gd.quests.areaFNPCSpecial.bossEventOnRemoveFromWorld(objectId)

	if Server then
		Shared.setUserdata(objectId, nil)
		Script.UnregisterForUpdate(objectId, "gd.quests.areaFNPCSpecial.updateStatus")

	end
	
end

-- Dispense Heroes
local heroCounter = 0

local function SpawnHeroes()

	local totalHeroes = table.getn(eventSpawnerId)
	math.randomseed(Time.Now())
	
	if heroCounter < totalHeroes then
		heroCounter = heroCounter + 1
	
	elseif heroCounter > totalHeroes then
		heroCounter = totalHeroes
		
	end
	
	for id = 1, heroCounter do
		local entity = Entity.Get(eventSpawnerId[id])
		
		if (entity != nil) && heroSpawnDead[id] then
			local totalSpawns = table.getn(heroSpawnInfo[id])
			local randomizer = random(1,totalSpawns)
			
			local spawn = Character.Create (heroSpawnInfo[id][randomizer], 0, nil)
			spawn:SetCoords(eventSpawnerCoords[id])
			heroSpawnDead[id] = false
			
			spawn:MoveAction(heroTargetId, heroTargetCoords, true)
			
		end
	
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
			waveChance = waveChance + 4
			
			if waveChance > 100 then
				waveChance = 100
			end

		end
	
	end

end


local heroAliveTimer = 0
local heroMaxAliveTimer = 35

function gd.quests.areaFNPCSpecial.updateStatus(objectId)
	if Server then
		if bossSpawned then
			if not bossKilled then
				if (heroSpawnDead[1] && heroSpawnDead[2] && heroSpawnDead[3] && heroSpawnDead[4]) || forceHeroSpawn then
					print "HERO TIMER GOING OFF"
					-- increment the timer and chance to spawn
					incrementTimer()
					
					-- if timer has surpassed the minimum cooldown between spawns, try to spawn heroes	
					if waveTimer >= waveCooldown then
						math.randomseed(Time.Now())
						local randomizer = random(1,100)
					
						if randomizer <= waveChance then
							print "SPAWN HERO"
							SpawnHeroes()
							waveChance = 10
							waveTimer = 0
							forceHeroSpawn = false
							heroAliveTimer = 0							
						
						end
					
					end			
				
				elseif forceHeroSpawn == false && ((heroSpawnDead[1] && heroSpawnDead[2] && heroSpawnDead[3]) || (heroSpawnDead[2] && heroSpawnDead[3] && heroSpawnDead[4]) || (heroSpawnDead[1] && heroSpawnDead[3] && heroSpawnDead[4]) || (heroSpawnDead[1] && heroSpawnDead[2] && heroSpawnDead[4])) then
					heroAliveTimer = heroAliveTimer + 1
					
					if heroAliveTimer >= heroMaxAliveTimer then
						print "FORCING HERO COUNTDOWN"
						forceHeroSpawn = true
					
					end
				
				
				end
			
			else
				endAddSpawnEvent(objectId)
				
			end
		
		end
	
	end

end


function gd.quests.areaFNPCSpecial.bossOnAddToWorld(objectId)
	
	if Server then
		-- Starts the spawning of adds
		bossSpawned = true
		
	end

end

function gd.quests.areaFNPCSpecial.bossKilled()
	
	GiveTokenToLocalPlayer("AREAF_SECRETBOSS_SLAIN")
	
	if Server then
		bossKilled = true
		
		local door = Door.Get(exitShortcut)
		local door02 = Door.Get(lootDoorId)
		local lootChest = Chest.Get(lootChestId);
		local lootChest02 = Chest.Get(lootChest02Id);
		
		-- Unlock Loot Chests
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
			
		end
		
		-- Unlock Loot Door
		if door02 ~= nil then
			door02:SetLocked(false)
			door02:Open()
			
		end
	
	end
	
end


function gd.quests.areaFNPCSpecial.lootDoorOnAddToWorld(objectId)
	
	if Server then
		lootDoorId = objectId
		
	end
	
end

function gd.quests.areaFNPCSpecial.exitShortcutOnAddToWorld(objectId)
	
	if Server then
		exitShortcut = objectId
		
	end
	
end

function gd.quests.areaFNPCSpecial.lootChestOnAddToWorld(objectId)
	
	if Server then
		lootChestId = objectId
		
	end
	
end

function gd.quests.areaFNPCSpecial.lootChest02OnAddToWorld(objectId)
	
	if Server then
		lootChest02Id = objectId
		
	end
	
end

-- Dialogue Clone along the path to boss, despawned on dialogue or crossing trigger volume. Do not respawn once boss is killed
local clonePortal= false
local cloneId = 0

local CloneState = { Default = 0, Despawned = 1 }

local clone01StateObjects = orderedTable()
	clone01StateObjects["AREAF_SECRETBOSS_SLAIN"	] = { state = CloneState.Despawned, dbr = nil }
	clone01StateObjects[""					 	] = { state = CloneState.Default, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_endoftestingplaceholder_01.dbr" }


function gd.quests.areaFNPCSpecial.clone01OnAddToWorld(objectId)
	
	if Server then
		if not clonePortal then
			cloneId = objectId
	
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, clone01StateObjects)
	
			Shared.setUserdata(objectId, userdata)
			
		end
	
	end
	
end

gd.quests.areaFNPCSpecial.cloneOnDestroy = ClearObjectUserdata

function gd.quests.areaFNPCSpecial.clone01Portal()

	if Server then
		if clonePortal == false then
			clonePortal = true

			local clone = Entity.Get(cloneId)
			local MPOverrideDbr = nil
			local MPOverrideState = true
		
			if (clone != nil) then
				local coords = clone:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(cloneId, clone01StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
		
		end
		
	end
	
end

-- Trigger Volumes if player skips the npc and walks past, despawns the NPC
function gd.quests.areaFNPCSpecial.clone01Triggered(triggererId)

	QuestEvent("areaFSpecialClonePortal")
	
end


-- Spawn Control for NPC at Ritual Site
local ritualNPCId = 0

local RitualNPCState = { Default = 0, Finished = 1 }

local ritualNPCStateObjects = orderedTable()
	ritualNPCStateObjects["AREAF_SECRET_OPEN"	] = { state = RitualNPCState.Finished, dbr = nil }
	ritualNPCStateObjects[""					 	] = { state = RitualNPCState.Default, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_secretritual_02.dbr" }


function gd.quests.areaFNPCSpecial.ritualNPCOnAddToWorld(objectId)
	
	if Server then
		if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
			ritualNPCId = objectId

			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, ritualNPCStateObjects)

			Shared.setUserdata(objectId, userdata)
		
		end
	
	end
	
end

gd.quests.areaFNPCSpecial.ritualNPCOnDestroy = ClearObjectUserdata


-- Rift to NPC Control
local secretRift = 0
local triggerId = 0
local triggerProxyId = 0
local triggerSpawned = false
local secretRiftOpen = false

function gd.quests.areaFNPCSpecial.secretRiftOnAddToWorld(objectId)
	
	if Server then
		secretRift = objectId
		
		local player = Game.GetLocalPlayer()
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Legendary && (player:HasToken("AREAF_SECRET_FOUND") || secretRiftOpen)) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

local TriggerStateObjects = orderedTable();
	TriggerStateObjects["AREAF_SECRET_FOUND"] = { state = RitualNPCState.Finished,  dbr = nil }
	TriggerStateObjects[""] = { state = RitualNPCState.Default, dbr = "records/proxies/special/proxy_zombie_amb.dbr" }

local function TriggerCreateArgs()

	return Entity.Get(triggerProxyId):GetCoords().origin
	
end
	
function gd.quests.areaFNPCSpecial.triggerProxyOnAddToWorld(objectId)

	if Server && not triggerSpawned && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		triggerSpawned = true
		triggerProxyId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, TriggerStateObjects, Proxy, TriggerCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaFNPCSpecial.triggerProxyOnDestroy = ClearObjectUserdata

function gd.quests.areaFNPCSpecial.triggerOnAddToWorld(objectId)

	if Server then
		triggerId = objectId
	
	end

end

function gd.quests.areaFNPCSpecial.secretTriggerGlobalMP()

	GiveTokenToLocalPlayer("AREAF_SECRET_FOUND")

end

function gd.quests.areaFNPCSpecial.secretTrigger()

	if Server && not secretRiftOpen then
		if (triggerId != 0) then
			local character = Character.Get(triggerId)
			
			if (character != nil) then
				local coords = character:GetCoords()
				local rift = Entity.Create("records/fx/skillsdevotion/empyrionlight_blueradius_fxpak01.dbr")
				
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				character:Kill()
				
			end
			
		end
		
		local door = Door.Get(secretRift)

		GiveTokenToLocalPlayer("AREAF_SECRET_FOUND")
		secretRiftOpen = true
		
		-- Unlock the secret area
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
		end
		
		QuestGlobalEvent("areaFSecretRiftTriggered")
		
	end

end

-- Rift to Dungeon Control
local entranceRift = 0
local dungeonOpen = false

function gd.quests.areaFNPCSpecial.entranceRiftOnAddToWorld(objectId)
	
	if Server then
		entranceRift = objectId
		
		local player = Game.GetLocalPlayer()
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Legendary && (player:HasToken("AREAF_SECRET_OPEN") || dungeonOpen)) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

function gd.quests.areaFNPCSpecial.openDungeon()

	if Server then
		local door = Door.Get(entranceRift)
		local npc = Entity.Get(ritualNPCId)
		
		GiveTokenToLocalPlayer("AREAF_SECRET_OPEN")
		dungeonOpen = true
		
		-- Unlock the secret dungeon
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
		end
		
		-- Despawn Ghost
		if npc != nil then
			local coords = npc:GetCoords()
			local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			
			end
			
			UpdateObjectSwap(ritualNPCId, ritualNPCStateObjects)
	
		end
		
	end
	
end


-- Secret Location Controls
function gd.quests.areaFNPCSpecial.sahdinaNecklaceFound(triggererId)
	local player = Player.Get(triggererId)
	
	if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if ((player:ServerHasToken("AREAE_NPCS") || player:ServerHasToken("AREAE_INTRO")) && player:HasToken("SAHDINA_NECKLACE") == false && player:HasToken("AREAF_SECRET_OPEN") == false && player:HasItem("records/items/gearaccessories/necklaces/b100_necklace_sahdina.dbr", 1, false) == false) then
			if (player:IsSpaceAvailable("records/items/gearaccessories/necklaces/b100_necklace_sahdina.dbr")) then
				UI.Notify("tagNotification_WarningAreaFSecret01")
				player:GiveItem("records/items/gearaccessories/necklaces/b100_necklace_sahdina.dbr", 1, false)
				GiveTokenIfPlayer(triggererId, "SAHDINA_NECKLACE")
			
			end

		end
		
	end
	
end


-- Door to Special Level Control
local secretDoorId = 0
local secretOpened = false

function gd.quests.areaFNPCSpecial.secretDoorOnAddToWorld(objectId)

	if Server then
		secretDoorId = objectId;
		
		if (secretOpened) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

function gd.quests.areaFNPCSpecial.openSecret()

	if Server && not secretOpened then
		secretOpened = true
		local door = Door.Get(secretDoorId)
		
		
		if ((door != nil) && (door:IsLocked())) then
			door:SetLocked(false)
			door:Open()
			
		end
	
	end
	
end

-- No Riftgate region warning trigger
local riftgatesWarning = false

function gd.quests.areaFNPCSpecial.warningNoRiftgates(triggererId)

	local player = Player.Get(triggererId)

	if (player != nil) && not riftgatesWarning then
		UI.Notify("tagNotification_WarningRiftgateDisabled")
		riftgatesWarning = true
		
	end
	
end


-- Trigger Volumes for whispers
local whispers = { false, false, false, false, false, false }

function gd.quests.areaFNPCSpecial.whisper01GlobalMP()

	whispers[1] = true

end

function gd.quests.areaFNPCSpecial.whisper01(triggererId)
	
	if (not whispers[1]) then
		whispers[1] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/specialwhispers_01.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("whispers01")

end

function gd.quests.areaFNPCSpecial.whisper02GlobalMP()

	whispers[2] = true

end

function gd.quests.areaFNPCSpecial.whisper02(triggererId)
	
	if (not whispers[2]) then
		whispers[2] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/specialwhispers_02.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("whispers02")

end

function gd.quests.areaFNPCSpecial.whisper03GlobalMP()

	whispers[3] = true

end

function gd.quests.areaFNPCSpecial.whisper03(triggererId)
	
	if (not whispers[3]) then
		whispers[3] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/specialwhispers_03.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("whispers03")

end

function gd.quests.areaFNPCSpecial.whisper04GlobalMP()

	whispers[4] = true

end

function gd.quests.areaFNPCSpecial.whisper04(triggererId)
	
	if (not whispers[4]) then
		whispers[4] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/specialwhispers_04.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("whispers04")

end

function gd.quests.areaFNPCSpecial.whisper05GlobalMP()

	whispers[5] = true

end

function gd.quests.areaFNPCSpecial.whisper05(triggererId)
	
	if (not whispers[5]) then
		whispers[5] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/specialwhispers_05.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("whispers05")

end

function gd.quests.areaFNPCSpecial.whisper06GlobalMP()

	whispers[6] = true

end

function gd.quests.areaFNPCSpecial.whisper06(triggererId)
	
	if (not whispers[6]) then
		whispers[6] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/specialwhispers_06.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("whispers06")

end

--
-- Special Smith that only spawns on Ultimate difficulty
--
local smithId = 0
local spawnSmith = false

function gd.quests.areaFNPCSpecial.smithOnAddToWorld(objectId)

	if Server then
		smithId = objectId
		
		if spawnSmith then
			local player = Game.GetLocalPlayer()
			
			if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
				local coords = Entity.Get(objectId):GetCoords()
				
				if player:ServerHasToken("AREAF_SECRET_OPEN") == false then
					local spawn = Entity.Create("records/creatures/npcs/merchants/areaf_blacksmithb103.dbr")
					spawn:SetCoords(coords)
				else
					local spawn = Entity.Create("records/creatures/npcs/merchants/areaf_blacksmithb103b.dbr")
					spawn:SetCoords(coords)
					
				end
				
			end
		
		end
	
	end
	
end

function gd.quests.areaFNPCSpecial.smithTriggeredMP()
	if Server && not spawnSmith then
		local player = Game.GetLocalPlayer()
		spawnSmith = true
		
		if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
			local coords = Entity.Get(smithId):GetCoords()
			
			if player:ServerHasToken("AREAF_SECRET_OPEN") == false then
				local spawn = Entity.Create("records/creatures/npcs/merchants/areaf_blacksmithb103.dbr")
				spawn:SetCoords(coords)
			else
				local spawn = Entity.Create("records/creatures/npcs/merchants/areaf_blacksmithb103b.dbr")
				spawn:SetCoords(coords)
				
			end
			
		end
	
	end
	
end

function gd.quests.areaFNPCSpecial.smithTriggered(triggererId)
	local player = Player.Get(triggererId)
	
	if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		QuestEvent("specialSmithSpawn")
		
	end
	
end

-- Lore Note Chest 01
function gd.quests.areaFNPCSpecial.loreChest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (Game.GetGameDifficulty() != Game.Difficulty.Legendary || player:ServerHasToken("AREAF_SECRET_OPEN")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--Urn
local spawnedUrns = false
local urnId = 0

local UrnState = { Default = 0, Spawned = 1, Looted = 2 }

local urnStateObjects = orderedTable()
	urnStateObjects["AREAF_DAILASWORD_LOOTED"	] = { state = UrnState.Looted, dbr = nil }
	urnStateObjects["AREAF_DAILASWORD"	] = { state = UrnState.Spawned,  dbr = "records/items/lootchests/questchests/questchest_dailasword2_break.dbr"}
	urnStateObjects[""					 	] = { state = UrnState.Default, dbr = nil }

function gd.quests.areaFNPCSpecial.urnOnAddToWorld(objectId)

	if Server then
		if (not spawnedUrns && Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
			urnId = objectId

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, urnStateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn urns next time. If spawned as chest, saved into world
			if (newState == UrnState.Spawned) then
				spawnedUrns = true
				
			end
			
		end
		
	end
	
end

gd.quests.areaFNPCSpecial.urnOnDestroy = ClearObjectUserdata

function gd.quests.areaFNPCSpecial.urnDestroyedGlobalMP()
	local player = Game.GetLocalPlayer()

	if (player:HasToken("AREAF_DAILASWORD") && player:HasToken("AREAF_DAILASWORD_LOOTED") == false) then
		GiveTokenToLocalPlayer("AREAF_DAILASWORD_LOOTED")
	
	end
	

end

function gd.quests.areaFNPCSpecial.urnDestroyed()

	QuestGlobalEvent("dailaSword2Found")

end

function gd.quests.areaFNPCSpecial.swordFoundGlobalMP()

	if Server then
		if not spawnedUrns then
			spawnedUrns = true

			local urn = Entity.Get(urnId)
			local MPOverrideDbr = "records/items/lootchests/questchests/questchest_dailasword2_break.dbr"
			local MPOverrideState = true
		
			if (urn != nil) then
				local coords = urn:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(urnId, urnStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
		
		end
		
	end
	
end

function gd.quests.areaFNPCSpecial.swordFound(triggererId)
	local player = Player.Get(triggererId)
	
	if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (player:HasToken("AREAF_DAILASWORD_LOOTED") == false && player:HasItem("records/items/crafting/materials/craft_heartofdarkness.dbr", 1, false)) then
			GiveTokenIfPlayer(triggererId, "AREAF_DAILASWORD")
			QuestEvent("spawnDailaSword")

		end
		
	end
	
end


--
-- Blockade for the secret on Normal/Elite
--
local spawnedBlockade = false

function gd.quests.areaFNPCSpecial.specialBlockadeOnAddToWorld(objectId)

	if Server && not spawnedBlockade then
		if (Game.GetGameDifficulty() != Game.Difficulty.Legendary) then
			spawnedBlockade = true
			
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Entity.Create("records/storyelements/questassets/areae_specialbarricade_break.dbr")
			spawn:SetCoords(coords)
			
		end
	
	end
	
end


-- Bucket Chest
function gd.quests.areaFNPCSpecial.bucketChest01Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX1_BUCKET")
	
end

function gd.quests.areaFNPCSpecial.bucketChest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX1_BUCKET")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end
