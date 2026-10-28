/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestFactionWendigo = {}

--
-- Faction 03 - Clearing the Mine, counts kills
--

local mineEnemiesKilled = 0

function gd.quests.areaEQuestFactionWendigo.wendigoMineClearedTokenMP()

	GiveTokenToLocalPlayer("AREAE_WENDIGOMINE_CLEARED")

end

function gd.quests.areaEQuestFactionWendigo.mineEnemyOnDie()
	local player = Game.GetLocalPlayer()
	
	mineEnemiesKilled = mineEnemiesKilled + 1
	
	if (mineEnemiesKilled >= 6 && player:ServerHasToken("AREAE_WENDIGOMINE_CLEARED") == false) then
		QuestGlobalEvent("wendigoMineCleared")
	
	end

end


--
-- Faction 04 - Larria the meddling witch
--
local witchId = 0
local MeddlingWitchState = {Friendly = 0, Hostile = 1, Safe = 2}
local DeadWitchState = {Default = 0, Corpse = 1 }
local meddlingWitchHostileSpawned = false

-- Larria
local deadWitchStateObjects = orderedTable();
	deadWitchStateObjects["AREAE_MEDDLINGWITCH_DEAD"] = { state = DeadWitchState.Corpse,  dbr = "records/storyelements/questassets/corpse_deadwitch_01.dbr" }
	deadWitchStateObjects[""] = { state = DeadWitchState.Default, dbr = nil }
	
function gd.quests.areaEQuestFactionWendigo.deadWitchOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAE_MEDDLINGWITCH_DEAD") == false then
			
			local player = Game.GetLocalPlayer()
			local kQuest = 0xF9F30700
			local kTask = 0x1501C060
			local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
			if (player != nil) && (questTaskState == QuestState.Complete) && (player:HasToken("AREAE_MEDDLINGWITCH_SAFE")) then
				GiveTokenToLocalPlayer("AREAE_MEDDLINGWITCH_DEAD")
			end
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, deadWitchStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.deadWitchOnDestroy = ClearObjectUserdata


local meddlingWitchStateObjects = orderedTable();
	meddlingWitchStateObjects["AREAE_MEDDLINGWITCH_SAFE"] = { state = MeddlingWitchState.Safe,  dbr = nil }
	meddlingWitchStateObjects["AREAE_MEDDLINGWITCH_HOSTILE"] = { state = MeddlingWitchState.Hostile,  dbr = "records/creatures/enemies/boss&quest/witch_larria.dbr" }
	meddlingWitchStateObjects[""] = { state = MeddlingWitchState.Friendly, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchlarria_01.dbr" }


local function WitchCharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(witchId):GetCoords().origin

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
	
function gd.quests.areaEQuestFactionWendigo.meddlingWitchOnAddToWorld(objectId)

	if Server then
	
		if (meddlingWitchHostileSpawned == false) then

			witchId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, meddlingWitchStateObjects, Character, WitchCharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == MeddlingWitchState.Hostile) then
				meddlingWitchHostileSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.meddlingWitchOnDestroy = ClearObjectUserdata

-- Boss Door Control
local witchDoor01 = 0
local witchDoor02 = 0
local doorOpened01 = false
local doorOpened02 = false

function gd.quests.areaEQuestFactionWendigo.witchDoor01OnAddToWorld(objectId)
	
	if Server then
			local player = Game.GetLocalPlayer()
		witchDoor01 = objectId
		
		if not meddlingWitchHostileSpawned && not doorOpened01 && player:HasToken("AREAE_MEDDLINGWITCH_HOSTILE") == false then
			doorOpened01 = true
			local door = Door.Get(objectId)
			
			door:Open()
		
		end
		
	end
	
end

function gd.quests.areaEQuestFactionWendigo.witchDoor02OnAddToWorld(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		witchDoor02 = objectId
		
		if not meddlingWitchHostileSpawned && not doorOpened02 && player:HasToken("AREAE_MEDDLINGWITCH_HOSTILE") == false then
			doorOpened02 = true
			local door = Door.Get(objectId)
			
			door:Open()
		
		end
		
	end
	
end

-- Meddling witch goes hostile - activated by dialogue.
function gd.quests.areaEQuestFactionWendigo.meddlingWitchHostileTokenGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xF9F30700
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_MEDDLINGWITCH_SAFE") == false) then
		GiveTokenToLocalPlayer("AREAE_MEDDLINGWITCH_HOSTILE")
	end
	
end

function gd.quests.areaEQuestFactionWendigo.meddlingWitchTransition()
	
	if Server then
	
		if not meddlingWitchHostileSpawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:HasToken("AREAE_MEDDLINGWITCH_HOSTILE") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/witch_larria.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(witchId, meddlingWitchStateObjects, Character, WitchCharacterCreateArgs, MPOverrideState, MPOverrideDbr)
			meddlingWitchHostileSpawned = true
			
			QuestGlobalEvent("meddlingWitchHostileToken")
			
			-- close door
			local door01 = Door.Get(witchDoor01)	
			
			if door01 != nil then
				door01:Close()
		
			end

		end
	
	end

end

function gd.quests.areaEQuestFactionWendigo.witchOnKill()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("AREAE_MEDDLINGWITCH_HOSTILE")) then
		GiveTokenToLocalPlayer("AREAE_MEDDLINGWITCH_KILLED")
	end
	
	-- open doors
	if Server then
		local door01 = Door.Get(witchDoor01)
		local door02 = Door.Get(witchDoor02)
	
		if door01 ~= nil then
			door01:Open()
		
		end

		if door02 ~= nil then
			door02:Open()
		
		end
		
	end

end

-- Prevent Witch from Leaving Room
local bossId = 0

function gd.quests.areaEQuestFactionWendigo.witchOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaEQuestFactionWendigo.witchLeaveRoom()

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


-- Meddling witch kept safe - activated by dialogue.
function gd.quests.areaEQuestFactionWendigo.meddlingWitchSafeTokenGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xF9F30700
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_MEDDLINGWITCH_HOSTILE") == false) then
		GiveTokenToLocalPlayer("AREAE_MEDDLINGWITCH_SAFE")
	end
	
end


--
-- Faction 05 - Ancient Hearts
--

local WendigoAncientState = {Unspawned = 0, Spawned = 1}

-- Wendigo Ancient 01
local wendigoAncient01Id = 0
local wendigoAnceint01Spawned = false

local WendigoAncient01StateObjects = orderedTable();
	WendigoAncient01StateObjects["AREAE_WENDIGOANCIENTS_ACTIVE"] = { state = WendigoAncientState.Spawned,  dbr = "records/creatures/enemies/boss&quest/wendigo_turned_handar.dbr"}
	WendigoAncient01StateObjects[""] = { state = WendigoAncientState.Unspawned, dbr = nil }


local function WendigoAncient01CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(wendigoAncient01Id):GetCoords().origin

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
	
function gd.quests.areaEQuestFactionWendigo.wendigoAncient01OnAddToWorld(objectId)

	if Server then
	
		if (wendigoAnceint01Spawned == false) then
			wendigoAncient01Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WendigoAncient01StateObjects, Character, WendigoAncient01CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WendigoAncientState.Spawned) then
				wendigoAnceint01Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.wendigoAncient01OnDestroy = ClearObjectUserdata

-- Wendigo Ancient 02
local wendigoAncient02Id = 0
local wendigoAnceint02Spawned = false

local WendigoAncient02StateObjects = orderedTable();
	WendigoAncient02StateObjects["AREAE_WENDIGOANCIENTS_ACTIVE"] = { state = WendigoAncientState.Spawned,  dbr = "records/creatures/enemies/boss&quest/wendigo_turned_olliva.dbr" }
	WendigoAncient02StateObjects[""] = { state = WendigoAncientState.Unspawned, dbr = nil }


local function WendigoAncient02CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(wendigoAncient02Id):GetCoords().origin

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
	
function gd.quests.areaEQuestFactionWendigo.wendigoAncient02OnAddToWorld(objectId)

	if Server then
	
		if (wendigoAnceint02Spawned == false) then
			wendigoAncient02Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WendigoAncient02StateObjects, Character, WendigoAncient02CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WendigoAncientState.Spawned) then
				wendigoAnceint02Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.wendigoAncient02OnDestroy = ClearObjectUserdata

-- Wendigo Ancient 03
local wendigoAncient03Id = 0
local wendigoAnceint03Spawned = false

local WendigoAncient03StateObjects = orderedTable();
	WendigoAncient03StateObjects["AREAE_WENDIGOANCIENTS_ACTIVE"] = { state = WendigoAncientState.Spawned,  dbr = "records/creatures/enemies/boss&quest/wendigo_turned_yuvoll.dbr" }
	WendigoAncient03StateObjects[""] = { state = WendigoAncientState.Unspawned, dbr = nil }


local function WendigoAncient03CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(wendigoAncient03Id):GetCoords().origin

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
	
function gd.quests.areaEQuestFactionWendigo.wendigoAncient03OnAddToWorld(objectId)

	if Server then
	
		if (wendigoAnceint03Spawned == false) then
			wendigoAncient03Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WendigoAncient03StateObjects, Character, WendigoAncient03CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WendigoAncientState.Spawned) then
				wendigoAnceint03Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.wendigoAncient03OnDestroy = ClearObjectUserdata


-- Wendigo Ancient 03 activated by quest
local WendigoAncientsSpawned = false

function gd.quests.areaEQuestFactionWendigo.wendigoAncient03Activation()
	
	if Server && not WendigoAncientsSpawned then
		WendigoAncientsSpawned = true
		local player = Game.GetLocalPlayer()
		
		local MPOverrideDbr1 = nil
		local MPOverrideDbr2 = nil
		local MPOverrideDbr3 = nil
		local MPOverrideState = false

		if (player:HasToken("AREAE_WENDIGOANCIENTS_ACTIVE") == false) then
			MPOverrideDbr1 = "records/creatures/enemies/boss&quest/wendigo_turned_handar.dbr"
			MPOverrideDbr2 = "records/creatures/enemies/boss&quest/wendigo_turned_olliva.dbr"
			MPOverrideDbr3 = "records/creatures/enemies/boss&quest/wendigo_turned_yuvoll.dbr"
			MPOverrideState = true
		end
		
		local WendigoAncient01 = Entity.Get(wendigoAncient01Id)
		local WendigoAncient02 = Entity.Get(wendigoAncient02Id)
		local WendigoAncient03 = Entity.Get(wendigoAncient03Id)

		if (WendigoAncient01 != nil) then
		
			local coords = WendigoAncient01:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(wendigoAncient01Id, WendigoAncient01StateObjects, Character, WendigoAncient01CharacterCreateArgs, MPOverrideState, MPOverrideDbr1)
			
			wendigoAnceint01Spawned = true
			
		end
			
		if (WendigoAncient02 != nil) then
		
			local coords = WendigoAncient02:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(wendigoAncient02Id, WendigoAncient02StateObjects, Character, WendigoAncient02CharacterCreateArgs, MPOverrideState, MPOverrideDbr2)
			
			wendigoAnceint02Spawned = true
			
		end
		
		if (WendigoAncient03 != nil) then
			
			local coords = WendigoAncient03:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(wendigoAncient03Id, WendigoAncient03StateObjects, Character, WendigoAncient03CharacterCreateArgs, MPOverrideState, MPOverrideDbr3)	
			
			wendigoAnceint03Spawned = true
			
		end

	end

end


--
-- Side Quest 02 - Wendigo Captives
--
local captive01Ids = {0, 0}
local captive02Ids = {0, 0}

local captive01StateObjects = { }
local captive02StateObjects = { }

local travelerRescuePortal01 = false
local travelerRescuePortal02 = false
local travelersActivated = false

local TravelerRescueState = { NotSpawned = 0, Captive = 1, Town = 2}

-- Wendigo Captive 01
local Traveler01CaptiveStateObjects = orderedTable();
	Traveler01CaptiveStateObjects["AREAE_TRAVELERS01_RESCUED"] = { state = TravelerRescueState.Town, dbr = nil }
	Traveler01CaptiveStateObjects["AREAE_TRAVELERS_CAPTIVE"] = { state = TravelerRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_01.dbr" }
	Traveler01CaptiveStateObjects[""] = { state = TravelerRescueState.NotSpawned, dbr = nil }

function gd.quests.areaEQuestFactionWendigo.Traveler01CaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[1] = objectId
		captive01StateObjects[1] = Traveler01CaptiveStateObjects
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if travelersActivated && not travelerRescuePortal01 then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_01.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Traveler01CaptiveStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.Traveler01CaptiveOnDestroy = ClearObjectUserdata

-- Wendigo Captive 02
local Traveler02CaptiveStateObjects = orderedTable();
	Traveler02CaptiveStateObjects["AREAE_TRAVELERS01_RESCUED"] = { state = TravelerRescueState.Town, dbr = nil }
	Traveler02CaptiveStateObjects["AREAE_TRAVELERS_CAPTIVE"] = { state = TravelerRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_02.dbr" }
	Traveler02CaptiveStateObjects[""] = { state = TravelerRescueState.NotSpawned, dbr = nil }

function gd.quests.areaEQuestFactionWendigo.Traveler02CaptiveOnAddToWorld(objectId)

	if Server then
		captive01Ids[2] = objectId
		captive01StateObjects[2] = Traveler02CaptiveStateObjects
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if travelersActivated && not travelerRescuePortal01 then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_02.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Traveler02CaptiveStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.Traveler02CaptiveOnDestroy = ClearObjectUserdata

-- Wendigo Captive 03
local Traveler03CaptiveStateObjects = orderedTable();
	Traveler03CaptiveStateObjects["AREAE_TRAVELERS02_RESCUED"] = { state = TravelerRescueState.Town, dbr = nil }
	Traveler03CaptiveStateObjects["AREAE_TRAVELERS_CAPTIVE"] = { state = TravelerRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_03.dbr"}
	Traveler03CaptiveStateObjects[""] = { state = TravelerRescueState.NotSpawned, dbr = nil}

function gd.quests.areaEQuestFactionWendigo.Traveler03CaptiveOnAddToWorld(objectId)

	if Server then
		captive02Ids[1] = objectId
		captive02StateObjects[1] = Traveler03CaptiveStateObjects
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if travelersActivated && not travelerRescuePortal02 then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_03.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Traveler03CaptiveStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.Traveler03CaptiveOnDestroy = ClearObjectUserdata


-- Wendigo Captive 04
local Traveler04CaptiveStateObjects = orderedTable();
	Traveler04CaptiveStateObjects["AREAE_TRAVELERS02_RESCUED"] = { state = TravelerRescueState.Town, dbr = nil }
	Traveler04CaptiveStateObjects["AREAE_TRAVELERS_CAPTIVE"] = { state = TravelerRescueState.Captive, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_04.dbr" }
	Traveler04CaptiveStateObjects[""] = { state = TravelerRescueState.NotSpawned, dbr = nil}

function gd.quests.areaEQuestFactionWendigo.Traveler04CaptiveOnAddToWorld(objectId)

	if Server then
		captive02Ids[2] = objectId
		captive02StateObjects[2] = Traveler04CaptiveStateObjects
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if travelersActivated && not travelerRescuePortal02 then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_04.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Traveler04CaptiveStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWendigo.Traveler04CaptiveOnDestroy = ClearObjectUserdata

-- bestow token for travelers 01
function gd.quests.areaEQuestFactionWendigo.TravelersRescued01GlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xE88AE000
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_TRAVELERS01_RESCUED") == false) then
		GiveTokenToLocalPlayer("AREAE_TRAVELERS01_RESCUED")
	end

end

-- Activated by conversation with rescue group 01
function gd.quests.areaEQuestFactionWendigo.TravelersGroup01Rescue()

	if Server then
		local player = Game.GetLocalPlayer()
		local kQuest = 0xE88AE000
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
		if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_TRAVELERS01_RESCUED") == false) then
			GiveTokenToLocalPlayer("AREAE_TRAVELERS01_RESCUED")
		end
		
		QuestGlobalEvent("WendigoTravelers01Rescued")
		
		local MPOverrideDbr = nil
		local MPOverrideState = true
		
		if not travelerRescuePortal01 then
			travelerRescuePortal01 = true
			
			local captivesTotal = table.getn(captive01Ids)
		
			for id = 1, captivesTotal do
				local NPCEntity = Entity.Get(captive01Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(captive01Ids[id], captive01StateObjects[id], nil, nil, MPOverrideState, MPOverrideDbr)
					
				end
			
			end
		
		end
		
	end
	
end

--
-- Activated by conversation with rescue group 02
--
function gd.quests.areaEQuestFactionWendigo.TravelersRescued02GlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xE88AE000
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_TRAVELERS02_RESCUED") == false) then
		GiveTokenToLocalPlayer("AREAE_TRAVELERS02_RESCUED")
	end

end

function gd.quests.areaEQuestFactionWendigo.TravelersGroup02Rescue()

	if Server then
		local player = Game.GetLocalPlayer()
		local kQuest = 0xE88AE000
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
		if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_TRAVELERS02_RESCUED") == false) then
			GiveTokenToLocalPlayer("AREAE_TRAVELERS02_RESCUED")
		end
		
		QuestGlobalEvent("WendigoTravelers02Rescued")
		
		local MPOverrideDbr = nil
		local MPOverrideState = true
	
		if not travelerRescuePortal02 then
			travelerRescuePortal02 = true
			
			local captivesTotal = table.getn(captive02Ids)
		
			for id = 1, captivesTotal do
				local NPCEntity = Entity.Get(captive02Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(captive02Ids[id], captive02StateObjects[id], nil, nil, MPOverrideState, MPOverrideDbr)
					
				end
			
			end
		
		end
		
	end
	
end

-- Initial update to make travelers appear
function gd.quests.areaEQuestFactionWendigo.activateTravelers()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if not travelersActivated then
			travelersActivated = true
			
			local captives01Total = table.getn(captive01Ids)
			local captives02Total = table.getn(captive02Ids)
			
			local MPOverrideDbrSet01 = {"records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_01.dbr", "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_02.dbr"}
			local MPOverrideDbrSet02 = {"records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_03.dbr", "records/creatures/npcs/questnpcs/gdareae/npc_travelercaptive_04.dbr"}
			local MPOverrideState = true
			
			for id = 1, captives01Total do
				local NPCEntity = Entity.Get(captive01Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(captive01Ids[id], captive01StateObjects[id], nil, nil, MPOverrideState, MPOverrideDbrSet01[id])
					
				end
			
			end
			
			for id = 1, captives02Total do
				local NPCEntity = Entity.Get(captive02Ids[id])
				
				if (NPCEntity != nil) then
					local coords = NPCEntity:GetCoords()
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
			
					UpdateObjectSwap(captive02Ids[id], captive02StateObjects[id], nil, nil, MPOverrideState, MPOverrideDbrSet02[id])
					
				end
			
			end

		end
		
	end
	
end



