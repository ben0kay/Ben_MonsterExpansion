/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.dungeonChestsGDX1.bonusChests = {}

-- Bonus Chest State
local ChestState = { Default = 0, Looted = 1 }

-- Bonus Chest E01
local bonusChestE01StateObjects = orderedTable()
	bonusChestE01StateObjects["BONUSCHEST_E01"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	bonusChestE01StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_e01.dbr"}

local bonusChestE01Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusE01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestE01Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestE01Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestE01StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusE01OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusE01ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_E01")
	
end

-- Bonus Chest E02
local bonusChestE02StateObjects = orderedTable()
	bonusChestE02StateObjects["BONUSCHEST_E02"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestE02StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_e02.dbr"}

local bonusChestE02Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusE02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestE02Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestE02Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestE02StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusE02OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusE02ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_E02")
	
end

-- Bonus Chest E03
local bonusChestE03StateObjects = orderedTable()
	bonusChestE03StateObjects["BONUSCHEST_E03"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestE03StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_e03.dbr"}

local bonusChestE03Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusE03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestE03Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestE03Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestE03StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusE03OnDestroy = ClearObjectUserdata


function gd.dungeonChestsGDX1.bonusChests.bonusE03ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_E03")
	
end

-- Bonus Chest E04
local bonusChestE04StateObjects = orderedTable()
	bonusChestE04StateObjects["BONUSCHEST_E04"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestE04StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_e04.dbr"}

local bonusChestE04Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusE04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestE04Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestE04Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestE04StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusE04OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusE04ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_E04")
	
end

-- Bonus Chest F01
local bonusChestF01StateObjects = orderedTable()
	bonusChestF01StateObjects["BONUSCHEST_F01"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	bonusChestF01StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_f01.dbr"}

local bonusChestF01Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusF01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestF01Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestF01Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestF01StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusF01OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusF01ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_F01")
	
end

-- Bonus Chest F02
local bonusChestF02StateObjects = orderedTable()
	bonusChestF02StateObjects["BONUSCHEST_F02"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	bonusChestF02StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_f02.dbr"}

local bonusChestF02Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusF02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestF02Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestF02Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestF02StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusF02OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusF02ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_F02")
	
end

-- Bonus Chest F03
local bonusChestF03StateObjects = orderedTable()
	bonusChestF03StateObjects["BONUSCHEST_F03"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	bonusChestF03StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_f03.dbr"}

local bonusChestF03Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusF03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestF03Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestF03Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestF03StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusF03OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusF03ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_F03")
	
end


-- Bonus Chest F04
local bonusChestF04StateObjects = orderedTable()
	bonusChestF04StateObjects["BONUSCHEST_F04"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	bonusChestF04StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_f04.dbr"}

local bonusChestF04Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusF04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestF04Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestF04Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestF04StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusF04OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusF04ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_F04")
	
end


-- Bonus Chest F05
local bonusChestF05StateObjects = orderedTable()
	bonusChestF05StateObjects["BONUSCHEST_F05"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	bonusChestF05StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/bonuschests/bonuschest_f05.dbr"}

local bonusChestF05Spawned = false

function gd.dungeonChestsGDX1.bonusChests.bonusF05OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not bonusChestF05Spawned && player:GetLevel() > 2 && (Game.GetGameDifficulty() == Game.Difficulty.Normal)) then
			bonusChestF05Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, bonusChestF05StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.bonusChests.bonusF05OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.bonusChests.bonusF05ChestFound()

	GiveTokenToLocalPlayer("BONUSCHEST_F05")
	
end