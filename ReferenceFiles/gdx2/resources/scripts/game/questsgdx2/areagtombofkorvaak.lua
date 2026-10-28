/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGTombOfKorvaak = {}

--
-- The Tomb Entrance
--

-- Grant token to all on the quest
function gd.quests.areaGTombOfKorvaak.korvaakTombEntranceTokenMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x8E684000
	local kTask = 0x4C397380
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_KORVAAKTOMB_FOUND")
	end
	
end

-- The player hits the tomb entrance trigger
function gd.quests.areaGTombOfKorvaak.korvaakTombEntranceFound()

	QuestGlobalEvent("korvaakTombEntranceToken")

end

--
-- Daila's Pendant - This respawns as long as the player is still on the quest "A Mothers Gift"
--
local DailaPendantState = {Default = 0, OnQuest = 1, QuestFinished = 2}

local DailaPendantId = 0
local pendantSpawned = false

-- Daila's Pendant
local dailaPendant01StateObjects = orderedTable();
	dailaPendant01StateObjects["AREAG_DAILAQUESTCOMPLETE"] = { state = DailaPendantState.QuestFinished, dbr = nil}
	dailaPendant01StateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DailaPendantState.OnQuest, dbr = "records/items/lootchests/questchests/questchest_areag_uroboruukpendant.dbr"}
	dailaPendant01StateObjects[""] = { state = DailaPendantState.Default, dbr = nil}

function gd.quests.areaGTombOfKorvaak.dailaPendantOnAddToWorld(objectId)
	
	if Server && not pendantSpawned then
		DailaPendantId = objectId
		
		local userdata = {};
		
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, dailaPendant01StateObjects)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn chest. If spawned as chest, saved into world
		if (newState == DailaPendantState.OnQuest) then
			pendantSpawned = true
			
		end
	
	end
	
end

gd.quests.areaGTombOfKorvaak.dailaPendantOnDestroy = ClearObjectUserdata

-- Spawn Daila's Necklace at the end of the door sequence, if applicable
function gd.quests.areaGTombOfKorvaak.spawnNecklace()
	
	if Server && not pendantSpawned then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_DAILAQUESTCOMPLETE") == false then
			local pendantEntity = Entity.Get(DailaPendantId)

			if (pendantEntity != nil) then
			
				local MPOverrideDbr = "records/items/lootchests/questchests/questchest_areag_uroboruukpendant.dbr"
				local MPOverrideState = true
			
				UpdateObjectSwap(DailaPendantId, dailaPendant01StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
				
				pendantSpawned = true
				
			end
		
		end
		
	end
	
end

function gd.quests.areaGTombOfKorvaak.lootAmulet(looterId, itemId)

	if looterId == Game.GetLocalPlayer():GetId() then
		local kQuest = 0xC5710500
		local kTask  = 0x1501C060
		local player = Player.Get(looterId)
		
		local questState = player:GetQuestState(kQuest)

		if ((player != nil) && (questState == QuestState.Available)) then
			player:GrantQuest(kQuest, kTask)
			
		end
	
	end
	
end


-- 
-- Uroboruuk and Dravis
--

local UroboruukState = {Default = 0, OnQuest = 1, DravisKilled = 2, DoorUnlock = 3}

local uroboruukId = 0
local uroboruukTransition = false
local uroboruukSpawned = false

-- Uroboruuk
local uroboruuk01StateObjects = orderedTable();
	uroboruuk01StateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = UroboruukState.DoorUnlock, dbr = nil}
	uroboruuk01StateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = UroboruukState.OnQuest, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_uroboruuk_01.dbr"}
	uroboruuk01StateObjects[""] = { state = UroboruukState.Default, dbr = nil}

function gd.quests.areaGTombOfKorvaak.uroboruuk01OnAddToWorld(objectId)
	
	if Server then
		uroboruukId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, uroboruuk01StateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGTombOfKorvaak.uroboruuk01OnDestroy = ClearObjectUserdata

-- Uroboruuk initial transition
function gd.quests.areaGTombOfKorvaak.uroboruukTransition()
	
	if Server && not uroboruukTransition then
	
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_STARTED") then
	
			uroboruukTransition = true
			uroboruukSpawned = true
			
			local Uroboruuk = Entity.Get(uroboruukId)
		
			if (Uroboruuk != nil) then
			
				local coords = Uroboruuk:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(uroboruukId, uroboruuk01StateObjects)
			
			end
			
		end

	end

end

local function DummyCreateArgs()

	return 1, nil
	
end

-- Uroboruuk unlocks the door
function gd.quests.areaGTombOfKorvaak.uroboruukOpenTransition()

	if Server then
		local MPOverrideDbr = "records/creatures/enemies/faction/uroboruuk_doorsequence.dbr"
		local MPOverrideState = true

		UpdateObjectSwap(uroboruukId, uroboruuk01StateObjects, Character, DummyCreateArgs, MPOverrideState, MPOverrideDbr)
		
		uroboruukSpawned = true		
		
	end
	
end


--
-- Dravis 
--
local DravisBossId = 0
local DravisBossSpawned = false
local DravisTransition = false

local DravisState = {Default = 0, Talk = 1, Hostile = 2, Dead = 3, Finished = 4}

local dravisBossStateObjects = orderedTable();
	dravisBossStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DravisState.Finished, dbr = nil}
	dravisBossStateObjects["AREAG_KORVAAKTOMB_DRAVISKILLED"] = { state = DravisState.Dead,  dbr = nil }
	dravisBossStateObjects["AREAG_KORVAAKTOMB_DRAVISHOSTILE"] = { state = DravisState.Hostile,  dbr = "records/creatures/enemies/boss&quest/dravis.dbr" }
	dravisBossStateObjects["AREAG_KORVAAKTOMB_STARTED"] = { state = DravisState.Talk,  dbr = "records/creatures/npcs/questnpcs/gdareag/npc_dravis_01.dbr" }
	dravisBossStateObjects[""] = { state = DravisState.Default, dbr = nil }

local function DravisCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(DravisBossId):GetCoords().origin

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
	
function gd.quests.areaGTombOfKorvaak.dravisBossOnAddToWorld(objectId)

	if Server then
	
		if (DravisBossSpawned == false) then

			DravisBossId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, dravisBossStateObjects, Character, DravisCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == DravisState.Hostile)then
				DravisBossSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaGTombOfKorvaak.dravisBossOnDestroy = ClearObjectUserdata

-- Dravis initial transition
function gd.quests.areaGTombOfKorvaak.dravisTransition()
	
	if Server && not DravisBossSpawned && not DravisTransition then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_STARTED") then
			DravisTransition = true
	
			local Dravis = Entity.Get(DravisBossId)
		
			if (Dravis != nil) then
			
				local coords = Dravis:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(DravisBossId, dravisBossStateObjects)
			
			end
			
		end

	end

end

-- Dravis hostile transition - called by conversation with dravis
function gd.quests.areaGTombOfKorvaak.dravisHostileSwitchGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x8E684000
	local kTask = 0x3ED039C0
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) && player:HasToken("AREAG_KORVAAKTOMB_DRAVISKILLED") == false && player:HasToken("AREAG_KORVAAKTOMB_UNLOCKED") == false then
		player:GiveToken("AREAG_KORVAAKTOMB_DRAVISHOSTILE")
	
	end

end

function gd.quests.areaGTombOfKorvaak.dravisHostileSwitch()
	
	if Server then
		if not DravisBossSpawned then
			DravisBossSpawned = true
			
			QuestGlobalEvent("dravisHostileSwitchGlobalMP")
	
			local MPOverrideDbr = "records/creatures/enemies/boss&quest/dravis.dbr"
			local MPOverrideState = true

			UpdateObjectSwap(DravisBossId, dravisBossStateObjects, Character, DravisCreateArgs, MPOverrideState, MPOverrideDbr)
		
		end
	
	end

end

-- Dravis is Killed
function gd.quests.areaGTombOfKorvaak.DravisKilled()
	
	local player = Game.GetLocalPlayer()
	local kQuest = 0x8E684000
	local kTask = 0x3ED039C0
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) then
			player:RemoveToken("AREAG_KORVAAKTOMB_DRAVISHOSTILE")
			GiveTokenToLocalPlayer("AREAG_KORVAAKTOMB_DRAVISKILLED")
	end

end

-- Dravis After Tomb is Unlocked
local DravisBossUnlockedId = 0

local dravisBossUnlockedStateObjects = orderedTable();
	dravisBossUnlockedStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = DravisState.Finished, dbr = "records/creatures/enemies/boss&quest/dravis.dbr"}
	dravisBossUnlockedStateObjects[""] = { state = DravisState.Default, dbr = nil }

local function DravisUnlockedCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(DravisBossUnlockedId):GetCoords().origin

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
	
function gd.quests.areaGTombOfKorvaak.dravisBossUnlockedOnAddToWorld(objectId)

	if Server then
	
		if (DravisBossSpawned == false) then

			DravisBossUnlockedId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, dravisBossUnlockedStateObjects, Character, DravisUnlockedCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == DravisState.Finished)then
				DravisBossSpawned = true
			end
			
		end
		
	end
	
end

--
-- Temple guardian
--
local TempleDoorState = {Default = 0, Active = 1, Open = 2}

local TempleGuardId = 0
local TempleguardSpawned = false

local TempleGuardStateObjects = orderedTable();
	TempleGuardStateObjects["AREAG_KORVAAKTOMB_OPENED"] = { state = TempleDoorState.Open,  dbr = "records/creatures/enemies/boss&quest/statue_korvaaktombguardian.dbr"}
	TempleGuardStateObjects["AREAG_KORVAAKTOMB_GUARDIANSPAWNED"] = { state = TempleDoorState.Active,  dbr = "records/creatures/enemies/boss&quest/statue_korvaaktombguardian.dbr"}
	TempleGuardStateObjects[""] = { state = TempleDoorState.Default, dbr = nil }

local function GuardianCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(TempleGuardId):GetCoords().origin

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
	
function gd.quests.areaGTombOfKorvaak.templeGuardOnAddToWorld(objectId)

	if Server && not TempleguardSpawned then
	
		TempleGuardId = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, TempleGuardStateObjects, Character, GuardianCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as hostile
		if (newState == TempleDoorState.Active || newState == TempleDoorState.Open) then
			TempleguardSpawned = true
		end
		
	end
	
end

gd.quests.areaGTombOfKorvaak.templeGuardOnDestroy = ClearObjectUserdata

local function tombGuardInitialSpawn()

	if Server && not TempleguardSpawned then
	
		TempleguardSpawned = true

		local MPOverrideDbr = "records/creatures/enemies/boss&quest/statue_korvaaktombguardian.dbr"
		local MPOverrideState = true

		UpdateObjectSwap(TempleGuardId, TempleGuardStateObjects, Character, GuardianCreateArgs, MPOverrideState, MPOverrideDbr)
	
	end

end

-- Tomb guardian exit door
local TombGuardDoor01Open = false
local TombGuardDoor01Id = 0

function gd.quests.areaGTombOfKorvaak.tombGuardDoorInitialUpdate(objectId)
	
	if Server && TombGuardDoor01Open then
		local door = Door.Get(objectId)
		
		door01:SetLocked(false)
		door01:Open()
	
	end
	
end

function gd.quests.areaGTombOfKorvaak.tombGuardDoorOnAddToWorld(objectId)
	
	if Server then
		TombGuardDoor01Id = objectId
		
	end
	
end

-- When tomb guardian is killed, open the door
function gd.quests.areaGTombOfKorvaak.tombGuardKilled()

	if Server then
		
		local door01 = Door.Get(TombGuardDoor01Id)
		
		TombGuardDoor01Open = true
		
		if door01 != nil then
			door01:SetLocked(false)
			door01:Open()
			
		end
		
	end
	
end


-- Door/Barricade setup 
local KorvaakDoorBlockadeId = 0
local spawnedKorvaakDoorBlockade = false

local KorvaakDoorBlockadeStateObjects = orderedTable();
	KorvaakDoorBlockadeStateObjects["AREAG_KORVAAKTOMB_OPENED"] = { state = TempleDoorState.Open,  dbr = nil }
	KorvaakDoorBlockadeStateObjects["AREAG_KORVAAKTOMB_GUARDIANSPAWNED"] = { state = TempleDoorState.Active,  dbr = nil }
	KorvaakDoorBlockadeStateObjects[""] = { state = TempleDoorState.Default, dbr = "records/storyelementsgdx2/questassets/areag_korvaaktomb_door_break.dbr"}

function gd.quests.areaGTombOfKorvaak.korvaakDoorBlockadeOnAddToWorld(objectId)

	if Server then

		if (not spawnedKorvaakDoorBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, KorvaakDoorBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	
			spawnedKorvaakDoorBlockade = true

		end
		
	end
	
end

gd.quests.areaGTombOfKorvaak.korvaakDoorBlockadeOnDestroy = ClearObjectUserdata

function gd.quests.areaGTombOfKorvaak.korvaakDoorAvatarOnAddToWorld(objectId)
	
	if Server then
		KorvaakDoorBlockadeId = objectId
	
	end
	
end

--
-- Destroy Blockade & transition the guardian
--

-- The player hits the door/barricade destroy trigger
function gd.quests.areaGTombOfKorvaak.korvaakTombEntranceTrigger()

	QuestEvent("korvaakTombEntranceDestroy")

end

-- Token for clearing the barricade
function gd.quests.areaGTombOfKorvaak.korvaakDoorBlockadeDestroyGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x85B30C00
	local kTask = 0x36CD9D00
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_KORVAAKTOMB_GUARDIANSPAWNED")
		
	end

end

function gd.quests.areaGTombOfKorvaak.korvaakTombEntranceDestroy()

	if Server && not uroboruukSpawned then
		print "DOOR TRIGGERED"
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_UNLOCKED") && KorvaakDoorBlockadeId != 0 then
			print "DOOR EXPLODE"
			local Blockade = Destructible.Get(KorvaakDoorBlockadeId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			KorvaakDoorBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
			tombGuardInitialSpawn()
			
			QuestGlobalEvent("KorvaakTombBarricadeToken")
			
		end

	end

end

-- Initial Door FX
local KorvaakDoorFXId = 0
local KorvaakDoorFXSpawned = false

local KorvaakDoorFXStateObjects = orderedTable();
	KorvaakDoorFXStateObjects["AREAG_KORVAAKTOMB_UNLOCKED"] = { state = TempleDoorState.Open,  dbr = nil }
	KorvaakDoorFXStateObjects[""] = { state = TempleDoorState.Default, dbr = "records/storyelementsgdx2/questassets/areag_korvaaktomb_doorfx_break.dbr" }

function gd.quests.areaGTombOfKorvaak.korvaakDoorFXOnAddToWorld(objectId)

	if Server && not KorvaakDoorFXSpawned then
		KorvaakDoorFXSpawned = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, KorvaakDoorFXStateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

function gd.quests.areaGTombOfKorvaak.korvaakDoorFXAvatarOnAddToWorld(objectId)
	
	if Server then
		KorvaakDoorFXId = objectId
	
	end
	
end

gd.quests.areaGTombOfKorvaak.korvaakDoorFXOnDestroy = ClearObjectUserdata


-- Transition Door FX
function gd.quests.areaGTombOfKorvaak.korvaakDoorFXTransition()
	
	if Server then
		local Blockade = Destructible.Get(KorvaakDoorFXId)
		Blockade:Destroy(Vec(0,1,0), 1000, false)
		KorvaakDoorFXId = 0
		
		-- Spawn Daila's Necklace
		gd.quests.areaGTombOfKorvaak.spawnNecklace()
		
		uroboruukSpawned = false
		
	end
	
end


-- Grant token to all on the quest
function gd.quests.areaGTombOfKorvaak.korvaakTombInsideGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x85B30C00
	local kTask = 0x36CD9D00
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_KORVAAKTOMB_OPENED")
	end
	
end

-- The player enters the tomb
function gd.quests.areaGTombOfKorvaak.korvaakTombInside()

	QuestGlobalEvent("korvaakTombInsideToken")

end

