/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGBysmielQuests = {}



--
-- Bysmiel 01
--
local questDropperSpawned = { false, false, false, false, false, false, false, false, false, false }

local function spawnQuestDropper(id)
	local entity = Entity.Get(id)
	
	if entity != nil then
		local coords = entity:GetCoords()	
		local proxy = Proxy.Create("records/proxies/boss&questgdx2/proxy_areag_bysmielquestdropper.dbr", coords.origin)
		
		proxy:SetCoords(coords)
	
	end

end 

function gd.quests.areaGBysmielQuests.bysmielQuestDropper01OnAddToWorld(objectId)

	if Server && not questDropperSpawned[1] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[1] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper02OnAddToWorld(objectId)

	if Server && not questDropperSpawned[2] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[2] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper03OnAddToWorld(objectId)

	if Server && not questDropperSpawned[3] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[3] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper04OnAddToWorld(objectId)

	if Server && not questDropperSpawned[4] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[4] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper05OnAddToWorld(objectId)

	if Server && not questDropperSpawned[5] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[5] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper06OnAddToWorld(objectId)

	if Server && not questDropperSpawned[6] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[6] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper07OnAddToWorld(objectId)

	if Server && not questDropperSpawned[7] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[7] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper08OnAddToWorld(objectId)

	if Server && not questDropperSpawned[8] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[8] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper09OnAddToWorld(objectId)

	if Server && not questDropperSpawned[9] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[9] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.bysmielQuestDropper10OnAddToWorld(objectId)

	if Server && not questDropperSpawned[10] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_BYSMIEL") then
			questDropperSpawned[10] = true
			spawnQuestDropper(objectId)			
		end
		
	end
	
end

--
-- Bysmiel 02 - The Veiled Den
--
-- Riftgate to DC
local lockedEldritchRift = 0
local riftOpened = false

local lockedEldritchShortcutRift = 0
local shortcutRiftOpened = false

-- Rift
function gd.quests.areaGBysmielQuests.lockedChaosRiftOnAddToWorld(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		lockedEldritchRift = objectId
		
		-- Unlock the door if the player has the token or the door variable is set, or if the host is not part of the Bysmiel faction but another player has the door unlocked
		if (player:HasToken("AREAG_BYSMIELQUESTRIFT_OPENED") || riftOpened == true || (player:AnyoneHasToken("AREAG_BYSMIELQUESTRIFT_OPENED") && not player:HasToken("AREAG_CHOSEFACTION_BYSMIEL"))) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()
				riftOpened= true

			end
		
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.lockedShortcutRiftOnAddToWorld(objectId)
	
	if Server then
		lockedEldritchShortcutRift = objectId

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
function gd.quests.areaGBysmielQuests.RiftOpened()

	if Server then
		local player = Game.GetLocalPlayer()
		
		local door = Door.Get(lockedEldritchRift)
			
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			riftOpened= true
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/eldritchrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
	end
	
end

-- Eldritch Hound Death
function gd.quests.areaGBysmielQuests.OpenShortcutRift()

	if Server then		
		local door = Door.Get(lockedEldritchShortcutRift)
			
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			shortcutRiftOpened= true
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/eldritchrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
	end
	
end


--
-- Bysmiel 03 - Summoning Ritual
--

local AltarRiftState = { Default = 0, Active = 1, Finished = 2}

local guardiansKilled = false

function gd.quests.areaGBysmielQuests.guardiansKilledCheck()
	
	return guardiansKilled

end

-- Temple Guardians
local Guardian01Id = 0
local Guardian02Id = 0
local Guardian03Id = 0
local guardian01Spawned = false
local guardian02Spawned = false
local guardian03Spawned = false

local AltGuardianId = 0
local Bloodsworn01Id = 0
local Bloodsworn02Id = 0
local Bloodsworn03Id = 0
local bloodswornChestSpawned = false
local bloodswornGuardianSpawned = false

-- Temple Altar Interaction Site
local npcId = 0
local npcSpawned = false
local bysmielAllySummoned = false

local AltarInteractionSiteStateObjects = orderedTable();
	AltarInteractionSiteStateObjects["AREAG_BYSMIELALLY_SUMMONED"] = { state = AltarRiftState.Finished,  dbr = nil }
	AltarInteractionSiteStateObjects["AREAG_BYSMIELQUESTLINE"] = { state = AltarRiftState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_templealtar.dbr" }
	AltarInteractionSiteStateObjects[""] = { state = AltarRiftState.Default, dbr = nil }

function gd.quests.areaGBysmielQuests.interactionSiteOnAddToWorld(objectId)
	
	if Server && not bysmielAllySummoned then
		local player = Game.GetLocalPlayer()
		npcId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (npcSpawned || player:AnyoneHasToken("AREAG_BYSMIELQUESTLINE")) && not player:HasToken("AREAG_BYSMIELALLY_SUMMONED") then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_templealtar.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, AltarInteractionSiteStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGBysmielQuests.interactionSiteOnDestroy = ClearObjectUserdata

function gd.quests.areaGBysmielQuests.spawnInteractionSite()

	if Server && not npcSpawned then
		npcSpawned = true
		
		local player = Game.GetLocalPlayer()
		
		local npc = Entity.Get(npcId)
		
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_BYSMIELQUESTLINE") == false && not player:HasToken("AREAG_BYSMIELALLY_SUMMONED")) then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_templealtar.dbr"
			MPOverrideState = true
		end

		if (npc != nil) then
			local coords = npc:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(npcId, AltarInteractionSiteStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end	
	
	end
	
end

local function GuardianCreateArgs()

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

local TempleGuardiansState = { Bloodsworn = 0, NoBloodsworn = 1} 

local TempleGuardians01StateObjects = orderedTable();
	TempleGuardians01StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = nil}
	TempleGuardians01StateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = "records/creatures/enemies/boss&quest/stonegryphon_templeguardian_01.dbr"}

function gd.quests.areaGBysmielQuests.templeGuardians01OnAddToWorld(objectId)
	
	if Server && not bloodswornGuardianSpawned && not guardian01Spawned then

		Guardian01Id = objectId;
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		local player = Game.GetLocalPlayer()
		
		-- Spawn Ultimate difficulty version of this boss
		if (Game.GetGameDifficulty() == Game.Difficulty.Legendary && not player:HasToken("AREAE_BLOODSWORN_RELEASED")) then
			MPOverrideDbr = "records/creatures/enemies/boss&quest/stonegryphon_templeguardian_01B.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, TempleGuardians01StateObjects, Character, GuardianCreateArgs, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as monster
		if (newState == TempleGuardiansState.NoBloodsworn) then
			guardian01Spawned = true
		end
	
	end
	
end

gd.quests.areaGBysmielQuests.templeGuardians01OnDestroy = ClearObjectUserdata

local TempleGuardians02StateObjects = orderedTable();
	TempleGuardians02StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = nil}
	TempleGuardians02StateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = "records/creatures/enemies/boss&quest/statue_templeguardian_02.dbr"}

	
function gd.quests.areaGBysmielQuests.templeGuardians02OnAddToWorld(objectId)
	
	if Server && not bloodswornGuardianSpawned && not guardian02Spawned then

		Guardian02Id = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, TempleGuardians02StateObjects, Character, GuardianCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as monster
		if (newState == TempleGuardiansState.NoBloodsworn) then
			guardian02Spawned = true
		end
	
	end
	
end

gd.quests.areaGBysmielQuests.templeGuardians02OnDestroy = ClearObjectUserdata

local TempleGuardians03StateObjects = orderedTable();
	TempleGuardians03StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = nil}
	TempleGuardians03StateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = "records/creatures/enemies/boss&quest/statue_templeguardian_03.dbr"}

	
function gd.quests.areaGBysmielQuests.templeGuardians03OnAddToWorld(objectId)
	
	if Server && not bloodswornGuardianSpawned && not guardian03Spawned then

		Guardian03Id = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, TempleGuardians03StateObjects, Character, GuardianCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as monster
		if (newState == TempleGuardiansState.NoBloodsworn) then
			guardian03Spawned = true
		end
	
	end
	
end

gd.quests.areaGBysmielQuests.templeGuardians03OnDestroy = ClearObjectUserdata

--
-- Credit For Kills
-- 

-- Temple Guardians
local guardian01Killed = false

function gd.quests.areaGBysmielQuests.guardian01OnKill()

	guardian01Killed = true
	
	if guardian01Killed && guardian02Killed && guardian03Killed then
		guardiansKilled = true
	
	end

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAG_BYSMIELGUARDIANSALL_KILLED")) then
		if (player != nil) then
			player:GiveToken("AREAG_BYSMIELGUARDIAN01_KILLED")
			
		end
		
		if (player:HasToken("AREAG_BYSMIELGUARDIAN01_KILLED") && player:HasToken("AREAG_BYSMIELGUARDIAN02_KILLED") && player:HasToken("AREAG_BYSMIELGUARDIAN03_KILLED")) then
			player:GiveToken("AREAG_BYSMIELGUARDIANSALL_KILLED")
			
		end

	end
	
end

function gd.quests.areaGBysmielQuests.guardian02OnKill()

	guardian02Killed = true
	
	if guardian01Killed && guardian02Killed && guardian03Killed then
		guardiansKilled = true
	
	end
	
	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAG_BYSMIELGUARDIANSALL_KILLED")) then
		if (player != nil) then
			player:GiveToken("AREAG_BYSMIELGUARDIAN02_KILLED")
			
		end
		
		if (player:HasToken("AREAG_BYSMIELGUARDIAN01_KILLED") && player:HasToken("AREAG_BYSMIELGUARDIAN02_KILLED") && player:HasToken("AREAG_BYSMIELGUARDIAN03_KILLED")) then
			player:GiveToken("AREAG_BYSMIELGUARDIANSALL_KILLED")
			
		end
		
	end
	
end

function gd.quests.areaGBysmielQuests.guardian03OnKill()

	guardian03Killed = true
	
	if guardian01Killed && guardian02Killed && guardian03Killed then
		guardiansKilled = true
	
	end

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAG_BYSMIELGUARDIANSALL_KILLED")) then
		if (player != nil) then
			player:GiveToken("AREAG_BYSMIELGUARDIAN03_KILLED")
			
		end
		
		if (player:HasToken("AREAG_BYSMIELGUARDIAN01_KILLED") && player:HasToken("AREAG_BYSMIELGUARDIAN02_KILLED") && player:HasToken("AREAG_BYSMIELGUARDIAN03_KILLED")) then
			player:GiveToken("AREAG_BYSMIELGUARDIANSALL_KILLED")
			
		end
		
	end
	
end

--
-- Bloodsworn version of the temple guardian
--

-- Trigger to start the bloodsworn quest.
local bloodswornTriggered = false

function gd.quests.areaGBysmielQuests.bloodswornTrigger()

	QuestEvent("bloodswornQuestCheck")
	
end

function gd.quests.areaGBysmielQuests.bloodswornTriggerMP()

	if Server && not bloodswornTriggered then
		bloodswornTriggered = true
		
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAE_BLOODSWORN_RELEASED") && not guardian01Spawned && not guardian02Spawned && not guardian03Spawned then
			QuestGlobalEvent("bloodswornGrantQuest")
		
		end
	
	end
	
end

function gd.quests.areaGBysmielQuests.bloodswornGrantQuest()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("AREAE_BLOODSWORN_RELEASED")) then

		local questId01 = 0x039E6438
		local taskId01 = 0xA2F0D500
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if ((questTaskState01 != QuestState.Complete) && (questTaskState01 != QuestState.InProgress)) then
			player:GrantQuest(0x039E6438, 0xA2F0D500)
		end
		
	end
	
end


-- Alt Temple Guardian - Appears only if the player has completed the bloodsworn damned quest from GDX1
local AltTempleGuardiansStateObjects = orderedTable();
	AltTempleGuardiansStateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = "records/creatures/enemies/boss&quest/chthonianrylok_bloodsworn.dbr"}
	AltTempleGuardiansStateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = nil}
	
function gd.quests.areaGBysmielQuests.altTempleGuardianOnAddToWorld(objectId)
	
	if Server && not bloodswornGuardianSpawned && not guardian01Spawned && not guardian02Spawned && not guardian03Spawned then

		AltGuardianId = objectId;
		local MPOverrideDbr = nil
		local MPOverrideState = false
		local player = Game.GetLocalPlayer()
		
		-- on Ultimate difficulty, spawns alternate version with chance to drop Legendary
		if Game.GetGameDifficulty() == Game.Difficulty.Legendary && player:HasToken("AREAE_BLOODSWORN_RELEASED") then
			MPOverrideDbr = "records/creatures/enemies/boss&quest/chthonianrylok_bloodswornb.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, AltTempleGuardiansStateObjects, Character, GuardianCreateArgs, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
			
		-- Don't respawn if spawned as monster
		if (newState == TempleGuardiansState.Bloodsworn) then
			bloodswornGuardianSpawned = true
		end
	
	end
	
end

gd.quests.areaGBysmielQuests.altTempleGuardianOnDestroy = ClearObjectUserdata

-- Chthonian Guardian is killed
function gd.quests.areaGBysmielQuests.BloodswornChthonianOnKill()

	guardiansKilled = true

	local player = Game.GetLocalPlayer()
	
	if (player != nil) then
		player:GiveToken("AREAG_BLOODSWORNCHTHONIAN_KILLED")
		
	end
	
end

-- Bloodsworn 01, is a chest
local Bloodsworn01StateObjects = orderedTable();
	Bloodsworn01StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = "records/items/lootchests/questchests/questchest_areag_bloodsworncorpse.dbr"}
	Bloodsworn01StateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = nil}

	
function gd.quests.areaGBysmielQuests.bloodsworn01OnAddToWorld(objectId)
	
	if Server && not bloodswornChestSpawned && not guardian01Spawned && not guardian02Spawned && not guardian03Spawned then

		Bloodsworn01Id = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Bloodsworn01StateObjects)
		Shared.setUserdata(objectId, userdata)
			
		-- Don't respawn if spawned as chest
		if (newState == TempleGuardiansState.Bloodsworn) then
			bloodswornChestSpawned = true
		end
	
	end
	
end

gd.quests.areaGBysmielQuests.bloodsworn01OnDestroy = ClearObjectUserdata

-- Bloodsworn 02

local Bloodsworn02StateObjects = orderedTable();
	Bloodsworn02StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = "records/level art/carnage/corpse_human_burned_03.dbr"}
	Bloodsworn02StateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = nil}

	
function gd.quests.areaGBysmielQuests.bloodsworn02OnAddToWorld(objectId)
	
	if Server && not guardian01Spawned && not guardian02Spawned && not guardian03Spawned then

		Bloodsworn02Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Bloodsworn02StateObjects)
		Shared.setUserdata(objectId, userdata)
	
	end
	
end

gd.quests.areaGBysmielQuests.bloodsworn02OnDestroy = ClearObjectUserdata

-- Bloodsworn 03

local Bloodsworn03StateObjects = orderedTable();
	Bloodsworn03StateObjects["AREAE_BLOODSWORN_RELEASED"] = { state = TempleGuardiansState.Bloodsworn, dbr = "records/level art/carnage/corpse_human_burned_03.dbr"}
	Bloodsworn03StateObjects[""] = { state = TempleGuardiansState.NoBloodsworn, dbr = nil}

	
function gd.quests.areaGBysmielQuests.bloodsworn03OnAddToWorld(objectId)
	
	if Server && not guardian01Spawned && not guardian02Spawned && not guardian03Spawned then

		Bloodsworn03Id = objectId;
			
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Bloodsworn03StateObjects)
		Shared.setUserdata(objectId, userdata)
	
	end
	
end

gd.quests.areaGBysmielQuests.bloodsworn03OnDestroy = ClearObjectUserdata


-- Summoned Bysmiel Ally
local BysmielAllyEntityId = 0
	
function gd.quests.areaGBysmielQuests.BysmielAlly01OnAddToWorld(objectId)
	
	if Server then
		BysmielAllyEntityId = objectId
	
	end
	
end

-- Player interacts with the summon site - transition the ally.
local altarFXId = 0

local riftFXStateObjects = orderedTable();
	riftFXStateObjects["AREAG_BYSMIELQUESTLINE"] = { state = AltarRiftState.Finished, dbr = "records/fx/ambient/altarateph01_active_fx01.dbr" }
	riftFXStateObjects["AREAG_BYSMIELALLY_SUMMONED"] = { state = AltarRiftState.Active, dbr = "records/fx/ambient/altarateph01_active_fx01.dbr" }
	riftFXStateObjects[""] = { state = AltarRiftState.Default, dbr = nil }

function gd.quests.areaGBysmielQuests.altarFX01OnAddToWorld(objectId)
	
	if Server then
		altarFXId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if bysmielAllySummoned then
			MPOverrideDbr = "records/fx/ambient/altarateph01_active_fx01.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, riftFXStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGBysmielQuests.altarFX01OnDestroy = ClearObjectUserdata


function gd.quests.areaGBysmielQuests.allyTransition()

	if Server && not bysmielAllySummoned then
		bysmielAllySummoned = true
		
		local bysmielSummon = Entity.Get(BysmielAllyEntityId)

		if (bysmielSummon != nil) then
			
			local coords = bysmielSummon:GetCoords()
			local riftEnd = Entity.Create("records/fx/creatures/eldritchspawn01_fx.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			local spawn = Character.Create ("records/creatures/enemies/faction/eldritch_bysmielally_despawn.dbr", 0, coords.origin)
			spawn:SetCoords(coords)
			
			-- create FX on altar
			local MPOverrideDbrFX = nil
			local MPOverrideState = false
			
			if (player != nil) && (player:HasToken("AREAG_BYSMIELALLY_SUMMONED") == false) then
				MPOverrideDbrFX = "records/fx/ambient/altarateph01_active_fx01.dbr"
				MPOverrideState =  true
			end
			
			local FXEntity = Entity.Get(altarFXId)
			
			if (FXEntity != nil) then
				UpdateObjectSwap(altarFXId, riftFXStateObjects, nil, nil, MPOverrideState, MPOverrideDbrFX)
			
			end
			
			local altar = Entity.Get(altarFXId)
			
			local altarCoords = altar:GetCoords()
			local altarFX = Entity.Create("records/fx/ambient/emissaryrift_activate_fxpak01.dbr")
		
			if (altarFX != nil) then
				altarFX:NetworkEnable()
				altarFX:SetCoords(altarCoords)
			end
		
		end
		
	end

end

