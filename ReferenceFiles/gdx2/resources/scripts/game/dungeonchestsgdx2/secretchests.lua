/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.dungeonChestsGDX2.secretChests = {}

--
-- Controls for Secret Area Chests. Chests spawn with better loot initially, then a lesser version spawns on subsequent visits
-- Each chest should only be placed once, one per intended secret area
--

-- Mask Chest
function gd.dungeonChestsGDX2.secretChests.maskChest01Found()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "SECRETCHESTGDX2_MASK")
	
end

function gd.dungeonChestsGDX2.secretChests.maskChest01OnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and it's not Ultimate difficulty
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("SECRETCHESTGDX2_MASK")) then

			chestEntity:Destroy()
			
		end
	
	end
	
end

-- Secret Chest State
local ChestState = { Default = 0, Looted = 1 }

-- Secret Chest G01 (placed in town so it despawns permanently once looted)
local secretChestG01StateObjects = orderedTable()
	secretChestG01StateObjects["SECRETCHEST_G01"	] = { state = ChestState.Looted, dbr = nil}
	secretChestG01StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g01.dbr"}

local secretChestG01Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG01Spawned && player:GetLevel() > 2) then
			secretChestG01Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG01StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG01OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG01ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G01")
	
end


-- Secret Chest G02
local secretChestG02StateObjects = orderedTable()
	secretChestG02StateObjects["SECRETCHEST_G02"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG02StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g02.dbr"}

local secretChestG02Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG02Spawned && player:GetLevel() > 2) then
			secretChestG02Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG02StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG02OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG02ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G02")
	
end


-- Secret Chest G03
local secretChestG03StateObjects = orderedTable()
	secretChestG03StateObjects["SECRETCHEST_G03"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG03StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g03.dbr"}

local secretChestG03Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG03Spawned && player:GetLevel() > 2) then
			secretChestG03Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG03StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG03OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG03ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G03")
	
end


-- Secret Chest G04
local secretChestG04StateObjects = orderedTable()
	secretChestG04StateObjects["SECRETCHEST_G04"	] = { state = ChestState.Looted, dbr = nil}
	secretChestG04StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g04.dbr"}

local secretChestG04Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG04Spawned && player:GetLevel() > 2) then
			secretChestG04Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG04StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG04OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG04ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G04")
	
end


-- Secret Chest G05
local secretChestG05StateObjects = orderedTable()
	secretChestG05StateObjects["SECRETCHEST_G05"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG05StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g05.dbr"}

local secretChestG05Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG05OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG05Spawned && player:GetLevel() > 2) then
			secretChestG05Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG05StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG05OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG05ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G05")
	
end


-- Secret Chest G06
local secretChestG06StateObjects = orderedTable()
	secretChestG06StateObjects["SECRETCHEST_G06"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG06StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g06.dbr"}

local secretChestG06Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG06OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG06Spawned && player:GetLevel() > 2) then
			secretChestG06Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG06StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG06OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG06ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G06")
	
end


-- Secret Chest G07
local secretChestG07StateObjects = orderedTable()
	secretChestG07StateObjects["SECRETCHEST_G07"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01.dbr"}
	secretChestG07StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g07.dbr"}

local secretChestG07Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG07OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG07Spawned && player:GetLevel() > 2) then
			secretChestG07Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG07StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG07OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG07ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G07")
	
end


-- Secret Chest G08
local secretChestG08StateObjects = orderedTable()
	secretChestG08StateObjects["SECRETCHEST_G08"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG08StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g08.dbr"}

local secretChestG08Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG08OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG08Spawned && player:GetLevel() > 2) then
			secretChestG08Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG08StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG08OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG08ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G08")
	
end


-- Secret Chest G09
local secretChestG09StateObjects = orderedTable()
	secretChestG09StateObjects["SECRETCHEST_G09"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01.dbr"}
	secretChestG09StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g09.dbr"}

local secretChestG09Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG09OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG09Spawned && player:GetLevel() > 2) then
			secretChestG09Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG09StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG09OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG09ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G09")
	
end

-- Secret Chest G10
local secretChestG10StateObjects = orderedTable()
	secretChestG10StateObjects["SECRETCHEST_G10"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG10StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g10.dbr"}

local secretChestG10Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG10OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG10Spawned && player:GetLevel() > 2) then
			secretChestG10Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG10StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG10OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG10ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G10")
	
end

-- Secret Chest G11
local secretChestG11StateObjects = orderedTable()
	secretChestG11StateObjects["SECRETCHEST_G11"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG11StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g11.dbr"}

local secretChestG11Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG11OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG11Spawned && player:GetLevel() > 2) then
			secretChestG11Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG11StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG11OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG11ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G11")
	
end

-- Secret Chest G12
local secretChestG12StateObjects = orderedTable()
	secretChestG12StateObjects["SECRETCHEST_G12"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG12StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g12.dbr"}

local secretChestG12Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG12OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG12Spawned && player:GetLevel() > 2) then
			secretChestG12Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG12StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG12OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG12ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G12")
	
end

-- Secret Chest G13
local secretChestG13StateObjects = orderedTable()
	secretChestG13StateObjects["SECRETCHEST_G13"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG13StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g13.dbr"}

local secretChestG13Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG13OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG13Spawned && player:GetLevel() > 2) then
			secretChestG13Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG13StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG13OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG13ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G13")
	
end

-- Secret Chest G14
local secretChestG14StateObjects = orderedTable()
	secretChestG14StateObjects["SECRETCHEST_G14"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG14StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g14.dbr"}

local secretChestG14Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG14OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG14Spawned && player:GetLevel() > 2) then
			secretChestG14Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG14StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG14OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG14ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G14")
	
end

-- Secret Chest G15
local secretChestG15StateObjects = orderedTable()
	secretChestG15StateObjects["SECRETCHEST_G15"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG15StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g15.dbr"}

local secretChestG15Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG15OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG15Spawned && player:GetLevel() > 2) then
			secretChestG15Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG15StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG15OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG15ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G15")
	
end

-- Secret Chest G16
local secretChestG16StateObjects = orderedTable()
	secretChestG16StateObjects["SECRETCHEST_G16"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG16StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g16.dbr"}

local secretChestG16Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG16OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG16Spawned && player:GetLevel() > 2) then
			secretChestG16Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG16StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG16OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG16ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G16")
	
end

-- Secret Chest G17
local secretChestG17StateObjects = orderedTable()
	secretChestG17StateObjects["SECRETCHEST_G17"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG17StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g17.dbr"}

local secretChestG17Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG17OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG17Spawned && player:GetLevel() > 2) then
			secretChestG17Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG17StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG17OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG17ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G17")
	
end

-- Secret Chest G18
local secretChestG18StateObjects = orderedTable()
	secretChestG18StateObjects["SECRETCHEST_G18"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG18StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g18.dbr"}

local secretChestG18Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG18OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG18Spawned && player:GetLevel() > 2) then
			secretChestG18Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG18StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG18OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG18ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G18")
	
end

-- Secret Chest G19
local secretChestG19StateObjects = orderedTable()
	secretChestG19StateObjects["SECRETCHEST_G19"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG19StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g19.dbr"}

local secretChestG19Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG19OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG19Spawned && player:GetLevel() > 2) then
			secretChestG19Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG19StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG19OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG19ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G19")
	
end

-- Secret Chest G20
local secretChestG20StateObjects = orderedTable()
	secretChestG20StateObjects["SECRETCHEST_G20"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_obsidianshards01.dbr"}
	secretChestG20StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g20.dbr"}

local secretChestG20Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG20OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG20Spawned && player:GetLevel() > 2) then
			secretChestG20Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG20StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG20OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG20ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G20")
	
end

-- Secret Chest G21
local secretChestG21StateObjects = orderedTable()
	secretChestG21StateObjects["SECRETCHEST_G21"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chesteldritch01.dbr"}
	secretChestG21StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g21.dbr"}

local secretChestG21Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG21OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG21Spawned && player:GetLevel() > 2) then
			secretChestG21Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG21StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG21OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG21ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G21")
	
end

-- Secret Chest G22
local secretChestG22StateObjects = orderedTable()
	secretChestG22StateObjects["SECRETCHEST_G22"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG22StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g22.dbr"}

local secretChestG22Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG22OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG22Spawned && player:GetLevel() > 2) then
			secretChestG22Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG22StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG22OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG22ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G22")
	
end

-- Secret Chest G23
local secretChestG23StateObjects = orderedTable()
	secretChestG23StateObjects["SECRETCHEST_G23"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG23StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g23.dbr"}

local secretChestG23Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG23OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG23Spawned && player:GetLevel() > 2) then
			secretChestG23Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG23StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG23OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG23ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G23")
	
end

-- Secret Chest G24
local secretChestG24StateObjects = orderedTable()
	secretChestG24StateObjects["SECRETCHEST_G24"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG24StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g24.dbr"}

local secretChestG24Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG24OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG24Spawned && player:GetLevel() > 2) then
			secretChestG24Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG24StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG24OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG24ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G24")
	
end

-- Secret Chest G25
local secretChestG25StateObjects = orderedTable()
	secretChestG25StateObjects["SECRETCHEST_G25"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG25StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g25.dbr"}

local secretChestG25Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG25OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG25Spawned && player:GetLevel() > 2) then
			secretChestG25Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG25StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG25OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG25ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G25")
	
end

-- Secret Chest G26
local secretChestG26StateObjects = orderedTable()
	secretChestG26StateObjects["SECRETCHEST_G26"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG26StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g26.dbr"}

local secretChestG26Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG26OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG26Spawned && player:GetLevel() > 2) then
			secretChestG26Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG26StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG26OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG26ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G26")
	
end

-- Secret Chest G27
local secretChestG27StateObjects = orderedTable()
	secretChestG27StateObjects["SECRETCHEST_G27"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG27StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g27.dbr"}

local secretChestG27Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG27OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG27Spawned && player:GetLevel() > 2) then
			secretChestG27Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG27StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG27OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG27ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G27")
	
end

-- Secret Chest G28
local secretChestG28StateObjects = orderedTable()
	secretChestG28StateObjects["SECRETCHEST_G28"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG28StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g28.dbr"}

local secretChestG28Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG28OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG28Spawned && player:GetLevel() > 2) then
			secretChestG28Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG28StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG28OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG28ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G28")
	
end

-- Secret Chest G29
local secretChestG29StateObjects = orderedTable()
	secretChestG29StateObjects["SECRETCHEST_G29"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG29StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g29.dbr"}

local secretChestG29Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG29OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG29Spawned && player:GetLevel() > 2) then
			secretChestG29Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG29StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG29OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG29ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G29")
	
end

-- Secret Chest G30
local secretChestG30StateObjects = orderedTable()
	secretChestG30StateObjects["SECRETCHEST_G30"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01_basalt.dbr"}
	secretChestG30StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g30.dbr"}

local secretChestG30Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG30OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG30Spawned && player:GetLevel() > 2) then
			secretChestG30Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG30StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
		
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG30OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG30ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G30")
	
end

-- Secret Chest G31
local secretChestG31StateObjects = orderedTable()
	secretChestG31StateObjects["SECRETCHEST_G31"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01.dbr"}
	secretChestG31StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g31.dbr"}

local secretChestG31Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG31OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG31Spawned && player:GetLevel() > 2) then
			secretChestG31Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG31StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
		
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG31OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG31ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G31")
	
end

-- Secret Chest G32
local secretChestG32StateObjects = orderedTable()
	secretChestG32StateObjects["SECRETCHEST_G32"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01.dbr"}
	secretChestG32StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g32.dbr"}

local secretChestG32Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG32OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG32Spawned && player:GetLevel() > 2) then
			secretChestG32Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG32StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
		
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG32OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG32ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G32")
	
end

-- Secret Chest G33
local secretChestG33StateObjects = orderedTable()
	secretChestG33StateObjects["SECRETCHEST_G33"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG33StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g33.dbr"}

local secretChestG33Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG33OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG33Spawned && player:GetLevel() > 2) then
			secretChestG33Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG33StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG33OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG33ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G33")
	
end

-- Secret Chest G34
local secretChestG34StateObjects = orderedTable()
	secretChestG34StateObjects["SECRETCHEST_G34"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestG34StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g34.dbr"}

local secretChestG34Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG34OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG34Spawned && player:GetLevel() > 2) then
			secretChestG34Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG34StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG34OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG34ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G34")
	
end

-- Secret Chest G35
local secretChestG35StateObjects = orderedTable()
	secretChestG35StateObjects["SECRETCHEST_G35"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestmetal01.dbr"}
	secretChestG35StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g35.dbr"}

local secretChestG35Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG35OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG35Spawned && player:GetLevel() > 2) then
			secretChestG35Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG35StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG35OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG35ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G35")
	
end

-- Secret Chest G36
local secretChestG36StateObjects = orderedTable()
	secretChestG36StateObjects["SECRETCHEST_G36"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG36StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g36.dbr"}

local secretChestG36Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG36OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG36Spawned && player:GetLevel() > 2) then
			secretChestG36Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG36StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG36OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG36ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G36")
	
end

-- Secret Chest G37
local secretChestG37StateObjects = orderedTable()
	secretChestG37StateObjects["SECRETCHEST_G37"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG37StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g37.dbr"}

local secretChestG37Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG37OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG37Spawned && player:GetLevel() > 2) then
			secretChestG37Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG37StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG37OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG37ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G37")
	
end

-- Secret Chest G38
local secretChestG38StateObjects = orderedTable()
	secretChestG38StateObjects["SECRETCHEST_G38"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestkorvan01.dbr"}
	secretChestG38StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g38.dbr"}

local secretChestG38Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG38OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG38Spawned && player:GetLevel() > 2) then
			secretChestG38Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG38StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG38OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG38ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G38")
	
end

-- Secret Chest G39
local secretChestG39StateObjects = orderedTable()
	secretChestG39StateObjects["SECRETCHEST_G39"	] = { state = ChestState.Looted, dbr = "records/items/lootchests/b01_chestcorpse01.dbr"}
	secretChestG39StateObjects[""					 	] = { state = ChestState.Default, dbr = "records/items/lootchests/secretchests/secretchest_g39.dbr"}

local secretChestG39Spawned = false

function gd.dungeonChestsGDX2.secretChests.secretG39OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		if (not secretChestG39Spawned && player:GetLevel() > 2) then
			secretChestG39Spawned = true
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, secretChestG39StateObjects)
			
			Shared.setUserdata(objectId, userdata)
		
		end
			
	end
	
end

gd.dungeonChestsGDX2.secretChests.secretG39OnDestroy = ClearObjectUserdata

function gd.dungeonChestsGDX2.secretChests.secretG39ChestFound()

	GiveTokenToLocalPlayer("SECRETCHEST_G39")
	
end

