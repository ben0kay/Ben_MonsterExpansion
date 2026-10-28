/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestWraith = {}

--
-- Ugdall, the wraith of Ugdenbog can either be allowed to pass on in peace, or banished by force
--
local wraithId = 0
local WraithState = {Default = 0, Hostile = 1, Passed = 2, Killed = 3}
local wraithSpawned = false

local wraithStateObjects = orderedTable();
	wraithStateObjects["AREAE_WRAITH_KILLED"] = { state = WraithState.Killed,  dbr = "records/creatures/enemies/boss&quest/wraith_ugdall.dbr" }
	wraithStateObjects["AREAE_WRAITH_PASSED"] = { state = WraithState.Passed,  dbr = "records/creatures/enemies/wraith_C01.dbr" }
	wraithStateObjects["AREAE_WRAITH_HOSTILE"] = { state = WraithState.Hostile,  dbr = "records/creatures/enemies/boss&quest/wraith_ugdall.dbr" }
	wraithStateObjects[""] = { state = WraithState.Default, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_wraithugdenbog_01.dbr" }

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(wraithId):GetCoords().origin

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 200
	end
	
	if (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+3)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+3)

	end
	
	if monsterLevel > maxLevel then
		originPoint = nil
	
	end

	return monsterLevel, originPoint
	
end
	
function gd.quests.areaEQuestWraith.wraithOnAddToWorld(objectId)

	if Server then
	
		if (wraithSpawned == false) then

			wraithId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, wraithStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WraithState.Hostile || newState == WraithState.Killed) then
				wraithSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestWraith.wraithOnDestroy = ClearObjectUserdata


-- Wraith goes hostile - activated by dialogue.
function gd.quests.areaEQuestWraith.wraithHostileTransition()
	
	if Server then
	
		if not wraithSpawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:HasToken("AREAE_WRAITH_HOSTILE") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/wraith_ugdall.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(wraithId, wraithStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
			wraithSpawned = true

		end
	
	end

end

-- Wraith passes on - activated by quest.
function gd.quests.areaEQuestWraith.wraithPassOnTransition()
	
	if Server then
	
		if not wraithSpawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = true
			
			local coords = Entity.Get(wraithId):GetCoords();
			local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
			
			if rift ~= nil then
				rift:NetworkEnable()
				rift:SetCoords(coords)
				
			end
			
			UpdateObjectSwap(wraithId, wraithStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
			wraithSpawned = true

		end
	
	end

end
