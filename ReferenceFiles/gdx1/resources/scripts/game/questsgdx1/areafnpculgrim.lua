/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCUlgrim = {}

--
-- Ulgrim movement in GDX1
-- Moves to the void exit
-- Moves to the malmouth gates
-- Moves to the rebel hideout
-- Moves to the malmouth inner city
-- Can be seen fighting along side the rebels as the player enters the factory

local UlgrimVoidExitId = 0
local UlgrimBridgeId = 0
local UlgrimHideoutId = 0
local UlgrimInnerCityId = 0
local UlgrimFightingId = 0
local UlgrimFightingAvatarId
local UlgrimRebelBaseId = 0
local UlgrimRebelBase01Id = 0


-- Hotfix V1.0.3.0 and up
local hotfixTriggered = false

function gd.quests.areaFNPCUlgrim.HotfixGlobalMP()

	if not hotfixTriggered then
		hotfixTriggered = true

		local player = Game.GetLocalPlayer()

		-- v1.0.3.0 Rictor's Thanks
		local kQuestRT = 0x8018AA00
		local kTaskRT = 0x3CC5C340

		local questTaskStateRT = player:GetQuestTaskState(kQuestRT, kTaskRT)
		
		if questTaskStateRT == QuestState.Complete && (player:HasToken("AREAF_MALMOUTHSTASH_OPENED") == false) then
			player:GiveToken("AREAF_MALMOUTHSTASH_OPENED")
			
		end
		
		-- v1.0.3.0 For the People
		local kQuestFP = 0xDD67A400
		local kTaskFP = 0xAC3CCE00
		local kQuestFP2 = 0xF2C96700
		local kTaskFP2 = 0x78D7A780

		local questTaskStateFP = player:GetQuestTaskState(kQuestFP, kTaskFP)
		local questTaskStateFP2 = player:GetQuestTaskState(kQuestFP2, kTaskFP2)
		
		if (questTaskStateFP2 == QuestState.InProgress || questTaskStateFP2 == QuestState.Complete || questTaskStateFP == QuestState.Complete) && (player:HasToken("AREAF_REBELBASE_UNLOCKDOORS") == false) then
			player:GiveToken("AREAF_REBELBASE_UNLOCKDOORS")
			
		end
		
		-- v1.0.3.0 Family Matters
		local kQuestFM = 0x6F1FFE80
		local kTaskFM = 0xEC4C5000
		local kTaskFM2 = 0x1501C060

		local questTaskStateFM = player:GetQuestTaskState(kQuestFM, kTaskFM)
		local questTaskStateFM2 = player:GetQuestTaskState(kQuestFM, kTaskFM2)
		
		if (questTaskStateFM == QuestState.Complete && questTaskStateFM2 != QuestState.InProgress && questTaskStateFM2 != QuestState.Complete) then
			player:GrantQuest(0x6F1FFE80, 0x1501C060)
			
		end
	
	end

end

--
-- Area F - Ulgrim Transitions
--

local UlgrimState = { Default = 0, VoidExit = 1, Bridge = 2, Hideout = 3, Hideout01 = 4, RebBase01 = 5, InnerCity = 6, Fighting = 7,  RebBase02 = 8 }

-- Ulgrim at void exit.
local VoidExitUlgrimStateObjects = orderedTable();
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimState.InnerCity,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE01"] = { state = UlgrimState.RebBase01,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT01"] = { state = UlgrimState.Hideout01,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT"] = { state = UlgrimState.Hideout,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_BRIDGE"] = { state = UlgrimState.Bridge,  dbr = nil }
	VoidExitUlgrimStateObjects["AREAF_NPCULGIRM_VOIDEXIT"] = { state = UlgrimState.VoidExit, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_08.dbr" }
	VoidExitUlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }
	
function gd.quests.areaFNPCUlgrim.voidExitOnAddToWorld(objectId)

	if Server then

		UlgrimVoidExitId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, VoidExitUlgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCUlgrim.ulgrimOnDestroy = ClearObjectUserdata

-- Ulgrim at the bridge.
local MalmouthBridgeUlgrimStateObjects = orderedTable();
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = nil }
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting,  dbr = nil }
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimState.InnerCity,  dbr = nil }
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE01"] = { state = UlgrimState.RebBase01,  dbr = nil }
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT01"] = { state = UlgrimState.Hideout01,  dbr = nil }
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT"] = { state = UlgrimState.Hideout,  dbr = nil }
	MalmouthBridgeUlgrimStateObjects["AREAF_NPCULGIRM_BRIDGE"] = { state = UlgrimState.Bridge,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_09.dbr" }
	MalmouthBridgeUlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }

function gd.quests.areaFNPCUlgrim.malmouthGatesOnAddToWorld(objectId)

	if Server then
	
		UlgrimBridgeId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, MalmouthBridgeUlgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Ulgrim outside the hideout
local RebelHideoutUlgrimStateObjects = orderedTable();
	RebelHideoutUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = nil }
	RebelHideoutUlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting,  dbr = nil }
	RebelHideoutUlgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimState.InnerCity,  dbr = nil }
	RebelHideoutUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE01"] = { state = UlgrimState.RebBase01,  dbr = nil }
	RebelHideoutUlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT01"] = { state = UlgrimState.Hideout01,  dbr = nil }
	RebelHideoutUlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT"] = { state = UlgrimState.Hideout,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_10.dbr" }
	RebelHideoutUlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }

function gd.quests.areaFNPCUlgrim.rebelHideoutOnAddToWorld(objectId)

	if Server then
	
		UlgrimHideoutId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelHideoutUlgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Ulgrim later inside the hideout
local RebelHideout01UlgrimStateObjects = orderedTable();
	RebelHideout01UlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = nil }
	RebelHideout01UlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting, dbr = nil }
	RebelHideout01UlgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimState.InnerCity, dbr = nil }
	RebelHideout01UlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE01"] = { state = UlgrimState.RebBase01,  dbr = nil }
	RebelHideout01UlgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT01"] = { state = UlgrimState.Hideout01, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_10.dbr" }
	RebelHideout01UlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }

function gd.quests.areaFNPCUlgrim.rebelHideout01OnAddToWorld(objectId)

	if Server then
		-- Run hotfix on players stuck on various quests
		QuestGlobalEvent("ulgrimSewersHotfixCheck")
	
		UlgrimHideout01Id = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelHideout01UlgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Ulgrim in the resistance base on the surface
local RebelBase01UlgrimStateObjects = orderedTable();
	RebelBase01UlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_13.dbr" }
	RebelBase01UlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting, dbr = nil }
	RebelBase01UlgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimState.InnerCity, dbr = nil }
	RebelBase01UlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE01"] = { state = UlgrimState.RebBase01,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_11.dbr"}
	RebelBase01UlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }

function gd.quests.areaFNPCUlgrim.rebelBaseOnAddToWorld(objectId)

	if Server then
		-- Run hotfix on players stuck on various quests
		QuestGlobalEvent("ulgrimSewersHotfixCheck")
	
		UlgrimRebelBase01Id = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelBase01UlgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Ulgrim in the Inner City
local InnerCityUlgrimStateObjects = orderedTable();
	InnerCityUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = nil }
	InnerCityUlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting,  dbr = nil }
	InnerCityUlgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimState.InnerCity,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_ulgrim_12.dbr" }
	InnerCityUlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }

function gd.quests.areaFNPCUlgrim.InnerCityOnAddToWorld(objectId)

	if Server then
	
		UlgrimInnerCityId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, InnerCityUlgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

-- Ulgrim fighting outside the factory entrance
local function CharacterCreateArgs()

	return 0, Entity.Get(UlgrimFightingId):GetCoords().origin
	
end

local FightingUlgrimStateObjects = orderedTable();
	FightingUlgrimStateObjects["AREAF_NPCULGIRM_REBELBASE"] = { state = UlgrimState.RebBase02,  dbr = nil }
	FightingUlgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimState.Fighting,  dbr = "records/creatures/enemies/faction/ulgrim_02.dbr" }
	FightingUlgrimStateObjects[""] = { state = UlgrimState.Default, dbr = nil }

function gd.quests.areaFNPCUlgrim.fightingOnAddToWorld(objectId)

	if Server && not ulgrimInBaseFinal then
	
		UlgrimFightingId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, FightingUlgrimStateObjects, Character, CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

function gd.quests.areaFNPCUlgrim.ulgrimFightingAvatarOnAddToWorld(objectId)

	if Server then
		UlgrimFightingAvatarId = objectId
	
	end
	
end


-- Activated by quest completion when the rift is activated
local ulgrimAtVoidExit = false

function gd.quests.areaFNPCUlgrim.voidExitTransition()
	
	if Server && not ulgrimAtVoidExit then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_VOIDEXIT") then
			ulgrimAtVoidExit = true
			
			local ulgrim = Entity.Get(UlgrimVoidExitId)
			
			-- Take ulgrim out of the void
			gd.quests.areaENPCUlgrim.inVoidTransition()
			
			if (ulgrim != nil) then
				local coords = ulgrim:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimVoidExitId, VoidExitUlgrimStateObjects)
			
			end
		
		end

	end

end

--
-- The player claims the malmouth bridge riftgate teleporting ulgrim there
-- 

-- Activated by quest task completion when the waved battle is finished
local ulgrimAtBridge = false

function gd.quests.areaFNPCUlgrim.malmouthBridgeTransition()
	
	if Server && not ulgrimAtBridge then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_BRIDGE") then
			ulgrimAtBridge = true
			
			local ulgrim = Entity.Get(UlgrimBridgeId)

			if (ulgrim != nil) then
			
				local coords = ulgrim:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimBridgeId, MalmouthBridgeUlgrimStateObjects)
			
			end
			
			local ulgrimVoidExit = Entity.Get(UlgrimVoidExitId)
			
			if (ulgrimVoidExit != nil) then
			
				local coords = ulgrimVoidExit:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimVoidExitId, VoidExitUlgrimStateObjects)
			
			end
		
		end

	end

end

--
-- The player speaks with Cpt. Wilfor transitioning ulgrim to the Hideout
-- 

-- Activated by quest task completion after the player speaks with the rebel captain.
local ulgrimInHideout = false

function gd.quests.areaFNPCUlgrim.hideoutTransition()
	
	if Server && not ulgrimInHideout then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_HIDEOUT") then
			ulgrimInHideout = true
			
			local ulgrimHideout = Entity.Get(UlgrimHideoutId)

			if (ulgrimHideout != nil) then
			
				local coords = ulgrimHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimHideoutId, RebelHideoutUlgrimStateObjects)
			
			end
			
			local ulgrimBridge = Entity.Get(UlgrimBridgeId)
					
			if (ulgrimBridge != nil) then
			
				local coords = ulgrimBridge:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimBridgeId, MalmouthBridgeUlgrimStateObjects)
			
			end
		
		end

	end

end

-- The player claims the resistance base on the surface 
local ulgrimInRebelBase01 = false

function gd.quests.areaFNPCUlgrim.rebelBase01Transition()
	
	if Server && not ulgrimInRebelBase01 then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_REBELBASE01") then
			ulgrimInRebelBase01 = true
			
			local ulgrimRebBase01 = Entity.Get(UlgrimRebelBase01Id)

			if (ulgrimRebBase01 != nil) then
			
				local coords = ulgrimRebBase01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimRebelBase01Id, RebelBase01UlgrimStateObjects)
			
			end
			
			local ulgrimHideout01 = Entity.Get(UlgrimHideout01Id)
					
			if (ulgrimHideout01 != nil) then
			
				local coords = ulgrimHideout01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimHideout01Id, RebelHideout01UlgrimStateObjects)
			
			end
		
		end

	end

end


-- Activated by quest when the player claims the inner city rift gate
local ulgrimInInnerCity = false

function gd.quests.areaFNPCUlgrim.innerCityTransition()
	
	if Server && not ulgrimInInnerCity then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_INNERCITY") then
			ulgrimInInnerCity = true
			
			local ulgrimInnerCity = Entity.Get(UlgrimInnerCityId)

			if (ulgrimInnerCity != nil) then
			
				local coords = ulgrimInnerCity:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimInnerCityId, InnerCityUlgrimStateObjects)
			
			end
			
			local ulgrimRebelBase01 = Entity.Get(UlgrimRebelBase01Id)
					
			if (ulgrimRebelBase01 != nil) then
			
				local coords = ulgrimRebelBase01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimRebelBase01Id, RebelBase01UlgrimStateObjects)
			
			end
		
		end

	end

end

-- Activated by quest when the player has destroyed the factory vents
local ulgrimFighting = false

function gd.quests.areaFNPCUlgrim.fightingTransition()
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_FIGHTING") then
			
			local ulgrimGateFight = Entity.Get(UlgrimFightingId)
				
			if (ulgrimGateFight != nil) then
			
				local coords = ulgrimGateFight:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimFightingId, FightingUlgrimStateObjects, Character, CharacterCreateArgs)
			
			end
			
			local ulgrimInnerCity = Entity.Get(UlgrimInnerCityId)
			
			if (ulgrimInnerCity != nil) then
			
				local coords = ulgrimInnerCity:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimInnerCityId, InnerCityUlgrimStateObjects)
			
			end

		end
		
	end

end


-- Activated by quest when the player kills the shaper of flesh
local ulgrimInBaseFinal = false

function gd.quests.areaFNPCUlgrim.rebelBase02Transition()
	
	if Server && not ulgrimInBaseFinal then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_REBELBASE") then
			ulgrimInBaseFinal = true
			
			local ulgrimRebBase01 = Entity.Get(UlgrimRebelBase01Id)

			if (ulgrimRebBase01 != nil) then
			
				local coords = ulgrimRebBase01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(UlgrimRebelBase01Id, RebelBase01UlgrimStateObjects)
			
			end
			
			local ulgrimGateFight = Entity.Get(UlgrimFightingAvatarId)
			
			if (ulgrimGateFight != nil) then
				local coords = ulgrimGateFight:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				ulgrimGateFight:Destroy()
			
			end

		end
		
	end

end

