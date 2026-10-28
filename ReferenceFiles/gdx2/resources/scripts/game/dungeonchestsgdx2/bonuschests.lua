/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.dungeonChestsGDX2.bonusChests = {}

-- Bonus Chest State
local ChestState = { Default = 0, Looted = 1 }

-- Bonus Chest G01
local bonusChestG01StateObjects = orderedTable()
	bonusChestG01StateObjects["BONUSCHEST_G01"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	bonusChestG01StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_g01.dbr"}

local bonusChestG01Spawned = false

function gd.dungeonChestsGDX2.bonusChests.bonusG01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestG01Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestG01Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestG01StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.bonusChests.bonusG01OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.bonusChests.bonusG01ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_G01")
	
end

-- Bonus Chest G02
local bonusChestG02StateObjects = orderedTable()
	bonusChestG02StateObjects["BONUSCHEST_G02"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestG02StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_g02.dbr"}

local bonusChestG02Spawned = false

function gd.dungeonChestsGDX2.bonusChests.bonusG02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestG02Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestG02Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestG02StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.bonusChests.bonusG02OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.bonusChests.bonusG02ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_G02")
	
end

-- Bonus Chest G03
local bonusChestG03StateObjects = orderedTable()
	bonusChestG03StateObjects["BONUSCHEST_G03"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestG03StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_g03.dbr"}

local bonusChestG03Spawned = false

function gd.dungeonChestsGDX2.bonusChests.bonusG03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestG03Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestG03Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestG03StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.bonusChests.bonusG03OnDestroy = ClearObjectUserdata


function gd.dungeonChestsGDX2.bonusChests.bonusG03ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_G03")
	
end

-- Bonus Chest G04
local bonusChestG04StateObjects = orderedTable()
	bonusChestG04StateObjects["BONUSCHEST_G04"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestG04StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_g04.dbr"}

local bonusChestG04Spawned = false

function gd.dungeonChestsGDX2.bonusChests.bonusG04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestG04Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestG04Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestG04StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.bonusChests.bonusG04OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.bonusChests.bonusG04ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_G04")
	
end