/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.nemesisGDX1 = {}

-- Grim Dawn Nemesis Bosses
local aetherialVanguardSpawned = false
local chthonianVoidbornSpawned = false
local beastSpawned = false
local wendigoSpawned = false
local monsterId = 0

local aetherialVanguardKilled = false
local chthonianVoidbornKilled = false
local beastKilled = false
local wendigoKilled = false

local aetherialVanguardChestDestroyed = false
local chthonianVoidbornChestDestroyed = false
local beastChestDestroyed = false
local wendigoChestDestroyed = false

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local minLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		minLevel = 40
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		minLevel = 55
		maxLevel = 100
	else
		minLevel = 65
		maxLevel = 200
	end
	
	if (averageLevel < minLevel) then
		monsterLevel = ((minLevel+(minLevel/50))+4)
	elseif (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+4)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+4)

	end

	return monsterLevel, nil
	
end

function gd.nemesisGDX1.aetherialVanguardNemesisOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (player:GetFaction("USER12") == -20000 && aetherialVanguardSpawned == false && aetherialVanguardChestDestroyed == false) then
			aetherialVanguardSpawned = true
			monsterId = objectId
			local coords = Entity.Get(objectId):GetCoords()
			
			local spawn = Character.Create ("records/creatures/enemies/nemesis/nemesis_aetherialvanguard_01.dbr", CharacterCreateArgs())
			spawn:SetCoords(coords)
		
		end
	
	end
	
end

function gd.nemesisGDX1.chthonianVoidbornNemesisOnAddToWorld(objectId)
-- only spawn new chthonian nemesis after player has traversed the void with Ulgrim, aka met the Rylok boss
	if Server then
		local player = Game.GetLocalPlayer()
		if (player:GetFaction("CTHONIANS") == -20000 && chthonianVoidbornSpawned == false && chthonianVoidbornChestDestroyed == false && player:HasToken("AREAF_DAILATRANSITION")) then
			chthonianVoidbornSpawned = true
			monsterId = objectId
			local coords = Entity.Get(objectId):GetCoords()
			
			local spawn = Character.Create ("records/creatures/enemies/nemesis/nemesis_chthonianvoidborn_01.dbr", CharacterCreateArgs())
			spawn:SetCoords(coords)
		
		end
	
	end
	
end

function gd.nemesisGDX1.beastNemesisOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (player:GetFaction("BEASTS") == -20000 && beastSpawned == false && beastChestDestroyed == false) then
			beastSpawned = true
			monsterId = objectId
			local coords = Entity.Get(objectId):GetCoords()
			
			local spawn = Character.Create ("records/creatures/enemies/nemesis/nemesis_beast_01_p1.dbr", CharacterCreateArgs())
			spawn:SetCoords(coords)
		
		end
	
	end
	
end

function gd.nemesisGDX1.wendigoNemesisOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (player:GetFaction("USER10") == -20000 && wendigoSpawned == false && wendigoChestDestroyed == false) then
			wendigoSpawned = true
			monsterId = objectId
			local coords = Entity.Get(objectId):GetCoords()
			
			local spawn = Character.Create ("records/creatures/enemies/nemesis/nemesis_wendigo_01.dbr", CharacterCreateArgs())
			spawn:SetCoords(coords)
		
		end
	
	end
	
end


-- Chests
local aetherialVanguardChestId = 0
local chthonianVoidbornChestId = 0
local beastChestId = 0
local wendigoChestId = 0

function gd.nemesisGDX1.aetherialVanguardChestOnAddToWorld(objectId)
	
	if Server then	
		aetherialVanguardChestId = objectId
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player does not meet the faction requirements to spawn the Nemesis
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:GetFaction("USER12") > -20000) then
			chestEntity:Destroy()
			aetherialVanguardChestDestroyed = true
		elseif aetherialVanguardKilled then
			local chest = Chest.Get(objectId)
			chest:SetLocked(false)
		
		end
	
	end
	
end

function gd.nemesisGDX1.chthonianVoidbornChestOnAddToWorld(objectId)
-- only spawn new chthonian nemesis after player has traversed the void with Ulgrim, aka met the Rylok boss
	if Server then	
		chthonianVoidbornChestId = objectId
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player does not meet the faction requirements to spawn the Nemesis
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:GetFaction("CTHONIANS") > -20000 || player:HasToken("AREAF_DAILATRANSITION") == false) then
			chestEntity:Destroy()
			chthonianVoidbornChestDestroyed = true
		elseif chthonianVoidbornKilled then
			local chest = Chest.Get(objectId)
			chest:SetLocked(false)
		
		end
	
	end
	
end

function gd.nemesisGDX1.beastChestOnAddToWorld(objectId)
	
	if Server then	
		beastChestId = objectId
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player does not meet the faction requirements to spawn the Nemesis
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:GetFaction("BEASTS") > -20000) then
			chestEntity:Destroy()
			beastChestDestroyed = true
		elseif beastKilled then
			local chest = Chest.Get(objectId)
			chest:SetLocked(false)
		
		end
	
	end
	
end

function gd.nemesisGDX1.wendigoChestOnAddToWorld(objectId)
	
	if Server then	
		wendigoChestId = objectId
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player does not meet the faction requirements to spawn the Nemesis
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:GetFaction("USER10") > -20000) then
			chestEntity:Destroy()
			wendigoChestDestroyed = true
		elseif wendigoKilled then
			local chest = Chest.Get(objectId)
			chest:SetLocked(false)
		
		end
	
	end
	
end


function gd.nemesisGDX1.aetherialVanguardNemesisKilled()
	
	if Server then
		local chest = Chest.Get(aetherialVanguardChestId);
		
		aetherialVanguardKilled = true
		
		-- Unlock chest if present
		if (chest != nil) then
			chest:SetLocked(false)
		end
		
	end
	
end

function gd.nemesisGDX1.chthonianVoidbornNemesisKilled()
	
	if Server then
		local chest = Chest.Get(chthonianVoidbornChestId);
		
		chthonianVoidbornKilled = true
		
		-- Unlock chest if present
		if (chest != nil) then
			chest:SetLocked(false)
		end
		
	end
	
end

function gd.nemesisGDX1.wendigoNemesisKilled()
	
	if Server then
		local chest = Chest.Get(wendigoChestId);
		
		wendigoKilled = true
		
		-- Unlock chest if present
		if (chest != nil) then
			chest:SetLocked(false)
		end
		
	end
	
end

-- Beast Nemesis
local beastP03Dead = { false, false, false, false }

local function beastNemesisFinished()
	if Server then
		local chest = Chest.Get(beastChestId);
		
		beastKilled = true
		
		-- Unlock chest if present
		if (chest != nil) then
			chest:SetLocked(false)
		end
		
	end

	end

function gd.nemesisGDX1.beastNemesisP03AKilled()
	
	if Server then
		beastP03Dead[1] = true
		
		if beastP03Dead[1] && beastP03Dead[2] && beastP03Dead[3] && beastP03Dead[4] then
			-- if all 4 Beast Nemesis phase 3 copies have been killed, open the chest
			beastNemesisFinished()
		
		end
		
	end
	
end

function gd.nemesisGDX1.beastNemesisP03BKilled()
	
	if Server then
		beastP03Dead[2] = true
		
		if beastP03Dead[1] && beastP03Dead[2] && beastP03Dead[3] && beastP03Dead[4] then
			-- if all 4 Beast Nemesis phase 3 copies have been killed, open the chest
			beastNemesisFinished()
		
		end
		
	end
	
end

function gd.nemesisGDX1.beastNemesisP03CKilled()
	
	if Server then
		beastP03Dead[3] = true
		
		if beastP03Dead[1] && beastP03Dead[2] && beastP03Dead[3] && beastP03Dead[4] then
			-- if all 4 Beast Nemesis phase 3 copies have been killed, open the chest
			beastNemesisFinished()
		
		end
		
	end
	
end

function gd.nemesisGDX1.beastNemesisP03DKilled()
	
	if Server then
		beastP03Dead[4] = true
		
		if beastP03Dead[1] && beastP03Dead[2] && beastP03Dead[3] && beastP03Dead[4] then
			-- if all 4 Beast Nemesis phase 3 copies have been killed, open the chest
			beastNemesisFinished()
		
		end
		
	end
	
end