/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGTombOfHereticBosses = {}


local doorBossA01 = 0
local doorBossA02 = 0
local doorBossB01 = 0
local doorBossB02 = 0
local doorPermaLocked = false
local doorLockedWarning = false
local doorBossDead = false



-- Tomb of the Heretic Boss, unlocks access to Epic Door.
function gd.quests.areaGTombOfHereticBosses.doorGuardianKilled()
	
	doorBossDead = true

end



-- Tomb of the Heretic boss door initialization
function gd.quests.areaGTombOfHereticBosses.doorBossA01OnAddToWorld(objectId)
	
	if Server then
		doorBossA01 = objectId
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.doorBossA02OnAddToWorld(objectId)
	
	if Server then
		doorBossA02 = objectId
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.doorBossB01OnAddToWorld(objectId)
	
	if Server then
		doorBossB01 = objectId
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.doorBossB02OnAddToWorld(objectId)
	
	if Server then
		doorBossB02 = objectId
	
	end
	
end


-- final boss of dungeon
-- Wraiths are activated when boss enters phase 2
local finalBossKilled = false
local wraithsCooldown = 0
local wraithsSequence = 0
local wraithsCounter = 0
local wraithsActive = false

local wraithTimer = 7
local wraithsResetCount = 8
local maxWraiths = 7

local wraithSpawnerId = 0
local wraithSpawnerCoords = nil
local wraithCounter = 0

local bossWraithIds = {0, 0, 0, 0, 0, 0, 0 }
local bossWraithsSpawned = { false, false, false, false, false, false, false }
local bossWraithDBRs = { "records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_01.dbr",
	"records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_02.dbr",
	"records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_03.dbr",
	"records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_04.dbr",
	"records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_05.dbr",
	"records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_06.dbr",
	"records/proxies/boss&questgdx2/proxy_areag_roguelike_finalboss_wraith_07.dbr" }

local turretId = 0
local turret02Id = 0
local turretSpawned = false
local decorIds = { 0, 0, 0, 0 }
local decorObject = { nil, nil, nil, nil }
local decorCoords = { nil, nil, nil, nil }
	
local function decorSpawn(decorNum)
	local dbr = nil
	
	if finalBossKilled then
		dbr = "records/level art/structures/sandstone ruins/sandtemple_statue_gryphon01a-large.dbr"
	else
		dbr = "records/level art/structures/sandstone ruins/sandtemple_statue_gryphon01a-large_arcane.dbr"
	end

	local object = Object.Get(decorIds[decorNum])

	if object != nil then
		object:Destroy()
		
	end
	
	if dbr != nil then
		local decor = Entity.Create(dbr)
		decorIds[decorNum] = decor:GetId()
		decor:SetCoords(decorCoords[decorNum])
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.turretDecor01OnAddToWorld(objectId)
	if Server then
		decorCoords[1] = Entity.Get(objectId):GetCoords()
		decorSpawn(1)
	end
end

function gd.quests.areaGTombOfHereticBosses.turretDecor02OnAddToWorld(objectId)
	if Server then
		decorCoords[2] = Entity.Get(objectId):GetCoords()
		decorSpawn(2)
	end
end

function gd.quests.areaGTombOfHereticBosses.turretDecor03OnAddToWorld(objectId)
	if Server then
		decorCoords[3] = Entity.Get(objectId):GetCoords()
		decorSpawn(3)
	end
end

function gd.quests.areaGTombOfHereticBosses.turretDecor04OnAddToWorld(objectId)
	if Server then
		decorCoords[4] = Entity.Get(objectId):GetCoords()
		decorSpawn(4)
	end
end

 local function TurretCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 200
	end
	
	if (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+2)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+3)

	end

	return monsterLevel, nil
	
end

function gd.quests.areaGTombOfHereticBosses.turretCreatureOnAddToWorld(objectId)

	if Server then
		turretId = objectId
		
	end
	
end

function gd.quests.areaGTombOfHereticBosses.turretCreature02OnAddToWorld(objectId)

	if Server then
		turret02Id = objectId
		
	end
	
end

function gd.quests.areaGTombOfHereticBosses.turret01OnAddToWorld(objectId)
	
	if Server && not finalBossKilled then
	
		if not turretSpawned then
			turretSpawned = true
			
			local coords = Entity.Get(objectId):GetCoords()
			local turret = Character.Create("records/skills/nonplayerskillsgdx2/bossskills/roguelike/turret_celestialcrystal.dbr", TurretCreateArgs())
			turret:SetCoords(coords)
		
		end
	
	end
	
end

-- Final Boss Killed Cleanup
function gd.quests.areaGTombOfHereticBosses.Boss2Killed()

	GiveTokenToLocalPlayer("AREAG_TOMBOFHERETIC_CLEARED")
	
	if Server then	
		finalBossKilled = true
		
		local door01 = Door.Get(doorBossB01)
		local door02 = Door.Get(doorBossB02)
	
		if door01 != nil then
			door01:Open()
		
		end
	
		if door02 != nil then
			door02:Open()
		
		end
		
		-- destroy turret monsters, if present
		local character = Character.Get(turretId)
		local character02 = Character.Get(turret02Id)
		
		if (character != nil) then
			coords = Entity.Get(turretId):GetCoords()
			
			character:Kill()
			local fx = Entity.Create("records/fx/skillsothergdx2/attackradius/celestialnova_massive_radius_fx01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
		if (character02 != nil) then
			character02:Kill()
			
		end
		
		-- destroy and respawn decorations
		local totalDecor = table.getn(decorIds)
		
		for id = 1, totalDecor do
			decorSpawn(id)
			
		end
	
	end

end

-- Wraith Control
local function endAddSpawnEvent(objectId)
	Script.UnregisterForUpdate(objectId, "gd.quests.areaGTombOfHereticBosses.updateStatus")
	
	local totalWraiths = table.getn(bossWraithIds)
	
	for id = 1, totalWraiths do
		local wraith = Character.Get(bossWraithIds[id])
		
		if (wraith != nil) then
			wraith:Kill()
			
		end
	
	end

end

function gd.quests.areaGTombOfHereticBosses.bossWraithsOnAddToWorld(objectId)
	if Server then
		local totalWraiths = table.getn(bossWraithIds)
		local test = false
		
		for id = 1, totalWraiths do
			if bossWraithIds[id] == 0 && not test then
				bossWraithIds[id] = objectId
				test = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGTombOfHereticBosses.bossEventSpawner01OnAddToWorld(objectId)
	
	if Server then
		wraithSpawnerId = objectId
		wraithSpawnerCoords = Entity.Get(objectId):GetCoords()

		-- increase maximum # of wraiths and # of triggers before new wraith spawns, based on difficulty
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			maxWraiths = 3
			WraithsResetCount = 12
			wraithTimer = 0
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			maxWraiths = 5
			WraithsResetCount = 10
		end

		Shared.setUserdata(objectId, userdata)
		Script.RegisterForUpdate(objectId, "gd.quests.areaGTombOfHereticBosses.updateStatus", 5000)
		
	end

end

function gd.quests.areaGTombOfHereticBosses.bossEventSpawner01OnRemoveFromWorld(objectId)

	if Server then
		Shared.setUserdata(objectId, nil)
		Script.UnregisterForUpdate(objectId, "gd.quests.areaGTombOfHereticBosses.updateStatus")

	end
	
end

-- Dispense Wraith
function gd.quests.areaGTombOfHereticBosses.proxyFollowPatrol(objectId)
	
	if Server then
	
		local proxy = Proxy.Get(objectId)
		
		proxy:LinkPatrolPointGroup("PatrolPoint_RegG_RoguelikeWraiths")
	
	end

end

local function SpawnWraith()

	local totalWraiths = table.getn(bossWraithsSpawned)
	local totalWraithDBRS = table.getn(bossWraithDBRs)
	math.randomseed(Time.Now())

	if true then
		if wraithCounter < totalWraithDBRS then
			wraithCounter = wraithCounter + 1
		
		end
		
		if wraithCounter > maxWraiths then
			wraithCounter = maxWraiths
			
			if wraithCounter > totalWraithDBRS then
				wraithCounter = totalWraithDBRS
				
			end
			
		end
		
		local wraithSpawned = false
		
		-- verify if any wraiths remain to be spawned
		local spawnTest = false
		
		for id = 1, totalWraiths do
			if not bossWraithsSpawned[id] then
				spawnTest = true
			
			end			
		
		end
		
		if spawnTest then
			-- select wraith that was not spawned yet
			while not wraithSpawned do
				local rand = random(1,totalWraiths)
				
				if not bossWraithsSpawned[rand] then
					wraithSpawned = true
					bossWraithsSpawned[rand] = true
					
					local spawn = Proxy.Create(bossWraithDBRs[rand], wraithSpawnerCoords.origin, true)
					spawn:SetCoords(wraithSpawnerCoords)
					
					local pfx = Entity.Create("records/fx/skillsothergdx2/attackradius/celestialnova_radius_fxpak01.dbr")
					if pfx != nil then
						pfx:NetworkEnable()
						pfx:SetCoords(wraithSpawnerCoords)
						
					end
					
				end
				
			end
		
		end
		
	end
	
end

function gd.quests.areaGTombOfHereticBosses.updateStatus(objectId)

	if Server then
		if wraithsActive then
			if not finalBossKilled then
				if wraithTimer >= wraithsResetCount then
					print "WRAITH TIMER GOING OFF"
					wraithTimer = 0
					SpawnWraith()
					
				else
					wraithTimer = wraithTimer + 1
				
				end
			
			else
				wraithsActive = false
				endAddSpawnEvent(objectId)
				
			end
		
		end
	
	end

end


function gd.quests.areaGTombOfHereticBosses.triggerWraithsGlobalMP()
	if Server then
		wraithsActive = true
	
	end
	
end
	
function gd.quests.areaGTombOfHereticBosses.triggerWraiths(triggererId)

	QuestEvent("tombOfHereticFinalBossWraiths")

end

--
-- Exit Shortcut Control
-- Only opens after main chest is opened
-- 
local shortcutId = 0
local shortcutOpen = false

function gd.quests.areaGTombOfHereticBosses.unlockShortcut()

	UI.Notify("tagNotificationStepsOfTormentShortcut")
	
	if Server then
		shortcutOpen = true
		
		local door = Door.Get(shortcutId)
		
		-- Unlock Shortcut
		if door != nil then
			door:SetLocked(false)
			door:Open()
		end
		
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.exitShortcutOnAddToWorld(objectId)
	
	if Server then
		shortcutId = objectId
		
		if shortcutOpen then
			local door = Door.Get(objectId)
			
			if (door:IsLocked()) then
				door:SetLocked(false)
				door:Open()
				
			end
		
		end
		
	end
	
end


--
-- Magi Boss Fight
--
local boss1LootChestId = 0

local magi01Spawned = false
local magi02Spawned = false
local magiDBRs = { "records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_01.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_02.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_03.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_04.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_05.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_06.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_07.dbr" }
	
local magiUltDBRs = { "records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_01U.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_02U.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_03U.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_04U.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_05U.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_06U.dbr",
	"records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_07U.dbr" }
	
local magi01Killed = false
local magi02Killed = false

-- number of magi spawned, default is 2, additional spawn points required if changed
local magiSpawnTotal = 2
local magiSpawnList = { }

function gd.quests.areaGTombOfHereticBosses.boss1LootChestOnAddToWorld(objectId)
	
	if Server then
		boss1LootChestId = objectId
		
	end
	
end

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local minLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		minLevel = 26
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		minLevel = 50
		maxLevel = 100
	else
		minLevel = 70
		maxLevel = 200
	end
	
	if (averageLevel < minLevel) then
		monsterLevel = ((minLevel+(minLevel/50))+4)
	elseif (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+4)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+5)

	end

	return monsterLevel, nil
	
end

local magiTest = false

local function MagiRandomizer(magiCount)
	
	
	local magiTable = magiDBRs
	
	if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		magiTable = magiUltDBRs
		
	end
	
	local totalMagi = table.getn(magiTable)
	local selectedList = {}
	
	print "selecting magi"
	-- randomly select magi until a unique list of length totalMagi is created
	if magiCount <= totalMagi then
		math.randomseed(Time.Now())
		
		while table.getn(selectedList) != magiCount do
			local rand = random(1,totalMagi)
			local found = false
			
			if rand <= totalMagi then
				for id = 1, table.getn(selectedList) do
					if magiTable[rand] == selectedList[id] then
						found = true
					
					end
				
				end
				
				if not found then
					table.insert(selectedList, magiTable[rand])
				
				end
			
			end
			
			magiTest = true
		
		end
		
		magiSpawnList = selectedList
		
	end

end

function gd.quests.areaGTombOfHereticBosses.generateMagiMP()
	if Server then
		-- generate list of Magi to spawn
		MagiRandomizer(magiSpawnTotal)
	end
	
end

function gd.quests.areaGTombOfHereticBosses.magiBoss01OnAddToWorld(objectId)

	 if Server then
		 if not magi01Spawned then
			local coords = Entity.Get(objectId):GetCoords()
			local dbr = "records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_01.dbr"
			
			if magiTest && magiSpawnList[1] != nil then
				dbr = magiSpawnList[1]
				
			end
			
			local spawn = Character.Create (dbr, CharacterCreateArgs())
			spawn:SetCoords(coords)
			
			magi01Spawned = true
		
		 end
		 
	 end
	 
 end
 
 function gd.quests.areaGTombOfHereticBosses.magiBoss02OnAddToWorld(objectId)

	 if Server then
		 if not magi02Spawned then
			local coords = Entity.Get(objectId):GetCoords()
			local dbr = "records/creatures/enemies/boss&quest/eldritcharmor_roguelikemagi_02.dbr"
			
			if magiTest && magiSpawnList[2] != nil then
				dbr = magiSpawnList[2]
				
			end
			
			local spawn = Character.Create (dbr, CharacterCreateArgs())
			spawn:SetCoords(coords)
			
			magi02Spawned = true
		
		 end
		 
	 end
	
 end
 
 function gd.quests.areaGTombOfHereticBosses.magiKilledGlobalMP()

	GiveTokenToLocalPlayer("GDX3_MAGIKILLED")
	
end
 
 local function Boss1Killed()
	if not magi01Killed then
		magi01Killed = true
	else
		magi02Killed = true
		
		local door01 = Door.Get(doorBossA01)
		local door02 = Door.Get(doorBossA02)
	
		if door01 != nil then
			door01:Open()
		
		end
	
		if door02 != nil then
			door02:Open()
		
		end
		
		local lootChest = Chest.Get(boss1LootChestId)
		
		if (lootChest ~= nil) then
			lootChest:SetLocked(false)
			
		end
		
		-- give out GDX3 token for killing magi
		QuestGlobalEvent("tombOfHereticMagiKilledTokenGlobalMP")
		
	end
	
end

local function MagiTokens(magiNum)
	local player = Game.GetLocalPlayer()
	
	if not player:HasToken("AREAG_ROGUELIKE_MAGIKILLED") then
		if magiNum == 1 then
			GiveTokenToLocalPlayer("AREAG_MAGI1_KILLED")
		elseif magiNum == 2 then
			GiveTokenToLocalPlayer("AREAG_MAGI2_KILLED")
		elseif magiNum == 3 then
			GiveTokenToLocalPlayer("AREAG_MAGI3_KILLED")
		elseif magiNum == 4 then
			GiveTokenToLocalPlayer("AREAG_MAGI4_KILLED")
		elseif magiNum == 5 then
			GiveTokenToLocalPlayer("AREAG_MAGI5_KILLED")
		elseif magiNum == 6 then
			GiveTokenToLocalPlayer("AREAG_MAGI6_KILLED")
		elseif magiNum == 7 then
			GiveTokenToLocalPlayer("AREAG_MAGI7_KILLED")
		end
		
		-- bestow final token if player has all 7
		if player:HasToken("AREAG_MAGI1_KILLED") && player:HasToken("AREAG_MAGI2_KILLED") && player:HasToken("AREAG_MAGI3_KILLED") && player:HasToken("AREAG_MAGI4_KILLED") && player:HasToken("AREAG_MAGI5_KILLED") && player:HasToken("AREAG_MAGI6_KILLED") && player:HasToken("AREAG_MAGI7_KILLED") then
			GiveTokenToLocalPlayer("AREAG_ROGUELIKE_MAGIKILLED")
			
			player:RemoveToken("AREAG_MAGI1_KILLED")
			player:RemoveToken("AREAG_MAGI2_KILLED")
			player:RemoveToken("AREAG_MAGI3_KILLED")
			player:RemoveToken("AREAG_MAGI4_KILLED")
			player:RemoveToken("AREAG_MAGI5_KILLED")
			player:RemoveToken("AREAG_MAGI6_KILLED")
			player:RemoveToken("AREAG_MAGI7_KILLED")
			
		end
	
	end
	
end
 
 function gd.quests.areaGTombOfHereticBosses.Magi1Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(1)
end

 function gd.quests.areaGTombOfHereticBosses.Magi2Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(2)
end

 function gd.quests.areaGTombOfHereticBosses.Magi3Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(3)
end

 function gd.quests.areaGTombOfHereticBosses.Magi4Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(4)
end

 function gd.quests.areaGTombOfHereticBosses.Magi5Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(5)
end

 function gd.quests.areaGTombOfHereticBosses.Magi6Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(6)
end

 function gd.quests.areaGTombOfHereticBosses.Magi7Killed()
	if Server then
		Boss1Killed()
	end
	
	MagiTokens(7)
end


-- No Riftgate region warning trigger
function gd.quests.areaGTombOfHereticBosses.warningNoRiftgates(triggererId)

	local player = Player.Get(triggererId)

	if (player != nil) && (player:HasToken("WARNING_TOMBOFHERETIC") == false) then
		UI.Notify("tagNotification_WarningRiftgateDisabled")
		GiveTokenIfPlayer(triggererId, "WARNING_TOMBOFHERETIC")
	end
	
end

--
-- Tomb of the Heretic Entry door control
--

function gd.quests.areaGTombOfHereticBosses.epicDoorOnInteractGlobalMP()

	doorPermaLocked = true

end

function gd.quests.areaGTombOfHereticBosses.epicDoorOnInteract(objectId, userId)
	
	local player = Player.Get(userId)
	local door = Door.Get(objectId)
		
	if (door != nil) then
		
		if player:HasItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false) && doorPermaLocked == false && doorBossDead == true then
		
			-- Mark the door as locked permanently for all players
			doorPermaLocked = true
			QuestGlobalEvent("tombOfHereticEpicDoor")
			
			-- Consume key to unlock door		
			door:Open()
			player:TakeItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false)
			
			UI.Notify("tagNotification_WarningTombOfHereticGates")
			
			-- generate list of Magi to spawn
			QuestEvent("tombOfHereticGenerateMagi")
			
		elseif player:HasItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false) && doorLockedWarning == false && doorBossDead == true then
			doorLockedWarning = true
			UI.Notify("tagNotification_WarningTombOfHereticGatesLocked")
		
		end
		
	end
	
end


--
-- Riggs Attackers, spawn randomly in FG content if player declines to settle their debt
--
local riggsAttacksSpawned = { false, false, false, false, false, false, false, false, false, false,
false, false, false, false, false, false, false, false, false, false, false, false }

local function spawnRiggsCollectors(objectId, spawnNum)
	local player = Game.GetLocalPlayer()
	
	if player:AnyoneHasToken("AREAG_RIGGS_ATTACKS") then
		riggsAttacksSpawned[spawnNum] = true
		
		local coords = Entity.Get(objectId):GetCoords()
		local proxy = Proxy.Create("records/proxies/boss&questgdx2/proxy_areag_riggscollectors_01.dbr", coords.origin)
		proxy:SetCoords(coords)
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors01OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[1] then
		spawnRiggsCollectors(objectId, 1)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors02OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[2] then
		spawnRiggsCollectors(objectId, 2)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors03OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[3] then
		spawnRiggsCollectors(objectId, 3)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors04OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[4] then
		spawnRiggsCollectors(objectId, 4)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors05OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[5] then
		spawnRiggsCollectors(objectId, 5)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors06OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[6] then
		spawnRiggsCollectors(objectId, 6)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors07OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[7] then
		spawnRiggsCollectors(objectId, 7)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors08OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[8] then
		spawnRiggsCollectors(objectId, 8)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors09OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[9] then
		spawnRiggsCollectors(objectId, 9)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors10OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[10] then
		spawnRiggsCollectors(objectId, 10)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors11OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[11] then
		spawnRiggsCollectors(objectId, 11)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors12OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[12] then
		spawnRiggsCollectors(objectId, 12)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors13OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[13] then
		spawnRiggsCollectors(objectId, 13)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors14OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[14] then
		spawnRiggsCollectors(objectId, 14)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors15OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[15] then
		spawnRiggsCollectors(objectId, 15)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors16OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[16] then
		spawnRiggsCollectors(objectId, 16)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors17OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[17] then
		spawnRiggsCollectors(objectId, 17)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors18OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[18] then
		spawnRiggsCollectors(objectId, 18)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors19OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[19] then
		spawnRiggsCollectors(objectId, 19)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors20OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[20] then
		spawnRiggsCollectors(objectId, 20)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors21OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[21] then
		spawnRiggsCollectors(objectId, 21)
	end
end

function gd.quests.areaGTombOfHereticBosses.riggsCollectors22OnAddToWorld(objectId)
	if Server && not riggsAttacksSpawned[22] then
		spawnRiggsCollectors(objectId, 22)
	end
end


-- Barricade
-- UG door to Lost Oasis
local tombDoor01Open = false
local tombDoor01Id = 0

function gd.quests.areaGTombOfHereticBosses.tombDoorInitialUpdate(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_LOSTOASIS_OPEN") || tombDoor01Open then
			local door = Door.Get(objectId)
			
			door:SetLocked(false)
			door:Open()
		
		end
	
	end
	
end

function gd.quests.areaGTombOfHereticBosses.tombGuardDoorOnAddToWorld(objectId)
	
	if Server then
		tombDoor01Id = objectId
		
	end
	
end

local tombBlockadeState = { Default = 0, Destroyed = 1}

local tombBlockadeId = 0
local spawnedBlockade = false

local tombBlockadeStateObjects = orderedTable();
	tombBlockadeStateObjects["AREAG_LOSTOASIS_OPEN"]	= { state = tombBlockadeState.Destroyed,  dbr = nil }
	tombBlockadeStateObjects[""] 						= { state = tombBlockadeState.Default, dbr = "records/storyelementsgdx2/questassets/areag_tombofheretic_door_break.dbr" }

function gd.quests.areaGTombOfHereticBosses.tombBlockadeOnAddToWorld(objectId)

	if Server then

		if (not spawnedBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, tombBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	
			spawnedBlockade = true
	
		end
		
	end
	
end

function gd.quests.areaGTombOfHereticBosses.blockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		tombBlockadeId = objectId
	
	end
	
end

gd.quests.areaGTombOfHereticBosses.tombBlockadeOnDestroy = ClearObjectUserdata
	
-- Interaction Site
local blockadeCleared = false

local tombInteractionSiteStateObjects = orderedTable();
	tombInteractionSiteStateObjects["AREAG_LOSTOASIS_OPEN"] = { state = tombBlockadeState.Destroyed,  dbr = nil }
	tombInteractionSiteStateObjects[""] 					= { state = tombBlockadeState.Default, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_tombofhereticblockade.dbr" }

function gd.quests.areaGTombOfHereticBosses.interactionSiteOnAddToWorld(objectId)
	
	if Server && not blockadeCleared then
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, tombInteractionSiteStateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGTombOfHereticBosses.interactionSiteOnDestroy = ClearObjectUserdata

-- Destroy Blockade
function gd.quests.areaGTombOfHereticBosses.tombBlockadeDestroyGlobalMP()

	GiveTokenToLocalPlayer("AREAG_LOSTOASIS_OPEN")
	
end

function gd.quests.areaGTombOfHereticBosses.tombBlockadeDestroy()

	if Server && not blockadeCleared then
		blockadeCleared = true
		
		if tombBlockadeId != 0 then
			local Blockade = Destructible.Get(tombBlockadeId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			tombBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsothergdx2/attackradius/celestialnova_massive_radius_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		QuestGlobalEvent("tombOfHereticDestroyBlockadeToken")
		
		local door01 = Door.Get(tombDoor01Id)
		
		tombDoor01Open = true
		
		if door01 != nil then
			door01:SetLocked(false)
			door01:Open()
			
		end
		
	end

end

