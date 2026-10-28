/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.bountiesGDX1 = {}


--
-- Reset Scripts for all Bounties in case we make quest changes that reset them
--

-- reset fix for Coven bounties in case we make changes that reset them
local CUReset = false

function gd.bountiesGDX1.covenResetGlobalMP()

	if not CUReset then
		CUReset = true
		local player = Game.GetLocalPlayer()

		if (player:HasToken("BOUNTY_ACTIVE_CU")) then
			if (player:GetQuestState(0x2FEF17C0) != QuestState.InProgress && player:GetQuestState(0xC10E0500) != QuestState.InProgress && player:GetQuestState(0xC5441100) != QuestState.InProgress && player:GetQuestState(0x8BE45500) != QuestState.InProgress && player:GetQuestState(0x81B7C800) != QuestState.InProgress && player:GetQuestState(0x9447E200) != QuestState.InProgress && player:GetQuestState(0x9DB49B00) != QuestState.InProgress && player:GetQuestState(0xA6F8D000) != QuestState.InProgress && player:GetQuestState(0xE01A6900) != QuestState.InProgress && player:GetQuestState(0x31D40B80) != QuestState.InProgress) then
				if (player:GetQuestState(0x54E4F880) != QuestState.InProgress && player:GetQuestState(0x079DFC88) != QuestState.InProgress && player:GetQuestState(0x2161FEC0) != QuestState.InProgress && player:GetQuestState(0xBAD73B00) != QuestState.InProgress) then
					player:RemoveToken("BOUNTY_ACTIVE_CU")
				
				end

			end
			
		end
			
	end

end

-- reset fix for Cult bounties in case we make changes that reset them
local CWReset = false

function gd.bountiesGDX1.cultResetGlobalMP()

	if not CWReset then
		CWReset = true
		local player = Game.GetLocalPlayer()

		if (player:HasToken("BOUNTY_ACTIVE_CW")) then
			if (player:GetQuestState(0x9141B600) != QuestState.InProgress && player:GetQuestState(0x3AB17CC0) != QuestState.InProgress && player:GetQuestState(0xECD33000) != QuestState.InProgress && player:GetQuestState(0x2F60FF80) != QuestState.InProgress && player:GetQuestState(0x78D2B380) != QuestState.InProgress && player:GetQuestState(0x97909A00) != QuestState.InProgress && player:GetQuestState(0x2BD80DC0) != QuestState.InProgress && player:GetQuestState(0xA4DED500) != QuestState.InProgress && player:GetQuestState(0xF4A2C300) != QuestState.InProgress && player:GetQuestState(0xA53E9400) != QuestState.InProgress) then
				if (player:GetQuestState(0xE4E82300) != QuestState.InProgress && player:GetQuestState(0x5C6E4300) != QuestState.InProgress && player:GetQuestState(0xBDAAC200) != QuestState.InProgress && player:GetQuestState(0x1CA5B820) != QuestState.InProgress) then
					player:RemoveToken("BOUNTY_ACTIVE_CW")
					
				end

			end
			
		end
			
	end

end

-- reset fix for Malmouth bounties in case we make changes that reset them
local PMReset = false

function gd.bountiesGDX1.malmouthResetGlobalMP()

	if not PMReset then
		PMReset = true
		local player = Game.GetLocalPlayer()

		if (player:HasToken("BOUNTY_ACTIVE_PM")) then
			if (player:GetQuestState(0xD48A6000) != QuestState.InProgress && player:GetQuestState(0xE1282900) != QuestState.InProgress && player:GetQuestState(0x77D47380) != QuestState.InProgress && player:GetQuestState(0x4D70D680) != QuestState.InProgress && player:GetQuestState(0x857A6300) != QuestState.InProgress && player:GetQuestState(0xBDABF200) != QuestState.InProgress && player:GetQuestState(0xE495A900) != QuestState.InProgress && player:GetQuestState(0x0BB74940) != QuestState.InProgress && player:GetQuestState(0x88682C00) != QuestState.InProgress && player:GetQuestState(0x9C88DB00) != QuestState.InProgress) then
				if (player:GetQuestState(0xA8AEA000) != QuestState.InProgress && player:GetQuestState(0x432C8500) != QuestState.InProgress && player:GetQuestState(0x3887F240) != QuestState.InProgress && player:GetQuestState(0x867B2F00) != QuestState.InProgress) then
					player:RemoveToken("BOUNTY_ACTIVE_PM")
				
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
local CUBounties = 0
local CWBounties = 0
local PMBounties = 0


-- Coven
function gd.bountiesGDX1.CUCheck()

	local test = true
	
	if CUBounties < bountyLimit then
		test = false
	
	end
	
	return test

end

function gd.bountiesGDX1.CUIncrement()
	
	CUBounties = CUBounties + 1

end

-- Cult
function gd.bountiesGDX1.CWCheck()

	local test = true
	
	if CWBounties < bountyLimit then
		test = false
	
	end
	
	return test

end

function gd.bountiesGDX1.CWIncrement()
	
	CWBounties = CWBounties + 1

end

-- Malmouth
function gd.bountiesGDX1.PMCheck()

	local test = true
	
	if PMBounties < bountyLimit then
		test = false
	
	end
	
	return test

end

function gd.bountiesGDX1.PMIncrement()
	
	PMBounties = PMBounties + 1

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
gd.bountiesGDX1.bountyOnDestroy = ClearObjectUserdata

-- Coven of Ugdenbog Spawns
--Bounty 04
local CUBounty04Id = 0
local CUBounty04Spawned = false

local CUBounty04StateObjects = orderedTable()
	CUBounty04StateObjects["CU_BOUNTY04"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cu_bounty04.dbr"}
	CUBounty04StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CUBounty04OnAddToWorld(objectId)
	if Server then
		if (not CUBounty04Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CU_BOUNTY04")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty04.dbr"
				MPOverrideState = true
				CUBounty04Spawned = true
				
			end

			monsterId = objectId
			CUBounty04Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CUBounty04StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CUBounty04Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCUBounty04()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CUBounty04Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CUBounty04Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CU_BOUNTY04")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty04.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = CUBounty04Id
				local didWork, newState = UpdateObjectSwap(CUBounty04Id, CUBounty04StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CUBounty04Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 05
local CUBounty05Id = 0
local CUBounty05Spawned = false

local CUBounty05StateObjects = orderedTable()
	CUBounty05StateObjects["CU_BOUNTY05"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cu_bounty05.dbr"}
	CUBounty05StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CUBounty05OnAddToWorld(objectId)
	if Server then
		if (not CUBounty05Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CU_BOUNTY05")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty05.dbr"
				MPOverrideState = true
				CUBounty05Spawned = true
				
			end

			monsterId = objectId
			CUBounty05Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CUBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CUBounty05Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCUBounty05()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CUBounty05Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CUBounty05Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CU_BOUNTY05")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty05.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = CUBounty05Id
				local didWork, newState = UpdateObjectSwap(CUBounty05Id, CUBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CUBounty05Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 06
local CUBounty06Id = 0
local CUBounty06Spawned = false

local CUBounty06StateObjects = orderedTable()
	CUBounty06StateObjects["CU_BOUNTY06"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cu_bounty06.dbr"}
	CUBounty06StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CUBounty06OnAddToWorld(objectId)
	if Server then
		if (not CUBounty06Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CU_BOUNTY06")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty06.dbr"
				MPOverrideState = true
				CUBounty06Spawned = true
				
			end

			monsterId = objectId
			CUBounty06Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CUBounty06StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CUBounty06Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCUBounty06()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CUBounty06Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CUBounty06Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CU_BOUNTY06")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty06.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = CUBounty06Id
				local didWork, newState = UpdateObjectSwap(CUBounty06Id, CUBounty06StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CUBounty06Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 07
local CUBounty07Id = 0
local CUBounty07Spawned = false

local CUBounty07StateObjects = orderedTable()
	CUBounty07StateObjects["CU_BOUNTY07"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cu_bounty07.dbr"}
	CUBounty07StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CUBounty07OnAddToWorld(objectId)
	if Server then
		if (not CUBounty07Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CU_BOUNTY07")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty07.dbr"
				MPOverrideState = true
				CUBounty07Spawned = true
				
			end

			monsterId = objectId
			CUBounty07Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CUBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CUBounty07Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCUBounty07()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CUBounty07Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CUBounty07Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CU_BOUNTY07")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty07.dbr"
					MPOverrideState = true
					
				end
			
				monsterId = CUBounty07Id
				local didWork, newState = UpdateObjectSwap(CUBounty07Id, CUBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CUBounty07Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 08
local CUBounty08Id = 0
local CUBounty08Spawned = false

local CUBounty08StateObjects = orderedTable()
	CUBounty08StateObjects["CU_BOUNTY08"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cu_bounty08.dbr"}
	CUBounty08StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CUBounty08OnAddToWorld(objectId)
	if Server then
		if (not CUBounty08Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CU_BOUNTY08")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty08.dbr"
				MPOverrideState = true
				CUBounty08Spawned = true
				
			end

			monsterId = objectId
			CUBounty08Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CUBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CUBounty08Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCUBounty08()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CUBounty08Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(CUBounty08Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CU_BOUNTY08")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty08.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = CUBounty08Id
				local didWork, newState = UpdateObjectSwap(CUBounty08Id, CUBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CUBounty08Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 09
local CUBounty09Id = 0
local CUBounty09Spawned = false

local CUBounty09StateObjects = orderedTable()
	CUBounty09StateObjects["CU_BOUNTY09"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cu_bounty09.dbr"}
	CUBounty09StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CUBounty09OnAddToWorld(objectId)
	if Server then
		if (not CUBounty09Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CU_BOUNTY09")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty09.dbr"
				MPOverrideState = true
				CUBounty09Spawned = true
				
			end

			monsterId = objectId
			CUBounty09Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CUBounty09StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CUBounty09Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCUBounty09()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CUBounty09Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(CUBounty09Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CU_BOUNTY09")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cu_bounty09.dbr"
					MPOverrideState = true
					
				end
				monsterId = CUBounty09Id
				local didWork, newState = UpdateObjectSwap(CUBounty09Id, CUBounty09StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CUBounty09Spawned = true
			
			end
			
		end
	
	end

end


-- Cult of Wendigo Spawns
-- Bounty 04
local CWBounty04Id = 0
local CWBounty04Spawned = false

local CWBounty04StateObjects = orderedTable()
	CWBounty04StateObjects["CW_BOUNTY04"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cw_bounty04.dbr"}
	CWBounty04StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CWBounty04OnAddToWorld(objectId)
	if Server then
		if (not CWBounty04Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CW_BOUNTY04")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty04.dbr"
				MPOverrideState = true
				CWBounty04Spawned = true
				
			end

			monsterId = objectId
			CWBounty04Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CWBounty04StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CWBounty04Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCWBounty04()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CWBounty04Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(CWBounty04Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CW_BOUNTY04")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty04.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = CWBounty04Id
				local didWork, newState = UpdateObjectSwap(CWBounty04Id, CWBounty04StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CWBounty04Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 05
local CWBounty05Id = 0
local CWBounty05Spawned = false

local CWBounty05StateObjects = orderedTable()
	CWBounty05StateObjects["CW_BOUNTY05"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cw_bounty05.dbr"}
	CWBounty05StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CWBounty05OnAddToWorld(objectId)
	if Server then
		if (not CWBounty05Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CW_BOUNTY05")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty05.dbr"
				MPOverrideState = true
				CWBounty05Spawned = true
				
			end

			monsterId = objectId
			CWBounty05Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CWBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CWBounty05Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCWBounty05()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CWBounty05Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(CWBounty05Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CW_BOUNTY05")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty05.dbr"
					MPOverrideState = true
				
				end
				
				monsterId = CWBounty05Id
				local didWork, newState = UpdateObjectSwap(CWBounty05Id, CWBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CWBounty05Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 06
local CWBounty06Id = 0
local CWBounty06Spawned = false

local CWBounty06StateObjects = orderedTable()
	CWBounty06StateObjects["CW_BOUNTY06"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cw_bounty06.dbr"}
	CWBounty06StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CWBounty06OnAddToWorld(objectId)
	if Server then
		if (not CWBounty06Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CW_BOUNTY06")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty06.dbr"
				MPOverrideState = true
				CWBounty06Spawned = true
				
			end

			monsterId = objectId
			CWBounty06Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CWBounty06StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CWBounty06Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCWBounty06()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CWBounty06Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CWBounty06Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CW_BOUNTY06")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty06.dbr"
					MPOverrideState = true
				
				end
				
				monsterId = CWBounty06Id
				local didWork, newState = UpdateObjectSwap(CWBounty06Id, CWBounty06StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CWBounty06Spawned = true
			
			end
			
		end
	
	end

end


--Bounty 07
local CWBounty07Id = 0
local CWBounty07Spawned = false

local CWBounty07StateObjects = orderedTable()
	CWBounty07StateObjects["CW_BOUNTY07"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cw_bounty07.dbr"}
	CWBounty07StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CWBounty07OnAddToWorld(objectId)
	if Server then
		if (not CWBounty07Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CW_BOUNTY07")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty07.dbr"
				MPOverrideState = true
				CWBounty07Spawned = true
				
			end

			monsterId = objectId
			CWBounty07Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CWBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CWBounty07Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCWBounty07()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CWBounty07Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CWBounty07Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CW_BOUNTY07")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty07.dbr"
					MPOverrideState = true
				
				end
				
				monsterId = CWBounty07Id
				local didWork, newState = UpdateObjectSwap(CWBounty07Id, CWBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CWBounty07Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 08
local CWBounty08Id = 0
local CWBounty08Spawned = false

local CWBounty08StateObjects = orderedTable()
	CWBounty08StateObjects["CW_BOUNTY08"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cw_bounty08.dbr"}
	CWBounty08StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CWBounty08OnAddToWorld(objectId)
	if Server then
		if (not CWBounty08Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CW_BOUNTY08")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty08.dbr"
				MPOverrideState = true
				CWBounty08Spawned = true
				
			end

			monsterId = objectId
			CWBounty08Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CWBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CWBounty08Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCWBounty08()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CWBounty08Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CWBounty08Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CW_BOUNTY08")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty08.dbr"
					MPOverrideState = true
				
				end
				
				monsterId = CWBounty08Id
				local didWork, newState = UpdateObjectSwap(CWBounty08Id, CWBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CWBounty08Spawned = true
			
			end
			
		end
	
	end

end


--Bounty 09
local CWBounty09Id = 0
local CWBounty09Spawned = false

local CWBounty09StateObjects = orderedTable()
	CWBounty09StateObjects["CW_BOUNTY09"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/cw_bounty09.dbr"}
	CWBounty09StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.CWBounty09OnAddToWorld(objectId)
	if Server then
		if (not CWBounty09Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("CW_BOUNTY09")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty09.dbr"
				MPOverrideState = true
				CWBounty09Spawned = true
				
			end

			monsterId = objectId
			CWBounty09Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, CWBounty09StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				CWBounty09Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnCWBounty09()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not CWBounty09Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(CWBounty09Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("CW_BOUNTY09")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/cw_bounty09.dbr"
					MPOverrideState = true
				
				end
				
				monsterId = CWBounty09Id
				local didWork, newState = UpdateObjectSwap(CWBounty09Id, CWBounty09StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				CWBounty09Spawned = true
			
			end
			
		end
	
	end

end

--People of Malmouth Spawns
--Bounty 05
local PMBounty05Id = 0
local PMBounty05Spawned = false

local PMBounty05StateObjects = orderedTable()
	PMBounty05StateObjects["PM_BOUNTY05"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/pm_bounty05.dbr"}
	PMBounty05StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.PMBounty05OnAddToWorld(objectId)
	if Server then
		if (not PMBounty05Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("PM_BOUNTY05")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty05.dbr"
				MPOverrideState = true
				PMBounty05Spawned = true
				
			end

			monsterId = objectId
			PMBounty05Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, PMBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				PMBounty05Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnPMBounty05()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not PMBounty05Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			local entity = Entity.Get(PMBounty05Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("PM_BOUNTY05")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty05.dbr"
					MPOverrideState = true
					
				end
				
				monsterId = PMBounty05Id
				local didWork, newState = UpdateObjectSwap(PMBounty05Id, PMBounty05StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				PMBounty05Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 06
local PMBounty06Id = 0
local PMBounty06Spawned = false

local PMBounty06StateObjects = orderedTable()
	PMBounty06StateObjects["PM_BOUNTY06"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/pm_bounty06.dbr"}
	PMBounty06StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.PMBounty06OnAddToWorld(objectId)
	if Server then
		if (not PMBounty06Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("PM_BOUNTY06")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty06.dbr"
				MPOverrideState = true
				PMBounty06Spawned = true
				
			end

			monsterId = objectId
			PMBounty06Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, PMBounty06StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				PMBounty06Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnPMBounty06()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not PMBounty06Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(PMBounty06Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("PM_BOUNTY06")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty06.dbr"
					MPOverrideState = true
				
				end
				
				monsterId = PMBounty06Id
				local didWork, newState = UpdateObjectSwap(PMBounty06Id, PMBounty06StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				PMBounty06Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 07
local PMBounty07Id = 0
local PMBounty07Spawned = false

local PMBounty07StateObjects = orderedTable()
	PMBounty07StateObjects["PM_BOUNTY07"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/pm_bounty07.dbr"}
	PMBounty07StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.PMBounty07OnAddToWorld(objectId)
	if Server then
		if (not PMBounty07Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("PM_BOUNTY07")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty07.dbr"
				MPOverrideState = true
				PMBounty07Spawned = true
				
			end

			monsterId = objectId
			PMBounty07Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, PMBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				PMBounty07Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnPMBounty07()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not PMBounty07Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(PMBounty07Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("PM_BOUNTY07")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty07.dbr"
					MPOverrideState = true
				
				end
			
				monsterId = PMBounty07Id
				local didWork, newState = UpdateObjectSwap(PMBounty07Id, PMBounty07StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				PMBounty07Spawned = true
			
			end
			
		end
	
	end

end

--Bounty 08
local PMBounty08Id = 0
local PMBounty08Spawned = false

local PMBounty08StateObjects = orderedTable()
	PMBounty08StateObjects["PM_BOUNTY08"	] = { state = BountyState.Spawned, dbr = "records/creatures/enemies/bounties/pm_bounty08.dbr"}
	PMBounty08StateObjects[""					 	] = { state = BountyState.Default, dbr = nil }

function gd.bountiesGDX1.PMBounty08OnAddToWorld(objectId)
	if Server then
		if (not PMBounty08Spawned) then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:AnyoneHasToken("PM_BOUNTY08")) then
				MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty08.dbr"
				MPOverrideState = true
				PMBounty08Spawned = true
				
			end

			monsterId = objectId
			PMBounty08Id = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, PMBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
			if (newState == BountyState.Spawned) then
				PMBounty08Spawned = true
				
			end
			
		end
	
	end
	
end

function gd.bountiesGDX1.spawnPMBounty08()
	if Server then
		local player = Game.GetLocalPlayer()
		
		if not PMBounty08Spawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			local entity = Entity.Get(PMBounty08Id)
			
			if entity != nil then
				if (player:AnyoneHasToken("PM_BOUNTY08")) then
					MPOverrideDbr = "records/creatures/enemies/bounties/pm_bounty08.dbr"
					MPOverrideState = true
					
				end
				monsterId = PMBounty08Id
				local didWork, newState = UpdateObjectSwap(PMBounty08Id, PMBounty08StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
	
				-- Don't respawn the Monster next time. If spawned as hostile, will be saved into the world
				PMBounty08spawned = true
			
			end
			
		end
	
	end

end



