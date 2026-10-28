/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGKorvaak = {}


--
-- The final boss of GDX2
--
local bossKilled = false
local bossFinished = false
local bossExitShortcutId = 0
local shortcutOpen = false

local bossChestId = 0
local lootChestId = 0
local lootChest02Id = 0

local phase01Spawned = false
local phase03Spawned = false


local finalBossId = 0
local FinalBossSpawned = false
local FinalBossState = {Default = 0, Killed = 1}

local FinalBossStateObjects = orderedTable();
	FinalBossStateObjects["AREAG_KORVAAK_KILLED"] = { state = FinalBossState.Killed,  dbr = "records/creatures/enemies/boss&quest/korvaakfinal_01.dbr" }
	FinalBossStateObjects[""] = { state = FinalBossState.Default, dbr = "records/creatures/enemies/boss&quest/korvaakfinal_00.dbr" }

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(finalBossId):GetCoords().origin

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
	
function gd.quests.areaGKorvaak.finalBossOnAddToWorld(objectId)

	if Server && not FinalBossSpawned then
		finalBossId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, FinalBossStateObjects, Character, CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		FinalBossSpawned = true
		
	end
	
end

gd.quests.areaGKorvaak.finalBossOnDestroy = ClearObjectUserdata


-- Boss Reward Chests
function gd.quests.areaGKorvaak.bossChestOnAddToWorld(objectId)
	
	if Server then
		local chestEntity = Entity.Get(objectId)
		bossChestId = objectId
		player = Game.GetLocalPlayer()
	
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHEST_KORVAAK")) then
			print "Destroying Chest"
			chestEntity:Destroy()
			
		end
		
	end
	
end

function gd.quests.areaGKorvaak.bossChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHEST_KORVAAK");
	
end

function gd.quests.areaGKorvaak.lootChestOnAddToWorld(objectId)
	
	if Server then
		lootChestId = objectId
		
	end
	
end

function gd.quests.areaGKorvaak.lootChest02OnAddToWorld(objectId)
	
	if Server then
		lootChest02Id = objectId
		
	end
	
end

-- Shortcut back to the surface after boss is killed
function gd.quests.areaGKorvaak.bossExitShortcutOnAddToWorld(objectId)
	
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

-- in phase 01, boss breaks free of his chains, the decoration is despawned
local decorationId = 0

function gd.quests.areaGKorvaak.bossPhase01OnAddToWorld(objectId)
	
	if Server then
		if not phase01Spawned then
			phase01Spawned = true
			
			-- destroy decoration, if loaded
			local decor = Object.Get(decorationId)
			
			if (decor != nil) then
				local coords = Entity.Get(decorationId):GetCoords()
				decor:Destroy()
				
				local fx = Entity.Create("records/fx/ambient/emissaryrift_activate_fxpak01.dbr")
			
				if (fx != nil) then
					fx:NetworkEnable()
					fx:SetCoords(coords)
				end
				
			end
			
		end
		
	end
	
end

-- Decorations
local turretDecorIds = { 0, 0, 0 }
local turretDecorBreakSpawned = { false, false, false }

function gd.quests.areaGKorvaak.decorationOnAddToWorld(objectId)
	
	if Server && not phase01Spawned then
		local coords = Entity.Get(objectId):GetCoords()
		local decor = Entity.Create("records/storyelementsgdx2/questassets/areag_korvaak_decoration.dbr")
		
		decor:SetCoords(coords)
	
	end
	
end

function gd.quests.areaGKorvaak.decorationAvatarOnAddToWorld(objectId)
	
	if Server then
		decorationId = objectId
	
	end
	
end

local function turretDecorSpawningControl(decorNum, coordinates)

	if Server && not turretDecorBreakSpawned[decorNum] then
		if not phase03Spawned then
			local turretDBR = nil
			
			if decorNum == 1 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_01.dbr"
			elseif decorNum == 2 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_02.dbr"
			else
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_03.dbr"
			end
			
			local decor = Entity.Create(turretDBR)
			decor:SetCoords(coordinates)
			
		elseif not bossFinished then
			local turretDBR = nil
			
			if decorNum == 1 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_01_korvaak.dbr"
			elseif decorNum == 2 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_02_korvaak.dbr"
			else
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_03_korvaak.dbr"
			end
			
			local decor = Entity.Create(turretDBR)
			decor:SetCoords(coordinates)
			
		else
			turretDecorBreakSpawned[decorNum] = true
			local breakable = Entity.Create("records/storyelementsgdx2/questassets/areag_korvaak_throne_break.dbr")
			breakable:SetCoords(coordinates)
		
		end		
	
	end

end

function gd.quests.areaGKorvaak.turretDecor01OnAddToWorld(objectId)
	
	if Server && not turretDecorBreakSpawned[1] then
		local coords = Entity.Get(objectId):GetCoords()
		
		turretDecorSpawningControl(1, coords)
	
	end
	
end

function gd.quests.areaGKorvaak.turretDecor01AvatarOnAddToWorld(objectId)
	
	if Server then
		turretDecorIds[1] = objectId
	
	end
	
end

function gd.quests.areaGKorvaak.turretDecor02OnAddToWorld(objectId)
	
	if Server && not turretDecorBreakSpawned[2] then
		local coords = Entity.Get(objectId):GetCoords()
		
		turretDecorSpawningControl(2, coords)
	
	end

end

function gd.quests.areaGKorvaak.turretDecor02AvatarOnAddToWorld(objectId)
	
	if Server then
		turretDecorIds[2] = objectId
	
	end
	
end
	
function gd.quests.areaGKorvaak.turretDecor03OnAddToWorld(objectId)
	
	if Server && not turretDecorBreakSpawned[3] then
		local coords = Entity.Get(objectId):GetCoords()
		
		turretDecorSpawningControl(3, coords)
	
	end

end

function gd.quests.areaGKorvaak.turretDecor03AvatarOnAddToWorld(objectId)
	
	if Server then
		turretDecorIds[3] = objectId
	
	end
	
end

local function swapDecorations()
	
	if Server then
		local decorationsTotal = table.getn(turretDecorIds)
		
		for id = 1, decorationsTotal do
			local object = Object.Get(turretDecorIds[id])

			if object != nil && not turretDecorBreakSpawned[id] then
				local coords = Entity.Get(turretDecorIds[id]):GetCoords()
				local decorDBR = nil
				
				object:Destroy()
				
				turretDecorSpawningControl(id, coords)
				
			end
			
		end
	
	end

end


-- break throne self-destruct
function gd.quests.areaGKorvaak.turretBreakOnAddToWorld(objectId)

	if Server then
		local throne = Destructible.Get(objectId)
		throne:Destroy(Vec(0,1,0), 1000, false)
	
	end

end


-- Turrets
local turretAvatarIds = { 0, 0, 0 }
local turretCreatureIds = { 0, 0, 0 }
local turretCreatureSpawned = { false, false, false }
local turretBreakSpawned = { false, false, false }


-- store Turret Ids when spawned as creatures
function gd.quests.areaGKorvaak.turretCreatureOnAddToWorld(objectId)

	if Server then
		local found = false
		local turretsTotal = table.getn(turretCreatureIds)
		
		for id = 1, turretsTotal do
			if (turretCreatureIds[id] == 0 && not found) then
				turretCreatureIds[id] = objectId
				found = true
				
			end
			
		end
		
	end
	
end

 local function TurretCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 70
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 90
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


local function turretSpawningControl(turretNum, coordinates)

	if Server then
		if not phase03Spawned then
			local turretDBR = nil
			
			if turretNum == 1 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_01b.dbr"
			elseif turretNum == 2 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_02b.dbr"
			else
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_03b.dbr"
			end
			
			local decor = Entity.Create(turretDBR)
			decor:SetCoords(coordinates)
			
		elseif not bossKilled && not turretCreatureSpawned[turretNum] then
			turretCreatureSpawned[turretNum] = true
			local turret = Character.Create("records/skills/nonplayerskillsgdx2/bossskills/final/turret_eldritchthrone.dbr", TurretCreateArgs())
			turret:SetCoords(coordinates)
			
		elseif not bossFinished && bossKilled && not turretBreakSpawned[turretNum] then
			local turretDBR = nil
			
			if turretNum == 1 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_01b_korvaak.dbr"
			elseif turretNum == 2 then
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_02b_korvaak.dbr"
			else
				turretDBR = "records/storyelementsgdx2/questassets/areag_korvaak_throne_03b_korvaak.dbr"
			end
			
			local decor = Entity.Create(turretDBR)
			decor:SetCoords(coordinates)
		
		elseif bossFinished && not turretBreakSpawned[turretNum] then
			turretBreakSpawned[turretNum] = true
			local breakable = Entity.Create("records/storyelementsgdx2/questassets/areag_korvaak_throne_break.dbr")
			breakable:SetCoords(coordinates)
		
		end		
	
	end

end


function gd.quests.areaGKorvaak.turret01OnAddToWorld(objectId)
	
	if Server && not turretCreatureSpawned[1] then
		local coords = Entity.Get(objectId):GetCoords()
		
		turretSpawningControl(1, coords)
	
	end
	
end

function gd.quests.areaGKorvaak.turret01AvatarOnAddToWorld(objectId)
	
	if Server then
		turretAvatarIds[1] = objectId
	
	end
	
end


function gd.quests.areaGKorvaak.turret02OnAddToWorld(objectId)
	
	if Server && not turretCreatureSpawned[2] then
		local coords = Entity.Get(objectId):GetCoords()
		
		turretSpawningControl(2, coords)
	
	end
	
end

function gd.quests.areaGKorvaak.turret02AvatarOnAddToWorld(objectId)
	
	if Server then
		turretAvatarIds[2] = objectId
	
	end
	
end


function gd.quests.areaGKorvaak.turret03OnAddToWorld(objectId)
	
	if Server && not turretCreatureSpawned[3] then
		local coords = Entity.Get(objectId):GetCoords()
		
		turretSpawningControl(3, coords)
	
	end
	
end

function gd.quests.areaGKorvaak.turret03AvatarOnAddToWorld(objectId)
	
	if Server then
		turretAvatarIds[3] = objectId
	
	end
	
end

local function swapTurrets()
	
	if Server then
		local turretsTotal = table.getn(turretAvatarIds)
		
		for id = 1, turretsTotal do
			local object = Object.Get(turretAvatarIds[id])
			local character = Character.Get(turretCreatureIds[id])
			
			local coords = nil
			
			-- destroy turret decorations, if present
			if object != nil && not turretBreakSpawned[id] then
				coords = Entity.Get(turretAvatarIds[id]):GetCoords()
				local decorDBR = nil
				
				object:Destroy()
				
			end
			
			-- destroy turret monsters, if present
			if (character != nil) then
				coords = Entity.Get(turretCreatureIds[id]):GetCoords()
				
				character:Kill()
				
			end
			
			-- spawn new turrets
			turretSpawningControl(id, coords)
			
		end
	
	end

end


--
-- Final Boss Phase
-- in phase 03, boss destroys the thrones and turns them into turrets
--
function gd.quests.areaGKorvaak.bossPhase03OnAddToWorld(objectId)
	
	if Server then
		if not phase03Spawned then
			phase03Spawned = true
			
			-- swap thrones
			swapDecorations()
			
			swapTurrets()
		
		end
		
	end
	
end

-- boss killed
function gd.quests.areaGKorvaak.bossPhase03Killed()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x85B30C00
	local kTask = 0x7173CF80
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (questTaskState == QuestState.InProgress || questTaskState == QuestState.Complete) then
		GiveTokenToLocalPlayer("AREAG_KORVAAK_KILLED")
	end
	
	if Server then
		
		bossKilled = true
		
		-- swap thrones
		swapTurrets()
		
	end
	
end

function gd.quests.areaGKorvaak.bossPhase03Finished()
	
	if Server then
		local chest = Chest.Get(bossChestId);
		local lootChest = Chest.Get(lootChestId);
		local lootChest02 = Chest.Get(lootChest02Id);
		local door = Door.Get(bossExitShortcutId)
		
		bossFinished = true
	
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
		
		-- swap thrones
		swapDecorations()
		
		swapTurrets()
		
	end
	
end


-- Korvaak VO
local korvaakVO = { false, false, false }

function gd.quests.areaGKorvaak.korvaakVO01GlobalMP()

	korvaakVO[1] = true

end

function gd.quests.areaGKorvaak.korvaakVO01(triggererId)
	
	if (not korvaakVO[1]) then
		korvaakVO[1] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/korvaakvo_01.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("korvaakVO01")

end

function gd.quests.areaGKorvaak.korvaakVO02GlobalMP()

	korvaakVO[2] = true

end

function gd.quests.areaGKorvaak.korvaakVO02(triggererId)
	
	if (not korvaakVO[2]) then
		korvaakVO[2] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/korvaakvo_02.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("korvaakVO02")

end

function gd.quests.areaGKorvaak.korvaakVO03GlobalMP()

	korvaakVO[3] = true

end

function gd.quests.areaGKorvaak.korvaakVO03(triggererId)
	
	if (not korvaakVO[3]) then
		korvaakVO[3] = true
		local playerEntity = Entity.Get(triggererId)

		if (playerEntity != nil) then
		
			local coords = playerEntity:GetCoords()
			local pfx = Entity.Create("records/fx/anomalies/korvaakvo_03.dbr")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
		end
	
	end

	QuestGlobalEvent("korvaakVO03")

end
