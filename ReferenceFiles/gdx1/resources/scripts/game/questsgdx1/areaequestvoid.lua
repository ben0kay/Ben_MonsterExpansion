/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestVoid = {}



--
-- Void's Edge Boss
--
local ulgrimDoorId = 0
local ulgrimDoorOpen = false
local ulgrimShortcutEntranceId = 0
local ulgrimShortcutExitId = 0
local bossKilled = false
local portal01Open = false
local portal02Open = false
local doorBossA01 = 0
local doorBossA02 = 0

-- ulgrim door
-- Opened after accepting quest
function gd.quests.areaEQuestVoid.doorUlgrimOnAddToWorld(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		ulgrimDoorId = objectId
		
		if (player:HasToken("AREAF_ULGRIMVOIDDOOR_OPEN") && ulgrimDoorOpen == false) then
			local door = Door.Get(objectId)
			ulgrimDoorOpen = true
			door:Open()

		end
	
	end
	
end

function gd.quests.areaEQuestVoid.doorUlgrimOpen()
	
	if Server then
		local door = Door.Get(ulgrimDoorId)
	
		if ulgrimDoorOpen == false && door != nil then
			door:Open()
			ulgrimDoorOpen = true
		
		end

	end
	
end

-- boss doors
function gd.quests.areaEQuestVoid.doorBossA01OnAddToWorld(objectId)
	
	if Server then
		doorBossA01 = objectId
	
	end
	
end

function gd.quests.areaEQuestVoid.doorBossA02OnAddToWorld(objectId)
	
	if Server then
		doorBossA02 = objectId
	
	end
	
end

function gd.quests.areaEQuestVoid.ulgrimShortcutEntranceOnAddToWorld(objectId)
	
	if Server then
		ulgrimShortcutEntranceId = objectId
		
	end
	
end

function gd.quests.areaEQuestVoid.ulgrimShortcutEntranceInitialUpdate(objectId)
	
	if Server && bossKilled && portal01Open == false then
		local door = Door.Get(objectId)
		
		door:SetLocked(false)
		door:Open()
		
		portal01Open = true
	
	end
	
end

function gd.quests.areaEQuestVoid.ulgrimShortcutExitOnAddToWorld(objectId)
	
	if Server then
		ulgrimShortcutExitId = objectId
		
		if (bossKilled && portal02Open == false) then
			local door = Door.Get(objectId)
			portal02Open = true
			
			door:SetLocked(false)
			door:Open()
			
		end
		
	end
	
end

function gd.quests.areaEQuestVoid.ulgrimBossKilled()
	
	if Server then
		local door01 = Door.Get(ulgrimShortcutEntranceId)
		local door02 = Door.Get(ulgrimShortcutExitId)
		
		bossKilled = true
	
		-- unlock shortcut
		if door01 ~= nil then
			door01:SetLocked(false)
			door01:Open()
			portal01Open = true
		end
		
		if door02 ~= nil then
			door02:SetLocked(false)
			door02:Open()
			portal02Open = true
		end

		local bossDoor01 = Door.Get(doorBossA01)
		local bossDoor02 = Door.Get(doorBossA02)
		
		-- unlock boss room
		if bossDoor01 != nil then
			bossDoor01:Open()
		
		end
	
		if bossDoor02 != nil then
			bossDoor02:Open()
		
		end

	end
	
end

-- Prevent Boss from Leaving Room
local bossId = 0

function gd.quests.areaEQuestVoid.bossOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaEQuestVoid.bossLeaveRoom()

	if Server then
		-- Teleport boss back to spawn point if he is somehow kited out of boss room
		if (bossId != 0) then
			local bossEntity = Character.Get(bossId)

			if bossEntity != nil then
				local coords = bossEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				bossEntity:TeleportHome()
			
			end
			
		end
	
	end

end

-- Chthonian Boss before Ulgrim
local rylokBossId = 0
local rylokBossSpawned = false

local function RylokCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(rylokBossId):GetCoords().origin

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
	
function gd.quests.areaEQuestVoid.rylokBossOnAddToWorld(objectId)

	if Server then
		rylokBossId = objectId;
		
	end
	
end

-- Spawn the boss
local bossTriggered = false

function gd.quests.areaEQuestVoid.rylokBossTransition()

	if Server && not rylokBossSpawned then
		rylokBossSpawned = true

		local coords = Entity.Get(rylokBossId):GetCoords()
		
		local spawn = Character.Create ("records/creatures/enemies/boss&quest/chthonianrylok_ekketzul.dbr", RylokCreateArgs())
		spawn:SetCoords(coords)
		
	end
	
end

function gd.quests.areaEQuestVoid.rylokBossTrigger(triggererId)

	if not bossTriggered then
		QuestEvent("spawnRylokBoss")
		bossTriggered = true
	
	end
	
end

-- Void Cleared Trigger
-- Checks if the player had cleared the way through the void for ulgrim in This session
local voidCleared = false

function gd.quests.areaEQuestVoid.voidClearedTriggerGlobalMP()

	if not voidCleared then
		voidCleared = true
	
	end

end

function gd.quests.areaEQuestVoid.voidClearedTrigger(triggererId)
	
	if not voidCleared then
		QuestGlobalEvent("ulgrimVoidCleared")
	
	end

end

function gd.quests.areaEQuestVoid.voidClearedCheck()

	local test = voidCleared
	
	return test

end

-- Void Exit Trigger
function gd.quests.areaEQuestVoid.voidExitTrigger(triggererId)

	local player = Player.Get(triggererId)
	
	if (player != nil) && (player:HasToken("AREAE_EMBERCRAGSFOUND") == false) then
		local questId01 = 0x5F3CB680
		local taskId01 = 0xBF320900

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (questTaskState01 == QuestState.InProgress) then
			UI.Notify("tagNotification_AreaF_EmberCrags")
		end
	
	end
	
	QuestGlobalEvent("ulgrimAtVoidExit")

end

function gd.quests.areaEQuestVoid.voidExitTriggerGlobalMP()

	local player = Game.GetLocalPlayer()
	if player:HasToken("AREAE_EMBERCRAGSFOUND") == false then
		GiveTokenToLocalPlayer("AREAE_EMBERCRAGSFOUND")
	end
	
	if voidCleared then
		GiveTokenToLocalPlayer("AREAE_ULGRIMVOID_CLEARED")
	
	end

end


-- Void's Edge Found
local voidEdgeFound = false

function gd.quests.areaEQuestVoid.voidEdgeFoundTriggerGlobalMP()
	if not voidEdgeFound then
		local player = Game.GetLocalPlayer()
		local kQuest = 0x6B11F400
		local kTask = 0x94054900
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
		if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_VOIDEDGEFOUND") == false) then
				GiveTokenToLocalPlayer("AREAE_VOIDEDGEFOUND")
				voidEdgeFound = true
		end
	
	end

end

function gd.quests.areaEQuestVoid.voidEdgeFoundTrigger(triggererId)
	local player = Player.Get(triggererId)
	
	if not voidEdgeFound && player:HasToken("AREAE_VOIDEDGEFOUND") == false then
		QuestGlobalEvent("voidEdgeFound")
	
	end

end

--
-- The bloodsworn caught in the void
--
local captive01Ids = {0, 0, 0}
local captive01StateObjects = { }

local BloodSwornState = { Default = 0, Released = 2, Left = 3}

-- Bloodsworn 01
local BloodSworn01StateObjects = orderedTable();
	BloodSworn01StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = BloodSwornState.Released, dbr = nil}
	BloodSworn01StateObjects["AREAE_BLOODSWORN_LEFT"] = { state = BloodSwornState.Left, dbr = "records/items/lootchests/breakables/a01_bonepilehuman_01_break.dbr"}
	BloodSworn01StateObjects[""] = { state = BloodSwornState.Default, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_bloodsworndamned_01.dbr" }

function gd.quests.areaEQuestVoid.bloodSworn01OnAddToWorld(objectId)

	if Server then
		captive01Ids[1] = objectId
		captive01StateObjects[1] = BloodSworn01StateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, BloodSworn01StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaEQuestVoid.bloodSwornOnDestroy = ClearObjectUserdata

-- Bloodsworn 02
local BloodSworn02StateObjects = orderedTable();
	BloodSworn02StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = BloodSwornState.Released, dbr = nil }
	BloodSworn02StateObjects["AREAE_BLOODSWORN_LEFT"] = { state = BloodSwornState.Left, dbr = "records/items/lootchests/breakables/a01_bonepilehuman_01_break.dbr"}
	BloodSworn02StateObjects[""] = { state = BloodSwornState.Default, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_bloodsworndamned_02.dbr" }

function gd.quests.areaEQuestVoid.bloodSworn02OnAddToWorld(objectId)

	if Server then
		captive01Ids[2] = objectId
		captive01StateObjects[2] = BloodSworn02StateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, BloodSworn02StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Bloodsworn 03
local BloodSworn03StateObjects = orderedTable();
	BloodSworn03StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = BloodSwornState.Released, dbr = nil }
	BloodSworn03StateObjects["AREAE_BLOODSWORN_LEFT"] = { state = BloodSwornState.Left, dbr = "records/items/lootchests/breakables/a01_bonepilehuman_01_break.dbr"}
	BloodSworn03StateObjects[""] = { state = BloodSwornState.Default, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_bloodsworndamned_03.dbr"}

function gd.quests.areaEQuestVoid.bloodSworn03OnAddToWorld(objectId)

	if Server then
		captive01Ids[3] = objectId
		captive01StateObjects[3] = BloodSworn03StateObjects
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, BloodSworn03StateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

--
-- Crystal object keeping the door closed
--
local CrystalState = { Default = 0, Finished = 1}

local crystalId = 0
local CrystalSwapped = false

local crystalStateObjects = orderedTable();
	crystalStateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = CrystalState.Finished,  dbr = nil}
	crystalStateObjects[""] = { state = CrystalState.Default, dbr = "records/storyelements/questassets/areae_bloodsworndamned_obsidianrune.dbr"}


function gd.quests.areaEQuestVoid.crystalOnAddToWorld(objectId)

	if Server then
	
		crystalId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, crystalStateObjects)
		Shared.setUserdata(objectId, userdata)
			
	end
	
end

gd.quests.areaEQuestVoid.crystalOnDestroy = ClearObjectUserdata

-- Swap the crystal
local crystalSwapped = false

function gd.quests.areaEQuestVoid.crystalTransition()
		
	if Server then
		local player = Game.GetLocalPlayer()
		
		if crystalSwapped == false && player:AnyoneHasToken("AREAE_BLOODSWORN_CHOOSERELEASE") then
			crystalSwapped = true
			local crystal = Entity.Get(crystalId)

			local MPOverrideDbr = "records/storyelements/questassets/areae_bloodsworndamned_obsidianrune_break.dbr"
			local MPOverrideState = true
			
			if (crystal != nil) then
				UpdateObjectSwap(crystalId, crystalStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
	
		end
		
	end
	
end

--
-- Door for the bloodsworn damned quest
--
local bloodswornDoor01 = 0

--Door Setup
function gd.quests.areaEQuestVoid.bloodswornDoor01OnAddToWorld(objectId)
	
	bloodswornDoor01 = objectId
	local player = Game.GetLocalPlayer()

	if Server then

		if (player:HasToken("AREAE_BLOODSWORN_RELEASED")) then
		
			local door = Door.Get(objectId)
			door:SetLocked(false)
			door:Open()

		end
	
	end
		
end

-- Called when the crystal is destroyed
function gd.quests.areaEQuestVoid.bloodswornReleasedTokenMP()

	local player = Game.GetLocalPlayer()
	
	local questId01 = 0x9A0F3500
	local taskId01 = 0x1501C060
	local taskId02 = 0x5F351E00

	local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
	local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
	
	-- Tries to begin Release scenario, checks if player has not already made this choice.
	if ((player:HasToken("AREAE_BLOODSWORN_LEFT") == false && player:HasToken("AREAE_BLOODSWORN_CHOOSERELEASE") == false) && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
		player:GrantQuest(0x9A0F3500, 0x5F351E00)
		GiveTokenToLocalPlayer("AREAE_BLOODSWORN_RELEASED")
		
	elseif questTaskState02 == QuestState.InProgress then
		GiveTokenToLocalPlayer("AREAE_BLOODSWORN_RELEASED")
		
	end

end

function gd.quests.areaEQuestVoid.bloodswornUnlockDoors()

	QuestGlobalEvent("bloodswornReleasedToken")
	
	if Server then
		local door01 = Door.Get(bloodswornDoor01)
		
		if door01 != nil then
			door01:SetLocked(false)
			door01:Open()
		end
		
	end
	
end

--
-- servitor boss for the bloodsworn damned quest. 
--
local servitorBossId = 0
local servitorBossSpawned = false
local servitorBossKilled = false
local fringesOfSanityExitShortcut = 0

local servitorBossStateObjects = orderedTable();
	servitorBossStateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = BloodSwornState.Released,  dbr = "records/creatures/enemies/boss&quest/chthonianservitor_lunalvalgoth.dbr" }
	servitorBossStateObjects["AREAE_BLOODSWORN_LEFT"] = { state = BloodSwornState.Left,  dbr = "records/creatures/enemies/boss&quest/chthonianservitor_lunalvalgoth.dbr" }
	servitorBossStateObjects[""] = { state = BloodSwornState.Default, dbr = nil }

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(servitorBossId):GetCoords().origin

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
	
function gd.quests.areaEQuestVoid.servitorBossOnAddToWorld(objectId)

	if Server then
	
		if (servitorBossSpawned == false) then

			servitorBossId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, servitorBossStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == BloodSwornState.Left || newState == BloodSwornState.Released) then
				servitorBossSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestVoid.servitorBossOnDestroy = ClearObjectUserdata

function gd.quests.areaEQuestVoid.servitorBossDeadCheck()

	local test = servitorBossKilled
	
	return test

end

function gd.quests.areaEQuestVoid.servitorBossOnKill()
	
	servitorBossKilled = true
	
	if Server then
		gd.quests.areaEQuestVoid.crystalTransition()
		
		-- open shortcut back out
		local door = Door.Get(fringesOfSanityExitShortcut)
	
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
		end
	
	end

end

-- Fringes of Sanity Shortcut Exit, opened when boss killed
function gd.quests.areaEQuestVoid.fringesOfSanityExitShortcutOnAddToWorld(objectId)
	
	if Server then
		fringesOfSanityExitShortcut = objectId
		
	end
	
end


-- Spawn the boss
function gd.quests.areaEQuestVoid.servitorBossTransition()
	
	if Server then

		if (servitorBossSpawned == false) then
			servitorBossSpawned = true
			
			local chthonianBoss = Entity.Get(servitorBossId)
			
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = "records/creatures/enemies/boss&quest/chthonianservitor_lunalvalgoth.dbr"
			local MPOverrideState = true
			
			if (chthonianBoss != nil) then
			
				local coords = chthonianBoss:GetCoords()	
				local rift = Entity.Create("records/fx/ambient/fx_voidrift_nova_large01.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(servitorBossId, servitorBossStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
			
			end
	
		end
		
	end
	
end

