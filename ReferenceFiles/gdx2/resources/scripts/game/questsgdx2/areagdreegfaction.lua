/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGDreegFaction = {}


--
-- Dreeg Faction Quest 01 - The player must use a given item to unlock a tomb. Inside the tomb is a dreeg sister that has been driven crazy by her investigations into Korvaak
-- The player can speak with the sister and attempt to talk her down, but she's just too far gone. The player must
--

-- Barricade

local madWitchBlockadeState = { Default = 0, Active = 1, Destroyed = 1}

local madWitchBlockadeId = 0
local spawnedBlockade = false
local madWitchId = 0
local madWitchHostile = false

-- Blockade to the mad witch hideout
local MadWitchBlockadeStateObjects = orderedTable();
	MadWitchBlockadeStateObjects["AREAG_MADWITCHBLOCKADE_CLEARED"]	= { state = madWitchBlockadeState.Destroyed,  dbr = nil }
	MadWitchBlockadeStateObjects[""] 								= { state = madWitchBlockadeState.Default, dbr = "records/storyelementsgdx2/questassets/areag_madwitch_door_break.dbr" }

function gd.quests.areaGDreegFaction.madWitchBlockadeOnAddToWorld(objectId)

	if Server then

		if (not spawnedBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, MadWitchBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	
			spawnedBlockade = true
	
		end
		
	end
	
end

function gd.quests.areaGDreegFaction.blockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		madWitchBlockadeId = objectId
	
	end
	
end

gd.quests.areaGDreegFaction.madWitchBlockadeOnDestroy = ClearObjectUserdata
	
-- Interaction Site
local npcId = 0
local npcSpawned = false
local blockadeCleared = false

local MadWitchInteractionSiteStateObjects = orderedTable();
	MadWitchInteractionSiteStateObjects["AREAG_MADWITCHBLOCKADE_CLEARED"] = { state = madWitchBlockadeState.Destroyed,  dbr = nil }
	MadWitchInteractionSiteStateObjects["AREAG_MADWITCH_STARTED"] = { state = madWitchBlockadeState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_madwitchblockade.dbr" }
	MadWitchInteractionSiteStateObjects[""] = { state = madWitchBlockadeState.Default, dbr = nil }

function gd.quests.areaGDreegFaction.interactionSiteOnAddToWorld(objectId)
	
	if Server && not blockadeCleared then
		local player = Game.GetLocalPlayer()
		npcId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (npcSpawned || player:AnyoneHasToken("AREAG_MADWITCH_STARTED")) && not player:HasToken("AREAG_MADWITCHBLOCKADE_CLEARED") then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_madwitchblockade.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MadWitchInteractionSiteStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGDreegFaction.interactionSiteOnDestroy = ClearObjectUserdata

function gd.quests.areaGDreegFaction.spawnInteractionSite()

	if Server && not npcSpawned then
		npcSpawned = true
		
		local player = Game.GetLocalPlayer()
		
		local npc = Entity.Get(npcId)
		
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_MADWITCH_STARTED") == false && not player:HasToken("AREAG_MADWITCHBLOCKADE_CLEARED")) then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_madwitchblockade.dbr"
			MPOverrideState = true
		end

		if (npc != nil) then
			local coords = npc:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(npcId, MadWitchInteractionSiteStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end	
	
	end
	
end


-- Destroy Blockade
function gd.quests.areaGDreegFaction.madWitchBlockadeDestroyGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xF3264C00
	local kTask = 0x9F44BC00
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_MADWITCHBLOCKADE_CLEARED")
	end

end

function gd.quests.areaGDreegFaction.madWitchBlockadeDestroy()

	if Server then
		blockadeCleared = true
		
		if madWitchBlockadeId != 0 then
			local Blockade = Destructible.Get(madWitchBlockadeId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			madWitchBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		QuestGlobalEvent("madWitchBlockadeToken")
		
	end

end

-- The Mad Witch
local madWitchState = { Neutral = 0, Hostile = 1, Killed = 2}

local MadWitchStateObjects = orderedTable();
	MadWitchStateObjects["AREAG_MADWITCH_KILLED"] = { state = madWitchState.Killed, dbr = "records/creatures/enemies/boss&quest/human_madwitch_01.dbr" }
	MadWitchStateObjects["AREAG_MADWITCH_HOSTILE"] = { state = madWitchState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_madwitch_01.dbr" }
	MadWitchStateObjects[""] = { state = madWitchState.Neutral, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_dreeg_madwitch.dbr" }

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local bossLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(madWitchId):GetCoords().origin

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 200
	end
	
	if (averageLevel > maxLevel) then
		bossLevel = ((maxLevel+(maxLevel/50))+3)
	else
		bossLevel = ((averageLevel+(averageLevel/50))+3)

	end
	
	if bossLevel > maxLevel then
		originPoint = nil
	
	end

	return bossLevel, originPoint
	
end
	
function gd.quests.areaGDreegFaction.madWitchOnAddToWorld(objectId)
	
	if Server then
		if (not madWitchHostile) then
			
			madWitchId = objectId
	
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, MadWitchStateObjects, Character, CharacterCreateArgs)
	
			Shared.setUserdata(objectId, userdata)
	
			-- Don't respawn next time. If spawned as hostile, will be saved into the world
			if (newState == madWitchState.Hostile || newState == madWitchState.Killed) then
				madWitchHostile = true
				
			end
			
		end
	
	end
	
end

gd.quests.areaGDreegFaction.madWitchOnDestroy = ClearObjectUserdata

-- Mad Witch Hostile Transition
function gd.quests.areaGDreegFaction.madWitchHostileTransition()

	if Server && not madWitchHostile then
		madWitchHostile = true
		
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_MADWITCH_HOSTILE") == false) then
			MPOverrideDbr = "records/creatures/enemies/boss&quest/human_madwitch_01.dbr"
			MPOverrideState = true
		end
		
		UpdateObjectSwap(madWitchId, MadWitchStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
	end
	
end

-- Mad witch kill credit
function gd.quests.areaGDreegFaction.madWitchKill()

	local player = Game.GetLocalPlayer()
	
	if (player != nil) then
		player:GiveToken("AREAG_MADWITCH_KILLED")
		
	end
	
end

