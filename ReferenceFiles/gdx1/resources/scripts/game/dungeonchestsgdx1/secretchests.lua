/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.dungeonChestsGDX1.secretChests = {}

--
-- Controls for Secret Area Chests. Chests spawn with better loot initially, then a lesser version spawns on subsequent visits
-- Each chest should only be placed once, one per intended secret area
--

-- Secret Chest State
local ChestState = { Default = 0, Looted = 1 }

-- Secret Chest E01
local secretChestE01StateObjects = orderedTable()
	secretChestE01StateObjects["SECRETCHEST_E01"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE01StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e01.dbr"}

local secretChestE01Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE01Spawned && player:GetLevel() > 2) then
			secretChestE01Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE01StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE01OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE01ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E01")
	
end


-- Secret Chest E02
local secretChestE02StateObjects = orderedTable()
	secretChestE02StateObjects["SECRETCHEST_E02"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE02StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e02.dbr"}

local secretChestE02Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE02Spawned && player:GetLevel() > 2) then
			secretChestE02Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE02StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE02OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE02ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E02")
	
end


-- Secret Chest E03
local secretChestE03StateObjects = orderedTable()
	secretChestE03StateObjects["SECRETCHEST_E03"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE03StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e03.dbr"}

local secretChestE03Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE03Spawned && player:GetLevel() > 2) then
			secretChestE03Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE03StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE03OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE03ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E03")
	
end


-- Secret Chest E04
local secretChestE04StateObjects = orderedTable()
	secretChestE04StateObjects["SECRETCHEST_E04"	] = { state = ChestState.Looted, dbr = nil}
	secretChestE04StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e04.dbr"}

local secretChestE04Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE04Spawned && player:GetLevel() > 2) then
			secretChestE04Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE04StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE04OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE04ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E04")
	
end


-- Secret Chest E05
local secretChestE05StateObjects = orderedTable()
	secretChestE05StateObjects["SECRETCHEST_E05"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE05StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e05.dbr"}

local secretChestE05Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE05OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE05Spawned && player:GetLevel() > 2) then
			secretChestE05Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE05StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE05OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE05ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E05")
	
end


-- Secret Chest E06
local secretChestE06StateObjects = orderedTable()
	secretChestE06StateObjects["SECRETCHEST_E06"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE06StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e06.dbr"}

local secretChestE06Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE06OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE06Spawned && player:GetLevel() > 2) then
			secretChestE06Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE06StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE06OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE06ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E06")
	
end


-- Secret Chest E07
local secretChestE07StateObjects = orderedTable()
	secretChestE07StateObjects["SECRETCHEST_E07"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE07StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e07.dbr"}

local secretChestE07Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE07OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE07Spawned && player:GetLevel() > 2) then
			secretChestE07Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE07StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE07OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE07ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E07")
	
end


-- Secret Chest E08
local secretChestE08StateObjects = orderedTable()
	secretChestE08StateObjects["SECRETCHEST_E08"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE08StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e08.dbr"}

local secretChestE08Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE08OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE08Spawned && player:GetLevel() > 2) then
			secretChestE08Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE08StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE08OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE08ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E08")
	
end


-- Secret Chest E09
local secretChestE09StateObjects = orderedTable()
	secretChestE09StateObjects["SECRETCHEST_E09"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE09StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e09.dbr"}

local secretChestE09Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE09OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE09Spawned && player:GetLevel() > 2) then
			secretChestE09Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE09StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE09OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE09ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E09")
	
end

-- Secret Chest E10
local secretChestE10StateObjects = orderedTable()
	secretChestE10StateObjects["SECRETCHEST_E10"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE10StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e10.dbr"}

local secretChestE10Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE10OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE10Spawned && player:GetLevel() > 2) then
			secretChestE10Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE10StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE10OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE10ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E10")
	
end

-- Secret Chest E11
local secretChestE11StateObjects = orderedTable()
	secretChestE11StateObjects["SECRETCHEST_E11"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE11StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e11.dbr"}

local secretChestE11Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE11OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE11Spawned && player:GetLevel() > 2) then
			secretChestE11Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE11StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE11OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE11ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E11")
	
end

-- Secret Chest E12
local secretChestE12StateObjects = orderedTable()
	secretChestE12StateObjects["SECRETCHEST_E12"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE12StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e12.dbr"}

local secretChestE12Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE12OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE12Spawned && player:GetLevel() > 2) then
			secretChestE12Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE12StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE12OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE12ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E12")
	
end

-- Secret Chest E13
local secretChestE13StateObjects = orderedTable()
	secretChestE13StateObjects["SECRETCHEST_E13"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE13StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e13.dbr"}

local secretChestE13Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE13OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE13Spawned && player:GetLevel() > 2) then
			secretChestE13Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE13StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE13OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE13ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E13")
	
end

-- Secret Chest E14
local secretChestE14StateObjects = orderedTable()
	secretChestE14StateObjects["SECRETCHEST_E14"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE14StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e14.dbr"}

local secretChestE14Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE14OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE14Spawned && player:GetLevel() > 2) then
			secretChestE14Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE14StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE14OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE14ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E14")
	
end

-- Secret Chest E15
local secretChestE15StateObjects = orderedTable()
	secretChestE15StateObjects["SECRETCHEST_E15"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE15StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e15.dbr"}

local secretChestE15Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE15OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE15Spawned && player:GetLevel() > 2) then
			secretChestE15Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE15StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE15OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE15ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E15")
	
end

-- Secret Chest E16
local secretChestE16StateObjects = orderedTable()
	secretChestE16StateObjects["SECRETCHEST_E16"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE16StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e16.dbr"}

local secretChestE16Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE16OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE16Spawned && player:GetLevel() > 2) then
			secretChestE16Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE16StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE16OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE16ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E16")
	
end

-- Secret Chest E17
local secretChestE17StateObjects = orderedTable()
	secretChestE17StateObjects["SECRETCHEST_E17"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE17StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e17.dbr"}

local secretChestE17Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE17OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE17Spawned && player:GetLevel() > 2) then
			secretChestE17Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE17StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE17OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE17ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E17")
	
end

-- Secret Chest E18
local secretChestE18StateObjects = orderedTable()
	secretChestE18StateObjects["SECRETCHEST_E18"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE18StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e18.dbr"}

local secretChestE18Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE18OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE18Spawned && player:GetLevel() > 2) then
			secretChestE18Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE18StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE18OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE18ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E18")
	
end

-- Secret Chest E19
local secretChestE19StateObjects = orderedTable()
	secretChestE19StateObjects["SECRETCHEST_E19"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestE19StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e19.dbr"}

local secretChestE19Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE19OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE19Spawned && player:GetLevel() > 2) then
			secretChestE19Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE19StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE19OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE19ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E19")
	
end

-- Secret Chest E20
local secretChestE20StateObjects = orderedTable()
	secretChestE20StateObjects["SECRETCHEST_E20"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE20StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e20.dbr"}

local secretChestE20Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE20OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE20Spawned && player:GetLevel() > 2) then
			secretChestE20Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE20StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE20OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE20ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E20")
	
end

-- Secret Chest E21
local secretChestE21StateObjects = orderedTable()
	secretChestE21StateObjects["SECRETCHEST_E21"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE21StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e21.dbr"}

local secretChestE21Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE21OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE21Spawned && player:GetLevel() > 2) then
			secretChestE21Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE21StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE21OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE21ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E21")
	
end

-- Secret Chest E22
local secretChestE22StateObjects = orderedTable()
	secretChestE22StateObjects["SECRETCHEST_E22"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestE22StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_e22.dbr"}

local secretChestE22Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretE22OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestE22Spawned && player:GetLevel() > 2) then
			secretChestE22Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestE22StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretE22OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretE22ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_E22")
	
end


-- Secret Chest F01
local secretChestF01StateObjects = orderedTable()
	secretChestF01StateObjects["SECRETCHEST_F01"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestF01StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f01.dbr"}

local secretChestF01Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF01Spawned && player:GetLevel() > 2) then
			secretChestF01Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF01StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF01OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF01ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F01")
	
end


-- Secret Chest F02
local secretChestF02StateObjects = orderedTable()
	secretChestF02StateObjects["SECRETCHEST_F02"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestF02StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f02.dbr"}

local secretChestF02Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF02Spawned && player:GetLevel() > 2) then
			secretChestF02Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF02StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF02OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF02ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F02")
	
end


-- Secret Chest F03
local secretChestF03StateObjects = orderedTable()
	secretChestF03StateObjects["SECRETCHEST_F03"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestF03StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f03.dbr"}

local secretChestF03Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF03Spawned && player:GetLevel() > 2) then
			secretChestF03Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF03StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF03OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF03ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F03")
	
end


-- Secret Chest F04
local secretChestF04StateObjects = orderedTable()
	secretChestF04StateObjects["SECRETCHEST_F04"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestF04StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f04.dbr"}

local secretChestF04Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF04Spawned && player:GetLevel() > 2) then
			secretChestF04Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF04StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF04OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF04ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F04")
	
end


-- Secret Chest F05
local secretChestF05StateObjects = orderedTable()
	secretChestF05StateObjects["SECRETCHEST_F05"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestF05StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f05.dbr"}

local secretChestF05Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF05OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF05Spawned && player:GetLevel() > 2) then
			secretChestF05Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF05StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF05OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF05ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F05")
	
end


-- Secret Chest F06
local secretChestF06StateObjects = orderedTable()
	secretChestF06StateObjects["SECRETCHEST_F06"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF06StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f06.dbr"}

local secretChestF06Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF06OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF06Spawned && player:GetLevel() > 2) then
			secretChestF06Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF06StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF06OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF06ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F06")
	
end


-- Secret Chest F07
local secretChestF07StateObjects = orderedTable()
	secretChestF07StateObjects["SECRETCHEST_F07"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF07StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f07.dbr"}

local secretChestF07Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF07OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF07Spawned && player:GetLevel() > 2) then
			secretChestF07Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF07StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF07OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF07ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F07")
	
end


-- Secret Chest F08
local secretChestF08StateObjects = orderedTable()
	secretChestF08StateObjects["SECRETCHEST_F08"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF08StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f08.dbr"}

local secretChestF08Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF08OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF08Spawned && player:GetLevel() > 2) then
			secretChestF08Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF08StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF08OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF08ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F08")
	
end


-- Secret Chest F09
local secretChestF09StateObjects = orderedTable()
	secretChestF09StateObjects["SECRETCHEST_F09"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF09StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f09.dbr"}

local secretChestF09Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF09OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF09Spawned && player:GetLevel() > 2) then
			secretChestF09Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF09StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF09OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF09ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F09")
	
end


-- Secret Chest F10
local secretChestF10StateObjects = orderedTable()
	secretChestF10StateObjects["SECRETCHEST_F10"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF10StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f10.dbr"}

local secretChestF10Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF10OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF10Spawned && player:GetLevel() > 2) then
			secretChestF10Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF10StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF10OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF10ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F10")
	
end

-- Secret Chest F11
local secretChestF11StateObjects = orderedTable()
	secretChestF11StateObjects["SECRETCHEST_F11"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF11StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f11.dbr"}

local secretChestF11Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF11OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF11Spawned && player:GetLevel() > 2) then
			secretChestF11Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF11StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF11OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF11ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F11")
	
end

-- Secret Chest F12
local secretChestF12StateObjects = orderedTable()
	secretChestF12StateObjects["SECRETCHEST_F12"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF12StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f12.dbr"}

local secretChestF12Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF12OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF12Spawned && player:GetLevel() > 2) then
			secretChestF12Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF12StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF12OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF12ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F12")
	
end

-- Secret Chest F13
local secretChestF13StateObjects = orderedTable()
	secretChestF13StateObjects["SECRETCHEST_F13"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF13StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f13.dbr"}

local secretChestF13Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF13OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF13Spawned && player:GetLevel() > 2) then
			secretChestF13Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF13StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF13OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF13ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F13")
	
end

-- Secret Chest F14
local secretChestF14StateObjects = orderedTable()
	secretChestF14StateObjects["SECRETCHEST_F14"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF14StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f14.dbr"}

local secretChestF14Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF14OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF14Spawned && player:GetLevel() > 2) then
			secretChestF14Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF14StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF14OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF14ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F14")
	
end

-- Secret Chest F15
local secretChestF15StateObjects = orderedTable()
	secretChestF15StateObjects["SECRETCHEST_F15"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF15StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f15.dbr"}

local secretChestF15Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF15OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF15Spawned && player:GetLevel() > 2) then
			secretChestF15Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF15StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF15OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF15ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F15")
	
end

-- Secret Chest F16
local secretChestF16StateObjects = orderedTable()
	secretChestF16StateObjects["SECRETCHEST_F16"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF16StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f16.dbr"}

local secretChestF16Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF16OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF16Spawned && player:GetLevel() > 2) then
			secretChestF16Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF16StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF16OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF16ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F16")
	
end

-- Secret Chest F17
local secretChestF17StateObjects = orderedTable()
	secretChestF17StateObjects["SECRETCHEST_F17"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF17StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f17.dbr"}

local secretChestF17Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF17OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF17Spawned && player:GetLevel() > 2) then
			secretChestF17Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF17StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF17OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF17ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F17")
	
end

-- Secret Chest F18
local secretChestF18StateObjects = orderedTable()
	secretChestF18StateObjects["SECRETCHEST_F18"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF18StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f18.dbr"}

local secretChestF18Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF18OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF18Spawned && player:GetLevel() > 2) then
			secretChestF18Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF18StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF18OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF18ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F18")
	
end

-- Secret Chest F19
local secretChestF19StateObjects = orderedTable()
	secretChestF19StateObjects["SECRETCHEST_F19"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF19StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f19.dbr"}

local secretChestF19Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF19OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF19Spawned && player:GetLevel() > 2) then
			secretChestF19Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF19StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF19OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF19ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F19")
	
end

-- Secret Chest F20
local secretChestF20StateObjects = orderedTable()
	secretChestF20StateObjects["SECRETCHEST_F20"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF20StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f20.dbr"}

local secretChestF20Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF20OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF20Spawned && player:GetLevel() > 2) then
			secretChestF20Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF20StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF20OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF20ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F20")
	
end

-- Secret Chest F21
local secretChestF21StateObjects = orderedTable()
	secretChestF21StateObjects["SECRETCHEST_F21"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestF21StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f21.dbr"}

local secretChestF21Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF21OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF21Spawned && player:GetLevel() > 2) then
			secretChestF21Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF21StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF21OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF21ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F21")
	
end

-- Secret Chest F22
local secretChestF22StateObjects = orderedTable()
	secretChestF22StateObjects["SECRETCHEST_F22"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestF22StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f22.dbr"}

local secretChestF22Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF22OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF22Spawned && player:GetLevel() > 2) then
			secretChestF22Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF22StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF22OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF22ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F22")
	
end

-- Secret Chest F23
local secretChestF23StateObjects = orderedTable()
	secretChestF23StateObjects["SECRETCHEST_F23"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF23StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f23.dbr"}

local secretChestF23Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF23OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF23Spawned && player:GetLevel() > 2) then
			secretChestF23Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF23StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF23OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF23ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F23")
	
end

-- Secret Chest F24
local secretChestF24StateObjects = orderedTable()
	secretChestF24StateObjects["SECRETCHEST_F24"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF24StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f24.dbr"}

local secretChestF24Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF24OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF24Spawned && player:GetLevel() > 2) then
			secretChestF24Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF24StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF24OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF24ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F24")
	
end

-- Secret Chest F25
local secretChestF25StateObjects = orderedTable()
	secretChestF25StateObjects["SECRETCHEST_F25"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF25StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f25.dbr"}

local secretChestF25Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF25OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF25Spawned && player:GetLevel() > 2) then
			secretChestF25Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF25StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF25OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF25ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F25")
	
end

-- Secret Chest F26
local secretChestF26StateObjects = orderedTable()
	secretChestF26StateObjects["SECRETCHEST_F26"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF26StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f26.dbr"}

local secretChestF26Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF26OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF26Spawned && player:GetLevel() > 2) then
			secretChestF26Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF26StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF26OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF26ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F26")
	
end

-- Secret Chest F27
local secretChestF27StateObjects = orderedTable()
	secretChestF27StateObjects["SECRETCHEST_F27"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestF27StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_f27.dbr"}

local secretChestF27Spawned = false

function gd.dungeonChestsGDX1.secretChests.secretF27OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestF27Spawned && player:GetLevel() > 2) then
			secretChestF27Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestF27StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX1.secretChests.secretF27OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX1.secretChests.secretF27ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_F27")
	
end