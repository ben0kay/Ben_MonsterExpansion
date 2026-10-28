/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGSolaelQuests = {}


--
-- Source of Power Chest
--
local solaelChestId = 0
local solaelChestEntity = nil
local spawnedChest = false
local questChestSpawned = false
local chestTransition = false

local ChestState = { Default = 0, Spawned = 1 }

local solaelChestStateObjects = orderedTable()
	solaelChestStateObjects["AREAG_POWEROFSOLAEL_CHEST"	] = { state = ChestState.Spawned,  dbr = "records/items/lootchests/questchests/questchest_areag_solaelpower.dbr"}
	solaelChestStateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/c01_chestkorvansarcophagus_solaelpower.dbr"}

function gd.quests.areaGSolaelQuests.chestOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false

		local kQuest = 0x5F806100
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
		-- if chest hasn't already been spawned as the quest chest and needs to be, destroy any existing treasure chests and reset the spawnedChest variable
		if player:AnyoneHasToken("AREAG_POWEROFSOLAEL_CHEST") && questTaskState != QuestState.Complete && not chestTransition && not questChestSpawned then
			if solaelChestEntity != nil then
				solaelChestEntity:Destroy()
			end
			
			spawnedChest = false
			questChestSpawned = true
			
			MPOverrideDbr = "records/items/lootchests/questchests/questchest_areag_solaelpower.dbr"
			MPOverrideState = true
		
		end
		
		if (not spawnedChest) then
			solaelChestId = objectId

			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, solaelChestStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn chest next time. If spawned as chest, saved into world
			spawnedChest = true
			
		end
		
	end
	
end

function gd.quests.areaGSolaelQuests.chestAlternateOnAddToWorld(objectId)
	if Server then
		solaelChestEntity = Entity.Get(solaelChestId)
	
	end

end

gd.quests.areaGSolaelQuests.chestOnDestroy = ClearObjectUserdata

function gd.quests.areaGSolaelQuests.chestSpawn()
	if Server && not chestTransition then
		local player = Game.GetLocalPlayer()

		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_POWEROFSOLAEL_CHEST") == false) then
			MPOverrideDbr = "records/items/lootchests/questchests/questchest_areag_solaelpower.dbr"
			MPOverrideState = true
		end
		
		local entity = Entity.Get(solaelChestId)
		
		if entity != nil then
			if solaelChestEntity != nil then
				solaelChestEntity:Destroy()
			end
		
			UpdateObjectSwap(solaelChestId, solaelChestStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			spawnedChest = true
			chestTransition = true
		
		end
	
	end

end


--
-- Executing the weak
--

-- Create Args For Hostile NPCs
local function CharacterCreateArgs()

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
		monsterLevel = ((maxLevel+(maxLevel/50))+1)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+1)

	end

	return monsterLevel, nil
	
end

-- Credit For NPC Kills
local function NPCKillCredit()

	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("AREAG_SOLAELWEAK_A_KILLED") && (player:HasToken("AREAG_SOLAELWEAK_B_KILLED"))) then
		player:GiveToken("AREAG_SOLAELWEAK_C_KILLED")
	elseif (player:HasToken("AREAG_SOLAELWEAK_A_KILLED")) then
		player:GiveToken("AREAG_SOLAELWEAK_B_KILLED")
	else
		player:GiveToken("AREAG_SOLAELWEAK_A_KILLED")
	end
	
end

local NPC01Id = 0
local NPC01Hostile = false
local NPC02Id = 0
local NPC02Hostile = false
local NPC03Id = 0
local NPC03Hostile = false
local NPC04Id = 0
local NPC04Hostile = false
local NPC05Id = 0
local NPC05Hostile = false

local CleanseTheWeakState = { Default = 0, Hostile = 1, Dead = 2} 

-- NPC 01 
local NPC01IdStateObjects = orderedTable();
	NPC01IdStateObjects["AREAG_SOLAELWEAK_01_KILLED"] = { state = CleanseTheWeakState.Dead, dbr = nil}
	NPC01IdStateObjects["AREAG_SOLAELWEAK_01_CHOSEN"] = { state = CleanseTheWeakState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaelweak_01.dbr" }
	NPC01IdStateObjects[""] = { state = CleanseTheWeakState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaelweakflavor_01.dbr"}
	
function gd.quests.areaGSolaelQuests.cleanseTheWeakNPC01OnAddToWorld(objectId)

	if Server then
		if not NPC01Hostile then
			NPC01Id = objectId
		
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, NPC01IdStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata);
			
			-- Don't respawn if spawned as hostile
			if (newState == CleanseTheWeakState.Hostile) then
				NPC01Hostile = true
			end
			
		end
		
	end
	
end	
	
gd.quests.areaGSolaelQuests.cleanseTheWeakNPC01OnDestroy = ClearObjectUserdata

-- NPC 01 Global Token Grant
function gd.quests.areaGSolaelQuests.solaelWeakChose01MP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_SOLAELWEAK_01_CHOSEN")
	end
	
end

-- NPC 01 Transition
function gd.quests.areaGSolaelQuests.transitionNPC01()

	if Server && not NPC01Hostile then

		local NPC01 = Entity.Get(NPC01Id)
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (NPC01 != nil) then
			if (player:HasToken("AREAG_SOLAELWEAK_01_CHOSEN") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/human_solaelweak_01.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(NPC01Id, NPC01IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
			NPC01Hostile = true
			
			QuestGlobalEvent("solaelWeakChose01")
			
		end
	
	end
	
end

function gd.quests.areaGSolaelQuests.NPC01Killed()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		player:GiveToken("AREAG_SOLAELWEAK_01_KILLED")
	
		NPCKillCredit()
		
	end
	
end

-- NPC 02 
local NPC02IdStateObjects = orderedTable();
	NPC02IdStateObjects["AREAG_SOLAELWEAK_02_KILLED"] = { state = CleanseTheWeakState.Dead, dbr = nil}
	NPC02IdStateObjects["AREAG_SOLAELWEAK_02_CHOSEN"] = { state = CleanseTheWeakState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaelweak_02.dbr" }
	NPC02IdStateObjects[""] = { state = CleanseTheWeakState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaelweakflavor_02.dbr"}
	
function gd.quests.areaGSolaelQuests.cleanseTheWeakNPC02OnAddToWorld(objectId)

	if Server then
		if not NPC02Hostile then
			NPC02Id = objectId
		
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, NPC02IdStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata);
			
			-- Don't respawn if spawned as hostile
			if (newState == CleanseTheWeakState.Hostile) then
				NPC02Hostile = true
			end
			
		end
		
	end
	
end	
	
gd.quests.areaGSolaelQuests.cleanseTheWeakNPC02OnDestroy = ClearObjectUserdata

-- NPC 02 Global Token Grant
function gd.quests.areaGSolaelQuests.solaelWeakChose02MP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_SOLAELWEAK_02_CHOSEN")
	end

end

-- NPC 02 Transition
function gd.quests.areaGSolaelQuests.transitionNPC02()

	if Server && not NPC02Hostile then

		local NPC02 = Entity.Get(NPC02Id)
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (NPC02 != nil) then
			if (player:HasToken("AREAG_SOLAELWEAK_02_CHOSEN") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/human_solaelweak_02.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(NPC02Id, NPC02IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
			NPC02Hostile = true
			
			QuestGlobalEvent("solaelWeakChose02")
			
		end
	
	end
	
end

function gd.quests.areaGSolaelQuests.NPC02Killed()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		player:GiveToken("AREAG_SOLAELWEAK_02_KILLED")
	
		NPCKillCredit()
		
	end
	
end

-- NPC 03 
local NPC03IdStateObjects = orderedTable();
	NPC03IdStateObjects["AREAG_SOLAELWEAK_03_KILLED"] = { state = CleanseTheWeakState.Dead, dbr = nil}
	NPC03IdStateObjects["AREAG_SOLAELWEAK_03_CHOSEN"] = { state = CleanseTheWeakState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaelweak_03.dbr" }
	NPC03IdStateObjects[""] = { state = CleanseTheWeakState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaelweakflavor_03.dbr"}
	
function gd.quests.areaGSolaelQuests.cleanseTheWeakNPC03OnAddToWorld(objectId)

	if Server then
		if not NPC03Hostile then
			NPC03Id = objectId
		
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, NPC03IdStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata);
			
			-- Don't respawn if spawned as hostile
			if (newState == CleanseTheWeakState.Hostile) then
				NPC03Hostile = true
			end
			
		end
		
	end
	
end	
	
gd.quests.areaGSolaelQuests.cleanseTheWeakNPC03OnDestroy = ClearObjectUserdata

-- NPC 03 Global Token Grant
function gd.quests.areaGSolaelQuests.solaelWeakChose03MP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_SOLAELWEAK_03_CHOSEN")
	end

end

-- NPC 03 Transition
function gd.quests.areaGSolaelQuests.transitionNPC03()

	if Server && not NPC03Hostile then

		local NPC03 = Entity.Get(NPC03Id)
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (NPC03 != nil) then
			if (player:HasToken("AREAG_SOLAELWEAK_03_CHOSEN") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/human_solaelweak_03.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(NPC03Id, NPC03IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
			NPC03Hostile = true
			
			QuestGlobalEvent("solaelWeakChose03")
			
		end
	
	end
	
end

function gd.quests.areaGSolaelQuests.NPC03Killed()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		player:GiveToken("AREAG_SOLAELWEAK_03_KILLED")
	
		NPCKillCredit()
		
	end
	
end

-- NPC 04 
local NPC04IdStateObjects = orderedTable();
	NPC04IdStateObjects["AREAG_SOLAELWEAK_04_KILLED"] = { state = CleanseTheWeakState.Dead, dbr = nil}
	NPC04IdStateObjects["AREAG_SOLAELWEAK_04_CHOSEN"] = { state = CleanseTheWeakState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaelweak_04.dbr" }
	NPC04IdStateObjects[""] = { state = CleanseTheWeakState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaelweakflavor_04.dbr"}
	
function gd.quests.areaGSolaelQuests.cleanseTheWeakNPC04OnAddToWorld(objectId)

	if Server then
		if not NPC04Hostile then
			NPC04Id = objectId
		
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, NPC04IdStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata);
			
			-- Don't respawn if spawned as hostile
			if (newState == CleanseTheWeakState.Hostile) then
				NPC04Hostile = true
			end
			
		end
		
	end
	
end	
	
gd.quests.areaGSolaelQuests.cleanseTheWeakNPC04OnDestroy = ClearObjectUserdata

-- NPC 04 Global Token Grant
function gd.quests.areaGSolaelQuests.solaelWeakChose04MP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_SOLAELWEAK_04_CHOSEN")
	end

end

-- NPC 04 Transition
function gd.quests.areaGSolaelQuests.transitionNPC04()

	if Server && not NPC04Hostile then

		local NPC04 = Entity.Get(NPC04Id)
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (NPC04 != nil) then
			if (player:HasToken("AREAG_SOLAELWEAK_04_CHOSEN") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/human_solaelweak_04.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(NPC04Id, NPC04IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
			NPC04Hostile = true
			
			QuestGlobalEvent("solaelWeakChose04")
			
		end
	
	end
	
end

function gd.quests.areaGSolaelQuests.NPC04Killed()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		player:GiveToken("AREAG_SOLAELWEAK_04_KILLED")
	
		NPCKillCredit()
		
	end
	
end

-- NPC 05 
local NPC05IdStateObjects = orderedTable();
	NPC05IdStateObjects["AREAG_SOLAELWEAK_05_KILLED"] = { state = CleanseTheWeakState.Dead, dbr = nil}
	NPC05IdStateObjects["AREAG_SOLAELWEAK_05_CHOSEN"] = { state = CleanseTheWeakState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaelweak_05.dbr" }
	NPC05IdStateObjects[""] = { state = CleanseTheWeakState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaelweakflavor_05.dbr"}
	
function gd.quests.areaGSolaelQuests.cleanseTheWeakNPC05OnAddToWorld(objectId)

	if Server then
		if not NPC05Hostile then
			NPC05Id = objectId
		
			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, NPC05IdStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == CleanseTheWeakState.Hostile) then
				NPC05Hostile = true
			end
			
		end
		
	end
	
end	
	
gd.quests.areaGSolaelQuests.cleanseTheWeakNPC05OnDestroy = ClearObjectUserdata

-- NPC 05 Global Token Grant
function gd.quests.areaGSolaelQuests.solaelWeakChose05MP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_SOLAELWEAK_05_CHOSEN")
	end

end

-- NPC 05 Transition
function gd.quests.areaGSolaelQuests.transitionNPC05()

	if Server && not NPC05Hostile then

		local NPC05 = Entity.Get(NPC05Id)
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (NPC05 != nil) then
			if (player:HasToken("AREAG_SOLAELWEAK_05_CHOSEN") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/human_solaelweak_05.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(NPC05Id, NPC05IdStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
			NPC05Hostile = true
			
			QuestGlobalEvent("solaelWeakChose05")
			
		end
	
	end
	
end

function gd.quests.areaGSolaelQuests.NPC05Killed()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x5F806100
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		player:GiveToken("AREAG_SOLAELWEAK_05_KILLED")
	
		NPCKillCredit()
		
	end
	
end


--
-- Bloodied Wastes Rift
--
local SolaelRiftState = { Default = 0, Started = 1, Opened = 2}
local lockedVoidRiftId = 0
local riftOpened = false
local npcId = 0
local npcSpawned = false

local lockedVoidShortcutRift = 0
local shortcutRiftOpened = false

-- Interaction Site
local solaelAltarInteractionSite = orderedTable();
	solaelAltarInteractionSite["AREAG_SOLAELRIFT_OPENED"] = { state = SolaelRiftState.Opened,  dbr = nil }
	solaelAltarInteractionSite["AREAG_SOLAELRIFT_STARTED"] = { state = SolaelRiftState.Started, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelrift.dbr" }
	solaelAltarInteractionSite[""] = { state = SolaelRiftState.Default, dbr = nil }

function gd.quests.areaGSolaelQuests.interactionSiteOnAddToWorld(objectId)
	
	if Server && not riftOpened then
		local player = Game.GetLocalPlayer()
		npcId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (npcSpawned || player:AnyoneHasToken("AREAG_SOLAELRIFT_STARTED")) && not player:HasToken("AREAG_SOLAELRIFT_OPENED") then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelrift.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, solaelAltarInteractionSite, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGSolaelQuests.interactionSiteOnDestroy = ClearObjectUserdata

function gd.quests.areaGSolaelQuests.spawnInteractionSite()

	if Server && not npcSpawned then
		npcSpawned = true
		
		local player = Game.GetLocalPlayer()
		
		local npc = Entity.Get(npcId)
		
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_SOLAELRIFT_STARTED") == false && not player:HasToken("AREAG_SOLAELRIFT_OPENED")) then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelrift.dbr"
			MPOverrideState = true
		end

		if (npc != nil) then
			local coords = npc:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(npcId, solaelAltarInteractionSite, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end	
	
	end
	
end

-- Rift
function gd.quests.areaGSolaelQuests.lockedChaosRiftOnAddToWorld(objectId)
	
	if Server then
		
		local player = Game.GetLocalPlayer()
		lockedVoidRiftId = objectId
		
		if (player:HasToken("AREAG_SOLAELRIFT_OPENED") || riftOpened) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				riftOpened = true
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

function gd.quests.areaGSolaelQuests.lockedShortcutRiftOnAddToWorld(objectId)
	
	if Server then
		lockedVoidShortcutRift = objectId

		if shortcutRiftOpened then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

-- Open The Rift
function gd.quests.areaGSolaelQuests.RiftOpened()

	if Server then
		local player = Game.GetLocalPlayer()
		riftOpened= true
		
		local door = Door.Get(lockedVoidRiftId)
			
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/skillsother/fxpak_attackradius_riftblast01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
	end
	
end

-- Eldritch Lizard Death
function gd.quests.areaGSolaelQuests.OpenShortcutRift()

	if Server then
		local player = Game.GetLocalPlayer()
		
		local door = Door.Get(lockedVoidShortcutRift)
			
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			shortcutRiftOpened= true
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/skillsother/fxpak_attackradius_riftblast01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
	end
	
end


