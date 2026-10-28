/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGNPCSpecial = {}

--
-- Altar
--
local altarActive = false
local scionTriggered = false

local specialBoss01Id = 0
local specialBoss01Spawned = false
local specialBossAvatar01Id = 0

local siteNPC = nil
local fxCoords = nil

-- Interaction Site
function gd.quests.areaGNPCSpecial.special01nteractionSiteOnAddToWorld(objectId)
	
	if Server && not altarActive && not specialBoss01Spawned then
		local coords = Entity.Get(objectId):GetCoords()
		siteNPC = Character.Create ("records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_special01.dbr")
		siteNPC:SetCoords(coords)
		
	end
	
end

-- Boss
local function SpecialBoss01CreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local minLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		minLevel = 80
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		minLevel = 105
		maxLevel = 120
	else
		minLevel = 105
		maxLevel = 120
	end
	
	if (averageLevel < minLevel) then
		monsterLevel = ((minLevel+(minLevel/50))+5)
	elseif (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+5)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+5)

	end

	return monsterLevel, nil
	
end
	
function gd.quests.areaGNPCSpecial.specialBoss01OnAddToWorld(objectId)

	if Server then
		specialBoss01Id = objectId;
		
	end
	
end

function gd.quests.areaGNPCSpecial.specialBossAvatar01OnAddToWorld(objectId)

	if Server then
		specialBossAvatar01Id = objectId;
		
	end
	
end

function gd.quests.areaGNPCSpecial.scionTrigger()

	if Server && not scionTriggered then
		scionTriggered = true
		
		local scion01 = Character.Get(specialBossAvatar01Id)
		
		if scion01 != nil then
			scion01:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/nemesis/sandscion_specialenrage.dbr", specialBossAvatar01Id, false)
		
		end
		
	end

end

-- Altar Control
function gd.quests.areaGNPCSpecial.special01AltarFXOnAddToWorld(objectId)

	if Server then
		fxCoords = Entity.Get(objectId):GetCoords()
		
	end
	
end

function gd.quests.areaGNPCSpecial.altarTest()

	return altarActive
	
end

function gd.quests.areaGNPCSpecial.altarActivatedGlobalMP()

	altarActive = true	

end

function gd.quests.areaGNPCSpecial.altarActivated()

	if Server then
		QuestGlobalEvent("areaGSpecialAltarGlobalMP")
		
		altarActive = true
		
		if not specialBoss01Spawned then
			specialBoss01Spawned = true

			local bossCoords = Entity.Get(specialBoss01Id):GetCoords()
			local bossDBR = nil
			
			if (Game.GetGameDifficulty() == Game.Difficulty.Normal || Game.GetGameDifficulty() == Game.Difficulty.Epic) then
				bossDBR = "records/creatures/enemies/boss&quest/sandscion_01.dbr"
			else
				bossDBR = "records/creatures/enemies/boss&quest/sandscion_02.dbr"
			end
			
			-- spawn boss
			local spawn = Character.Create (bossDBR, SpecialBoss01CreateArgs())
			spawn:SetCoords(bossCoords)
			
			-- destroy site NPC			
			if (siteNPC != nil) then
				local siteCoords = siteNPC:GetCoords()
				
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(siteCoords)
				end
				
				siteNPC:Destroy()
			
			end
			
			-- create FX on altar
			local altarFX = Entity.Create("records/fx/ambient/emissaryrift_activate_fxpak01.dbr")
	
			if (altarFX != nil) then
				altarFX:NetworkEnable()
				altarFX:SetCoords(fxCoords)
			end
			
		end
	
	end

end


--
-- secret boss encounter
--
local secretBossDead = false

local lootDoorId = 0
local exitShortcut = 0
local lootChestId = 0
local lootChest02Id = 0

local spawnAvatarIds = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

function gd.quests.areaGNPCSpecial.spawnAvatarOnAddToWorld(objectId)

	if Server then
		local found = false
		local turretsTotal = table.getn(spawnAvatarIds)
		
		for id = 1, turretsTotal do
			if (spawnAvatarIds[id] == 0 && not found) then
				spawnAvatarIds[id] = objectId
				found = true
				
			end
			
		end
		
		-- destroy spawn if boss dead
		if secretBossDead then
			local object = Object.Get(objectId)
			
			if object != nil then
				local coords = Entity.Get(objectId):GetCoords()				
				object:Destroy()
				
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
			end
		
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.bossKilled()
	
	GiveTokenToLocalPlayer("AREAG_SECRETBOSS_SLAIN")
	
	if Server then
		secretBossDead = true
		
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
		
		-- destroy spawns
		local spawnsTotal = table.getn(spawnAvatarIds)
		
		for id = 1, spawnsTotal do
			if spawnAvatarIds[id] != 0 then
				local object = Object.Get(spawnAvatarIds[id])
				local coords = nil
				
				if object != nil then
					coords = Entity.Get(spawnAvatarIds[id]):GetCoords()				
					object:Destroy()
					
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
					
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
					
				end
			
			end
			
		end
		
	end
	
end

-- Spawn crate boss and its supporting cast on load. These entities are deleted on unload and respawned if the area is re-loaded for another attempt.
function gd.quests.areaGNPCSpecial.crateBoss01OnAddToWorld(objectId)
	
	if Server then
		if not secretBossDead then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Character.Create ("records/creatures/enemies/special/sand_01.dbr", SpecialBoss01CreateArgs())
			spawn:SetCoords(coords)
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.crateBoss01OnRemoveFromWorld(objectId)
	
	if Server then
		-- reset the crate spawns array
		if not secretBossDead then
			spawnAvatarIds = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.crateBoss02OnAddToWorld(objectId)
	
	if Server then
		if not secretBossDead then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Character.Create ("records/creatures/enemies/special/crate_01.dbr", SpecialBoss01CreateArgs())
			spawn:SetCoords(coords)
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.crateBoss03OnAddToWorld(objectId)
	
	if Server then
		if not secretBossDead then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Character.Create ("records/creatures/enemies/special/crate_02.dbr", SpecialBoss01CreateArgs())
			spawn:SetCoords(coords)
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.crateBoss04OnAddToWorld(objectId)
	
	if Server then
		if not secretBossDead then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Character.Create ("records/creatures/enemies/special/crate_02.dbr", SpecialBoss01CreateArgs())
			spawn:SetCoords(coords)
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.crateBoss05OnAddToWorld(objectId)
	
	if Server then
		if not secretBossDead then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Character.Create ("records/creatures/enemies/special/crate_03.dbr", SpecialBoss01CreateArgs())
			spawn:SetCoords(coords)
		end
	
	end
	
end


function gd.quests.areaGNPCSpecial.lootDoorOnAddToWorld(objectId)
	
	if Server then
		lootDoorId = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.exitShortcutOnAddToWorld(objectId)
	
	if Server then
		exitShortcut = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lootChestOnAddToWorld(objectId)
	
	if Server then
		lootChestId = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lootChest02OnAddToWorld(objectId)
	
	if Server then
		lootChest02Id = objectId
		
	end
	
end


-- Decal
function gd.quests.areaGNPCSpecial.decalOnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		local coords = Entity.Get(objectId):GetCoords()
		local decal = Entity.Create("records/storyelementsgdx2/questassets/decalspecial_01.dbr")
		decal:SetCoords(coords)
		
	end
	
end

--
-- Breakables
--
local crateNPCId = 0

local secretActive = false
local breakableId = { 0, 0, 0, 0, 0, 0 }
local breakableStateObjects = {nil, nil, nil, nil, nil, nil }
local breakableState = { false, false, false, false, false, false }
local breakableSpawned = {false, false, false, false, false, false }

local spawnedBlockade = false
local blockadeDestroyed = false
local specialBlockadeId = 0

local BreakableState = { Default = 0, Spawned = 1, Destroyed = 2 }


local crateNPCStateObjects = orderedTable()
	crateNPCStateObjects["AREAG_SECRETBOSS_SLAIN"	] = { state = BreakableState.Destroyed,  dbr = nil }
	crateNPCStateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Spawned, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_special02.dbr" }
	crateNPCStateObjects[""					 	] = { state = BreakableState.Default, dbr = nil }

function gd.quests.areaGNPCSpecial.crateNPCOnAddToWorld(objectId)
	
	if Server then
		crateNPCId = objectId

		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, crateNPCStateObjects)

		Shared.setUserdata(objectId, userdata)
	
	end
	
end

gd.quests.areaGNPCSpecial.crateNPCOnDestroy = ClearObjectUserdata


function gd.quests.areaGNPCSpecial.specialBlockadeOnAddToWorld(objectId)

	if Server && not spawnedBlockade then
		spawnedBlockade = true
		
		local coords = Entity.Get(objectId):GetCoords()
		local spawn = Entity.Create("records/storyelementsgdx2/questassets/areag_specialbarricade_break.dbr")
		spawn:SetCoords(coords)
	
	end
	
end

function gd.quests.areaGNPCSpecial.specialBlockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		specialBlockadeId = objectId
	
	end
	
end

function gd.quests.areaGNPCSpecial.specialBlockadeDestroy()

	if Server && spawnedBlockade && Game.GetGameDifficulty() == Game.Difficulty.Legendary && not blockadeDestroyed then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_SECRETBOSS_SLAIN") || secretActive || (player:HasToken("AREAG_CRATE01_BROKEN") && player:HasToken("AREAG_CRATE02_BROKEN") && player:HasToken("AREAG_CRATE03_BROKEN") && player:HasToken("AREAG_CRATE04_BROKEN") && player:HasToken("AREAG_CRATE05_BROKEN") && player:HasToken("AREAG_CRATE06_BROKEN")) then
			if specialBlockadeId != 0 then
				local Blockade = Destructible.Get(specialBlockadeId)
				
				if Blockade != nil then
					local coords = Blockade:GetCoords()
					Blockade:Destroy(Vec(0,1,0), 1000, false)
					specialBlockadeId = 0
				
					local pfx = Entity.Create("records/fx/ambient/emissaryrift_activate_fxpak01.dbr")
					if pfx != nil then
						pfx:NetworkEnable()
						pfx:SetCoords(coords)
						
					end
					
					blockadeDestroyed = true
				
				end
				
			end
		
		end
		
	end

end

function gd.quests.areaGNPCSpecial.barricadeTriggered()

	QuestEvent("areaGSpecialBarricade")
	
end


function gd.quests.areaGNPCSpecial.breakable01BrokenGlobalMP()

	GiveTokenToLocalPlayer("AREAG_CRATE01_BROKEN")

end

local function spawnBreakables()
	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		local totalBreakables = table.getn(breakableId)
		
		for id = 2, totalBreakables do
			if not breakableSpawned[id] then
				local entity = Entity.Get(breakableId[id])
		
				if entity != nil then
					local didWork, newState = UpdateObjectSwap(breakableId[id], breakableStateObjects[id])
			
					-- Don't respawn the crate next time
					if (newState == BreakableState.Spawned) then
						breakableSpawned[id] = true
						
					end
				
				end
			
			end
			
		end
		
		-- spawn NPC
		local npc = Entity.Get(crateNPCId)
		
		if npc != nil then
			local coords = npc:GetCoords()
			local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			
			end
			
			UpdateObjectSwap(crateNPCId, crateNPCStateObjects)
	
		end
	
	end

end

local function breakableTest()
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		if (breakableState[1] && breakableState[2] && breakableState[3] && breakableState[4] && breakableState[5] && breakableState[6]) || (player:HasToken("AREAG_CRATE01_BROKEN") && player:HasToken("AREAG_CRATE02_BROKEN") && player:HasToken("AREAG_CRATE03_BROKEN") && player:HasToken("AREAG_CRATE04_BROKEN") && player:HasToken("AREAG_CRATE05_BROKEN") && player:HasToken("AREAG_CRATE06_BROKEN")) then
			secretActive = true
			
			gd.quests.areaGNPCSpecial.specialBlockadeDestroy()
			UI.Notify("tagNotification_AreaG_Special02")
			
		else
			UI.Notify("tagNotification_AreaG_Special01")
			
		end
	
	end
	
end


local breakable01StateObjects = orderedTable()
	breakable01StateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Destroyed,  dbr = nil }
	breakable01StateObjects[""					 	] = { state = BreakableState.Default, dbr = "records/items/lootchests/breakables/a201_cratespecial_01_break.dbr"}

function gd.quests.areaGNPCSpecial.breakable01OnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (not breakableSpawned[1]) then
			breakableId[1] = objectId
			breakableStateObjects[1] = breakable01StateObjects

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, breakable01StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == BreakableState.Default) then
				breakableSpawned[1] = true
				
			end
			
		end
		
	end
	
end

gd.quests.areaGNPCSpecial.breakableOnDestroy = ClearObjectUserdata

function gd.quests.areaGNPCSpecial.breakable01BrokenGlobalMP()
	GiveTokenToLocalPlayer("AREAG_CRATE01_BROKEN")	
end

function gd.quests.areaGNPCSpecial.breakable01Broken()
	
	if Server then
		QuestGlobalEvent("areaGSpecialBreakable01GlobalMP")
		
		GiveTokenToLocalPlayer("AREAG_CRATE01_BROKEN")		
		breakableState[1] = true
		
		breakableTest()
		
		spawnBreakables()

	end
	
end


local breakable02StateObjects = orderedTable()
	breakable02StateObjects["AREAG_CRATE02_BROKEN"	] = { state = BreakableState.Destroyed, dbr = nil }
	breakable02StateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Spawned,  dbr = "records/items/lootchests/breakables/a201_cratespecial_02_break.dbr"}
	breakable02StateObjects[""					 	] = { state = BreakableState.Default, dbr = nil }

function gd.quests.areaGNPCSpecial.breakable02OnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (not breakableSpawned[2]) then
			breakableId[2] = objectId
			breakableStateObjects[2] = breakable02StateObjects

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, breakable02StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == BreakableState.Spawned) then
				breakableSpawned[2] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.breakable02BrokenGlobalMP()
	GiveTokenToLocalPlayer("AREAG_CRATE02_BROKEN")	
end

function gd.quests.areaGNPCSpecial.breakable02Broken()
	
	if Server then
		QuestGlobalEvent("areaGSpecialBreakable02GlobalMP")
		
		GiveTokenToLocalPlayer("AREAG_CRATE02_BROKEN")		
		breakableState[2] = true
		
		breakableTest()

	end
	
end

local breakable03StateObjects = orderedTable()
	breakable03StateObjects["AREAG_CRATE03_BROKEN"	] = { state = BreakableState.Destroyed, dbr = nil }
	breakable03StateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Spawned,  dbr = "records/items/lootchests/breakables/a201_cratespecial_03_break.dbr"}
	breakable03StateObjects[""					 	] = { state = BreakableState.Default, dbr = nil }

function gd.quests.areaGNPCSpecial.breakable03OnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (not breakableSpawned[3]) then
			breakableId[3] = objectId
			breakableStateObjects[3] = breakable03StateObjects

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, breakable03StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == BreakableState.Spawned) then
				breakableSpawned[3] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.breakable03BrokenGlobalMP()
	GiveTokenToLocalPlayer("AREAG_CRATE03_BROKEN")	
end

function gd.quests.areaGNPCSpecial.breakable03Broken()
	
	if Server then
		QuestGlobalEvent("areaGSpecialBreakable03GlobalMP")
		
		GiveTokenToLocalPlayer("AREAG_CRATE03_BROKEN")		
		breakableState[3] = true
		
		breakableTest()

	end
	
end

local breakable04StateObjects = orderedTable()
	breakable04StateObjects["AREAG_CRATE04_BROKEN"	] = { state = BreakableState.Destroyed, dbr = nil }
	breakable04StateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Spawned,  dbr = "records/items/lootchests/breakables/a201_cratespecial_04_break.dbr"}
	breakable04StateObjects[""					 	] = { state = BreakableState.Default, dbr = nil }

function gd.quests.areaGNPCSpecial.breakable04OnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (not breakableSpawned[4]) then
			breakableId[4] = objectId
			breakableStateObjects[4] = breakable04StateObjects

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, breakable04StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == BreakableState.Spawned) then
				breakableSpawned[4] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.breakable04BrokenGlobalMP()
	GiveTokenToLocalPlayer("AREAG_CRATE04_BROKEN")	
end

function gd.quests.areaGNPCSpecial.breakable04Broken()
	
	if Server then
		QuestGlobalEvent("areaGSpecialBreakable04GlobalMP")
		
		GiveTokenToLocalPlayer("AREAG_CRATE04_BROKEN")		
		breakableState[4] = true
		
		breakableTest()

	end
	
end

local breakable05StateObjects = orderedTable()
	breakable05StateObjects["AREAG_CRATE05_BROKEN"	] = { state = BreakableState.Destroyed, dbr = nil }
	breakable05StateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Spawned,  dbr = "records/items/lootchests/breakables/a201_cratespecial_05_break.dbr"}
	breakable05StateObjects[""					 	] = { state = BreakableState.Default, dbr = nil }

function gd.quests.areaGNPCSpecial.breakable05OnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (not breakableSpawned[5]) then
			breakableId[5] = objectId
			breakableStateObjects[5] = breakable05StateObjects

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, breakable05StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == BreakableState.Spawned) then
				breakableSpawned[5] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.breakable05BrokenGlobalMP()
	GiveTokenToLocalPlayer("AREAG_CRATE05_BROKEN")	
end

function gd.quests.areaGNPCSpecial.breakable05Broken()
	
	if Server then
		QuestGlobalEvent("areaGSpecialBreakable05GlobalMP")
		
		GiveTokenToLocalPlayer("AREAG_CRATE05_BROKEN")		
		breakableState[5] = true
		
		breakableTest()

	end
	
end

local breakable06StateObjects = orderedTable()
	breakable06StateObjects["AREAG_CRATE06_BROKEN"	] = { state = BreakableState.Destroyed, dbr = nil }
	breakable06StateObjects["AREAG_CRATE01_BROKEN"	] = { state = BreakableState.Spawned,  dbr = "records/items/lootchests/breakables/a201_cratespecial_06_break.dbr"}
	breakable06StateObjects[""					 	] = { state = BreakableState.Default, dbr = nil }

function gd.quests.areaGNPCSpecial.breakable06OnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		if (not breakableSpawned[6]) then
			breakableId[6] = objectId
			breakableStateObjects[6] = breakable06StateObjects

			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, breakable06StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == BreakableState.Spawned) then
				breakableSpawned[6] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.breakable06BrokenGlobalMP()
	GiveTokenToLocalPlayer("AREAG_CRATE06_BROKEN")	
end

function gd.quests.areaGNPCSpecial.breakable06Broken()
	
	if Server then
		QuestGlobalEvent("areaGSpecialBreakable06GlobalMP")
		
		GiveTokenToLocalPlayer("AREAG_CRATE06_BROKEN")		
		breakableState[6] = true
		
		breakableTest()

	end
	
end

--
-- Lever Door Control
--
local leverDoorId = 0
local leverDoorOpened = false
local cleanUpRunning = false

local leverId = { 0, 0, 0, 0, 0 }
local leverStateObjects = {nil, nil, nil, nil, nil }
local leverBreakState = { false, false, false, false, false }
local leverSpawned = {false, false, false, false, false }
local leverEntityIds = { 0, 0, 0, 0, 0 }
local leverCoords = { nil, nil, nil, nil, nil }
local leverDBRS = { "records/storyelementsgdx2/questassets/lever_white.dbr", "records/storyelementsgdx2/questassets/lever_yellow.dbr", "records/storyelementsgdx2/questassets/lever_green.dbr", "records/storyelementsgdx2/questassets/lever_blue.dbr", "records/storyelementsgdx2/questassets/lever_purple.dbr" }

local LeverState = { Default = 0, Destroyed = 1 }

-- Levers
function gd.quests.areaGNPCSpecial.leverTestGlobalMP()
	GiveTokenToLocalPlayer("AREAG_LEVERSECRET")	
end

local function leverReset()
	
	if Server && not cleanUpRunning then
		cleanUpRunning = true
		UI.Notify("tagGDX2Notification_Special")
		print ("destroying levers")
		
		local leversTotal = table.getn(leverId)
		
		for id = 1, leversTotal do
			if leverEntityIds[id] != 0 then
				local lever = Destructible.Get(leverEntityIds[id])
				lever:Destroy(Vec(0,1,0), 10, false)
				
			end
		
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.leverCleanUpTriggerMP()
	
	if Server && cleanUpRunning then
		cleanUpRunning = false
		print ("remaking levers")
		
		local leversTotal = table.getn(leverId)
	
		for id = 1, leversTotal do
			-- destroy old lever
			local entity = Entity.Get(leverEntityIds[id])
			entity:Destroy()
			
			-- spawn new lever
			local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
	
			if (riftStart != nil) then
				riftStart:NetworkEnable()
				riftStart:SetCoords(leverCoords[id])
			end
			
			local newLever = Entity.Create(leverDBRS[id])
			newLever:SetCoords(leverCoords[id])
			
			leverBreakState[id] = false
		
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.leverCleanUpTrigger(triggererId)

	local player = Player.Get(triggererId)
	
	if player:ServerHasToken("AREAG_LEVERSECRET") == false then
		QuestEvent("areaGSpecialLeverTrigger")
	
	end
	
end

local function leverTest(leverNumber)
	
	if Server && not leverDoorOpened && not cleanUpRunning then
		print ("testingLevers")
		local test = false
		
		leverBreakState[leverNumber] = true
		
		if leverNumber != 1 then
			for id = leverNumber, 1, -1 do
				if not leverBreakState[id] then
					test = true
					print ("wrong lever", id)
					leverReset()
					break
					
				end
				
			end

			if leverNumber == 5 && not test then
				QuestGlobalEvent("areaGSpecialLeverSecretGlobalMP")
				UI.Notify("tagGDX2Notification_Special02")
				
				GiveTokenToLocalPlayer("AREAG_LEVERSECRET")
				
				if not leverDoorOpened then
					leverDoorOpened = true
					local door = Door.Get(leverDoorId)
					
					if ((door != nil) && (door:IsLocked())) then
						door:SetLocked(false)
						door:Open()
						
					end
				
				end
			
			end
		
		end
	
	end
	
end


local lever01StateObjects = orderedTable()
	lever01StateObjects["AREAG_LEVERSECRET"	] = { state = LeverState.Destroyed, dbr = nil }
	lever01StateObjects[""					 	] = { state = LeverState.Default, dbr = "records/storyelementsgdx2/questassets/lever_white.dbr"}

function gd.quests.areaGNPCSpecial.lever01AvatarOnAddToWorld(objectId)

	if Server then
		leverEntityIds[1] = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever01OnAddToWorld(objectId)

	if Server && not leverDoorOpened then
		leverId[1] = objectId
		leverStateObjects[1] = lever01StateObjects
		leverCoords[1] = Entity.Get(objectId):GetCoords()
		
		if (not leverSpawned[1]) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, lever01StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == LeverState.Spawned) then
				leverSpawned[1] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever01Broken()
	
	if Server && not leverBreakState[1] && not cleanUpRunning then
		print ("lever 1 broken")
		leverTest(1)

	end
	
end

gd.quests.areaGNPCSpecial.leverOnDestroy = ClearObjectUserdata


local lever02StateObjects = orderedTable()
	lever02StateObjects["AREAG_LEVERSECRET"	] = { state = LeverState.Destroyed, dbr = nil }
	lever02StateObjects[""					 	] = { state = LeverState.Default, dbr = "records/storyelementsgdx2/questassets/lever_yellow.dbr"}

function gd.quests.areaGNPCSpecial.lever02AvatarOnAddToWorld(objectId)

	if Server then
		leverEntityIds[2] = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever02OnAddToWorld(objectId)

	if Server && not leverDoorOpened then
		leverId[2] = objectId
		leverStateObjects[2] = lever02StateObjects
		leverCoords[2] = Entity.Get(objectId):GetCoords()
		
		if (not leverSpawned[2]) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, lever02StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == LeverState.Spawned) then
				leverSpawned[2] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever02Broken()
	
	if Server && not leverBreakState[2] && not cleanUpRunning then
		leverBreakState[2] = true
		print ("lever 2 broken")
		leverTest(2)

	end
	
end


local lever03StateObjects = orderedTable()
	lever03StateObjects["AREAG_LEVERSECRET"	] = { state = LeverState.Destroyed, dbr = nil }
	lever03StateObjects[""					 	] = { state = LeverState.Default, dbr = "records/storyelementsgdx2/questassets/lever_green.dbr"}

function gd.quests.areaGNPCSpecial.lever03AvatarOnAddToWorld(objectId)

	if Server then
		leverEntityIds[3] = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever03OnAddToWorld(objectId)

	if Server && not leverDoorOpened then
		leverId[3] = objectId
		leverStateObjects[3] = lever03StateObjects
		leverCoords[3] = Entity.Get(objectId):GetCoords()
		
		if (not leverSpawned[3]) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, lever03StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == LeverState.Spawned) then
				leverSpawned[3] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever03Broken()
	
	if Server && not leverBreakState[3] && not cleanUpRunning then
		print ("lever 3 broken")
		leverTest(3)

	end
	
end


local lever04StateObjects = orderedTable()
	lever04StateObjects["AREAG_LEVERSECRET"	] = { state = LeverState.Destroyed, dbr = nil }
	lever04StateObjects[""					 	] = { state = LeverState.Default, dbr = "records/storyelementsgdx2/questassets/lever_blue.dbr"}

function gd.quests.areaGNPCSpecial.lever04AvatarOnAddToWorld(objectId)

	if Server then
		leverEntityIds[4] = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever04OnAddToWorld(objectId)

	if Server && not leverDoorOpened then
		leverId[4] = objectId
		leverStateObjects[4] = lever04StateObjects
		leverCoords[4] = Entity.Get(objectId):GetCoords()
		
		if (not leverSpawned[4]) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, lever04StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == LeverState.Spawned) then
				leverSpawned[4] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever04Broken()
	
	if Server && not leverBreakState[4] && not cleanUpRunning then
		print ("lever 4 broken")
		leverTest(4)

	end
	
end


local lever05StateObjects = orderedTable()
	lever05StateObjects["AREAG_LEVERSECRET"	] = { state = LeverState.Destroyed, dbr = nil }
	lever05StateObjects[""					 	] = { state = LeverState.Default, dbr = "records/storyelementsgdx2/questassets/lever_purple.dbr"}

function gd.quests.areaGNPCSpecial.lever05AvatarOnAddToWorld(objectId)

	if Server then
		leverEntityIds[5] = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever05OnAddToWorld(objectId)

	if Server && not leverDoorOpened then
		leverId[5] = objectId
		leverStateObjects[5] = lever05StateObjects
		leverCoords[5] = Entity.Get(objectId):GetCoords()
		
		if (not leverSpawned[5]) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, lever05StateObjects)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn next time. If spawned as chest, saved into world
			if (newState == LeverState.Spawned) then
				leverSpawned[5] = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGNPCSpecial.lever05Broken()
	
	if Server && not leverBreakState[5] && not cleanUpRunning then
		print ("lever 5 broken")
		leverTest(5)

	end
	
end

-- Door
function gd.quests.areaGNPCSpecial.leverDoorOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		leverDoorId = objectId;
		
		if leverDoorOpened || player:HasToken("AREAG_LEVERSECRET") then
			leverDoorOpened = true
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

-- Door to Special Level Control
local secretDoorId = 0
local secretOpened = false

function gd.quests.areaGNPCSpecial.secretDoorOnAddToWorld(objectId)

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

function gd.quests.areaGNPCSpecial.openSecret()

	if Server && not secretOpened then
		UI.Notify("tagNotification_AreaG_Special03")
		
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

function gd.quests.areaGNPCSpecial.warningNoRiftgates(triggererId)

	local player = Player.Get(triggererId)

	if (player != nil) && not riftgatesWarning then
		UI.Notify("tagNotification_WarningRiftgateDisabled")
		riftgatesWarning = true
		
	end
	
end


-- Special Vanguard Ritual
local ritualActivated = false
local ritualFinished = false

local ritualCounter = 0
local ritualCheck = 10

local ritualObjectID = 0


function gd.quests.areaGNPCSpecial.vanguardRitualObjectOnAddToWorld(objectId)
	if Server then
		ritualObjectID = objectId
		
	end
	
end

function gd.quests.areaGNPCSpecial.vanguardRitualFinishedGlobalMP()
	
	if ritualActivated then
		GiveTokenToLocalPlayer("AREAG_VANGUARDRITUAL")
	end
	
end

function gd.quests.areaGNPCSpecial.vanguardRitualFinished()
	if Server && not ritualFinished then
		ritualFinished = true
		
		local coords = Entity.Get(ritualObjectID):GetCoords()
		local entity = Entity.Create("records/items/gearweapons/swords1h/d205_sword.dbr")
		entity:SetCoords(coords)
		
		-- bestow token for activating ritual to player(s) that participated
		QuestGlobalEvent("areaGVanguardRitualFinishedGlobalMP")
		
	end
	
end

function gd.quests.areaGNPCSpecial.vanguardRitualPeriodicFX()
	if Server && not ritualFinished then
		local coords = Entity.Get(ritualObjectID):GetCoords()
		
		local fx = Entity.Create("records/fx/skillsothergdx2/aoe/eldritchspurt_fxpak.dbr")

		fx:SetCoords(coords)
		
		if (fx != nil) then
			fx:NetworkEnable()
			fx:SetCoords(coords)
		end
	end
	
end

function gd.quests.areaGNPCSpecial.vanguardRitual(triggererId)

	if Game.GetGameDifficulty() == Game.Difficulty.Legendary then

		local triggerPlayer = Player.Get(triggererId)
		local player = Game.GetLocalPlayer()
		local playerID = player:GetId()

		if triggererId == playerID && not ritualActivated && not player:HasToken("AREAG_VANGUARDRITUAL") then
			ritualCounter = ritualCounter + 1
			print "counter up"
			
			if ritualCounter >= ritualCheck then
				UI.Notify("tagNotification_AreaG_Ritual")
				ritualActivated = true
				
				QuestEvent("areaGVanguardRitualFinished")
				
			elseif ritualCounter == 3 || ritualCounter== 6 || ritualCounter == 9 then
				QuestEvent("areaGVanguardRitualFX")
				
			end
			
		end
	
	end
	
end


-- Desert Rift
local specialRiftId = 0
local specialRiftNPCId = 0
local specialRiftOpened = false

-- Interaction Site, Ultimate only
function gd.quests.areaGNPCSpecial.interactionSiteOnAddToWorld(objectId)
	
	if Server && not specialRiftOpened && Game.GetGameDifficulty() == Game.Difficulty.Legendary then		
		local player = Game.GetLocalPlayer()
		
		if not player:HasToken("AREAG_SPECIALRIFT_OPENED") then
			local coords = Entity.Get(objectId):GetCoords()
			local npc = Entity.Create("records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_specialaltar.dbr")
			
			npc:SetCoords(coords)
			
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.interactionSiteAvatarOnAddToWorld(objectId)
	if Server then
		specialRiftNPCId = objectId
	
	end

end


-- Rift to Secret, Ultimate only
function gd.quests.areaGNPCSpecial.lockedSpecialRiftOnAddToWorld(objectId)
	
	if Server && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
		
		local player = Game.GetLocalPlayer()
		specialRiftId = objectId
		
		if (player:HasToken("AREAG_SPECIALRIFT_OPENED") || specialRiftOpened) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				specialRiftOpened = true
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

-- Open The Rift
function gd.quests.areaGNPCSpecial.openSpecialRift()
	if Server && not specialRiftOpened then
		specialRiftOpened= true
		
		-- open rift
		local door = Door.Get(specialRiftId)
		
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/eldritchrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
		-- despawn NPC
		local object = Object.Get(specialRiftNPCId)
		local coords = Entity.Get(specialRiftNPCId):GetCoords()
		
		if (object != nil) then
			object:Destroy()
			
			local fx = Entity.Create("records/fx/creatures/eldritchspawn01_fx.dbr")
			
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
				
			end
			
		end
		
	end
	
end


-- Focus Chest
function gd.quests.areaGNPCSpecial.focusChest01Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_FOCUS")
	
end

function gd.quests.areaGNPCSpecial.focusChest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_FOCUS")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

-- Glove Chest
function gd.quests.areaGNPCSpecial.gloveChest01Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_GLOVES")
	
end

function gd.quests.areaGNPCSpecial.gloveChest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_GLOVES")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

-- Ring Chest
function gd.quests.areaGNPCSpecial.ringA001Chest01Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_RINGA001")
	
end

function gd.quests.areaGNPCSpecial.ringA001Chest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_RINGA001")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

-- Shield Chest
function gd.quests.areaGNPCSpecial.shieldChest01Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_SHIELD")
	
end

function gd.quests.areaGNPCSpecial.shieldChest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_SHIELD")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.shieldChest02Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_SHIELD02")
	
end

function gd.quests.areaGNPCSpecial.shieldChest02OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_SHIELD02")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.shieldChest03Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_SHIELD03")
	
end

function gd.quests.areaGNPCSpecial.shieldChest03OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_SHIELD03")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.shieldChest04Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_SHIELD04")
	
end

function gd.quests.areaGNPCSpecial.shieldChest04OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_SHIELD04")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

function gd.quests.areaGNPCSpecial.shieldChest05Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_SHIELD05")
	
end

function gd.quests.areaGNPCSpecial.shieldChest05OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_SHIELD05")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end