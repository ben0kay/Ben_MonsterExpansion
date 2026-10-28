/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFNPCRebelLeaders = {}

local LeaderHideoutId = 0
local LeaderBaseId = 0
local CaptainHideoutId = 0
local CaptainBaseId = 0

--
-- Area F - Rebel Leader Transitions
--- 

local RebelLeaderStates = { Hideout = 0, Base = 1, LeaderFinal = 2}

-- Rebel leader at the hideout.
local RebelLeaderHideoutStatesObjects = orderedTable();
	RebelLeaderHideoutStatesObjects["AREAF_NPCREBELLEADERS_BASE"] = { state = RebelLeaderStates.Base,  dbr = nil }
	RebelLeaderHideoutStatesObjects[""] = { state = RebelLeaderStates.Hideout,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_korinia_01.dbr" }
	
function gd.quests.areaFNPCRebelLeaders.leaderHideoutOnAddToWorld(objectId)

	if Server then
		QuestGlobalEvent("malmouthBountyReset")

		LeaderHideoutId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelLeaderHideoutStatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCRebelLeaders.leaderHideoutOnDestroy = ClearObjectUserdata

-- Rebel leader at the base.
local RebelLeaderBaseStatesObjects = orderedTable();
	RebelLeaderBaseStatesObjects["AREAF_KORINIA_FINAL"] = { state = RebelLeaderStates.LeaderFinal,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_korinia_03.dbr" }
	RebelLeaderBaseStatesObjects["AREAF_NPCREBELLEADERS_BASE"] = { state = RebelLeaderStates.Base,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_korinia_02.dbr" }
	RebelLeaderBaseStatesObjects[""] = { state = RebelLeaderStates.Hideout,  dbr = nil }
	
function gd.quests.areaFNPCRebelLeaders.leaderBaseOnAddToWorld(objectId)

	if Server then
		QuestGlobalEvent("malmouthBountyReset")

		LeaderBaseId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelLeaderBaseStatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCRebelLeaders.leaderBaseOnDestroy = ClearObjectUserdata


-- Rebel captain at the hideout.
local RebelCaptainHideoutStatesObjects = orderedTable();
	RebelCaptainHideoutStatesObjects["AREAF_NPCREBELLEADERS_BASE"] = { state = RebelLeaderStates.Base,  dbr = nil }
	RebelCaptainHideoutStatesObjects[""] = { state = RebelLeaderStates.Hideout,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captainwilfor_01.dbr" }
	
function gd.quests.areaFNPCRebelLeaders.captainHideoutOnAddToWorld(objectId)

	if Server then

		CaptainHideoutId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelCaptainHideoutStatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCRebelLeaders.captainHideoutOnDestroy = ClearObjectUserdata

-- Rebel captain at the base.
local RebelCaptainBaseStatesObjects = orderedTable();
	RebelCaptainBaseStatesObjects["AREAF_NPCREBELLEADERS_BASE"] = { state = RebelLeaderStates.Base,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captainwilfor_02.dbr" }
	RebelCaptainBaseStatesObjects[""] = { state = RebelLeaderStates.Hideout,  dbr = nil }
	
function gd.quests.areaFNPCRebelLeaders.captainBaseOnAddToWorld(objectId)

	if Server then

		CaptainBaseId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelCaptainBaseStatesObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFNPCRebelLeaders.captainBaseOnDestroy = ClearObjectUserdata


-- Activated by quest when the player retakes the rebel base.
local rebelsAtBase = false

function gd.quests.areaFNPCRebelLeaders.baseTransition()
	
	if Server && not rebelsAtBase then
	
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCREBELLEADERS_BASE") then
	
			rebelsAtBase = true
		
			--Leader fx
			local leaderHideout = Entity.Get(LeaderHideoutId)
		
			if (leaderHideout != nil) then
			
				local coords = leaderHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(LeaderHideoutId, RebelLeaderHideoutStatesObjects)
			
			end
			
			local LeaderBase = Entity.Get(LeaderBaseId)
		
			if (LeaderBase != nil) then
			
				local coords = LeaderBase:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(LeaderBaseId, RebelLeaderBaseStatesObjects)
			
			end
			
			--Captain fx
			local CaptainHideout = Entity.Get(CaptainHideoutId)
		
			if (CaptainHideout != nil) then
			
				local coords = CaptainHideout:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(CaptainHideoutId, RebelCaptainHideoutStatesObjects)
			
			end
			
			local CaptainBase = Entity.Get(CaptainBaseId)
		
			if (CaptainBase != nil) then
			
				local coords = CaptainBase:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(CaptainBaseId, RebelCaptainBaseStatesObjects)
			
			end
			
			-- Spawn Ivonda, the mad woman
			gd.quests.areaFQuestMadRamblings.ivondaTransition()
			
		end

	end

end

-- Activated by dialogue when the player reveals Korinia
local leaderFinalTransition = false

function gd.quests.areaFNPCRebelLeaders.leaderFinalTransition()
	
	if Server && not leaderFinalTransition then
	
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_KORINIA_REVEAL") then
			leaderFinalTransition = true
			
			local LeaderBase = Entity.Get(LeaderBaseId)
		
			if (LeaderBase != nil) then
				UpdateObjectSwap(LeaderBaseId, RebelLeaderBaseStatesObjects)
				player:GiveToken("AREAF_KORINIA_FINAL")
				player:RemoveToken("AREAF_KORINIA_REVEAL")
			
			end
			
		end

	end

end
