/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.dungeonChestsGDX2.areaG = {}

--
-- Desert oneshot world chest 
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.desertChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_DESERT")
	
end

function gd.dungeonChestsGDX2.areaG.desertChestOnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_DESERT")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Volcanic oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.volcanicChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_VOLCANIC")
	
end

function gd.dungeonChestsGDX2.areaG.volcanicChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_VOLCANIC")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Temple oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.templeChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_TEMPLE")
	
end

function gd.dungeonChestsGDX2.areaG.templeChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_TEMPLE")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Tomb oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.tombChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_TOMB")
	
end

function gd.dungeonChestsGDX2.areaG.tombChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_TOMB")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Riggs oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.riggsChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_RIGGS")
	
end

function gd.dungeonChestsGDX2.areaG.riggsChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_RIGGS")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- pre Roguelike oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.tombOfHereticChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_TOMBOFHERETIC")
	
end

function gd.dungeonChestsGDX2.areaG.tombOfHereticChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_TOMBOFHERETIC")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- new side areas one shot world chests
--

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.sideArea01ChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_SIDEAREA01")
	
end

function gd.dungeonChestsGDX2.areaG.sideArea01ChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_SIDEAREA01")) then
			chestEntity:Destroy()
		end
	
	end
	
end

-- Called when chest opened
function gd.dungeonChestsGDX2.areaG.sideArea02ChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX2_SIDEAREA02")
	
end

function gd.dungeonChestsGDX2.areaG.sideArea02ChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX2_SIDEAREA02")) then
			chestEntity:Destroy()
		end
	
	end
	
end
