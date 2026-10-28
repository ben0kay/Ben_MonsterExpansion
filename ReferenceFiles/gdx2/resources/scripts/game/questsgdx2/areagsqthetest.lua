/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGTheTest = {}


local Recruit01Id = 0
local Recruit01Hostile = false
local Recruit01Defeated = false
local Recruit02Id = 0
local Recruit02Hostile = false
local Recruit02Defeated = false
local Recruit03Id = 0
local Recruit03Hostile = false
local Recruit03Defeated = false

local theTestState = { Default = 0, Hostile = 2, Defeated = 3, Left = 4, Stay = 5} 

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

-- Recruit 01 
local Recruit01StateObjects = orderedTable();
	Recruit01StateObjects["AREAG_SOLAELRECRUITS_FAILED"] = { state = theTestState.Left, dbr = nil}
	Recruit01StateObjects["AREAG_SOLAELRECRUITS_SUCCEED"] = { state = theTestState.Stay, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_01b.dbr"}
	Recruit01StateObjects["AREAG_SOLAELRECRUIT01_DEFEATED"] = { state = theTestState.Defeated, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_01b.dbr"}
	Recruit01StateObjects["AREAG_SOLAELRECRUITS_HOSTILE"] = { state = theTestState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaeltest_01.dbr"}
	Recruit01StateObjects[""] = { state = theTestState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_01.dbr"}
	
function gd.quests.areaGTheTest.theTestRecruit01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_SOLAELRECRUITS_FAILED") == false then
			if not Recruit01Hostile then
				Recruit01Id = objectId
				
				local userdata = {}
				local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Recruit01StateObjects, Character, CharacterCreateArgs)
				Shared.setUserdata(objectId, userdata);
				
				-- Don't respawn next time. If spawned as hostile, will be saved into the world
				if (newState == theTestState.Hostile) then
					Recruit01Hostile = true
					
				end
			
			elseif Recruit01Defeated then
				Recruit01Id = objectId
				
				local MPOverrideDbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_01b.dbr"
				local MPOverrideState = true

				local userdata = {}
				TokenStateBasedObjectSwap(objectId, userdata, Recruit01StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
				Shared.setUserdata(objectId, userdata);
			
			end
		
		end
		
	end
	
end

gd.quests.areaGTheTest.theTestRecruit01OnDestroy = ClearObjectUserdata

-- Rrecruit 01 defeated credit
function gd.quests.areaGTheTest.killRecruit01()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x434ED700
	local kTask = 0x3882E100
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress)then
		player:GiveToken("AREAG_SOLAELRECRUIT01_DEFEATED")
	end
	
	if Server then
		Recruit01Defeated = true
		
	end

end

-- Recruit 02 
local Recruit02StateObjects = orderedTable();
	Recruit02StateObjects["AREAG_SOLAELRECRUITS_FAILED"] = { state = theTestState.Left, dbr = nil}
	Recruit02StateObjects["AREAG_SOLAELRECRUITS_SUCCEED"] = { state = theTestState.Stay, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_02b.dbr"}
	Recruit02StateObjects["AREAG_SOLAELRECRUIT02_DEFEATED"] = { state = theTestState.Defeated, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_02b.dbr"}
	Recruit02StateObjects["AREAG_SOLAELRECRUITS_HOSTILE"] = { state = theTestState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaeltest_02.dbr"}
	Recruit02StateObjects[""] = { state = theTestState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_02.dbr"}
	
function gd.quests.areaGTheTest.theTestRecruit02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_SOLAELRECRUITS_FAILED") == false then
			if not Recruit02Hostile then
				Recruit02Id = objectId
				
				local userdata = {}
				local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Recruit02StateObjects, Character, CharacterCreateArgs)
				Shared.setUserdata(objectId, userdata);
				
				-- Don't respawn next time. If spawned as hostile, will be saved into the world
				if (newState == theTestState.Hostile) then
					Recruit02Hostile = true
					
				end
			
			elseif Recruit02Defeated then
				Recruit02Id = objectId
				
				local MPOverrideDbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_02b.dbr"
				local MPOverrideState = true

				local userdata = {}
				TokenStateBasedObjectSwap(objectId, userdata, Recruit02StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
				Shared.setUserdata(objectId, userdata);
			
			end
		
		end
		
	end
	
end
	
gd.quests.areaGTheTest.theTestRecruit02OnDestroy = ClearObjectUserdata

-- Rrecruit 02 defeated credit
function gd.quests.areaGTheTest.killRecruit02()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x434ED700
	local kTask = 0x3882E100
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress)then
		player:GiveToken("AREAG_SOLAELRECRUIT02_DEFEATED")
	end
	
	if Server then
		Recruit02Defeated = true
		
	end

end

-- Recruit 03 
local Recruit03StateObjects = orderedTable();
	Recruit03StateObjects["AREAG_SOLAELRECRUITS_FAILED"] = { state = theTestState.Left, dbr = nil}
	Recruit03StateObjects["AREAG_SOLAELRECRUITS_SUCCEED"] = { state = theTestState.Stay, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_03b.dbr"}
	Recruit03StateObjects["AREAG_SOLAELRECRUIT03_DEFEATED"] = { state = theTestState.Defeated, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_03b.dbr"}
	Recruit03StateObjects["AREAG_SOLAELRECRUITS_HOSTILE"] = { state = theTestState.Hostile, dbr = "records/creatures/enemies/boss&quest/human_solaeltest_03.dbr"}
	Recruit03StateObjects[""] = { state = theTestState.Default, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_03.dbr"}
	
function gd.quests.areaGTheTest.theTestRecruit03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_SOLAELRECRUITS_FAILED") == false then
			if not Recruit03Hostile then
				Recruit03Id = objectId
				
				local userdata = {}
				local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Recruit03StateObjects, Character, CharacterCreateArgs)
				Shared.setUserdata(objectId, userdata);
				
				-- Don't respawn next time. If spawned as hostile, will be saved into the world
				if (newState == theTestState.Hostile) then
					Recruit03Hostile = true
					
				end
			
			elseif Recruit03Defeated then
				Recruit03Id = objectId
				
				local MPOverrideDbr = "records/creatures/npcs/flavornpcs/gdareag/npc_solaeltest_03b.dbr"
				local MPOverrideState = true

				local userdata = {}
				TokenStateBasedObjectSwap(objectId, userdata, Recruit03StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
				Shared.setUserdata(objectId, userdata);
			
			end
		
		end
		
	end
	
end
	
gd.quests.areaGTheTest.theTestRecruit03OnDestroy = ClearObjectUserdata

-- Rrecruit 03 defeated credit
function gd.quests.areaGTheTest.killRecruit03()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x434ED700
	local kTask = 0x3882E100
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress)then
		player:GiveToken("AREAG_SOLAELRECRUIT03_DEFEATED")
	end
	
	if Server then
		Recruit03Defeated = true
		
	end

end


-- Transition recruits to hostile activated by conversation
local recruitsTransitioned = false

function gd.quests.areaGTheTest.transitionRecruits()

	if Server && not recruitsTransitioned then
		recruitsTransitioned = true
		
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr01 = nil
		local MPOverrideDbr02 = nil
		local MPOverrideDbr03 = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_SOLAELRECRUITS_HOSTILE") == false) then
			MPOverrideDbr01 = "records/creatures/enemies/boss&quest/human_solaeltest_01.dbr"
			MPOverrideDbr02 = "records/creatures/enemies/boss&quest/human_solaeltest_02.dbr"
			MPOverrideDbr03 = "records/creatures/enemies/boss&quest/human_solaeltest_03.dbr"
			MPOverrideState = true
		end

		local Recruit01 = Entity.Get(Recruit01Id)
		
		if (not Recruit01Hostile) && (Recruit01 != nil) then
			UpdateObjectSwap(Recruit01Id, Recruit01StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr01)
			
			Recruit01Hostile = true
		
		end
		
		local Recruit02 = Entity.Get(Recruit02Id)
		
		if (not Recruit02Hostile) && (Recruit02 != nil) then
			UpdateObjectSwap(Recruit02Id, Recruit02StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr02)

			Recruit02Hostile = true
		
		end

		local Recruit03 = Entity.Get(Recruit03Id)
		
		if (not Recruit03Hostile) && (Recruit03 != nil) then
			UpdateObjectSwap(Recruit03Id, Recruit03StateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr03)
			
			Recruit03Hostile = true
		
		end
		
	end
	
end

-- Recruits Passed Token
function gd.quests.areaGTheTest.recruitsPassedTokenGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x434ED700
	local kTask = 0x1880DD60
		
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress || questTaskState == QuestState.Complete) && player:HasToken("AREAG_SOLAELRECRUITS_FAILED") == false then
		player:GiveToken("AREAG_SOLAELRECRUITS_SUCCEED")
	end

end

-- Recruits Failed Token
function gd.quests.areaGTheTest.recruitsFailedTokenGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x434ED700
	local kTask = 0x1880DD60
		
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress || questTaskState == QuestState.Complete) && player:HasToken("AREAG_SOLAELRECRUITS_SUCCEED") == false then
		player:GiveToken("AREAG_SOLAELRECRUITS_FAILED")
	end

end

