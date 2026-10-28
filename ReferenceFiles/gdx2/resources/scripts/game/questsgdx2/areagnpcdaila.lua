/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGNPCDaila = {}

local DailaState = { Default = 0, KorvanValley = 1, QuestComplete=2}

local DailaInKorvanId = 0

--
-- Daila In GDX2 Korvan Valley
--
local DailaKorvanValleyStateObjects = orderedTable();
	DailaKorvanValleyStateObjects["AREAG_DAILAQUESTCOMPLETE"] = { state = DailaState.QuestComplete, dbr = nil }
	DailaKorvanValleyStateObjects["AREAG_DAILATRANSITION"] = { state = DailaState.KorvanValley, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_daila_02.dbr" }
	DailaKorvanValleyStateObjects[""] = { state = DailaState.Default, dbr = nil}
	
function gd.quests.areaGNPCDaila.inKorvanValleyOnAddToWorld(objectId)

	if Server then
		DailaInKorvanId = objectId;
		
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0x6F1FFE80
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if questTaskState01 != QuestState.Complete then
		
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, DailaKorvanValleyStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCDaila.inKorvanValleyOnDestroy = ClearObjectUserdata

-- Daila Transition
local dailaTransition = false

function gd.quests.areaGNPCDaila.dailaAreaGTransition()

	if Server && not dailaTransition then
		
		local player = Game.GetLocalPlayer()
		local questId01 = 0x6F1FFE80
		local taskId01 = 0x1501C060
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		if player:HasToken("AREAG_DAILATRANSITION") && (questTaskState01 == QuestState.Complete) then
			dailaTransition = true
			
			local dailaKorvan = Entity.Get(DailaInKorvanId)
	
			if (dailaKorvan != nil) then
		
				local coords = dailaKorvan:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(DailaInKorvanId, DailaKorvanValleyStateObjects)
			
			end
			
			-- Transition Daila in AreaF to AreaG
			gd.quests.areaFNPCDaila.dailaAreaGTransition()
		
		end
		
	end
	
end



