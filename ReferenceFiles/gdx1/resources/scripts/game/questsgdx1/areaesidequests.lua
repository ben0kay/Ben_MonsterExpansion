/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaESideQuests = {}

--
-- Area E Trap Chests
--

-- UGdenbog
local ChestState = { Default = 0, Looted = 1 }
local BogChestCoords = nil
local bogChestOpened = false

local trappedChestBogStateObjects = orderedTable()
	trappedChestBogStateObjects["AREAE_TRAPPEDCHESTBOG_FOUND"] = { state = ChestState.Looted, dbr = nil}
	trappedChestBogStateObjects[""] = { state = ChestState.Default, dbr = "records/items/lootchests/questchests/ugdenbogtrap_01.dbr"}

local trappedChestBogSpawned = false

function gd.quests.areaESideQuests.trappedChestBogOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (not trappedChestBogSpawned && player:GetLevel() > 2) then
			
			trappedChestBogSpawned = true
			
			local entity = Entity.Get(objectId)
			BogChestCoords = entity:GetCoords()
			
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, trappedChestBogStateObjects)
			Shared.setUserdata(objectId, userdata)
		
		end
		
	end
	
end

gd.quests.areaESideQuests.trappedChestBogOnDestroy = ClearObjectUserdata

function gd.quests.areaESideQuests.trappedChestBogOpenedMP()
	
	if Server && not bogChestOpened then		
		bogChestOpened = true
		
		local fx = Entity.Create("records/fx/skillsothergdx1/attackradius/ghostnova_blue_radius_fxpak01.dbr")
		
		if (fx != nil) then
			fx:NetworkEnable()
			fx:SetCoords(BogChestCoords)
		end	

		local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areae_trapchest_01.dbr", BogChestCoords.origin)
		proxy:SetCoords(BogChestCoords)

	end

end

function gd.quests.areaESideQuests.trappedChestBogOpened()

	GiveTokenToLocalPlayer("AREAE_TRAPPEDCHESTBOG_FOUND")
	QuestEvent("BogTrappedChest")
	
end

-- Gloomwald Stash blockade
-- GloomwaldStashToken
-- GloomwaldStashBarricadeDestroy
-- AREAE_GLOOMWALDSTASH_OPENED
-- GloomwaldStashUpdate

-- The quest item is picked up - grant quest
function gd.quests.areaESideQuests.gloomwaldStashGrantQuest()
	local player = Game.GetLocalPlayer()
	
	local questId01 = 0x3B440600
	local taskId01 = 0x3CC5C340
	
	local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
	
	if ((questTaskState01 != QuestState.Complete) && (questTaskState01 != QuestState.InProgress)) then
		player:GrantQuest(0x3B440600, 0x3CC5C340)
	end
	
	if player:HasToken("DUNGEONCHEST_GLOOMWALDSTASH") == false then
		GiveTokenToLocalPlayer("AREAE_GLOOMWALDSTASH_UNLOCKED")
	
	end

end


local StashBlockadeState = { locked = 0, Active = 1, Destroyed = 2, Found = 3}

local StashBlockadeId = 0
local StashInteractiveId = 0
local spawnedStashBlockade = false
local GloomwaldStashUnlocked = false
local chestId = 0

-- Blockade
local StashBlockadeStateObjects = orderedTable();
	StashBlockadeStateObjects["DUNGEONCHEST_GLOOMWALDSTASH"] = { state = StashBlockadeState.Found,  dbr = nil }
	StashBlockadeStateObjects["AREAE_GLOOMWALDSTASH_OPENED"] = { state = StashBlockadeState.Destroyed,  dbr = nil }
	StashBlockadeStateObjects[""] = { state = StashBlockadeState.locked, dbr = "records/storyelements/questassets/areae_gloomwaldstash_break.dbr" }

function gd.quests.areaESideQuests.StashBlockadeOnAddToWorld(objectId)

	if Server then
		if (not spawnedStashBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, StashBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
		
			spawnedStashBlockade = true
		
		end
		
	end
	
end

gd.quests.areaESideQuests.StashBlockadeOnDestroy = ClearObjectUserdata

function gd.quests.areaESideQuests.StashBlockadeAvatarOnAddToWorld(objectId)

	if Server then
		StashBlockadeId = objectId
		
	end
	
end

-- Detonation Site - This remains invisible until the player has spoken with the wounded survivor.
local StashDetonationSiteStateObjects = orderedTable();
	StashDetonationSiteStateObjects["DUNGEONCHEST_GLOOMWALDSTASH"] = { state = StashBlockadeState.Found,  dbr = nil }
	StashDetonationSiteStateObjects["AREAE_GLOOMWALDSTASH_OPENED"]	= { state = StashBlockadeState.Destroyed,  dbr = nil }
	StashDetonationSiteStateObjects["AREAE_GLOOMWALDSTASH_UNLOCKED"] = { state = StashBlockadeState.Active,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_gloomwaldstash_detonationsite.dbr" }
	StashDetonationSiteStateObjects[""] = { state = StashBlockadeState.locked, dbr = nil }

function gd.quests.areaESideQuests.StashDetonationSiteOnAddToWorld(objectId)

	if Server then
	
		StashInteractiveId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, StashDetonationSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaESideQuests.StashDetonationSiteOnDestroy = ClearObjectUserdata

-- Swap the detonation site object
function gd.quests.areaESideQuests.gloomwaldStashUpdate()

	if Server then
		
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAE_GLOOMWALDSTASH_UNLOCKED") && not GloomwaldStashUnlocked then
			
			GloomwaldStashUnlocked = true
			
			local StashInteractive = Entity.Get(StashInteractiveId)
	
			if StashInteractive != nil then

				UpdateObjectSwap(StashInteractiveId, StashDetonationSiteStateObjects)
		
			end
	
		end
	
	end
	
end

-- Destroy Blockade
function gd.quests.areaESideQuests.StashBlockadeDestroyGlobalMP()

	GiveTokenToLocalPlayer("AREAE_GLOOMWALDSTASH_OPENED")

end

function gd.quests.areaESideQuests.StashBlockadeDestroy()

	if Server then
		
		if StashBlockadeId != 0 then
		
			local StashBlockade = Destructible.Get(StashBlockadeId)
			local coords = StashBlockade:GetCoords()
			StashBlockade:Destroy(Vec(0,1,0), 1000, false)
			StashBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		-- Unlock chest
		local chest = Chest.Get(chestId);
		if (chest != nil) then
			chest:SetLocked(false)
		end
	
		QuestGlobalEvent("GloomwaldStashToken")
	
	end
	
end

-- Called when chest opened
function gd.quests.areaESideQuests.chestFound()
	
	GiveTokenToLocalPlayer("DUNGEONCHEST_GLOOMWALDSTASH")
	
end

function gd.quests.areaESideQuests.chestOnAddToWorld(objectId)

	if Server then
		chestId = objectId
		local chestEntity = Entity.Get(objectId)
		local chest = Chest.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:ServerHasToken("DUNGEONCHEST_GLOOMWALDSTASH")) then
			chestEntity:Destroy()
		elseif (player:HasToken("AREAE_GLOOMWALDSTASH_OPENED") && chest != nil) then
			chest:SetLocked(false)
		end
	
	end
	
end

