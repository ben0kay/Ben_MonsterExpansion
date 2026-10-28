/*
	
	GRIM DAWN
	scripts/quests/_GDX1MPQuestControl.lua
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.GDX2MPQuestControl = {}

--
-- MP Control for bestowing quests to all players.
-- Triggered by Conversations
--


--
--Main Quests
-- 

-- GDX2 Breadcrumb
-- Starts the quest to speak with the emissary - This is activated when the warden quest is finished and the emissary is added to the world.
-- Quest Title: A Stranger Beckons
-- File: MQ_00_GDX2Breadcrumb
local breadcrumbQuest = false
function gd.GDX2MPQuestControl.bestowGDX2BreadcrumbGlobalMP()

	if not breadcrumbQuest then
		breadcrumbQuest = true
		local player = Game.GetLocalPlayer()
		
		-- Two completion states for the warden quest.
		local questId01 = 0xD631D200
		local taskId01 = 0xDC054F00
		local taskId02 = 0x65B6A800
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		-- GDX2 breadcrumb quest
		local questId02 = 0xC36C5F00
		local taskId03 = 0xAC3CCE00
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		-- Bestow GDX2 Breadcrumb quest if the warden has been defeated and if the breadcrumb quest is not in progress or completed and the player hasn't already started the emissary quest
		if ((questTaskState01 == QuestState.Complete || questTaskState02 == QuestState.Complete || questTaskState01 == QuestState.InProgress || questTaskState02 == QuestState.InProgress)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) && player:HasToken("AREAG_COVENBASERIFT_OPENED") == false then
			player:GrantQuest(0xC36C5F00, 0xAC3CCE00)
			
		end
	end

end

-- Bestowed if GDX2 is unlocked
-- Quest Title: The Emissary
-- File: MQ_01_TheEmissary
local theEmissaryQuest = false
function gd.GDX2MPQuestControl.theEmissaryQuestGlobalMP()

	if not theEmissaryQuest then
		theEmissaryQuest = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Emissary
		local questId01 = 0xA3C4A500
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if player:HasToken("UNLOCKGDX2_TRUE") && (questTaskState01 != QuestState.InProgress && questTaskState01 != QuestState.Complete) then
			player:GrantQuest(0xA3C4A500, 0xAC3CCE00)
			
		end
		
	end
	
end

-- Bestowed if The Emissary quest is completed
-- Quest Title: The Eldritch Trials
-- File: MQ_02_TestedAndProven
local testedAndProvenQuest = false
function gd.GDX2MPQuestControl.testedAndProvenQuestGlobalMP()
	
	if not testedAndProvenQuest then
		testedAndProvenQuest = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Emissary
		local questId01 = 0xA3C4A500
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Tested and Proven
		local questId02 = 0xC8E3D500
		local taskId02 = 0xEC4C5000
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0xC8E3D500, 0xEC4C5000)
			
		end
		
	end

end

-- Bestowed if Tested and Proven is completed
-- Quest Title: Loyalty to the Three
-- File: MQ_03_PledgingLoyalty
local pledgingLoyalty = false
function gd.GDX2MPQuestControl.pledgingLoyaltyQuestGlobalMP()

	if not pledgingLoyalty then
		pledgingLoyalty = true
		
		local player = Game.GetLocalPlayer()
		
		-- Tested and Proven final task
		local questId01 = 0xC8E3D500
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Pledging loyalty
		local questId02 = 0xF3E30C00
		local taskId02 = 0x2188F4C0
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0xF3E30C00, 0x2188F4C0)
			
		end
		
	end

end

-- Bestowed if any of the 03 faction quests are completed
-- Quest Title: Tomb of the Eldritch Sun
-- File: MQ_04_TheTombOfKorvaak
local tombOfKorvaak = false
function gd.GDX2MPQuestControl.tombOfKorvaakQuestGlobalMP()

	if not tombOfKorvaak then
		tombOfKorvaak = true
		
		local player = Game.GetLocalPlayer()
		
		-- Bysmiel 03 Final Task
		local questId01 = 0x18C83B40
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Dreeg 03 Final Task
		local questId02 = 0x9BD99400
		local taskId02 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Solael 03 Final Task
		local questId03 = 0x6D568700
		local taskId03 = 0xAC3CCE00
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		-- Tomb of Korvaak
		local questId04 = 0x8E684000
		local taskId04 = 0x4C397380
		local questTaskState04 = player:GetQuestTaskState(questId04, taskId04)
		
		if ((questTaskState01 == QuestState.Complete) || (questTaskState02 == QuestState.Complete) || (questTaskState03 == QuestState.Complete)) && ((questTaskState04 != QuestState.InProgress) && (questTaskState04 != QuestState.Complete)) then
			player:GrantQuest(0x8E684000, 0x4C397380)
			
		end
		
	end
	
end

-- Bestowed if Tomb of Korvaak is completed
-- Quest Title: The Forgotten God
-- File: MQ_05_TheForgottenGod
local theForgottenGod = false
function gd.GDX2MPQuestControl.theForgottenGodQuestGlobalMP()

	if not theForgottenGod then
		theForgottenGod = true
		
		local player = Game.GetLocalPlayer()
		
		-- Tomb of Korvaak Final Task
		local questId01 = 0x8E684000
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- The Forgotten God
		local questId02 = 0x85B30C00
		local taskId02 = 0x36CD9D00
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x85B30C00, 0x36CD9D00)
			
		end
		
	end

end

--
--Bysmiel Quests
--
-- Bestowed only if the player has the bysmiel token
-- Quest Title: In Service of Bysmiel
-- File: MQ_B00_BysmielArc
local bysmielArc = false
function gd.GDX2MPQuestControl.bysmielArcQuestGlobalMP()

	if not bysmielArc then
		bysmielArc = true
		
		local player = Game.GetLocalPlayer()
		
		-- Bysmiel Arc
		local questId01 = 0x6201B380
		local taskId01 = 0x77FD5600
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (player:HasToken("AREAG_CHOSEFACTION_BYSMIEL")) && ((questTaskState01 != QuestState.InProgress) || (questTaskState01 != QuestState.Complete)) then
			player:GrantQuest(0x6201B380, 0x77FD5600)
			
		end
		
	end

end

-- Bestowed only the player is on the bysmiel arc quest.
-- Quest Title: Blood of the Korvan Guardians
-- File: MQ_B01_GatheringEssence
local gatheringEssence = false
function gd.GDX2MPQuestControl.bysmielGatheringEssenceQuestGlobalMP()

	if not gatheringEssence then
		gatheringEssence = true
		
		local player = Game.GetLocalPlayer()
		
		-- Bysmiel Arc
		local questId01 = 0x6201B380
		local taskId01 = 0x77FD5600
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Gathering Essence
		local questId02 = 0x73516780
		local taskId02 = 0xA2F0D500
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.InProgress)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x73516780, 0xA2F0D500)
			
		end
		
	end

end

-- Bestowed only if gathering essence is complete
-- Quest Title: The Power of Galfang
-- Title: MQ_B02_GatheringPower
local gatheringPower = false
function gd.GDX2MPQuestControl.bysmielGatheringPowerQuestGlobalMP()
	if not gatheringPower then
		gatheringPower = true
		
		local player = Game.GetLocalPlayer()
		
		-- Gathering Essence
		local questId01 = 0x73516780
		local taskId01 = 0xA2F0D500
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- The Power of Galfang
		local questId02 = 0x0A798C70
		local taskId02 = 0xAC3CCE00
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x0A798C70, 0xAC3CCE00)
			
		end
		
	end
	
end

-- Bestowed only if the bysmiel arc is complete. Bestowed in the Witch God Forward Base
-- Quest Title: Byscilla's Plan
-- File: MQ_B03_SummoningRitual
local summoningRitual = false
function gd.GDX2MPQuestControl.bysmielsummoningRitualQuestGlobalMP()

	if not summoningRitual then
		summoningRitual = true
		
		local player = Game.GetLocalPlayer()
		
		-- Bysmiel Arc Final
		local questId01 = 0x6201B380
		local taskId01 = 0x72DB6400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Summoning Ritual
		local questId02 = 0x18C83B40
		local taskId02 = 0xBF320900
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x18C83B40, 0xBF320900)
			
		end
		
	end

end

-- Faction Quest - Bestowed only if summoning ritual is complete and the player's faction standing is high enough
-- Quest Title: Kymon's Deserters
-- File: SQ_Bysmiel_01
local kymonDeserters = false
function gd.GDX2MPQuestControl.kymonDesertersQuestGlobalMP()

	if not kymonDeserters then
		kymonDeserters = true
		
		local player = Game.GetLocalPlayer()
		
		-- Summoning Ritual Final
		local questId01 = 0x18C83B40
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Kymon's Deserters
		local questId02 = 0x02852988
		local taskId02 = 0xA2F0D500
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((player:GetFaction("USER13") >= 10000) && (questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x02852988, 0xA2F0D500)
			
		end
		
	end

end



--
--Dreeg Quests
--
-- Bestowed only if the player has the dreeg token.
-- Quest Title: In Service of Dreeg
-- File: MQ_D00_DreegArc
local dreegArc = false
function gd.GDX2MPQuestControl.DreegArcQuestGlobalMP()
	if not dreegArc then
		dreegArc = true
		
		local player = Game.GetLocalPlayer()
		
		-- Dreeg Arc
		local questId01 = 0x99652E00
		local taskId01 = 0x9145A400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (player:HasToken("AREAG_CHOSEFACTION_DREEG")) && ((questTaskState01 != QuestState.InProgress) || (questTaskState01 != QuestState.Complete)) then
			player:GrantQuest(0x99652E00, 0x9145A400)
			
		end
		
	end
	
end

-- Bestowed only if the player is on the Dreeg Arc quest and player is not already on or has not done task 2
-- Quest Title: Eldritch Corruption
-- File: MQ_D01_CleanseTheCorrupted
local cleanseCorrupted = false
function gd.GDX2MPQuestControl.dreegCleanseCorruptedQuestGlobalMP()
	
	if not cleanseCorrupted then
		cleanseCorrupted = true
		
		local player = Game.GetLocalPlayer()
		
		-- Dreeg Arc
		local questId01 = 0x99652E00
		local taskId01 = 0x9145A400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Cleanse Corrupted
		local questId02 = 0x9641A900
		local taskId02 = 0xBF320900
		local taskId03 = 0xAC3CCE00
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
	
		
		if ((questTaskState01 == QuestState.InProgress)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x9641A900, 0xBF320900)
			
		end
		
	end
	
end

-- Bestow only if the player is on the Dreeg Arc quest and has the tokens for killing the targets and player is not already on or has not done task 1
-- Eldritch Corruption retro credit
local cleanseCorruptedReturn = false
function gd.GDX2MPQuestControl.dreegCleanseCorruptedReturnQuestGlobalMP()

	if not cleanseCorruptedReturn then
		cleanseCorruptedReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Dreeg Arc
		local questId01 = 0x99652E00
		local taskId01 = 0x9145A400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
				
		-- Cleanse Corrupted Final
		local questId02 = 0x9641A900
		local taskId02 = 0xAC3CCE00
		local taskId03 = 0xBF320900
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.InProgress) && (player:HasToken("AREAG_DREEGCORRUPTEDALL01_KILLED")) && (player:HasToken("AREAG_DREEGCORRUPTEDALL02_KILLED")) && (player:HasToken("AREAG_DREEGCORRUPTEDALL03_KILLED"))) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x9641A900, 0xAC3CCE00)
			
		end
		
	end

end

-- Bestow only if cleanse corrupted is complete and player is not already on or has not done task 2
-- Quest Title: Slay the Usurper
-- File: MQ_D01 _CleanseTheUsurper
local cleanseUsurper = false
function gd.GDX2MPQuestControl.dreegSlayUsurperQuestGlobalMP()
	
	if not cleanseUsurper then
		cleanseUsurper = true
		
		local player = Game.GetLocalPlayer()
		
		-- Cleanse Corrupted Final
		local questId01 = 0x9641A900
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Cleanse Usurper
		local questId02 = 0x8632B200
		local taskId02 = 0xEC4C5000
		local taskId03 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x8632B200, 0xEC4C5000)
			
		end
		
	end

end

-- Bestow only if cleanse corrupted is complete and the player has the kill token for the usurper and is not already on or has not done task 1
-- Slay the Usurper retro credit
local cleanseUsurperReturn = false
function gd.GDX2MPQuestControl.dreegSlayUsurperReturnQuestGlobalMP()
	
	if not cleanseUsurperReturn then
		cleanseUsurperReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Cleanse Corrupted Final
		local questId01 = 0x9641A900
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
				
		-- Cleanse Usurper Final
		local questId02 = 0x8632B200
		local taskId02 = 0x1501C060
		local taskId03 = 0xEC4C5000
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.InProgress) && (player:HasToken("AREAG_DREEGUSURPER_KILLED"))) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x8632B200, 0x1501C060)
			
		end
		
	end
end

-- Bestow only if the Dreeg Arc is complete and player is not already on or has not done task 2, Given out in the Witchgod Forward Base.
-- Quest Title: A Future Foretold
-- File: MQ_D03_ForetoldFuture
local foretoldFuture = false
function gd.GDX2MPQuestControl.dreegForetoldFutureQuestGlobalMP()

	if not foretoldFuture then
		foretoldFuture = true
		
		local player = Game.GetLocalPlayer()
		
		-- Dreeg Arc Final
		local questId01 = 0x99652E00
		local taskId01 = 0x72DB6400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Foretold Future
		local questId02 = 0x9BD99400
		local taskId02 = 0xEC4C5000
		local taskId03 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x9BD99400, 0xEC4C5000)
			
		end
		
	end

end

-- Bestow only if Dreeg Arc is complete and the player has the token for killing the DC boss and is not already on or has not done task 1.
-- A Future Foretold retro credit
local foretoldFutureReturn = false
function gd.GDX2MPQuestControl.dreegForetoldFutureReturnQuestGlobalMP()

	if not foretoldFutureReturn then
		foretoldFutureReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Dreeg Arc Final
		local questId01 = 0x99652E00
		local taskId01 = 0x72DB6400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Foretold Future Final
		local questId02 = 0x9BD99400
		local taskId02 = 0x1501C060
		local taskId03 = 0xEC4C5000
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.Complete) && (player:HasToken("AREAG_DREEGDCBOSS_KILLED"))) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x9BD99400, 0x1501C060)
			
		end
		
	end

end

-- Bestow only if Foretold Future is complete and the player has high enough faction standing and is not already on or has not done task 2
-- Quest Title: The Future is Madness.
-- File: SQ_Dreeg_01
local futureIsMadness = false
function gd.GDX2MPQuestControl.futureIsMadnessQuestGlobalMP()

	if not futureIsMadness then
		futureIsMadness = true
		
		local player = Game.GetLocalPlayer()
		
		-- Fortold Future Final
		local questId01 = 0x9BD99400
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Future Is Madness
		local questId02 = 0xF3264C00
		local taskId02 = 0x9F44BC00
		local taskId03 = 0xA2F0D500
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((player:GetFaction("USER14") >= 10000) && (questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0xF3264C00, 0x9F44BC00)
			
		end
		
	end

end

local futureIsMadnessReturn = false
-- bestow only if Fortold Future is complete, the player has high enough faction standing and the kill token and is not already on or has not done task 1.
-- The Future is Madness retro credit.
function gd.GDX2MPQuestControl.futureIsMadnessReturnQuestGlobalMP()

	if not futureIsMadnessReturn then
		futureIsMadnessReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Fortold Future Final
		local questId01 = 0x9BD99400
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Future Is Madness
		local questId02 = 0xF3264C00
		local taskId02 = 0xA2F0D500
		local taskId03 = 0x9F44BC00
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((player:GetFaction("USER14") >= 10000) && (questTaskState01 == QuestState.Complete) && (player:HasToken("AREAG_MADWITCH_KILLED"))) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0xF3264C00, 0xA2F0D500)
			
		end
		
	end

end

--
--Solael
--

--Bestow only if the player has the solael token.
-- Quest Title: In Service of Solael
-- File: MQ_S00_SolaelArc
local solaelArc = false
function gd.GDX2MPQuestControl.SolaelArcQuestGlobalMP()

	if not solaelArc then
		solaelArc = true
		
		local player = Game.GetLocalPlayer()
		
		-- Solael Arc
		local questId01 = 0x36D56200
		local taskId01 = 0xE25E1F00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (player:HasToken("AREAG_CHOSEFACTION_SOLAEL")) && ((questTaskState01 != QuestState.InProgress) || (questTaskState01 != QuestState.Complete)) then
			player:GrantQuest(0x36D56200, 0xE25E1F00)
			
		end
		
	end

end

-- Bestow only if the player is on the solael arc quest.
-- Quest Title: The Eye of Ekur
-- File: MQ_S01_ASourceOfPower
local solaelSourceOfPower = false
function gd.GDX2MPQuestControl.solaelSourceOfPowerQuestGlobalMP()

	if not solaelSourceOfPower then
		solaelSourceOfPower = true
		
		local player = Game.GetLocalPlayer()
		
		-- Solael Arc
		local questId01 = 0x36D56200
		local taskId01 = 0xE25E1F00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Source of Power
		local questId02 = 0x547B6100
		local taskId02 = 0xA2F0D500
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.InProgress)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x547B6100, 0xA2F0D500)
			
		end
		
	end

end

-- Bestow only if the player has completed Source of Power.
-- Quest Title: No Room For Weakness
-- File: MQ_S02_NoRoomForWeakness 
local noRoomForWeakness = false
function gd.GDX2MPQuestControl.solaelNoRoomForWeaknessQuestGlobalMP()

	if not noRoomForWeakness then
		noRoomForWeakness = true
		
		local player = Game.GetLocalPlayer()
		
		-- Source of Power
		local questId01 = 0x547B6100
		local taskId01 = 0xA2F0D500
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- No Room For Weakness
		local questId02 = 0x5F806100
		local taskId02 = 0xEC4C5000
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x5F806100, 0xEC4C5000)
			
		end
		
	end

end

-- Bestow only if the Solael Arc is complete and player is not already on or has done task 2.
-- Quest Title: The Heart of Onarix
-- File: MQ_S03_HeartAsTribute
local heartAsTribute = false
function gd.GDX2MPQuestControl.solaelHeartAsTributeQuestGlobalMP()

	if not heartAsTribute then
		heartAsTribute = true
		
		local player = Game.GetLocalPlayer()
		
		-- Solael Arc Final
		local questId01 = 0x36D56200
		local taskId01 = 0x72DB6400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Heart As Tribute
		local questId02 = 0x6D568700
		local taskId02 = 0x417D6A80
		local taskId03 = 0xAC3CCE00
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x6D568700, 0x417D6A80)
			
		end
		
	end

end

-- Bestow only if the player has completed the solael arc and has the required item and is not already on or has done task 1.
-- player:HasItem("records/items/questitems/quest_areag_solaeltribute.dbr", 1, false)
-- The Heart of Onarix retro credit
local heartAsTributeReturn = false
function gd.GDX2MPQuestControl.solaelHeartAsTributeReturnQuestGlobalMP()
	
	if not heartAsTributeReturn then
		heartAsTributeReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Solael Arc Final
		local questId01 = 0x36D56200
		local taskId01 = 0x72DB6400
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Heart As Tribute Final
		local questId02 = 0x6D568700
		local taskId02 = 0xAC3CCE00
		local taskId03 = 0x417D6A80
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		local questTaskState03 = player:GetQuestTaskState(questId02, taskId03)
		
		if ((questTaskState01 == QuestState.Complete) && (player:HasItem("records/items/questitems/quest_areag_solaeltribute.dbr", 1, false))) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) && ((questTaskState03 != QuestState.InProgress) && (questTaskState03 != QuestState.Complete)) then
			player:GrantQuest(0x6D568700, 0xAC3CCE00)
			
		end
		
	end
end

-- Bestow only if Heart as Tribute is finished and the player has high enough faction standing
-- Quest Title: The Word of Rahn
-- File: SQ_Solael_01
local wordOfRahn = false
function gd.GDX2MPQuestControl.solaelWordOfRahnQuestGlobalMP()

	if not wordOfRahn then
		wordOfRahn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Heart As Tribute Final
		local questId01 = 0x6D568700
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Word of Rahn
		local questId02 = 0x4C906080
		local taskId02 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((player:GetFaction("USER15") >= 10000) && (questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x4C906080, 0x1501C060)
			
		end
		
	end
	
end


--
--Sidequests
--

-- Bestow only if the player has unlocked the witch god base
-- Quest Title: Tomb Brothers
-- File: SQ_02_ThreeBrothers
local threeBrothers = false
function gd.GDX2MPQuestControl.threeBrothersQuestGlobalMP()

	if not threeBrothers then
		threeBrothers = true
		
		local player = Game.GetLocalPlayer()
		
		-- Three Brothers
		local questId01 = 0x655E3E00
		local taskId01 = 0xCCE8DC00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if (player:HasToken("AREAG_COVENBASE_UNLOCKED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) then
			player:GrantQuest(0x655E3E00, 0xCCE8DC00)
			
		end
		
	end

end


-- Bestow only if the player has the witch god forward camp unlocked and player is not already on or has not done task 2.
-- Quest Title: The Messenger
-- File: SQ_04_KorvaaksMessenger
local theMessenger = false
function gd.GDX2MPQuestControl.theMessengerQuestGlobalMP()
	
	if not theMessenger then
		theMessenger = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Messenger
		local questId01 = 0x6A38FF00
		local taskId01 = 0x8C82F700
		local taskId02 = 0xA2F0D500
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		if (player:HasToken("AREAG_FORWARDCAMP_UNLOCKED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x6A38FF00, 0x8C82F700)
			
		end
		
	end

end

-- Bestow if the player has unlcoked the witch god forward camp and has the kill token for the messenger and is not already on or has not done task 1.
-- The Messenger retro credit
local theMessengerReturn = false
function gd.GDX2MPQuestControl.theMessengerReturnQuestGlobalMP()

	if not theMessengerReturn then
		theMessengerReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Messenger
		local questId01 = 0x6A38FF00
		local taskId01 = 0xA2F0D500
		local taskId02 = 0x8C82F700
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		if (player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && player:HasToken("AREAG_KORVAAKMESSENGER_KILLED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x6A38FF00, 0xA2F0D500)
			
		end
		
	end

end

-- Bestow only if the player has the witch god forward camp unlocked and player is not already on or has not done task 2.
-- Quest Title: Preemptive Strike
-- File: SQ_05_PreemptiveStrike
local preemptiveStrike = false
function gd.GDX2MPQuestControl.preemptiveStrikeQuestGlobalMP()

	if not preemptiveStrike then
		preemptiveStrike = true
		
		local player = Game.GetLocalPlayer()
		
		-- PReemptive Strike
		local questId01 = 0xE35DFB00
		local taskId01 = 0xEC4C5000
		local taskId02 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		if (player:HasToken("AREAG_FORWARDCAMP_UNLOCKED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0xE35DFB00, 0xEC4C5000)
			
		end
		
	end


end

-- Bestow if the polayer has unlocked the witch god forward base and has the kill token for the Dustreaper and is not already on or has not done task 1.
-- Preemptive Strike retro credit.
local preemptiveStrikeReturn = false
function gd.GDX2MPQuestControl.preemptiveStrikeReturnQuestGlobalMP()

	if not preemptiveStrikeReturn then
		preemptiveStrikeReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Preemptive Strike
		local questId01 = 0xE35DFB00
		local taskId01 = 0xEC4C5000
		local taskId02 = 0x1501C060
		
local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		if (player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && player:HasToken("AREAG_PREEMPTIVESTRIKEBOSS_KILLED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0xE35DFB00, 0x1501C060)
			
		end
		
	end

end

-- Bestow only if the player has unlocked the witch god base.
-- Quest Title: Good Aspirants are Hard to Find
-- File: SQ_06_SupllyRun
local supplyRun = false
function gd.GDX2MPQuestControl.supplyRunQuestGlobalMP()

	if not supplyRun then
		supplyRun = true
		
		local player = Game.GetLocalPlayer()
		
		-- Supply Run
		local questId01 = 0x49FDBE00
		local taskId01 = 0xEC4C5000
		local taskId02 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		if (player:HasToken("AREAG_COVENBASE_UNLOCKED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x49FDBE00, 0xEC4C5000)
			
		end
		
	end

end

-- Bestow if the witch god base is unlocked and the player has the token for rescuing the witches
-- Good Aspirants are Hard to Find retro credit.
local supplyRunReturn = false
function gd.GDX2MPQuestControl.supplyRunReturnQuestGlobalMP()

	if not supplyRunReturn then
		supplyRunReturn = true
		
		local player = Game.GetLocalPlayer()
		
		-- Supply Run Final
		local questId01 = 0x49FDBE00
		local taskId01 = 0x1501C060
		local taskId02 = 0xEC4C5000
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId01, taskId02)
		
		if (player:HasToken("AREAG_COVENBASE_UNLOCKED") && player:HasToken("AREAG_WITCHES_RESCUED")) && ((questTaskState01 != QuestState.InProgress) && (questTaskState01 != QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x49FDBE00, 0x1501C060)
			
		end
		
	end

end

-- Bestow if supply run is complete.
-- Quest Title: Worthy of Solael
-- File: SQ_09_TheTest
local theTest = false
function gd.GDX2MPQuestControl.theTestQuestGlobalMP()

	if not theTest then
		theTest = true
		
		local player = Game.GetLocalPlayer()
		
		-- Supply Run Final
		local questId01 = 0x49FDBE00
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- The Test
		local questId02 = 0x434ED700
		local taskId02 = 0x096E8B70
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete)) && ((questTaskState02 != QuestState.InProgress) && (questTaskState02 != QuestState.Complete)) then
			player:GrantQuest(0x434ED700, 0x096E8B70)
			
		end
		
	end

end

-- Bestow only if one of the 01 faction quests has been completed
-- Quest Title: The Tome of Eanatum
-- File: SQ_10_LostTome
local lostTome = false
function gd.GDX2MPQuestControl.lostTomeQuestGlobalMP()

	if not lostTome then
		lostTome = true
		
		local player = Game.GetLocalPlayer()
		
		-- Bysmiel 01 - Gathering Essence Final
		local questId01 = 0x73516780
		local taskId01 = 0xA2F0D500
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Dreeg 01 - Cleanse The Corrupted Final
		local questId02 = 0x9641A900
		local taskId02 = 0xAC3CCE00
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Solael 01 - Source Of Power
		local questId03 = 0x547B6100
		local taskId03 = 0xA2F0D500
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		
		-- Lost Tome
		local questId04 = 0x9E1C9400
		local taskId04 = 0xA2F0D500
		local questTaskState04 = player:GetQuestTaskState(questId04, taskId04)
		
		if ((questTaskState01 == QuestState.Complete) || (questTaskState02 == QuestState.Complete) || (questTaskState03 == QuestState.Complete)) && ((questTaskState04 != QuestState.InProgress) && (questTaskState04 != QuestState.Complete)) then
			player:GrantQuest(0x9E1C9400, 0xA2F0D500)
			
		end
		
	end
	
end


-- Riggs Quest
-- questID 0x7DAFEB80
-- task01ID 0xBF320900
-- task02ID 0x3C46D580
-- task03ID turn in 0xAC3CCE00
local riggsQuest = false
local riggsReturnQuest = false
local riggsReturnSealQuest = false

function gd.GDX2MPQuestControl.riggsQuestQuestGlobalMP()

	if not riggsQuest then
		riggsQuest = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Forgotten God
		local questId01 = 0x85B30C00
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Riggs Debt
		local questId02 = 0x7B9B5700
		local taskId02 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Riggs Quest
		local questId03 = 0x7DAFEB80
		local taskId03 = 0xBF320900
		local taskId04 = 0x3C46D580
		local taskId05 = 0xAC3CCE00
		
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		local questTaskState04 = player:GetQuestTaskState(questId03, taskId04)
		local questTaskState05 = player:GetQuestTaskState(questId03, taskId05)
		
		if (questTaskState01 == QuestState.Complete && questTaskState02 == QuestState.Complete) && (questTaskState03 != QuestState.InProgress && questTaskState03 != QuestState.Complete) && (questTaskState04 != QuestState.InProgress && questTaskState04 != QuestState.Complete) && (questTaskState05 != QuestState.InProgress && questTaskState05 != QuestState.Complete) then
			player:GrantQuest(0x7DAFEB80, 0xBF320900)
			
		end
		
	end

end

function gd.GDX2MPQuestControl.riggsReturnQuestQuestGlobalMP()

	if not riggsReturnQuest then
		riggsReturnQuest = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Forgotten God
		local questId01 = 0x85B30C00
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Riggs Debt
		local questId02 = 0x7B9B5700
		local taskId02 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Riggs Quest
		local questId03 = 0x7DAFEB80
		local taskId03 = 0xBF320900
		local taskId04 = 0x3C46D580
		local taskId05 = 0xAC3CCE00
		
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		local questTaskState04 = player:GetQuestTaskState(questId03, taskId04)
		local questTaskState05 = player:GetQuestTaskState(questId03, taskId05)
		
		if (questTaskState01 == QuestState.Complete && questTaskState02 == QuestState.Complete) && player:HasItem("records/items/questitems/quest_areag_riggsquest_04.dbr", 1, false) && (questTaskState03 != QuestState.InProgress && questTaskState03 != QuestState.Complete) && (questTaskState04 != QuestState.InProgress && questTaskState04 != QuestState.Complete) && (questTaskState05 != QuestState.InProgress && questTaskState05 != QuestState.Complete) then
			player:GrantQuest(0x7DAFEB80, 0xAC3CCE00)
			GiveTokenToLocalPlayer("AREAG_LOSTOASIS_OPEN")
			player:TakeItem("records/items/questitems/quest_areag_riggsquest_01.dbr", 1, false)
			player:TakeItem("records/items/questitems/quest_areag_riggsquest_02.dbr", 1, false)
			player:TakeItem("records/items/questitems/quest_areag_riggsquest_03.dbr", 1, false)
			
			player:GiveItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false)
			
		end
		
	end

end

function gd.GDX2MPQuestControl.riggsReturnSealQuestQuestGlobalMP()

	if not riggsReturnSealQuest then
		riggsReturnSealQuest = true
		
		local player = Game.GetLocalPlayer()
		
		-- The Forgotten God
		local questId01 = 0x85B30C00
		local taskId01 = 0xAC3CCE00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		-- Riggs Debt
		local questId02 = 0x7B9B5700
		local taskId02 = 0x1501C060
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		-- Riggs Quest
		local questId03 = 0x7DAFEB80
		local taskId03 = 0xBF320900
		local taskId04 = 0x3C46D580
		local taskId05 = 0xAC3CCE00
		
		local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
		local questTaskState04 = player:GetQuestTaskState(questId03, taskId04)
		local questTaskState05 = player:GetQuestTaskState(questId03, taskId05)
		
		if (player:HasToken("AREAG_LOSTOASIS_OPEN")) && (questTaskState01 == QuestState.Complete && questTaskState02 == QuestState.Complete) && (questTaskState03 != QuestState.InProgress && questTaskState03 != QuestState.Complete) && (questTaskState04 != QuestState.InProgress && questTaskState04 != QuestState.Complete) && (questTaskState05 != QuestState.InProgress && questTaskState05 != QuestState.Complete) then
			player:GrantQuest(0x7DAFEB80, 0x3C46D580)
			
			player:GiveItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false)
			
		end
		
	end

end



