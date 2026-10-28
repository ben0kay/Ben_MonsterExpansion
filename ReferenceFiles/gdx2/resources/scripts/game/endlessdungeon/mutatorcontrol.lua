/*
	
	GRIM DAWN SURVIVAL MODE
	
	For more information visit us at http://www.grimdawn.com
	
*/


gd.endlessDungeon.mutatorControl = {}

-- Define Mutator Pack List
-- Mutator Packs intended for players MUST have "player" in the dbr name. Otherwise it will get applied to the monsters.
local mutatorListMonsters = {"records/game/mutators/mutatorpak_monster_01.dbr",
"records/game/mutators/mutatorpak_monster_02.dbr",
"records/game/mutators/mutatorpak_monster_03.dbr",
"records/game/mutators/mutatorpak_monster_04.dbr",
"records/game/mutators/mutatorpak_monster_05.dbr",
"records/game/mutators/mutatorpak_monster_06.dbr",
"records/game/mutators/mutatorpak_monster_07.dbr",
"records/game/mutators/mutatorpak_monster_08.dbr",
"records/game/mutators/mutatorpak_monster_09.dbr",
"records/game/mutators/mutatorpak_monster_10.dbr",
"records/game/mutators/mutatorpak_monster_11.dbr",
"records/game/mutators/mutatorpak_monster_12.dbr",
"records/game/mutators/mutatorpak_monster_13.dbr",
"records/game/mutators/mutatorpak_monster_14.dbr",
"records/game/mutators/mutatorpak_monster_15.dbr",
"records/game/mutators/mutatorpak_monster_16.dbr",
"records/game/mutators/mutatorpak_monster_17.dbr"}

local mutatorListPlayer = {"records/game/mutators/mutatorpak_player_01.dbr",
"records/game/mutators/mutatorpak_player_02.dbr",
"records/game/mutators/mutatorpak_player_03.dbr",
"records/game/mutators/mutatorpak_player_04.dbr",
"records/game/mutators/mutatorpak_player_05.dbr",
"records/game/mutators/mutatorpak_player_06.dbr",
"records/game/mutators/mutatorpak_player_07.dbr",
"records/game/mutators/mutatorpak_player_08.dbr",
"records/game/mutators/mutatorpak_player_09.dbr",
"records/game/mutators/mutatorpak_player_10.dbr"}

local totalMutators = 0
local currentMutators = 0
local assignedPlayerMutators = { }
local assignedMonsterMutators = { }

-- Select Mutator(s)
local function EndlessDungeon_MutatorRandomizer()

	local totalMutatorsMonsters = table.getn(mutatorListMonsters)	
	local totalMutatorsPlayer = table.getn(mutatorListPlayer)
	local maxMutators = totalMutatorsMonsters + totalMutatorsPlayer

	local selectedList = {}
	
	print "selecting mutators"
	-- randomly select mutators until a unique list of length totalMutators is created
	if totalMutators <= maxMutators then
		math.randomseed(Time.Now())
		
		-- determine how many player vs monster mutators to roll
		local playerMutatorCount = 0
		local monsterMutatorCount = 0
		
		if totalMutators >= 6 then
			playerMutatorCount = 2
		elseif totalMutators >=2 then
			playerMutatorCount = 1
		end
		
		monsterMutatorCount = totalMutators - playerMutatorCount
		if monsterMutatorCount < 0 then
			monsterMutatorCount = 0
		end
		
		-- roll player mutators until assigned list is of size playerMutatorCount.
		
		if playerMutatorCount < totalMutatorsPlayer && playerMutatorCount > table.getn(assignedPlayerMutators) then
			while table.getn(assignedPlayerMutators) != playerMutatorCount do
				local rand = random(1,totalMutatorsPlayer)
				local found = false
				
				if rand <= totalMutatorsPlayer then
					for id = 1, table.getn(selectedList) do
						if mutatorListPlayer[rand] == selectedList[id] then
							found = true
						
						end
					
					end
					
					for id = 1, table.getn(assignedPlayerMutators) do
						if mutatorListPlayer[rand] == assignedPlayerMutators[id] then
							found = true
						
						end
					
					end
					
					if not found then
						table.insert(selectedList, mutatorListPlayer[rand])
						table.insert(assignedPlayerMutators, mutatorListPlayer[rand])
					
					end
				
				end
			
			end
		
		end
			
		-- roll monster mutators until assigned list is of size monsterMutatorCount.
		if monsterMutatorCount < totalMutatorsMonsters && monsterMutatorCount > table.getn(assignedMonsterMutators) then
			while table.getn(assignedMonsterMutators) != monsterMutatorCount do
				local rand = random(1,totalMutatorsMonsters)
				local found = false
				
				if rand <= totalMutatorsMonsters then
					for id = 1, table.getn(selectedList) do
						if mutatorListMonsters[rand] == selectedList[id] then
							found = true
						
						end
					
					end
					
					for id = 1, table.getn(assignedMonsterMutators) do
						if mutatorListMonsters[rand] == assignedMonsterMutators[id] then
							found = true
						
						end
					
					end
					
					if not found then
						table.insert(selectedList, mutatorListMonsters[rand])
						table.insert(assignedMonsterMutators, mutatorListMonsters[rand])
					
					end
				
				end
			
			end
		
		end
		
		-- update current Mutators count
		currentMutators = table.getn(assignedPlayerMutators) + table.getn(assignedMonsterMutators)
		
		-- apply selected Mutators
		local totalMutatorsSelected = table.getn(selectedList)
		
		for id = 1, totalMutatorsSelected do
			Game.AddMutator(selectedList[id])
		
		end		
	
	end

end

function gd.endlessDungeon.mutatorControl.addMutators(dungeonTier)
	
	if dungeonTier <= 1 then
		totalMutators = 1
	elseif dungeonTier <= 2 then
		totalMutators = 2
	elseif dungeonTier <= 4 then
		totalMutators = 3
	elseif dungeonTier <= 8 then
		totalMutators = 4
	elseif dungeonTier <= 16 then
		totalMutators = 5
	elseif dungeonTier <= 24 then
		totalMutators = 6
	elseif dungeonTier <= 32 then
		totalMutators = 7
	else
		totalMutators = 8
	end
	
	
	if totalMutators > 0 && currentMutators < totalMutators then
		EndlessDungeon_MutatorRandomizer()
		
	end

end

function gd.endlessDungeon.mutatorControl.resetMutatorVariables()

	totalMutators = 0
	currentMutators = 0
	assignedPlayerMutators = { }
	assignedMonsterMutators = { }

end


