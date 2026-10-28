/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.bountiesGDX2 = {}


--
-- Reset Scripts for all Bounties in case we make quest changes that reset them
--

-- -- reset fix for Witch God Cult bounties in case we make changes that reset them
local WGReset = false

function gd.bountiesGDX2.witchGodResetGlobalMP()

	if not WGReset then
		WGReset = true
		local player = Game.GetLocalPlayer()

		if (player:HasToken("BOUNTY_ACTIVE_WG")) then
			if (player:GetQuestState(0xD48A6000) != QuestState.InProgress && player:GetQuestState(0xE1282900) != QuestState.InProgress && player:GetQuestState(0x77D47380) != QuestState.InProgress && player:GetQuestState(0x4D70D680) != QuestState.InProgress && player:GetQuestState(0x857A6300) != QuestState.InProgress && player:GetQuestState(0xBDABF200) != QuestState.InProgress && player:GetQuestState(0xE495A900) != QuestState.InProgress && player:GetQuestState(0x0BB74940) != QuestState.InProgress && player:GetQuestState(0x88682C00) != QuestState.InProgress && player:GetQuestState(0x9C88DB00) != QuestState.InProgress) then
				if (player:GetQuestState(0xA8AEA000) != QuestState.InProgress && player:GetQuestState(0x432C8500) != QuestState.InProgress && player:GetQuestState(0x3887F240) != QuestState.InProgress && player:GetQuestState(0x867B2F00) != QuestState.InProgress) then
					player:RemoveToken("BOUNTY_ACTIVE_WG")
				
				end

			end
			
		end
			
	end

end


--
-- Grim Dawn Bounties
-- Bounty Limit per faction
-- Default Bounty Cap per session is 5
--

local bountyLimit = 5
local WGBounties = 0


-- Malmouth
function gd.bountiesGDX2.WGCheck()

	local test = true
	
	if WGBounties < bountyLimit then
		test = false
	
	end
	
	return test

end

function gd.bountiesGDX2.WGIncrement()
	
	WGBounties = WGBounties + 1

end


--
-- Bounty Monster Spawns
-- Controls spawns active only during a bounty. Spawns if any players has the bounty active, rather than depending on host state.
--
local BountyState = { Default = 0, Spawned = 1 }

-- Bounty Monster Level Control
local monsterId = 0

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
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

-- General bounty functions
gd.bountiesGDX2.bountyOnDestroy = ClearObjectUserdata

--Witch God Cult Spawns
--Bounty 04
local WGBounty04Id = 0
local WGBounty04Spawned = false

local WGBounty04StateObjects = orderedTable()
	WGBounty04StateObjects["WG_BOUNTY04"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty04.dbr"}
	WGBounty04StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty04OnAddToWorld(objectId)
	if Server then
		if (not WGBounty04Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY04")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty04.dbr"
				MPOverrideState = true
				WGBounty04Spawned = true
				
			end

			monsterId = objectId
			WGBounty04Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty04StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty04Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty04()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty04Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(WGBounty04Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY04")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty04.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = WGBounty04Id
				local didWork, newState = UpdateObjectSwap(WGBounty04Id, WGBounty04StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty04Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 05
local WGBounty05Id = 0
local WGBounty05Spawned = false

local WGBounty05StateObjects = orderedTable()
	WGBounty05StateObjects["WG_BOUNTY05"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty05.dbr"}
	WGBounty05StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty05OnAddToWorld(objectId)
	if Server then
		if (not WGBounty05Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY05")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty05.dbr"
				MPOverrideState = true
				WGBounty05Spawned = true
				
			end

			monsterId = objectId
			WGBounty05Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty05Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty05()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty05Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(WGBounty05Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY05")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty05.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = WGBounty05Id
				local didWork, newState = UpdateObjectSwap(WGBounty05Id, WGBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty05Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 07
local WGBounty07Id = 0
local WGBounty07Spawned = false

local WGBounty07StateObjects = orderedTable()
	WGBounty07StateObjects["WG_BOUNTY07"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty07.dbr"}
	WGBounty07StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty07OnAddToWorld(objectId)
	if Server then
		if (not WGBounty07Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY07")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty07.dbr"
				MPOverrideState = true
				WGBounty07Spawned = true
				
			end

			monsterId = objectId
			WGBounty07Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty07Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty07()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty07Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(WGBounty07Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY07")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty07.dbr"
					MPOverrideState = true
				
				end
			
				monsterId = WGBounty07Id
				local didWork, newState = UpdateObjectSwap(WGBounty07Id, WGBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty07Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 08
local WGBounty08Id = 0
local WGBounty08Spawned = false

local WGBounty08StateObjects = orderedTable()
	WGBounty08StateObjects["WG_BOUNTY08"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty08.dbr"}
	WGBounty08StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty08OnAddToWorld(objectId)
	if Server then
		if (not WGBounty08Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY08")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty08.dbr"
				MPOverrideState = true
				WGBounty08Spawned = true
				
			end

			monsterId = objectId
			WGBounty08Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty08Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty08()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty08Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(WGBounty08Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY08")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty08.dbr"
					MPOverrideState = true
					
				end
				monsterId = WGBounty08Id
				local didWork, newState = UpdateObjectSwap(WGBounty08Id, WGBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty08spawned = true
			
			end
			
		end
	
	end

end

--Bounty 09
local WGBounty09Id = 0
local WGBounty09Spawned = false

local WGBounty09StateObjects = orderedTable()
	WGBounty09StateObjects["WG_BOUNTY09"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty09.dbr"}
	WGBounty09StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty09OnAddToWorld(objectId)
	if Server then
		if (not WGBounty09Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY09")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty09.dbr"
				MPOverrideState = true
				WGBounty09Spawned = true
				
			end

			monsterId = objectId
			WGBounty09Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty09StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty09Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty09()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty09Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(WGBounty09Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY09")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty09.dbr"
					MPOverrideState = true
					
				end
				monsterId = WGBounty09Id
				local didWork, newState = UpdateObjectSwap(WGBounty09Id, WGBounty09StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty09spawned = true
			
			end
			
		end
	
	end

end

--Bounty 10
local WGBounty10Id = 0
local WGBounty10Spawned = false

local WGBounty10StateObjects = orderedTable()
	WGBounty10StateObjects["WG_BOUNTY10"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty10.dbr"}
	WGBounty10StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty10OnAddToWorld(objectId)
	if Server then
		if (not WGBounty10Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY10")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty10.dbr"
				MPOverrideState = true
				WGBounty10Spawned = true
				
			end

			monsterId = objectId
			WGBounty10Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty10StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty10Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty10()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty10Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(WGBounty10Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY10")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty10.dbr"
					MPOverrideState = true
					
				end
				monsterId = WGBounty10Id
				local didWork, newState = UpdateObjectSwap(WGBounty10Id, WGBounty10StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty10spawned = true
			
			end
			
		end
	
	end

end

--Bounty 11
local WGBounty11Id = 0
local WGBounty11Spawned = false

local WGBounty11StateObjects = orderedTable()
	WGBounty11StateObjects["WG_BOUNTY11"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/wg_bounty11.dbr"}
	WGBounty11StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX2.WGBounty11OnAddToWorld(objectId)
	if Server then
		if (not WGBounty11Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("WG_BOUNTY11")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty11.dbr"
				MPOverrideState = true
				WGBounty11Spawned = true
				
			end

			monsterId = objectId
			WGBounty11Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WGBounty11StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				WGBounty11Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX2.spawnWGBounty11()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not WGBounty11Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(WGBounty11Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("WG_BOUNTY11")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/wg_bounty11.dbr"
					MPOverrideState = true
					
				end
				monsterId = WGBounty11Id
				local didWork, newState = UpdateObjectSwap(WGBounty11Id, WGBounty11StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				WGBounty11spawned = true
			
			end
			
		end
	
	end

end



