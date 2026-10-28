/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.dungeonChestsGDX1.areaEF = {}

--
-- Ugdenbog oneshot world chest 
--

-- Called when chest opened
function gd.dungeonChestsGDX1.areaEF.ugdenbogChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX1_UGDENBOG")
	
end

function gd.dungeonChestsGDX1.areaEF.ugdenbogChestOnAddToWorld(objectId)
	
	if Server then	
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX1_UGDENBOG")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Void's Edge oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX1.areaEF.voidEdgeChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX1_VOIDEDGE")
	
end

function gd.dungeonChestsGDX1.areaEF.voidEdgeChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX1_VOIDEDGE")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Malmouth oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX1.areaEF.malmouthChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX1_MALMOUTH")
	
end

function gd.dungeonChestsGDX1.areaEF.malmouthChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX1_MALMOUTH")) then
			chestEntity:Destroy()
		end
	
	end
	
end

--
-- Aetherial Factory oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX1.areaEF.factoryChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX1_FACTORY")
	
end

function gd.dungeonChestsGDX1.areaEF.factoryChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX1_FACTORY")) then
			chestEntity:Destroy()
		end
	
	end
	
end


--
-- Roguelike oneshot world chest
--

-- Called when chest opened
function gd.dungeonChestsGDX1.areaEF.roguelikeChestFound()

	GiveTokenIfPlayer(Game.GetLocalPlayer():GetId(), "DUNGEONCHESTGDX1_ROGUELIKE")
	
end

function gd.dungeonChestsGDX1.areaEF.roguelikeChestOnAddToWorld(objectId)

	if Server then
		local chestEntity = Entity.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:AnyoneHasToken("DUNGEONCHESTGDX1_ROGUELIKE")) then
			chestEntity:Destroy()
		end
	
	end
	
end