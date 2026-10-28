/*
	
	GRIM DAWN ENDLESS DUNGEON
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.endlessDungeon.rewards = {}

--
-- Dispense rewards at the end of the Endless Dungeon
-- up to 7 chests are dispensed based on which stopping point the players achieve, plus 2 Bonus Chests and 2 Special Checkpoint Chests
-- Rewards can be dispensed after each boss room
--
local vendorId = 0
local vendorScriptId = 0

local rewardDispensed = false
local rewardDisabled = false

local checkpointUsed = false
local checkPointTier = 0

local triggerVolumeRewardRoom = nil

local bonusChestIds = {0, 0}

local specialChestId = 0
local specialChest02Id = 0

local rewardChestIds = {0, 0, 0, 0, 0, 0, 0}
local rewardChestEntities = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local destroyChestEntities = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
-- total chests that can spawn at max, stored here because lua sucks
local maxChests = 11

local dbrChestA = "records/endlessdungeon/lootchests/chest_a01.dbr"
local dbrChestB = "records/endlessdungeon/lootchests/chest_b01.dbr"
local dbrChestC = "records/endlessdungeon/lootchests/chest_c01.dbr"
local dbrChestD = "records/endlessdungeon/lootchests/chest_d01.dbr"
local dbrChestE = "records/endlessdungeon/lootchests/chest_e01.dbr"
local dbrChestF = "records/endlessdungeon/lootchests/chest_f01.dbr"
local dbrChestG = "records/endlessdungeon/lootchests/chest_g01.dbr"
local dbrChestH = "records/endlessdungeon/lootchests/chest_h01.dbr"
local dbrChestI = "records/endlessdungeon/lootchests/chest_i01.dbr"
local dbrChestJ = "records/endlessdungeon/lootchests/chest_j01.dbr"
local dbrChestK = "records/endlessdungeon/lootchests/chest_k01.dbr"
local dbrChestL = "records/endlessdungeon/lootchests/chest_l01.dbr"
local dbrChestM = "records/endlessdungeon/lootchests/chest_m01.dbr"
local dbrChestN= "records/endlessdungeon/lootchests/chest_n01.dbr"
local dbrChestO = "records/endlessdungeon/lootchests/chest_o01.dbr"
local dbrChestP = "records/endlessdungeon/lootchests/chest_p01.dbr"
local dbrChestQ =  "records/endlessdungeon/lootchests/chest_q01.dbr"
local dbrChestR =  "records/endlessdungeon/lootchests/chest_r01.dbr"
local dbrChestS =  "records/endlessdungeon/lootchests/chest_s01.dbr"

local dbrSpecialChestA = "records/endlessdungeon/lootchests/chestspecial_a01.dbr"
local dbrSpecialChestB = "records/endlessdungeon/lootchests/chestspecial_b01.dbr"
local dbrSpecialChestC = "records/endlessdungeon/lootchests/chestspecial_c01.dbr"
local dbrSpecialChestD = "records/endlessdungeon/lootchests/chestspecial_d01.dbr"
local dbrSpecialChestE = "records/endlessdungeon/lootchests/chestspecial_e01.dbr"
local dbrSpecialChestF = "records/endlessdungeon/lootchests/chestspecial_f01.dbr"
local dbrSpecialChestG = "records/endlessdungeon/lootchests/chestspecial_g01.dbr"

local dbrSpecialChest02A = "records/endlessdungeon/lootchests/chestspecial_a02.dbr"
local dbrSpecialChest02B = "records/endlessdungeon/lootchests/chestspecial_b02.dbr"
local dbrSpecialChest02C = "records/endlessdungeon/lootchests/chestspecial_c02.dbr"
local dbrSpecialChest02D = "records/endlessdungeon/lootchests/chestspecial_d02.dbr"
local dbrSpecialChest02E = "records/endlessdungeon/lootchests/chestspecial_e02.dbr"
local dbrSpecialChest02F = "records/endlessdungeon/lootchests/chestspecial_e02.dbr"

-- Reward Table by Reward Tier with # of Entries equal to # of Chests
-- Chests go from A to Q, with incrementally better rewards, nil for when the chest location is unused
local rewardTable = { }
rewardTable[0] = { nil, nil, dbrChestA, dbrChestB, dbrChestA, nil, nil }

rewardTable[1] = { nil, dbrChestA, dbrChestD, dbrChestJ, dbrChestD, dbrChestA, nil }

rewardTable[2] = { nil, dbrChestC, dbrChestE, dbrChestJ, dbrChestD, dbrChestC, nil }
rewardTable[3] = { nil, dbrChestD, dbrChestE, dbrChestJ, dbrChestE, dbrChestC, nil }

rewardTable[4] = { nil, dbrChestE, dbrChestG, dbrChestJ, dbrChestE, dbrChestC, nil }
rewardTable[5] = { nil, dbrChestE, dbrChestG, dbrChestJ, dbrChestF, dbrChestD, nil }

rewardTable[6] = { nil, dbrChestF, dbrChestH, dbrChestK, dbrChestG, dbrChestE, nil }
rewardTable[7] = { nil, dbrChestG, dbrChestI, dbrChestK, dbrChestG, dbrChestE, nil }

rewardTable[8] = { nil, dbrChestG, dbrChestJ, dbrChestL, dbrChestH, dbrChestF, nil }
rewardTable[9] = { nil, dbrChestH, dbrChestJ, dbrChestL, dbrChestH, dbrChestG, nil }

rewardTable[10] = { nil, dbrChestH, dbrChestK, dbrChestM, dbrChestI, dbrChestH, nil }
rewardTable[11] = { nil, dbrChestI, dbrChestK, dbrChestM, dbrChestI, dbrChestH, nil }

rewardTable[12] = { nil, dbrChestJ, dbrChestL, dbrChestM, dbrChestJ, dbrChestI, nil }
rewardTable[13] = { nil, dbrChestJ, dbrChestL, dbrChestN, dbrChestK, dbrChestI, nil }

rewardTable[14] = { nil, dbrChestK, dbrChestM, dbrChestN, dbrChestL, dbrChestJ, nil }
rewardTable[15] = { nil, dbrChestK, dbrChestN, dbrChestN, dbrChestL, dbrChestJ, nil }

rewardTable[16] = { nil, dbrChestL, dbrChestN, dbrChestO, dbrChestM, dbrChestK, nil }
rewardTable[17] = { dbrChestB, dbrChestL, dbrChestN, dbrChestO, dbrChestM, dbrChestL, nil }

rewardTable[18] = { dbrChestC, dbrChestM, dbrChestO, dbrChestP, dbrChestM, dbrChestL, nil }
rewardTable[19] = { dbrChestC, dbrChestM, dbrChestO, dbrChestP, dbrChestN, dbrChestL, dbrChestB }

rewardTable[20] = { dbrChestD, dbrChestM, dbrChestP, dbrChestP, dbrChestN, dbrChestM, dbrChestC }
rewardTable[21] = { dbrChestD, dbrChestN, dbrChestP, dbrChestQ, dbrChestN, dbrChestM, dbrChestC }

rewardTable[22] = { dbrChestE, dbrChestN, dbrChestP, dbrChestQ, dbrChestO, dbrChestN, dbrChestD }
rewardTable[23] = { dbrChestE, dbrChestN, dbrChestQ, dbrChestQ, dbrChestO, dbrChestN, dbrChestD }

rewardTable[24] = { dbrChestE, dbrChestO, dbrChestQ, dbrChestR, dbrChestO, dbrChestN, dbrChestF }
rewardTable[25] = { dbrChestF, dbrChestO, dbrChestQ, dbrChestR, dbrChestO, dbrChestN, dbrChestF }

rewardTable[26] = { dbrChestG, dbrChestO, dbrChestQ, dbrChestR, dbrChestP, dbrChestN, dbrChestH }
rewardTable[27] = { dbrChestG, dbrChestO, dbrChestQ, dbrChestR, dbrChestP, dbrChestO, dbrChestH }

rewardTable[28] = { dbrChestH, dbrChestP, dbrChestQ, dbrChestS, dbrChestP, dbrChestO, dbrChestI }
rewardTable[29] = { dbrChestH, dbrChestP, dbrChestQ, dbrChestS, dbrChestP, dbrChestP, dbrChestI }

rewardTable[30] = { dbrChestI, dbrChestQ, dbrChestQ, dbrChestS, dbrChestQ, dbrChestP, dbrChestJ }
rewardTable[31] = { dbrChestJ, dbrChestQ, dbrChestQ, dbrChestS, dbrChestQ, dbrChestP, dbrChestJ }

rewardTable[32] = { dbrChestK, dbrChestQ, dbrChestR, dbrChestS, dbrChestQ, dbrChestQ, dbrChestK }
rewardTable[33] = { dbrChestK, dbrChestQ, dbrChestR, dbrChestS, dbrChestQ, dbrChestQ, dbrChestL }

rewardTable[34] = { dbrChestL, dbrChestR, dbrChestR, dbrChestS, dbrChestR, dbrChestQ, dbrChestM }
rewardTable[35] = { dbrChestL, dbrChestR, dbrChestS, dbrChestS, dbrChestR, dbrChestQ, dbrChestM }

rewardTable[36] = { dbrChestM, dbrChestR, dbrChestS, dbrChestS, dbrChestS, dbrChestR, dbrChestN }
rewardTable[37] = { dbrChestN, dbrChestR, dbrChestS, dbrChestS, dbrChestS, dbrChestR, dbrChestN }

rewardTable[38] = { dbrChestO, dbrChestS, dbrChestS, dbrChestS, dbrChestS, dbrChestR, dbrChestP }
rewardTable[39] = { dbrChestP, dbrChestS, dbrChestS, dbrChestS, dbrChestS, dbrChestR, dbrChestP }

rewardTable[40] = { dbrChestR, dbrChestS, dbrChestS, dbrChestS, dbrChestS, dbrChestS, dbrChestR }


-- Reward Table for Checkpoint for when players skip to a later floor, with # of Entries equal to # of Chests
-- Chests go from A to Q, with incrementally better rewards, nil for when the chest location is unused
local checkpointTable = { }
checkpointTable[2] = { nil, dbrChestB, dbrChestD, nil, nil, dbrChestB, nil }
checkpointTable[4] = { nil, dbrChestC, dbrChestE, nil, nil, dbrChestC, nil }
checkpointTable[6] = { nil, dbrChestD, dbrChestF, nil, nil, dbrChestD, nil }
checkpointTable[8] = { nil, dbrChestE, dbrChestG, nil, nil, dbrChestE, nil }
checkpointTable[10] = { nil, dbrChestF, dbrChestH, nil, nil, dbrChestF, nil }
checkpointTable[12] = { nil, dbrChestG, dbrChestI, nil, nil, dbrChestH, nil }
checkpointTable[14] = { nil, dbrChestH, dbrChestJ, nil, nil, dbrChestH, nil }
checkpointTable[16] = { nil, dbrChestI, dbrChestK, nil, nil, dbrChestI, nil }
checkpointTable[18] = { nil, dbrChestJ, dbrChestL, nil, nil, dbrChestJ, nil }
checkpointTable[20] = { nil, dbrChestK, dbrChestM, nil, nil, dbrChestK, nil }
checkpointTable[22] = { nil, dbrChestL, dbrChestN, nil, nil, dbrChestL, nil }
checkpointTable[24] = { nil, dbrChestM, dbrChestN, nil, nil, dbrChestM, nil }
checkpointTable[26] = { nil, dbrChestN, dbrChestO, nil, nil, dbrChestN, nil }
checkpointTable[28] = { nil, dbrChestO, dbrChestO, nil, nil, dbrChestO, nil }
checkpointTable[30] = { nil, dbrChestP, dbrChestP, nil, nil, dbrChestP, nil }
checkpointTable[32] = { nil, dbrChestP, dbrChestP, nil, nil, dbrChestP, nil }
checkpointTable[34] = { nil, dbrChestQ, dbrChestQ, nil, nil, dbrChestQ, nil }
checkpointTable[36] = { nil, dbrChestQ, dbrChestQ, nil, nil, dbrChestQ, nil }
checkpointTable[38] = { nil, dbrChestR, dbrChestR, nil, nil, dbrChestR, nil }
checkpointTable[40] = { nil, dbrChestR, dbrChestR, nil, nil, dbrChestR, nil }


-- Bonus Table used for the Time-based chests.
-- Chests go from A to Q, with incrementally better rewards, nil for when the chest location is unused
local bonusTable = { }
bonusTable[0] = { nil, nil }

bonusTable[1] = { nil, dbrChestA }

bonusTable[2] = { dbrChestB, dbrChestA }
bonusTable[3] = { dbrChestB, dbrChestA }

bonusTable[4] = { dbrChestB, dbrChestC }
bonusTable[5] = { dbrChestC, dbrChestC }

bonusTable[6] = { dbrChestD, dbrChestD }
bonusTable[7] = { dbrChestD, dbrChestD }

bonusTable[8] = { dbrChestE, dbrChestE }
bonusTable[9] = { dbrChestE, dbrChestF }

bonusTable[10] = { dbrChestF, dbrChestG }
bonusTable[11] = { dbrChestF, dbrChestG }

bonusTable[12] = { dbrChestG, dbrChestH }
bonusTable[13] = { dbrChestG, dbrChestH }

bonusTable[14] = { dbrChestH, dbrChestH }
bonusTable[15] = { dbrChestH, dbrChestI }

bonusTable[16] = { dbrChestI, dbrChestI }
bonusTable[17] = { dbrChestI, dbrChestI }

bonusTable[18] = { dbrChestJ, dbrChestJ }
bonusTable[19] = { dbrChestJ, dbrChestJ }

bonusTable[20] = { dbrChestJ, dbrChestK }
bonusTable[21] = { dbrChestK, dbrChestK }

bonusTable[22] = { dbrChestK, dbrChestL }
bonusTable[23] = { dbrChestK, dbrChestL }

bonusTable[24] = { dbrChestL, dbrChestM }
bonusTable[25] = { dbrChestL, dbrChestM }

bonusTable[26] = { dbrChestM, dbrChestM }
bonusTable[27] = { dbrChestM, dbrChestN }

bonusTable[28] = { dbrChestN, dbrChestN }
bonusTable[29] = { dbrChestN, dbrChestN }

bonusTable[30] = { dbrChestO, dbrChestO }
bonusTable[31] = { dbrChestO, dbrChestO }

bonusTable[32] = { dbrChestO, dbrChestP }
bonusTable[33] = { dbrChestO, dbrChestP }

bonusTable[34] = { dbrChestP, dbrChestQ }
bonusTable[35] = { dbrChestP, dbrChestQ }

bonusTable[36] = { dbrChestP, dbrChestR }
bonusTable[37] = { dbrChestP, dbrChestR }

bonusTable[38] = { dbrChestQ, dbrChestR }
bonusTable[39] = { dbrChestQ, dbrChestS }

bonusTable[40] = { dbrChestQ, dbrChestS }

-- Bonus Reward Table for Checkpoint for when players skip to a later floor, with # of Entries equal to # of Chests
-- Chests go from A to Q, with incrementally better rewards, nil for when the chest location is unused
local checkpointBonusTable = { }
checkpointBonusTable[4] = { dbrChestB, nil }
checkpointBonusTable[6] = { dbrChestD, nil }
checkpointBonusTable[8] = { dbrChestE, nil }
checkpointBonusTable[10] = { dbrChestF, nil }
checkpointBonusTable[12] = { dbrChestG, nil }
checkpointBonusTable[14] = { dbrChestH, nil }
checkpointBonusTable[16] = { dbrChestI, nil }
checkpointBonusTable[18] = { dbrChestJ, nil }
checkpointBonusTable[20] = { dbrChestJ, nil }
checkpointBonusTable[22] = { dbrChestK, nil }
checkpointBonusTable[24] = { dbrChestL, nil }
checkpointBonusTable[26] = { dbrChestM, nil }
checkpointBonusTable[28] = { dbrChestM, nil }
checkpointBonusTable[30] = { dbrChestN, nil }
checkpointBonusTable[32] = { dbrChestN, nil }
checkpointBonusTable[34] = { dbrChestO, nil }
checkpointBonusTable[36] = { dbrChestO, nil }
checkpointBonusTable[38] = { dbrChestP, nil }
checkpointBonusTable[40] = { dbrChestP, nil }


-- Special Tables used for reaching checkpoints and specific dungeon tiers.
local specialTable = { nil, dbrSpecialChestA, dbrSpecialChestB, dbrSpecialChestC, dbrSpecialChestD, dbrSpecialChestE, dbrSpecialChestF, dbrSpecialChestG }

local special02Table = { nil, dbrSpecialChest02A, dbrSpecialChest02B, dbrSpecialChest02C, dbrSpecialChest02D, dbrSpecialChest02E, dbrSpecialChest02F }


function gd.endlessDungeon.rewards.rewardChest01OnAddToWorld(objectId)

	if Server then
		rewardChestIds[1] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.rewardChest02OnAddToWorld(objectId)

	if Server then
		rewardChestIds[2] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.rewardChest03OnAddToWorld(objectId)

	if Server then
		rewardChestIds[3] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.rewardChest04OnAddToWorld(objectId)

	if Server then
		rewardChestIds[4] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.rewardChest05OnAddToWorld(objectId)

	if Server then
		rewardChestIds[5] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.rewardChest06OnAddToWorld(objectId)

	if Server then
		rewardChestIds[6] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.rewardChest07OnAddToWorld(objectId)

	if Server then
		rewardChestIds[7] = objectId
		
	end
	
end


function gd.endlessDungeon.rewards.bonusChest01OnAddToWorld(objectId)

	if Server then
		bonusChestIds[1] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.bonusChest02OnAddToWorld(objectId)

	if Server then
		bonusChestIds[2] = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.specialChest01OnAddToWorld(objectId)

	if Server then
		specialChestId = objectId
		
	end
	
end

function gd.endlessDungeon.rewards.specialChest02OnAddToWorld(objectId)

	if Server then
		specialChest02Id = objectId
		
	end
	
end

-- Show Screen Glow for when boss floor is cleared
local function screenGlow()
	
	local player = Game.GetLocalPlayer()
	
	if player:InEndlessBossFloor() then
		Game.PlayFullscreenGlow()
	
	end
	
end

-- Bestow Tokens for reaching certain floors 
local function shardProgressToken01()
	
	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS01")
		
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS01")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS01")
		
	else
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS01")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS01")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ULTIMATE_SHARDPROGRESS01")
		
	end
	
end

local function shardProgressToken02()
	
	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS02")
		
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS02")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS02")
		
	else
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS02")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS02")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ULTIMATE_SHARDPROGRESS02")
		
	end
	
end

local function shardProgressToken03()
	
	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS03")
		
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS03")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS03")
		
	else
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS03")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS03")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ULTIMATE_SHARDPROGRESS03")
		
	end
	
end

local function shardProgressToken04()
	
	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS04")
		
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS04")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS04")
		
	else
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_NORMAL_SHARDPROGRESS04")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ELITE_SHARDPROGRESS04")
		GiveTokenToLocalPlayer("ENDLESSDUNGEON_ULTIMATE_SHARDPROGRESS04")
		
	end
	
end

-- Bestow Tokens for Waystone Progression
local function waystoneTokenShard05()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD10") == false && player:HasToken("EG_SHARD15") == false) then
		GiveTokenToLocalPlayer("EG_SHARD05")
		
	end
	
end

local function waystoneTokenShard10()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD15") == false) then
		GiveTokenToLocalPlayer("EG_SHARD10")
		
		if (player:HasToken("EG_SHARD05")) then
			player:RemoveToken("EG_SHARD05")
			
		end
		
	end

end

local function waystoneTokenShard15()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD15")
	
	if (player:HasToken("EG_SHARD05")) then
		player:RemoveToken("EG_SHARD05")
		
	end
	
	if (player:HasToken("EG_SHARD10")) then
		player:RemoveToken("EG_SHARD10")
		
	end
	
end

local function waystoneTokenShard20()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD25") == false && player:HasToken("EG_SHARD30") == false) then
		GiveTokenToLocalPlayer("EG_SHARD20")
		
	end
	
	-- grant tokens for waystone01
	waystoneTokenShard15()
	
end

local function waystoneTokenShard25()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD30") == false) then
		GiveTokenToLocalPlayer("EG_SHARD25")
		
		if (player:HasToken("EG_SHARD20")) then
			player:RemoveToken("EG_SHARD20")
			
		end
		
	end
	
	-- grant tokens for waystone01
	waystoneTokenShard15()
	
end

local function waystoneTokenShard30()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD30")
	
	if (player:HasToken("EG_SHARD20")) then
		player:RemoveToken("EG_SHARD20")
		
	end
	
	if (player:HasToken("EG_SHARD25")) then
		player:RemoveToken("EG_SHARD25")
		
	end
	
	-- grant tokens for waystone01
	waystoneTokenShard15()
	
end

local function waystoneTokenShard35()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD40") == false && player:HasToken("EG_SHARD45") == false) then
		GiveTokenToLocalPlayer("EG_SHARD35")
		
	end
	
	-- grant tokens for waystone02
	waystoneTokenShard30()
	
end

local function waystoneTokenShard40()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD45") == false) then
		GiveTokenToLocalPlayer("EG_SHARD40")
		
		if (player:HasToken("EG_SHARD35")) then
			player:RemoveToken("EG_SHARD35")
			
		end
		
	end
	
	-- grant tokens for waystone02
	waystoneTokenShard30()
	
end

local function waystoneTokenShard45()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD45")
	
	if (player:HasToken("EG_SHARD35")) then
		player:RemoveToken("EG_SHARD35")
		
	end
	
	if (player:HasToken("EG_SHARD40")) then
		player:RemoveToken("EG_SHARD40")
		
	end
	
	-- grant tokens for waystone02
	waystoneTokenShard30()
	
end

local function waystoneTokenShard50()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD55") == false && player:HasToken("EG_SHARD60") == false) then
		GiveTokenToLocalPlayer("EG_SHARD50")
		
	end
	
	-- grant tokens for waystone03
	waystoneTokenShard45()
	
end

local function waystoneTokenShard55()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD60") == false) then
		GiveTokenToLocalPlayer("EG_SHARD55")
		
		if (player:HasToken("EG_SHARD50")) then
			player:RemoveToken("EG_SHARD50")
			
		end
		
	end
	
	-- grant tokens for waystone03
	waystoneTokenShard45()
	
end

local function waystoneTokenShard60()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD60")
	
	if (player:HasToken("EG_SHARD50")) then
		player:RemoveToken("EG_SHARD50")
		
	end
	
	if (player:HasToken("EG_SHARD55")) then
		player:RemoveToken("EG_SHARD55")
		
	end
	
	-- grant tokens for waystone03
	waystoneTokenShard45()
	
end

local function waystoneTokenShard65()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD70") == false && player:HasToken("EG_SHARD75") == false) then
		GiveTokenToLocalPlayer("EG_SHARD65")
		
	end
	
	-- grant tokens for waystone04
	waystoneTokenShard60()
	
end

local function waystoneTokenShard70()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD75") == false) then
		GiveTokenToLocalPlayer("EG_SHARD70")
		
		if (player:HasToken("EG_SHARD65")) then
			player:RemoveToken("EG_SHARD65")
			
		end
		
	end
	
	-- grant tokens for waystone04
	waystoneTokenShard60()
	
end

local function waystoneTokenShard75()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD75")
	
	if (player:HasToken("EG_SHARD65")) then
		player:RemoveToken("EG_SHARD65")
		
	end
	
	if (player:HasToken("EG_SHARD70")) then
		player:RemoveToken("EG_SHARD70")
		
	end
	
	-- grant tokens for waystone04
	waystoneTokenShard60()
	
end

local function waystoneTokenShard80()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD85") == false && player:HasToken("EG_SHARD90") == false) then
		GiveTokenToLocalPlayer("EG_SHARD80")
		
	end
	
	-- grant tokens for waystone05
	waystoneTokenShard75()
	
end

local function waystoneTokenShard85()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD90") == false) then
		GiveTokenToLocalPlayer("EG_SHARD85")
		
		if (player:HasToken("EG_SHARD80")) then
			player:RemoveToken("EG_SHARD80")
			
		end
		
	end
	
	-- grant tokens for waystone05
	waystoneTokenShard75()
	
end

local function waystoneTokenShard90()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD90")
	
	if (player:HasToken("EG_SHARD80")) then
		player:RemoveToken("EG_SHARD80")
		
	end
	
	if (player:HasToken("EG_SHARD85")) then
		player:RemoveToken("EG_SHARD85")
		
	end
	
	-- grant tokens for waystone05
	waystoneTokenShard75()
	
end

local function waystoneTokenShard95()
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("EG_SHARD100") == false) then
		GiveTokenToLocalPlayer("EG_SHARD95")
		
	end
	
	-- grant tokens for waystone06
	waystoneTokenShard90()
	
end

local function waystoneTokenShard100()
	local player = Game.GetLocalPlayer()
	
	GiveTokenToLocalPlayer("EG_SHARD100")
	
	if (player:HasToken("EG_SHARD95")) then
		player:RemoveToken("EG_SHARD95")
		
	end
	
	-- grant tokens for waystone06
	waystoneTokenShard90()
	
end

local function waystoneTokenShard105NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD105NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard110NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD110NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard115NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD115NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard120NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD120NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard125NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD125NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard130NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD130NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard135NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD135NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard140NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD140NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard145NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD145NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard150NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD150NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard155NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD155NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard160NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD160NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard165NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD165NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard170NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD170NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard175NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD175NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard180NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD180NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard185NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD185NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard190NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD190NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard195NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD195NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard200NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD200NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard205NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD205NOLOOT")
	waystoneTokenShard100()
	
end

local function waystoneTokenShard210NoLoot()
	
	GiveTokenToLocalPlayer("EG_SHARD210NOLOOT")
	waystoneTokenShard100()
	
end


-- Grant Xp to each player at the END of the dungeon
function gd.endlessDungeon.rewards.playerFinishExperienceGlobalMP()

	local player = Game.GetLocalPlayer()
	
	if player:InEndlessDungeon() then
		local playerLevel = Game.GetAveragePlayerLevel()
		
		local rewardTier = Game.GetEndlessDungeonsGenerated()
		local difficultyModifier = 0
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			difficultyModifier = 1
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			difficultyModifier = 1.3
		else
			difficultyModifier = 2.2
		end
		
		-- Experience gained based on shard reached.
		local xp = 0
		
		xp = difficultyModifier * ((rewardTier * 2.5 * 12812) ^ 1.1)
		
		
		if checkpointUsed then
			-- if checkpoint is equal to current shard, give default xp
			if checkPointTier == rewardTier then
				xp = difficultyModifier * (2.5 * 12812 ^ 1.1)
			else
				-- otherwise subtract xp from shards prior to checkpoint
				local penalty = difficultyModifier * ((checkPointTier * 2.5 * 12812) ^ 1.1)
				xp = xp - penalty
				
			end
		
		end
		
		if playerLevel < 10 then
			xp = xp / 4
			if rewardTier > 5 then
				xp = xp / 200
			end
		elseif playerLevel < 18 then
			xp = xp / 3
			if rewardTier > 10 then
				xp = xp / 200
			end
		elseif playerLevel < 25 then
			xp = xp / 2
			if rewardTier > 10 then
				xp = xp / 100
			end
		elseif playerLevel < 35 then
			xp = xp / 1.5
			if rewardTier > 15 then
				xp = xp / 100
			end
		elseif playerLevel < 45 then
			xp = xp / 1.25
			if rewardTier > 15 then
				xp = xp / 100
			end
		end
		
		player:GiveExperience(xp)
	
	end

end


-- Grant Xp to each player after each dungeon section
function gd.endlessDungeon.rewards.playerProgressExperienceGlobalMP()

	local player = Game.GetLocalPlayer()
	
	if player:InEndlessDungeon() then
		local playerLevel = Game.GetAveragePlayerLevel()
		
		local rewardTier = Game.GetEndlessDungeonsGenerated()
		local difficultyModifier = 0
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			difficultyModifier = 1
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			difficultyModifier = 1.3
		else
			difficultyModifier = 2.2
		end
		
		-- Experience gained based on shard reached.
		local xp = difficultyModifier * ((rewardTier * 2.5 * 700) ^ 1.1 + 16152)
		
		if playerLevel < 10 then
			xp = xp / 4
			if rewardTier > 5 then
				xp = xp / 200
			end
		elseif playerLevel < 18 then
			xp = xp / 3
			if rewardTier > 10 then
				xp = xp / 200
			end
		elseif playerLevel < 25 then
			xp = xp / 2
			if rewardTier > 10 then
				xp = xp / 100
			end
		elseif playerLevel < 35 then
			xp = xp / 1.5
			if rewardTier > 15 then
				xp = xp / 100
			end
		elseif playerLevel < 45 then
			xp = xp / 1.25
			if rewardTier > 15 then
				xp = xp / 100
			end
		end
		
		player:GiveExperience(xp)
	
		-- play screen glow for clearing boss floor
		screenGlow()
		
		-- give out tokens based on Tier Reached
		if rewardTier == 2 then
			waystoneTokenShard05()
		elseif rewardTier == 4 then
			waystoneTokenShard10()
		elseif rewardTier == 6 then
			waystoneTokenShard15()
		elseif rewardTier == 8 then
			waystoneTokenShard20()
		elseif rewardTier == 10 then
			waystoneTokenShard25()
		elseif rewardTier == 12 then
			waystoneTokenShard30()
		elseif rewardTier == 14 then
			waystoneTokenShard35()
		elseif rewardTier == 16 then
			waystoneTokenShard40()
		elseif rewardTier == 18 then
			waystoneTokenShard45()
		elseif rewardTier == 20 then
			waystoneTokenShard50()
		elseif rewardTier == 22 then
			waystoneTokenShard55()
		elseif rewardTier == 24 then
			waystoneTokenShard60()
		elseif rewardTier == 26 then
			waystoneTokenShard65()
		elseif rewardTier == 28 then
			waystoneTokenShard70()
		elseif rewardTier == 30 then
			waystoneTokenShard75()
		elseif rewardTier == 32 then
			waystoneTokenShard80()
		elseif rewardTier == 34 then
			waystoneTokenShard85()
		elseif rewardTier == 36 then
			waystoneTokenShard90()
		elseif rewardTier == 38 then
			waystoneTokenShard95()
		elseif rewardTier == 40 then
			waystoneTokenShard100()
		elseif rewardTier == 42 then
			waystoneTokenShard105NoLoot()
		elseif rewardTier == 44 then
			waystoneTokenShard110NoLoot()
		elseif rewardTier == 46 then
			waystoneTokenShard115NoLoot()
		elseif rewardTier == 48 then
			waystoneTokenShard120NoLoot()
		elseif rewardTier == 50 then
			waystoneTokenShard125NoLoot()
		elseif rewardTier == 52 then
			waystoneTokenShard130NoLoot()
		elseif rewardTier == 54 then
			waystoneTokenShard135NoLoot()
		elseif rewardTier == 56 then
			waystoneTokenShard140NoLoot()
		elseif rewardTier == 58 then
			waystoneTokenShard145NoLoot()
		elseif rewardTier == 60 then
			waystoneTokenShard150NoLoot()
		elseif rewardTier == 62 then
			waystoneTokenShard155NoLoot()
		elseif rewardTier == 64 then
			waystoneTokenShard160NoLoot()
		elseif rewardTier == 66 then
			waystoneTokenShard165NoLoot()
		elseif rewardTier == 68 then
			waystoneTokenShard170NoLoot()
		elseif rewardTier == 70 then
			waystoneTokenShard175NoLoot()
		elseif rewardTier == 72 then
			waystoneTokenShard180NoLoot()
		elseif rewardTier == 74 then
			waystoneTokenShard185NoLoot()
		elseif rewardTier == 76 then
			waystoneTokenShard190NoLoot()
		elseif rewardTier == 78 then
			waystoneTokenShard195NoLoot()
		elseif rewardTier == 80 then
			waystoneTokenShard200NoLoot()
		elseif rewardTier == 82 then
			waystoneTokenShard205NoLoot()
		elseif rewardTier >= 84 then
			waystoneTokenShard210NoLoot()
		end
		
		-- quest/achievement progress tokens
		if rewardTier >= 2 then
			shardProgressToken01()
		end
		
		if rewardTier >= 6 then
			shardProgressToken02()		
		end
		
		if rewardTier >= 10 then
			shardProgressToken03()
		end
		
		if rewardTier >= 20 then
			shardProgressToken04()
		end
	
	end

end


-- npc merchant in reward room to sell stuff, buy potions, buy shattered realm set
local function spawnVendor()
	if Server && vendorScriptId != 0 && not rewardDisabled then
		local rewardTier = Game.GetEndlessDungeonsGenerated()
		
		-- clean up existing vendor, if applicable
		local entity = Entity.Get(vendorId)
		
		if entity != nil then
			entity:Destroy()
			
		end
		
		local dbr = "records/endlessdungeon/creatures/npcs/merchant_reward_01.dbr"
		
		if (Game.GetGameDifficulty() == Game.Difficulty.Legendary) && ((checkpointUsed && rewardTier != checkPointTier) || not checkpointUsed) then
			if rewardTier >= 24 then
				dbr = "records/endlessdungeon/creatures/npcs/merchant_reward_05.dbr"
			elseif rewardTier >= 18 then
				dbr = "records/endlessdungeon/creatures/npcs/merchant_reward_04.dbr"
			elseif rewardTier >= 12 then
				dbr = "records/endlessdungeon/creatures/npcs/merchant_reward_03.dbr"
			elseif rewardTier >= 8 then
				dbr = "records/endlessdungeon/creatures/npcs/merchant_reward_02.dbr"
			end
			
		end
		
		if dbr != nil then
			local coords = Entity.Get(vendorScriptId):GetCoords()
			local spawn = Entity.Create(dbr)
			spawn:SetCoords(coords)
		
		end
	
	end

end

function gd.endlessDungeon.rewards.vendorAvatarOnAddToWorld(objectId)

	if Server then
		vendorId = objectId
	
	end
	
end

function gd.endlessDungeon.rewards.vendorOnAddToWorld(objectId)

	if Server then
		vendorScriptId = objectId
		
		spawnVendor()
	
	end
	
end


-- End of Event Function. Dispenses Reward
function gd.endlessDungeon.rewards.dispenseReward()

	if Server then
		-- clean up old chests
		for id = 1, maxChests do
			if destroyChestEntities[id] != nil then
				destroyChestEntities[id]:Destroy()
				destroyChestEntities[id] = nil
			
			end
		
		end

		-- dispense new chests
		if not rewardDispensed then
			rewardDispensed = true
			
			-- clean up items in reward room
			if triggerVolumeRewardRoom != nil then
				triggerVolumeRewardRoom:DestroyItems()
			end

			local rewardTier = Game.GetEndlessDungeonsGenerated()
			local rewardTableSize = table.getn(rewardTable)
			local bonusEarned = Game.IsEndlessDungeonBonusComplete()
			
			if rewardTier > rewardTableSize then
				rewardTier = rewardTableSize
			
			end

			-- store existing chest entities into delete table for cleanup
			for id = 1, maxChests do
				destroyChestEntities[id] = rewardChestEntities[id]
			
			end
			
			if not rewardDisabled then
			
				-- create chests
				local totalChests = table.getn(rewardChestIds)
				
				for id = 1, totalChests do
					local chest = Entity.Get(rewardChestIds[id])
					
					if chest != nil then
						local coords = chest:GetCoords()

						-- if the player used a checkpoint, then they are given the checkpoint loot on the same Tier as they started if they "cash out".
						if checkpointUsed && rewardTier == checkPointTier then
							if checkpointTable[rewardTier][id] != nil then
								local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
						
								if (fx != nil) then
									fx:NetworkEnable()
									fx:SetCoords(coords)
								end
								
								rewardChestEntities[id] = Entity.Create(checkpointTable[rewardTier][id])
								if rewardChestEntities[id] != nil then
									rewardChestEntities[id]:SetCoords(coords)
								end
							
							end
						-- if the player reached the next treasure tier and opted to "cash out", they receive the earned rewards.
						else
							if rewardTable[rewardTier][id] != nil then
								local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
						
								if (fx != nil) then
									fx:NetworkEnable()
									fx:SetCoords(coords)
								end
								
								rewardChestEntities[id] = Entity.Create(rewardTable[rewardTier][id])
								if rewardChestEntities[id] != nil then
									rewardChestEntities[id]:SetCoords(coords)
								end

							end

						end
					
					end
				
				end
				
				-- Dispense 8th/9th bonus chests, if player beat the clock
				local totalBonusChests = table.getn(bonusChestIds)
				
				if bonusEarned then
					for id = 1, totalBonusChests do
						local chest = Entity.Get(bonusChestIds[id])
						local coords = chest:GetCoords()
						local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
					
						if (fx != nil) then
							fx:NetworkEnable()
							fx:SetCoords(coords)
						end
						
						-- add bonus chests to chest entity array, after the base chests
						local chestEntityId = id + totalChests
						
						if checkpointUsed && rewardTier == checkPointTier then
							if checkpointBonusTable[rewardTier][id] != nil then
								rewardChestEntities[chestEntityId] = Entity.Create(checkpointBonusTable[rewardTier][id])
								if rewardChestEntities[chestEntityId] != nil then
									rewardChestEntities[chestEntityId]:SetCoords(coords)
								end
								
							end
							
						else
							if bonusTable[rewardTier][id] != nil then
								rewardChestEntities[chestEntityId] = Entity.Create(bonusTable[rewardTier][id])
								if rewardChestEntities[chestEntityId] != nil then
									rewardChestEntities[chestEntityId]:SetCoords(coords)
								end
							
							end
							
						end
					
					end
				
				end
				
				-- Dispense Special Chest, only applies to specific dungeon tiers. Contain checkpoint rewards. Not dispensed if checkpoint is used and reward claimed at the same tier.
				local specialTier = 0
				
				if rewardTier >= 38 then
					specialTier = 8
				elseif rewardTier >= 32 then
					specialTier = 7
				elseif rewardTier >= 26 then
					specialTier = 6
				elseif rewardTier >= 20 then
					specialTier = 5
				elseif rewardTier >= 14 then
					specialTier = 4
				elseif rewardTier >= 8 then
					specialTier = 3
				elseif rewardTier >= 2 then
					specialTier = 2
				else
					specialTier = 1
				end
				
				if (checkpointUsed && rewardTier != checkPointTier) || not checkpointUsed then
					if specialTable[specialTier] != nil then
						local chest = Entity.Get(specialChestId)
						local coords = chest:GetCoords()
						local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
					
						if (fx != nil) then
							fx:NetworkEnable()
							fx:SetCoords(coords)
						end
						
						-- add special chest to chest entity array, after the base and bonus chests
						local chestEntityId = totalChests + totalBonusChests + 1

						rewardChestEntities[chestEntityId] = Entity.Create(specialTable[specialTier])
						if rewardChestEntities[chestEntityId] != nil then
							rewardChestEntities[chestEntityId]:SetCoords(coords)
						end
					
					end
				
				end
				
				-- Dispense second Special Chest, only applies to specific dungeon tiers. Contain unique rewards. Not dispensed if checkpoint is used and reward claimed at the same tier.
				local special02Tier = 0
				
				if rewardTier >= 30 then
					special02Tier = 7
				elseif rewardTier >= 24 then
					special02Tier = 6
				elseif rewardTier >= 18 then
					special02Tier = 5
				elseif rewardTier >= 12 then
					special02Tier = 4
				elseif rewardTier >= 8 then
					special02Tier = 3
				elseif rewardTier >= 4 then
					special02Tier = 2
				else
					special02Tier = 1
				end
				
				if (checkpointUsed && rewardTier != checkPointTier) || not checkpointUsed then
					if special02Table[special02Tier] != nil then
						local chest = Entity.Get(specialChest02Id)
						local coords = chest:GetCoords()
						local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
					
						if (fx != nil) then
							fx:NetworkEnable()
							fx:SetCoords(coords)
						end
						
						-- add special chest to chest entity array, after the base and bonus chests
						local chestEntityId = totalChests + totalBonusChests + 2

						rewardChestEntities[chestEntityId] = Entity.Create(special02Table[special02Tier])
						if rewardChestEntities[chestEntityId] != nil then
							rewardChestEntities[chestEntityId]:SetCoords(coords)
						end
					
					end
				
				end
				
				-- Respawn Vendor
				spawnVendor()
			
			end

		end
	
	end

end

-- Reset Server Variables and destroy chests
function gd.endlessDungeon.rewards.resetVariablesGlobalMP()

	checkpointUsed = false

end

function gd.endlessDungeon.rewards.resetVariables()
	
	if Server then
		rewardDispensed = false
		rewardDisabled = false
		checkpointUsed = false
		
		LuaGlobalEvent("resetRewardVariablesGlobalMP")
		
		for id = 1, maxChests do
			if destroyChestEntities[id] != nil then
				destroyChestEntities[id]:Destroy()
				destroyChestEntities[id] = nil
			
			end
		
		end
	
	end

end


function gd.endlessDungeon.rewards.disableRewards()

	if Server then
		rewardDisabled = true
	
	end
	
end


local function checkpointUsedTierCheck(tierNumber)

	if Server then
		local test = tierNumber
		if test == 2 then
			LuaGlobalEvent("checkpointUsedShard5GlobalMP")
		elseif test == 4 then
			LuaGlobalEvent("checkpointUsedShard10GlobalMP")
		elseif test == 6 then
			LuaGlobalEvent("checkpointUsedShard15GlobalMP")
		elseif test == 8 then
			LuaGlobalEvent("checkpointUsedShard20GlobalMP")
		elseif test == 10 then
			LuaGlobalEvent("checkpointUsedShard25GlobalMP")
		elseif test == 12 then
			LuaGlobalEvent("checkpointUsedShard30GlobalMP")
		elseif test == 14 then
			LuaGlobalEvent("checkpointUsedShard35GlobalMP")
		elseif test == 16 then
			LuaGlobalEvent("checkpointUsedShard40GlobalMP")
		elseif test == 18 then
			LuaGlobalEvent("checkpointUsedShard45GlobalMP")
		elseif test == 20 then
			LuaGlobalEvent("checkpointUsedShard50GlobalMP")
		elseif test == 22 then
			LuaGlobalEvent("checkpointUsedShard55GlobalMP")
		elseif test == 24 then
			LuaGlobalEvent("checkpointUsedShard60GlobalMP")
		elseif test == 26 then
			LuaGlobalEvent("checkpointUsedShard65GlobalMP")
		elseif test == 28 then
			LuaGlobalEvent("checkpointUsedShard70GlobalMP")
		elseif test == 30 then
			LuaGlobalEvent("checkpointUsedShard75GlobalMP")
		elseif test == 32 then
			LuaGlobalEvent("checkpointUsedShard80GlobalMP")
		elseif test == 34 then
			LuaGlobalEvent("checkpointUsedShard85GlobalMP")
		elseif test == 36 then
			LuaGlobalEvent("checkpointUsedShard90GlobalMP")
		elseif test == 38 then
			LuaGlobalEvent("checkpointUsedShard95GlobalMP")
		elseif test == 40 then
			LuaGlobalEvent("checkpointUsedShard100GlobalMP")
		end
	
	end
	
end

function gd.endlessDungeon.rewards.checkpointRewardCheck()

	if Server then
		if checkpointUsed then
			LuaGlobalEvent("checkpointUsedGlobalMP")
			
			checkpointUsedTierCheck(checkPointTier)
		
		end
		
		-- Grant player exp based on tier reached
		LuaGlobalEvent("playerFinishExperience")
	
	end

end

function gd.endlessDungeon.rewards.checkpointUsedGlobalMP()

	checkpointUsed = true
	
end

function gd.endlessDungeon.rewards.checkpointUsed(tierNumber)

	if Server then
		checkpointUsed = true
		LuaGlobalEvent("checkpointUsedGlobalMP")
		checkPointTier = tierNumber
		
		checkpointUsedTierCheck(checkPointTier)
	
	end
	
end


-- Start the Dungeon at Shard 5 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard5GlobalMP()
	checkPointTier = 2
end

-- Start the Dungeon at Shard 10 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard10GlobalMP()
	checkPointTier = 4
end

-- Start the Dungeon at Shard 15 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard15GlobalMP()
	checkPointTier = 6
end

-- Start the Dungeon at Shard 20 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard20GlobalMP()
	checkPointTier = 8
end

-- Start the Dungeon at Shard 25 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard25GlobalMP()
	checkPointTier = 10
end

-- Start the Dungeon at Shard 30 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard30GlobalMP()
	checkPointTier = 12
end

-- Start the Dungeon at Shard 35 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard35GlobalMP()
	checkPointTier = 14
end

-- Start the Dungeon at Shard 40 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard40GlobalMP()
	checkPointTier = 16
end

-- Start the Dungeon at Shard 45 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard45GlobalMP()
	checkPointTier = 18
end

-- Start the Dungeon at Shard 50 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard50GlobalMP()
	checkPointTier = 20
end

-- Start the Dungeon at Shard 55 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard55GlobalMP()
	checkPointTier = 22
end

-- Start the Dungeon at Shard 60 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard60GlobalMP()
	checkPointTier = 24
end

-- Start the Dungeon at Shard 65 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard65GlobalMP()
	checkPointTier = 26
end

-- Start the Dungeon at Shard 70 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard70GlobalMP()
	checkPointTier = 28
end

-- Start the Dungeon at Shard 75 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard75GlobalMP()
	checkPointTier = 30
end

-- Start the Dungeon at Shard 80 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard80GlobalMP()
	checkPointTier = 32
end

-- Start the Dungeon at Shard 85 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard85GlobalMP()
	checkPointTier = 34
end

-- Start the Dungeon at Shard 90 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard90GlobalMP()
	checkPointTier = 36
end

-- Start the Dungeon at Shard 95 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard95GlobalMP()
	checkPointTier = 38
end

-- Start the Dungeon at Shard 100 for Clients
function gd.endlessDungeon.rewards.checkpointUsedShard100GlobalMP()
	checkPointTier = 40
end

-- Reward Room Cleanup Trigger Volumes
function gd.endlessDungeon.rewards.rewardRoomTriggerVolumeOnAddToWorld(objectId)

	if Server then
		print "volume set"
		triggerVolumeRewardRoom = AreaTrigger.Get(objectId)
		
	end
	
end


