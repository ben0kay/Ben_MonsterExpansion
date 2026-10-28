/*
	
	GRIM DAWN
	scripts/quests/_GDX1MPQuestControl.lua
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.GDX1MPQuestControl = {}

--
-- MP Control for bestowing quests to all players.
-- Triggered by Conversations
--


-- GDX1 Breadcrumb
-- Starts the quest to speak to Creed to begin the main quest for GDX1
function gd.GDX1MPQuestControl.bestowGDX1BreadcrumbGlobalMP()

	local player = Game.GetLocalPlayer()
	local questId01 = 0x8BCA0200
	local taskId01 = 0xAC3CCE00

	-- Devil's Crossing Needs Help
	local questId02 = 0x92F9BE00
	local taskId02 = 0xBF320900

	-- Desperate Measures
	local questId03 = 0x48342280
	local taskId03 = 0xE89BDF00
	
	local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
	local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
	local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
	
	-- Player has completed Bane of Cairn and has not started the GDX questline
	if (questTaskState01 == QuestState.Complete && (questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress))  then
		player:GrantQuest(0xB7036200, 0xAC3CCE00)
	end

end

--
-- Area E Main Quests
--

-- Devil's Crossing Needs Help
-- questId 0x92F9BE00
-- taskID1 0xBF320900
-- taskID2 0xAC3CCE00

local devilsCrossingNeedsHelpQuest = false

function gd.GDX1MPQuestControl.bestowDevilsCrossingNeedsHelpQuestGlobalMP()

	if not devilsCrossingNeedsHelpQuest then
		devilsCrossingNeedsHelpQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x92F9BE00
		local taskId01 = 0xAC3CCE00
		
		-- Murderers and Worse
		local questId02 = 0x0DB402C0
		local taskId02 = 0xA5229F00

		-- Bane of Cairn
		local questId03 = 0x8BCA0200
		local taskId03 = 0xAC3CCE00
			
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)

		-- Check to make sure the player is not already on this quest, has completed Bane of Cairn and has not done Murderers and Worse
		if (questTaskState03 == QuestState.Complete && (questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress)) then
			player:GrantQuest(0x92F9BE00, 0xBF320900)
		end

	end

end


-- Desperate Measures
-- questId 0x48342280
-- taskID1 0xE89BDF00
-- taskID2 0xAC3CCE00

local desperateMeasuresQuest = false

function gd.GDX1MPQuestControl.bestowDesperateMeasuresQuestQuestGlobalMP()

	if not desperateMeasuresQuest then
		desperateMeasuresQuest = true
		local player = Game.GetLocalPlayer()
		
		-- Murderers and Worse
		local questId01 = 0x0DB402C0
		local taskId01 = 0xA5229F00

		-- Bane of Cairn
		local questId02 = 0x8BCA0200
		local taskId02 = 0xAC3CCE00
			
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)

		-- Check to make sure the player has completed act 1 and completed Bane of Cairn
		if (questTaskState02 == QuestState.Complete && (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress)) then
			player:GrantQuest(0x48342280, 0xE89BDF00)
		end

	end

end


-- A Wich's Deal
-- questId 0x8BE0D600
-- taskID1 0xBF320900
-- taskID2 0x3A1ADC00
-- taskID3 0xAC3CCE00

local aWitchDealQuest = false

function gd.GDX1MPQuestControl.bestowAWitchDealQuestGlobalMP()

	if not aWitchDealQuest then
		aWitchDealQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x48342280
		local taskId01 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task checks if player has completed Desperate Measures
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0x8BE0D600, 0xBF320900)
		end

	end

end


-- Jewel in the Mud
-- two versions of this quest depending on player state with the faction
-- friendly
-- questID 0xA617B600
-- taskID1 0x72DB6400
-- hostile
-- questId 0xB3558700
-- taskID1 0xAC3CCE00

local jewelInTheMudHostileQuest = false
local jewelInTheMudFriendlyQuest = false

function gd.GDX1MPQuestControl.bestowJewelInTheMudHostileQuestGlobalMP()

	if not jewelInTheMudHostileQuest then
		jewelInTheMudHostileQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x8BE0D600
		local taskId01 = 0x3A1ADC00
		local questId02 = 0xA617B600
		local taskId02 = 0x72DB6400
		local questId03 = 0xB3558700
		local taskId03 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		-- Begins hostile scenario checks if player has completed the previous quest and is not already on the quest
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress && questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress) then
			if player:GetFaction("USER10") <= 0 then
				player:GrantQuest(0xB3558700, 0xAC3CCE00)
			else
				player:GrantQuest(0xA617B600, 0x72DB6400)
			end
			
		end

	end

end

function gd.GDX1MPQuestControl.bestowJewelInTheMudFriendlyQuestGlobalMP()

	if not jewelInTheMudFriendlyQuest then
		jewelInTheMudFriendlyQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x8BE0D600
		local taskId01 = 0x3A1ADC00
		local questId02 = 0xA617B600
		local taskId02 = 0x72DB6400
		local questId03 = 0xB3558700
		local taskId03 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		-- Begins friendly scenario checks if player has completed the previous quest and is not already on the quest or has selected hostile
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress && questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress) then
			if player:GetFaction("USER10") >= 0 then
				player:GrantQuest(0xA617B600, 0x72DB6400)
			else
				player:GrantQuest(0xB3558700, 0xAC3CCE00)
			end
			
		end

	end

end


-- Into Jaws of Madness
-- questId 0x6B11F400
-- taskID1 0x4CB0DB00
-- taskID2 0x94054900
-- taskID3 0xAC3CCE00

local intoJawsOfMadnessQuest = false

function gd.GDX1MPQuestControl.bestowIntoJawsOfMadnessQuestGlobalMP()

	if not intoJawsOfMadnessQuest then
		intoJawsOfMadnessQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x8BE0D600
		local taskId01 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task checks if player has completed the previous quest
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0x6B11F400, 0x4CB0DB00)
		end

	end

end


-- Along the Void's Edge
-- questId 0x5F3CB680
-- taskID1 0xBF320900
-- taskID2 0xAC3CCE00

local alongTheVoidEdgeQuest = false
local alongTheVoidEdgeReturnQuest = false

function gd.GDX1MPQuestControl.bestowAlongTheVoidEdgeQuestGlobalMP()

	if not alongTheVoidEdgeQuest then
		alongTheVoidEdgeQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x6B11F400
		local taskId01 = 0xAC3CCE00
		local questId02 = 0x5F3CB680
		local taskId02 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task checks if player has completed the previous quest and is not already on the quest
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x5F3CB680, 0xBF320900)
		end

	end

end

function gd.GDX1MPQuestControl.bestowAlongTheVoidEdgeReturnQuestGlobalMP()

	if not alongTheVoidEdgeReturnQuest then
		alongTheVoidEdgeReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x6B11F400
		local taskId01 = 0xAC3CCE00
		local questId02 = 0x5F3CB680
		local taskId02 = 0xBF320900

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)

		-- Begins first task checks if player has completed the previous quest, is not already on the quest and has discovered the way out of the void
		if (player:HasToken("AREAE_EMBERCRAGSFOUND") && questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x5F3CB680, 0xAC3CCE00)
		end

	end

end

--
-- Area E Side Quests
--

-- Lost Father
-- questId 0x2B2FF440
-- taskID1 0xFEAFC100
-- taskID2 0xAC3CCE00

local lostFatherQuest = false
local lostFatherReturnQuest = false

function gd.GDX1MPQuestControl.bestowLostFatherQuestGlobalMP()

	if not lostFatherQuest then
		lostFatherQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x48342280
		local taskId01 = 0xE89BDF00
		local questId02 = 0x2B2FF440
		local taskId02 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player has started/finished Desperate Measures and is not already on the quest
		if ((questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x2B2FF440, 0xFEAFC100)
		end

	end

end

function gd.GDX1MPQuestControl.bestowLostFatherReturnQuestGlobalMP()

	if not lostFatherReturnQuest then
		lostFatherReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x48342280
		local taskId01 = 0xE89BDF00
		local questId02 = 0x2B2FF440
		local taskId02 = 0xFEAFC100
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player has started/finished Desperate Measures, is not already on the quest and has rescued the father
		if (player:HasToken("AREAE_LOSTFATHERFOUND") && (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x2B2FF440, 0xAC3CCE00)
		end

	end

end

-- Burn the Taken End
-- questId 0x35A43240
-- taskID1 0x1501C060

local burnTheTakenEndQuest = false

function gd.GDX1MPQuestControl.bestowBurnTheTakenEndQuestGlobalMP()

	if not burnTheTakenEndQuest then
		burnTheTakenEndQuest = true
		local player = Game.GetLocalPlayer()

		-- Check to make sure the player has saved Rallia in the Blood Grove
		if (player:HasToken("AREAC_BURNTHETAKEN_FREEFINISH")) then
			player:GrantQuest(0x35A43240, 0x1501C060)
		end

	end

end

-- Cleanse the Corruption
-- questId 0xA6F55100
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local cleanseCorruptionQuest = false
local cleanseCorruptionReturnQuest = false

function gd.GDX1MPQuestControl.bestowCleanseCorruptionQuestGlobalMP()

	if not cleanseCorruptionQuest then
		cleanseCorruptionQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xA6F55100
		local taskId01 = 0x1501C060
		local questId02 = 0x48342280
		local taskId02 = 0xE89BDF00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest and has completed the first task of Desperate Measures
		if (questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress && questTaskState02 == QuestState.Complete) then
			player:GrantQuest(0xA6F55100, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowCleanseCorruptionReturnQuestGlobalMP()

	if not cleanseCorruptionReturnQuest then
		cleanseCorruptionReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xA6F55100
		local taskId01 = 0xEC4C5000
		local questId02 = 0x48342280
		local taskId02 = 0xE89BDF00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player is not already on the quest and has killed the boss and has completed the first task of Desperate Measures
		if (player:HasToken("AREAE_ANCIENTGROVE_CLEARED") && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress && questTaskState02 == QuestState.Complete) then
			player:GrantQuest(0xA6F55100, 0x1501C060)
		end

	end

end

-- Wraith Ugdenbog
-- friendly
-- questID 0x10553F40
-- taskID1 0xEC4C5000 - hostile
-- taskID2 0x1501C060 - friendly

local wraithUgdenbogHostileQuest = false
local wraithUgdenbogFriendlyQuest = false

function gd.GDX1MPQuestControl.bestowWraithUgdenbogHostileQuestGlobalMP()

	if not wraithUgdenbogHostileQuest then
		wraithUgdenbogHostileQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x10553F40
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins hostile scenario checks if player is not already on the quest or has chosen Friendly
		if (player:HasToken("AREAE_WRAITH_FRIENDLY") == false && player:HasToken("AREAE_WRAITH_PASSED") == false && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
			player:GrantQuest(0x10553F40, 0xEC4C5000)
			
		end

	end

end

function gd.GDX1MPQuestControl.bestowWraithUgdenbogFriendlyQuestGlobalMP()

	if not wraithUgdenbogFriendlyQuest then
		wraithUgdenbogFriendlyQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x10553F40
		local taskId01 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins hostile scenario checks if player is not already on the quest or has chosen Friendly
		if (player:HasToken("AREAE_WRAITH_HOSTILE") == false && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
			player:GrantQuest(0x10553F40, 0x1501C060)
			
		end

	end

end

-- Bloodsworn Damned
-- questID 0x9A0F3500
-- taskID1 0x1501C060 - leave them
-- taskID2 0x5F351E00 - release them

local bloodswornDamnedLeaveQuest = false
local bloodswornDamnedReleaseQuest = false

function gd.GDX1MPQuestControl.bestowBloodswornDamnedLeaveQuestGlobalMP()

	if not bloodswornDamnedLeaveQuest then
		bloodswornDamnedLeaveQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x9A0F3500
		local taskId01 = 0x5F351E00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins Leave scenario, checks if player has not already made this choice.
		if ((player:HasToken("AREAE_BLOODSWORN_CHOOSERELEASE") == false && player:HasToken("AREAE_BLOODSWORN_RELEASED") == false) && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
			player:GrantQuest(0x9A0F3500, 0x1501C060)
			
		end

	end

end

function gd.GDX1MPQuestControl.bestowBloodswornDamnedReleaseQuestGlobalMP()

	if not bloodswornDamnedReleaseQuest then
		bloodswornDamnedReleaseQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x9A0F3500
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins Release scenario, checks if player has not already made this choice.
		if ((player:HasToken("AREAE_BLOODSWORN_LEFT") == false && player:HasToken("AREAE_BLOODSWORN_CHOOSERELEASE") == false) && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
			player:GrantQuest(0x9A0F3500, 0x5F351E00)
			
		end

	end

end

-- Puppetmaster
-- questID 0xAF0CDE00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local puppetmasterQuest = false

function gd.GDX1MPQuestControl.bestowPuppetmasterQuestGlobalMP()

	if not puppetmasterQuest then
		puppetmasterQuest = true
		local player = Game.GetLocalPlayer()
		
		-- Begins first task, checks if player has at least 10000 reputation with the coven and has access to the Aetherial Factory
		if (player:GetFaction("USER9") >= 10000 && player:HasToken("AREAF_FINALFACTORY")) then
			player:GrantQuest(0xAF0CDE00, 0xEC4C5000)
			
		end

	end

end

-- Coven Faction Quests

-- Coven Q01 - Future Sisters
-- questId 0xB4E39200
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local futureSistersQuest = false
local futureSistersReturnQuest = false

function gd.GDX1MPQuestControl.bestowFutureSistersQuestGlobalMP()

	if not futureSistersQuest then
		futureSistersQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x48342280
		local taskId01 = 0xAC3CCE00
		local questId02 = 0xB4E39200
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest and has completed Desperate Measures
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xB4E39200, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowFutureSistersReturnQuestGlobalMP()

	if not futureSistersReturnQuest then
		futureSistersReturnQuest = true
		local player = Game.GetLocalPlayer()

		local questId01 = 0x48342280
		local taskId01 = 0xAC3CCE00
		local questId02 = 0xB4E39200
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player is not already on the quest, has completed Desperate Measures and has already rescued the sisters.
		if (player:HasToken("AREAE_WITCHES01_RESCUED") && questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xB4E39200, 0x1501C060)
		end

	end

end

-- Coven Q02 - Coven's Walls
-- questId 0xBB668600
-- taskID1 0xA2F0D500

local covenWallsQuest = false

function gd.GDX1MPQuestControl.bestowCovenWallsQuestGlobalMP()

	if not covenWallsQuest then
		covenWallsQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x6B11F400
		local taskId01 = 0x4CB0DB00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player is on Into the Jaws of Madness
		if (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) then
			player:GrantQuest(0xBB668600, 0xA2F0D500)
		end

	end

end

-- Coven Q03 - Pruning the Weeds
-- questId 0xC2A19D00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local pruningWeedsQuest = false
local pruningWeedsReturnQuest = false

function gd.GDX1MPQuestControl.bestowPruningWeedsQuestGlobalMP()

	if not pruningWeedsQuest then
		pruningWeedsQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xBB668600
		local taskId01 = 0xA2F0D500
		local questId02 = 0xC2A19D00
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest and has done Coven's Walls
		if ((questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xC2A19D00, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowPruningWeedsReturnQuestGlobalMP()

	if not pruningWeedsReturnQuest then
		pruningWeedsReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xBB668600
		local taskId01 = 0xA2F0D500
		local questId02 = 0xC2A19D00
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player is not already on the quest,  has done Coven's Walls and has slain Sylvarria
		if (player:HasToken("AREAE_SYLVARRIA_KILLED") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xC2A19D00, 0x1501C060)
		end

	end

end

-- Coven Q04 - Allure of the Wendigo
-- questId 0xC93CAC00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local allureWendigoQuest = false
local allureWendigoReturnQuest = false

function gd.GDX1MPQuestControl.bestowAllureWendigoQuestGlobalMP()

	if not allureWendigoQuest then
		allureWendigoQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xC2A19D00
		local taskId01 = 0x1501C060
		local questId02 = 0xC93CAC00
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest, has done Pruning the Weeds and has at least 1500 rep
		if (player:GetFaction("USER9") >= 1500 && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xC2A19D00, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowAllureWendigoReturnQuestGlobalMP()

	if not allureWendigoReturnQuest then
		allureWendigoReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xC2A19D00
		local taskId01 = 0x1501C060
		local questId02 = 0xC93CAC00
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player is not already on the quest,  has done Pruning the Weeds, has slain Janaxia and has at least 1500 rep
		if (player:GetFaction("USER9") >= 1500 && player:HasToken("AREAE_WITCHBETRAYER_KILLED") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xC2A19D00, 0x1501C060)
		end

	end

end

-- Coven Q05 - Power in the Circles
-- questId 0xCF77D200
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local powerInCirclesQuest = false
local powerInCirclesReturnQuest = false

function gd.GDX1MPQuestControl.bestowPowerInCirclesQuestGlobalMP()

	if not powerInCirclesQuest then
		powerInCirclesQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xC93CAC00
		local taskId01 = 0x1501C060
		local questId02 = 0xCF77D200
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest, has done Allure of the Wendigo and has at least 5000 Reputation
		if (player:GetFaction("USER9") >= 5000 && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xCF77D200, 0xEC4C5000)
		end

	end

end

-- Coven Q06 - The Final Seal
--questId 0xDBED1700
--taskId1 0xEC4C5000 perform ritual
--taskId2 0x1501C060 turn-in
local finalSealQuest = false

function gd.GDX1MPQuestControl.bestowFinalSealQuestGlobalMP()

	if not finalSealQuest then
		finalSealQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xCF77D200
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player has done Power in the Circles and has at least 10000 Reputation
		if (questTaskState01 == QuestState.Complete && player:GetFaction("USER9") >= 10000) then
			player:GrantQuest(0xDBED1700, 0xEC4C5000)

		end

	end

end


-- Wendigo Faction Quests

-- Wendigo Q01 - Wendigo Wards
-- questId 0xE2200700
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local wendigoWardsQuest = false

function gd.GDX1MPQuestControl.bestowWendigoWardsQuestGlobalMP()

	if not wendigoWardsQuest then
		wendigoWardsQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xA617B600
		local taskId01 = 0x72DB6400

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player is not already on the quest and is eligible.
		if (player:HasToken("AREAE_VILLAGEFRIENDLY") && (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress)) then
			player:GrantQuest(0xE2200700, 0xEC4C5000)
		end

	end

end

-- Wendigo Q02 - Travelers Beware
-- questId 0xE88AE000
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local travelersBewareQuest = false

function gd.GDX1MPQuestControl.bestowTravelersBewareQuestGlobalMP()

	if not travelersBewareQuest then
		travelersBewareQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xA617B600
		local taskId01 = 0x72DB6400

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player is not already on the quest and is eligible.
		if (player:HasToken("AREAE_VILLAGEFRIENDLY") && (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress)) then
			player:GrantQuest(0xE88AE000, 0xEC4C5000)
		end

	end

end

-- Wendigo Q03 - Mine Pests
-- questId 0xEF660D00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local minePestsQuest = false
local minePestsReturnQuest = false

function gd.GDX1MPQuestControl.bestowMinePestsQuestGlobalMP()

	if not minePestsQuest then
		minePestsQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xE2200700
		local taskId01 = 0x1501C060
		local questId02 = 0xEF660D00
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest and has done Wendigo Wards
		if ((questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xEF660D00, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowMinePestsReturnQuestGlobalMP()

	if not minePestsReturnQuest then
		minePestsReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xE2200700
		local taskId01 = 0x1501C060
		local questId02 = 0xEF660D00
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player is not already on the quest,  has done Coven's Walls and has slain Sylvarria
		if (player:HasToken("AREAE_WENDIGOMINE_CLEARED") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xEF660D00, 0x1501C060)
		end

	end

end

-- Wendigo Q04 - Meddling Witch
-- questId 0xF9F30700
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local meddlingWitchQuest = false

function gd.GDX1MPQuestControl.bestowMeddlingWitchQuestGlobalMP()

	if not meddlingWitchQuest then
		meddlingWitchQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xE88AE000
		local taskId01 = 0x1501C060
		local questId02 = 0xEF660D00
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player is not already on the quest, has done Mine Pests and Travelers Beware and has at least 1500 reputation
		if (player:GetFaction("USER10") >= 1500 && (questTaskState01 == QuestState.Complete) && (questTaskState02 == QuestState.Complete)) then
			player:GrantQuest(0xF9F30700, 0xEC4C5000)
		end

	end

end

-- Wendigo Q05 - The Feast
-- questId 0x0045C4E8
-- taskID1 0x1501C060

local theFeastQuest = false

function gd.GDX1MPQuestControl.bestowTheFeastQuestGlobalMP()

	if not theFeastQuest then
		theFeastQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xF9F30700
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player is not already on the quest, has done Meddling Witch and has at least 5000 Reputation
		if (player:GetFaction("USER10") >= 5000 && (questTaskState01 == QuestState.Complete)) then
			player:GrantQuest(0x0045C4E8, 0x1501C060)
		end

	end

end

-- Wendigo Q06 - Cast Off the Flesh
--questId 0x0969A8E0
--taskId1 0x1501C060
local castOffTheFleshQuest = false

function gd.GDX1MPQuestControl.bestowCastOffTheFleshQuestGlobalMP()

	if not castOffTheFleshQuest then
		castOffTheFleshQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x0045C4E8
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player has done The Feast and has at least 10000 Reputation
		if (questTaskState01 == QuestState.Complete && player:GetFaction("USER10") >= 10000) then
			player:GrantQuest(0x0969A8E0, 0x1501C060)

		end

	end

end

--
-- Area F Main Quests
--


-- Along the Void's Edge (End Area E Quest)
-- questId 0x5F3CB680
-- taskID1 0xBF320900
-- taskID2 0xAC3CCE00


-- Malmouth The Fallen City
-- questId 0x67926780
-- taskID1 0xBF320900 
-- taskID2 0x37D46E00
-- taskID3 0xA8EE0800
-- taskID4 0xAC3CCE00

local malmouthFallenCityQuest = false
local malmouthFallenCityReturnQuest = false

function gd.GDX1MPQuestControl.bestowmalmouthFallenCityQuestGlobalMP()

	if not malmouthFallenCityQuest then
		malmouthFallenCityQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x5F3CB680
		local taskId01 = 0xAC3CCE00
		local questId02 = 0x67926780
		local taskId02 = 0x37D46E00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task checks if player has completed the At the Void's Edge and is not already on the quest
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x67926780, 0xBF320900)
		end

	end

end

function gd.GDX1MPQuestControl.bestowmalmouthFallenCityReturnQuestGlobalMP()

	if not malmouthFallenCityReturnQuest then
		malmouthFallenCityReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x5F3CB680
		local taskId01 = 0xAC3CCE00
		local questId02 = 0x67926780
		local taskId02 = 0xBF320900

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player has completed Sister's Love, is not already on the quest and has killed the boss
		if ((player:HasToken("AREAF_CITYGATESFOUND") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress)) then
			player:GrantQuest(0x67926780, 0x37D46E00)
		end

	end

end

-- Someone On The Inside
-- questId 0x3C42F000
-- taskID1 0x093EA120
-- taskID2 0xBA384C00
-- taskID3 0xAC3CCE00

local SomeoneOnTheInsideQuest = false

function gd.GDX1MPQuestControl.bestowSomeoneOnTheInsideQuestGlobalMP()

	if not SomeoneOnTheInsideQuest then
		SomeoneOnTheInsideQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x67926780
		local taskId01 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task checks if player has completed Malmouth
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0x3C42F000, 0x093EA120)
		end

	end

end


-- For The People
-- questId 0xDD67A400 
-- taskID1 0x0F756D40
-- taskID2 0xAC3CCE00 

local ForThePeopleQuest = false

function gd.GDX1MPQuestControl.bestowforThePeopleQuestGlobalMP()

	if not ForThePeopleQuest then
		ForThePeopleQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x3C42F000
		local taskId01 = 0xAC3CCE00
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task checks if player has completed Someone On The Inside
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0xDD67A400, 0x0F756D40)
		end

	end

end


-- Tip Of The Spear
-- questId 0xF2C96700
-- taskID1 0x78D7A780
-- taskID2 0x1A3B6DE0
-- taskID3 0xAC3CCE00

local tipOfTheSpearQuest = false
local tipOfTheSpearReturnQuest = false

function gd.GDX1MPQuestControl.bestowTipOfTheSpearQuestGlobalMP()

	if not tipOfTheSpearQuest then
		tipOfTheSpearQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xDD67A400
		local taskId01 = 0xAC3CCE00
		local questId02 = 0xF2C96700
		local taskId02 = 0x1A3B6DE0
		local taskId03 = 0xAC3CCE00
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		-- Begins first task checks if player has completed For the People and is not already on the quest
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress && questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress) then
			player:GrantQuest(0xF2C96700, 0x78D7A780)
		end

	end

end

function gd.GDX1MPQuestControl.bestowTipOfTheSpearReturnQuestGlobalMP()

	if not tipOfTheSpearReturnQuest then
		tipOfTheSpearReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xDD67A400
		local taskId01 = 0xAC3CCE00
		local questId02 = 0xF2C96700
		local taskId02 = 0x78D7A780
		local taskId03 = 0x1A3B6DE0
		local taskId04 = 0xAC3CCE00
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		local questTaskState04 = player:GetQuestTaskState(questId02, taskId04)

		-- Checks if the player has completed For the People , has destroyed the inner gate and/or has claimed the riftgate and is not already on the quest
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			if ((player:HasToken("AREAF_INNERCITYGATEDESTROYED") && player:HasToken("AREAF_INNERCITYRIFTGATECLAIMED")) && questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress) then
				player:GrantQuest(0xF2C96700, 0xAC3CCE00)
			elseif ((player:HasToken("AREAF_INNERCITYGATEDESTROYED")) && questTaskState04 != QuestState.Complete && questTaskState04 != QuestState.InProgress) then
				player:GrantQuest(0xF2C96700, 0x1A3B6DE0)
			end
		
		end

	end

end


-- Stoking The Flames
-- questId 0x59364F80
-- taskID1 0x38DD1B00
-- taskID2 0xAC3CCE00

local StokingTheFlamesQuest = false

function gd.GDX1MPQuestControl.bestowStokingTheFlamesQuestGlobalMP()

	if not StokingTheFlamesQuest then
		StokingTheFlamesQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xDD67A400
		local taskId01 = 0xAC3CCE00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Checks if the player has completed For the People
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0x59364F80, 0x38DD1B00)
		end

	end

end


--The Living Factory Quest
-- questId 0x3DA9CFC0
-- taskID1 0xBF320900
-- taskID2 0x4D1B4180
-- taskID3 0xAC3CCE00

local theLivingFactoryQuest = false
local TheLivingFactoryGuardiansQuest = false

function gd.GDX1MPQuestControl.bestowTheLivingFactoryQuestGlobalMP()

	if not theLivingFactoryQuest then
		theLivingFactoryQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xF2C96700
		local taskId01 = 0xAC3CCE00
		local questId02 = 0x3DA9CFC0
		local taskid02 = 0x4D1B4180
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskid02)
		
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.InProgress && questTaskState02 != QuestState.Complete) then
			player:GrantQuest(0x3DA9CFC0, 0xBF320900)

		end

	end

end

function gd.GDX1MPQuestControl.bestowTheLivingFactoryGuardiansQuestGlobalMP()

	if not TheLivingFactoryGuardiansQuest then
		TheLivingFactoryGuardiansQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xF2C96700
		local taskId01 = 0xAC3CCE00
		local questId02 = 0x3DA9CFC0
		local taskid02 = 0xBF320900
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskid02)
		
		-- checks if the player has destroyed the factory vents and has not completed the first task - begins the living factory task 02
		if (player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED") && questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.InProgress && questTaskState02 != QuestState.Complete) then
			player:GrantQuest(0x3DA9CFC0, 0x4D1B4180)
			GiveTokenToLocalPlayer("AREAF_FINALFACTORY")

		end

	end

end

--
-- Area F Side Quests
--


-- Mad Ramblings
-- questId 0xA8DA7100
-- taskID1 0x1501C060

local madRamblingsQuest = false

function gd.GDX1MPQuestControl.bestowMadRamblingsQuestGlobalMP()

	if not madRamblingsQuest then
		madRamblingsQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xDD67A400
		local taskId01 = 0xAC3CCE00
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task checks if player has completed For the People
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0xA8DA7100, 0x1501C060)
		end

	end

end

-- Can't Leave Them
-- questID 0x654BAA00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local cantLeaveThemQuest = false
local cantLeaveThemReturnQuest = false

function gd.GDX1MPQuestControl.bestowCantLeaveThemQuestGlobalMP()

	if not cantLeaveThemQuest then
		cantLeaveThemQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x89FC0D00
		local taskId01 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins the first task, checks if player has access to the factory and is not already on the quest
		if (player:HasToken("AREAF_FINALFACTORY") && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
			player:GrantQuest(0x654BAA00, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowCantLeaveThemReturnQuestGlobalMP()

	if not cantLeaveThemReturnQuest then
		cantLeaveThemReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x89FC0D00
		local taskId01 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins the second task, checks if player has access to the factory, has found the women and is not already on the quest
		if (player:HasToken("AREAF_FINALFACTORY") && player:HasToken("AREAF_CANTLEAVETHEM_FOUND") && questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) then
			player:GrantQuest(0x654BAA00, 0x1501C060)
		end

	end

end

-- Resistance SQ 01 - Corpse Wagons
-- questID 0x89FC0D00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local corpseWagonsQuest = false
local corpseWagonsReturnQuest = false

function gd.GDX1MPQuestControl.bestowCorpseWagonsQuestGlobalMP()

	if not corpseWagonsQuest then
		corpseWagonsQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x3C42F000
		local taskId01 = 0x093EA120
		local questId02 = 0x89FC0D00
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins the first task, checks if player is on Someone on the Inside and is not already on the quest
		if ((questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x89FC0D00, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowCorpseWagonsReturnQuestGlobalMP()

	if not corpseWagonsReturnQuest then
		corpseWagonsReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x3C42F000
		local taskId01 = 0x093EA120
		local questId02 = 0x89FC0D00
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins the first task, checks if player has destroyed all wagons, is on Someone on the Inside and is not already on the quest
		if ((player:HasToken("AREAF_CORPSEWAGONS_ALLDESTROYED") && questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x89FC0D00, 0x1501C060)
		end

	end

end

-- Resistance SQ 02 - Gather Supplies
-- questID 0x90F78A00
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local gatherSuppliesQuest = false
local gatherSuppliesReturnQuest = false

function gd.GDX1MPQuestControl.bestowGatherSuppliesQuestGlobalMP()

	if not gatherSuppliesQuest then
		gatherSuppliesQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x89FC0D00
		local taskId01 = 0x1501C060
		local questId02 = 0x90F78A00
		local taskId02 = 0x1501C060
		local questId03 = 0x59364F80
		local taskId03 = 0x38DD1B00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		-- Begins the first task, checks if the player has completed Corpse Wagons and is on Stoking the Flames, is not already on the quest
		if ((questTaskState01 == QuestState.Complete) && (questTaskState03 == QuestState.InProgress) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x90F78A00, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowGatherSuppliesReturnQuestGlobalMP()

	if not gatherSuppliesReturnQuest then
		gatherSuppliesReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x89FC0D00
		local taskId01 = 0x1501C060
		local questId02 = 0x90F78A00
		local taskId02 = 0xEC4C5000
		local questId03 = 0x59364F80
		local taskId03 = 0x38DD1B00

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		-- Begins the second task, checks if the player has completed Corpse Wagons and is on Stoking the Flames, is not already on the quest and has claimed the two caches
		if ((questTaskState01 == QuestState.Complete) && (questTaskState03 == QuestState.InProgress) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress && player:HasToken("AREAF_REBEL_WEAPONS_CLAIMED") && player:HasToken("AREAF_REBEL_ARCANE_CLAIMED")) then
			player:GrantQuest(0x90F78A00, 0x1501C060)
			
		end

	end

end


-- Resistance SQ 03 - rescue resistance
-- questID 0x971A1100
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local rescueResistanceQuest = false
local rescueResistanceReturnQuest = false

function gd.GDX1MPQuestControl.bestowRescueResistanceQuestGlobalMP()

	if not rescueResistanceQuest then
		rescueResistanceQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x90F78A00
		local taskId01 = 0x1501C060
		local questId02 = 0x971A1100
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins the first task, checks if the player has completed Gather Supplies and is not already on the quest
		if ((questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x971A1100, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowRescueResistanceReturnQuestGlobalMP()

	if not rescueResistanceReturnQuest then
		rescueResistanceReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x90F78A00
		local taskId01 = 0x1501C060
		local questId02 = 0x971A1100
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins the second task, checks if the player has completed Gather Supplies, is not already on the quest and has rescued the survivor groups
		if (player:HasToken("AREAF_REBELS01_RESCUED") && player:HasToken("AREAF_REBELS02_RESCUED") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x971A1100, 0x1501C060)
		end

	end

end

-- Resistance SQ 04 - Secure The Docks
-- questID 0x9CF4C900
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060 

local secureTheDocksQuest = false
local secureTheDocksReturnQuest = false

function gd.GDX1MPQuestControl.bestowSecureTheDocksQuestGlobalMP()

	if not secureTheDocksQuest then
		secureTheDocksQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x971A1100
		local taskId01 = 0x1501C060
		local questId02 = 0x9CF4C900
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins the first task, checks if the player has completed Rescue the Resistance, has 5000 rep and is not already on the quest
		if (player:GetFaction("USER11") >= 5000 && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x9CF4C900, 0xEC4C5000)
		end

	end

end

-- Resistance SQ 05 - Fleshbound Enclave
-- questID 0xA2979900
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local enclaveQuest = false
local enclaveReturnQuest = false

function gd.GDX1MPQuestControl.bestowAssaultEnclaveQuestGlobalMP()

	if not enclaveQuest then
		enclaveQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x9CF4C900
		local taskId01 = 0x1501C060
		local questId02 = 0xA2979900
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player has completed Secure the Docks, has at least 10000 rep and is not already on the quest
		if (player:GetFaction("USER11") >= 10000 && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xA2979900, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowAssaultEnclaveReturnQuestGlobalMP()

	if not enclaveReturnQuest then
		enclaveReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x9CF4C900
		local taskId01 = 0x1501C060
		local questId02 = 0xA2979900
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player has completed Secure the Docks, has at least 10000 rep, is not already on the quest and has slain the bosses
		if (player:GetFaction("USER11") >= 10000 && player:HasToken("AREAF_MALMOUTHENCLAVE_CLEARED") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0xA2979900, 0x1501C060)
		end

	end

end

-- Kasparov's Gambit and Hargate's Edge

-- Hargate's Edge
-- questId 0x76C3B780
-- taskID1 0x1501C060

local hargateEdge = false

function gd.GDX1MPQuestControl.bestowHargateEdgeQuestGlobalMP()

	if not hargateEdge then
		hargateEdge = true
		local player = Game.GetLocalPlayer()

		-- Begins first task, checks if player has the required token.
		if (player:HasToken("GD_SLITNOTES_KEPT")) then
			player:GrantQuest(0x76C3B780, 0x1501C060)
		end

	end

end

-- Kasparov's Gamble
-- questId 0x8320E100
-- taskID1 0x1501C060

local kasparovGamble = false

function gd.GDX1MPQuestControl.bestowKasparovGambleQuestGlobalMP()

	if not kasparovGamble then
		kasparovGamble = true
		local player = Game.GetLocalPlayer()
		
		-- Begins first task, checks if player has the required token.
		if (player:HasToken("GD_SLITNOTES_KASPAROV")) then
			player:GrantQuest(0x8320E100, 0x1501C060)
		end

	end

end


-- AreaC Daila Quest
--questID 0x1CE68AC0
--taskID1 0x639E4B80

-- Dravis/Daila SQ 01 - Sister's love
-- questID 0xB48F5E00
-- taskID1 0x1501C060

local Daila01Quest = false

function gd.GDX1MPQuestControl.bestowSisterLoveQuestGlobalMP()

	if not Daila01Quest then
		Daila01Quest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x1CE68AC0
		local taskId01 = 0x639E4B80

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Begins first task, checks if player has completed Daila's quest from Homestead
		if (questTaskState01 == QuestState.Complete) then
			player:GrantQuest(0xB48F5E00, 0x1501C060)
		end

	end

end

-- Dravis/Daila SQ 02 - Family Matter
-- questID 0x6F1FFE80
-- taskID1 0xEC4C5000
-- taskID2 0x1501C060

local Daila02Quest = false
local Daila02ReturnQuest = false

function gd.GDX1MPQuestControl.bestowFamilyMattersQuestGlobalMP()

	if not Daila02Quest then
		Daila02Quest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xB48F5E00
		local taskId01 = 0x1501C060
		local questId02 = 0x6F1FFE80
		local taskId02 = 0x1501C060

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins first task, checks if player has completed Sister's Love and is not already on the quest
		if (questTaskState01 == QuestState.Complete && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress) then
			player:GrantQuest(0x6F1FFE80, 0xEC4C5000)
		end

	end

end

function gd.GDX1MPQuestControl.bestowFamilyMattersReturnQuestGlobalMP()

	if not Daila02ReturnQuest then
		Daila02ReturnQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xB48F5E00
		local taskId01 = 0x1501C060
		local questId02 = 0x6F1FFE80
		local taskId02 = 0xEC4C5000

		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Begins second task, checks if player has completed Sister's Love, is not already on the quest and has killed the boss
		if ((player:HasToken("AREAF_DRAVISMINION_KILLED") && (questTaskState01 == QuestState.Complete) && questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress)) then
			player:GrantQuest(0x6F1FFE80, 0x1501C060)
		end

	end

end

-- Non linear side quests

-- Burn The Womb
-- questId 0x4975E180
-- taskID1 0x1501C060

local burnTheWombQuest = false

function gd.GDX1MPQuestControl.bestowBurnTheWombQuestGlobalMP()

	if not burnTheWombQuest then
		burnTheWombQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x4975E180
		local taskId01 = 0x1501C060
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if ((questTaskState01 != QuestState.Complete) && (questTaskState01 != QuestState.InProgress)) then
			player:GrantQuest(0x4975E180, 0x1501C060)
		end


	end

end

-- Savior
-- questId 0x7FB3C780
-- taskID1 0x3CC5C340 - speak to nicoh in town
-- taskID2 0x2F5C50C0 - kill nicoh
-- taskID3 0x54CAA000 - speak to child in slums

-- Friendly
local saviorFriendlyQuest = false

function gd.GDX1MPQuestControl.bestowSaviorQuestFriendlyGlobalMP()

	if not saviorFriendlyQuest then
		saviorFriendlyQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x7FB3C780
		local taskId01 = 0x3CC5C340
		local taskId02 = 0x2F5C50C0
		local taskId03 = 0x54CAA000
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId01, taskId03)
		
		if ((questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress)  && (questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress)) then
			player:GrantQuest(0x7FB3C780, 0x3CC5C340)
		end


	end

end

-- Hostile
local saviorHostileQuest = false

function gd.GDX1MPQuestControl.bestowSaviorQuestHostileGlobalMP()

	if not saviorHostileQuest then
		saviorHostileQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x7FB3C780
		local taskId01 = 0x3CC5C340
		local taskId02 = 0x2F5C50C0
		local taskId03 = 0x54CAA000
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId01, taskId03)
		
		if ((questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress)  && (questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress)) then
			player:GrantQuest(0x7FB3C780, 0x2F5C50C0)
		end

	end

end

-- Survivors
local SurvivorsSideQuest = false

function gd.GDX1MPQuestControl.bestowSurvivorsSideQuestGlobalMP()

	if not SurvivorsSideQuest then
		SurvivorsSideQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x84157000
		local taskId01 = 0x3CC5C340
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if ((questTaskState01 != QuestState.Complete) && (questTaskState01 != QuestState.InProgress)) then
			player:GrantQuest(0x84157000, 0x3CC5C340)
		end


	end

end

-- Stash
local StashSideQuest = false

function gd.GDX1MPQuestControl.bestowStashSideQuestGlobalMP()

	if not StashSideQuest then
		StashSideQuest = true
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x8018AA00
		local taskId01 = 0x3CC5C340
		
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if ((questTaskState01 != QuestState.Complete) && (questTaskState01 != QuestState.InProgress) && player:HasToken("AREAF_SQSURVIVORS_SAVED")) then
			player:GrantQuest(0x8018AA00, 0x3CC5C340)
		end

	end

end

