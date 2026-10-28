/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

--
-- John Bourbon movement for GDX1
--


gd.quests.areaENPCBourbon = {}

local bourbonFortIkonId = 0
local bourbonGDX1Id = 0

local BourbonLocation = { Intro = 0, FortIkon = 1, GDX1 = 2 }

-- John Bourbon GDX1 Position
local bourbonGDX1StateObjects = orderedTable()
	bourbonGDX1StateObjects["AREAE_NPCS"]	= { state = BourbonLocation.GDX1,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_johnbourbon_02.dbr" }
	bourbonGDX1StateObjects["AREAE_INTRO"]	= { state = BourbonLocation.FortIkon,   dbr = nil }
	bourbonGDX1StateObjects[""]					= { state = BourbonLocation.Intro,   dbr = nil }
	
function gd.quests.areaENPCBourbon.gdx1OnAddToWorld(objectId)
	
	if Server then
		QuestGlobalEvent("GDX1BreadcrumbBeginQuest")
	
		bourbonGDX1Id = objectId

		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, bourbonGDX1StateObjects)
		Shared.setUserdata(objectId, userdata)
		
		-- Fix for Lost Journal Quest if player is still somehow on it
		local player = Game.GetLocalPlayer()
		local kQuest_Journal = 0x63541000
		local kTask_Journal = 0x89B35400
		local questTaskState = player:GetQuestTaskState(kQuest_Journal, kTask_Journal)
		
		if (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_INTRO") || player:HasToken("AREAE_NPCS")) then
			player:CompleteQuest(0x63541000, 0x89B35400)
			
		end
		
	end
	
end

gd.quests.areaENPCBourbon.gdx1OnDestroy = ClearObjectUserdata

-- John Bourbon Fort Ikon Position
local bourbonFortIkonStateObjects = orderedTable()
	bourbonFortIkonStateObjects["AREAE_NPCS"]	= { state = BourbonLocation.GDX1,  dbr = nil }
	bourbonFortIkonStateObjects["AREAE_INTRO"]	= { state = BourbonLocation.FortIkon,   dbr = "records/creatures/npcs/questnpcs/gdareae/npc_johnbourbon_01.dbr" }
	bourbonFortIkonStateObjects[""]					= { state = BourbonLocation.Intro,   dbr = nil }
	
function gd.quests.areaENPCBourbon.fortIkonOnAddToWorld(objectId)
	
	if Server then
		QuestGlobalEvent("GDX1BreadcrumbBeginQuest")
	
		bourbonFortIkonId = objectId

		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, bourbonFortIkonStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaENPCBourbon.fortIkonOnDestroy = ClearObjectUserdata



-- Called by quest, teleports John Bourbon to his Fort Ikon Intro Position
local bourbonMoveFortIkon = false

function gd.quests.areaENPCBourbon.moveToFortIkon()

	if Server then
		if not bourbonMoveFortIkon then
			local player = Game.GetLocalPlayer()
			
			if player:HasToken("AREAE_INTRO") then
				bourbonMoveFortIkon = true
				UpdateObjectSwap(bourbonFortIkonId, bourbonFortIkonStateObjects)

				
			end

		end
		
	end

end


-- GDX1 Intro NPC Transition
-- Transitions Captain Bourbon and Amelia to Fort Ikon if the Host is eligible
local introTransition = false

function gd.quests.areaENPCBourbon.introNPCTransitionGlobalMP()
		local player = Game.GetLocalPlayer()

		-- Murderers and Worse
		local questId01 = 0x0DB402C0
		local taskId01 = 0xA5229F00

		-- Bane of Cairn
		local questId02 = 0x8BCA0200
		local taskId02 = 0xAC3CCE00
			
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)

		-- Check to make sure the player has completed act 1, completed Bane of Cairn and their NPCs are not already in the GDX state
		if (questTaskState02 == QuestState.Complete && (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) && player:HasToken("AREAE_NPCS") == false) then
			GiveTokenToLocalPlayer("AREAE_INTRO")
			
		end

end

function gd.quests.areaENPCBourbon.GDX1IntroNPCTransition()
	
	if Server && not introTransition then
		local player = Game.GetLocalPlayer()

		-- Murderers and Worse
		local questId01 = 0x0DB402C0
		local taskId01 = 0xA5229F00

		-- Bane of Cairn
		local questId02 = 0x8BCA0200
		local taskId02 = 0xAC3CCE00
			
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)

		-- Check to make sure the player has completed act 1, completed Bane of Cairn and their NPCs are not already in the GDX state
		if (questTaskState02 == QuestState.Complete && (questTaskState01 == QuestState.Complete || questTaskState01 == QuestState.InProgress) && player:HasToken("AREAE_INTRO") == false && player:HasToken("AREAE_NPCS") == false) then
			GiveTokenToLocalPlayer("AREAE_INTRO")
			
			introTransition = true
			
			gd.quests.areaENPCAmelia.introTransition()
			gd.quests.areaENPCBourbon.moveToFortIkon()
			
			-- Despawn Bourbon in the Office, if spawned
			gd.quests.devilsCrossing.johnBourbon.despawnOffice()
			
			-- Transition DC to the attacked state
			gd.quests.devilsCrossingAttack.attackTransition()
			
			-- Spawn Creed Lore Note in Fort Ikon
			gd.quests.areaFNPCCreed.spawnFortIkonNote()
			
		end
		
		QuestGlobalEvent("gdx1NPCIntroToken")


	end

end

-- Teleports Creed/Bourbon/Amelia to AreaE if Host is on that quest
local NPCAreaETransition = false

function gd.quests.areaENPCBourbon.areaETransitionTriggerVolume(triggererId)

	QuestEvent("areaENPCTransition")

end

function gd.quests.areaENPCBourbon.areaETransition()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAE_NPCS") && NPCAreaETransition == false && player:HasToken("AREAE_BURRWITCHBLOCKADE_CLEARED") == false then
			NPCAreaETransition = true
			
			local bourbonFortIkon = Entity.Get(bourbonFortIkonId)
			local bourbonFinal = Entity.Get(bourbonGDX1Id)
		
			if (bourbonFortIkon != nil) then
		
				local coords = bourbonFortIkon:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(bourbonFortIkonId, bourbonFortIkonStateObjects)
			
			end
			
			if (bourbonFinal != nil) then
		
				local coords = bourbonFinal:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(bourbonGDX1Id, bourbonGDX1StateObjects)
			
			end
			
			-- Teleport Creed and Amelia back to DC
			gd.quests.areaCNPCInquisitorCreed.areaETransition()
			gd.quests.areaENPCAmelia.transition()
			
			-- Transition DC to the attacked state if it has not triggered already
			gd.quests.devilsCrossingAttack.attackTransition()
			
			-- Transition Black Legion reinforcements
			gd.quests.devilsCrossingAttack.blackLegionTransition()
			
			-- Spawn Kasparov's Crystal, if applicable
			gd.quests.areaFQuestHargateFormula.kasparovCrystalSpawn()
			
		end
		
	end
	
end

