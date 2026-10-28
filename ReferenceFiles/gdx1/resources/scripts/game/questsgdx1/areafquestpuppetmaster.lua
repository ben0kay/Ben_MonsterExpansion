/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestPuppetmaster = {}

local PuppetmasterId = 0
local PuppetmasterState = {NotSpawned = 0, Spawned = 1, Hostile = 2, Dead = 3}
local PuppetmasterSpawned = false

local PuppetmasterStateObjects = orderedTable();
	PuppetmasterStateObjects["AREAF_PUPPETMASTER_HOSTILE"] = { state = PuppetmasterState.Hostile,  dbr = "records/creatures/enemies/boss&quest/humanascendant_mindthief_01.dbr" }
	PuppetmasterStateObjects["AREAF_PUPPETMASTER_ACTIVE"] = { state = PuppetmasterState.Spawned,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_puppetmaster_01.dbr" }
	PuppetmasterStateObjects[""] = { state = PuppetmasterState.NotSpawned, dbr = nil }


local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(PuppetmasterId):GetCoords().origin

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
	
function gd.quests.areaFQuestPuppetmaster.PuppetmasterOnAddToWorld(objectId)

	if Server then
	
		if (PuppetmasterSpawned == false) then
			
			PuppetmasterId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, PuppetmasterStateObjects, Character, CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == PuppetmasterState.Hostile) then
				PuppetmasterSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaFQuestPuppetmaster.PuppetmasterOnDestroy = ClearObjectUserdata


-- Door to Puppetmaster
local doorId = 0

function gd.quests.areaFQuestPuppetmaster.doorInitialUpdate(objectId)
	if Server then
		local door01 = Door.Get(objectId)	
		local player = Game.GetLocalPlayer()
		
		if (door01 ~= nil && (player:HasToken("AREAF_PUPPETMASTER_ACTIVE") || player:HasToken("AREAF_PUPPETMASTER_HOSTILE"))) then
			door01:SetLocked(false)
			door01:Open()
		end
		
	end
	
end

function gd.quests.areaFQuestPuppetmaster.doorOnAddToWorld(objectId)
	if Server then
		doorId = objectId
		
	end
	
end

-- Activated by conversation with Rugia the witch
function gd.quests.areaFQuestPuppetmaster.PuppetmasterActivate()

	if Server then
		local PuppetMaster = Entity.Get(PuppetmasterId)
	
		if (PuppetMaster != nil) then
		
			local coords = PuppetMaster:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end

			UpdateObjectSwap(PuppetmasterId, PuppetmasterStateObjects, Character, CharacterCreateArgs)
			
		end
		
		-- Open door to Puppetmaster, if loaded
		local door = Door.Get(doorId)	
	
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
		
		end
		
	end

end

-- Hostile transition - activated by conversation with the puppetmaster
function gd.quests.areaFQuestPuppetmaster.PuppetmasterHostileTransition()
	if Server then
	
		if not PuppetmasterSpawned then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false

			if (player:HasToken("AREAF_PUPPETMASTER_HOSTILE") == false) then
				MPOverrideDbr = "records/creatures/enemies/boss&quest/humanascendant_mindthief_01.dbr"
				MPOverrideState = true
			end
			
			UpdateObjectSwap(PuppetmasterId, PuppetmasterStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
			PuppetmasterSpawned = true

		end
	
	end

end
