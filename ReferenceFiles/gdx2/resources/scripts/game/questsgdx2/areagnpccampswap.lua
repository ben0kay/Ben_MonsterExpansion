/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGNPCCampSwap = {}

--
-- Bysmiel Camp Character Swaps
--

local leadersTransitioned = false
local LeaderState = { Default = 0, InForwardCamp = 1, KorvaakKilled = 2 }

local leaderIds = { 0, 0, 0, 0, 0, 0 }
local leaderStateObjects = { }

-- Bysmiel Leader
local BysmielLeaderConclaveId = 0
local BysmielLeaderVanguardId = 0

-- FX for Leaders
local function spawnFXRune(objectId, leaderNum)
	if Server then
		local player = Game.GetLocalPlayer()
	
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not player:HasToken("AREAG_KORVAAK_KILLED") then		
			
			local entity = Entity.Get(objectId)
			
			if (entity != nil) then
				local fxDBR = nil
				
				if leaderNum == 1 then
					fxDBR = "records/fx/ambient/eldritchrunecircle01_bysmiel.dbr"
				elseif leaderNum == 2 then
					fxDBR = "records/fx/ambient/eldritchrunecircle01_dreeg.dbr"
				else
					fxDBR = "records/fx/ambient/eldritchrunecircle01_solael.dbr"
				end
				
				local coords = entity:GetCoords()
				
				local rune = Entity.Create (fxDBR)
				rune:SetCoords(coords)
			
			end
		
		end
	
	end

end

-- In Conclave
local BysmielLeaderConclaveStateObjects = orderedTable();
	BysmielLeaderConclaveStateObjects["AREAG_KORVAAK_KILLED"] = { state = LeaderState.KorvaakKilled, dbr = nil}
	BysmielLeaderConclaveStateObjects["AREAG_FORWARDCAMP_UNLOCKED"] = { state = LeaderState.InForwardCamp, dbr = nil}
	BysmielLeaderConclaveStateObjects[""] = { state = LeaderState.Default, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_bysmielleader_01.dbr"}
	
function gd.quests.areaGNPCCampSwap.BysmielLeaderConclaveOnAddToWorld(objectId)

	if Server then
		leaderIds[1] = objectId;
		leaderStateObjects[1] = BysmielLeaderConclaveStateObjects
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, BysmielLeaderConclaveStateObjects)
		Shared.setUserdata(objectId, userdata)
	
	end
	
end

gd.quests.areaGNPCCampSwap.BysmielLeaderConclaveOnDestroy = ClearObjectUserdata


-- In Vanguard
local BysmielLeaderVanguardStateObjects = orderedTable();
	BysmielLeaderVanguardStateObjects["AREAG_KORVAAK_KILLED"] = { state = LeaderState.KorvaakKilled, dbr = nil}
	BysmielLeaderVanguardStateObjects["AREAG_FORWARDCAMP_UNLOCKED"] = { state = LeaderState.InForwardCamp, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_bysmielleader_02.dbr" }
	BysmielLeaderVanguardStateObjects[""] = { state = LeaderState.Default, dbr = nil}
	
function gd.quests.areaGNPCCampSwap.BysmielLeaderVanguardOnAddToWorld(objectId)

	if Server then
		leaderIds[2] = objectId;
		leaderStateObjects[2] = BysmielLeaderVanguardStateObjects
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, BysmielLeaderVanguardStateObjects)
		Shared.setUserdata(objectId, userdata)
		
		-- spawn the Rune circle if the objectId is not nil
		spawnFXRune(objectId, 1)
		
	end
	
end

gd.quests.areaGNPCCampSwap.BysmielLeaderVanguardOnDestroy = ClearObjectUserdata

--
-- Dreeg Camp Character Swaps
--
-- Dreeg Leader
local DreegLeaderConclaveId = 0
local DreegLeaderVanguardId = 0

-- In Conclave
local DreegLeaderConclaveStateObjects = orderedTable();
	DreegLeaderConclaveStateObjects["AREAG_FORWARDCAMP_UNLOCKED"] = { state = LeaderState.InForwardCamp, dbr = nil }
	DreegLeaderConclaveStateObjects[""] = { state = LeaderState.Default, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_dreegleader_01.dbr"}
	
function gd.quests.areaGNPCCampSwap.DreegLeaderConclaveOnAddToWorld(objectId)

	if Server then
		leaderIds[3] = objectId;
		leaderStateObjects[3] = DreegLeaderConclaveStateObjects
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, DreegLeaderConclaveStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaGNPCCampSwap.DreegLeaderConclaveOnDestroy = ClearObjectUserdata

-- In Vanguard
local DreegLeaderVanguardStateObjects = orderedTable();
	DreegLeaderVanguardStateObjects["AREAG_KORVAAK_KILLED"] = { state = LeaderState.KorvaakKilled, dbr = nil}
	DreegLeaderVanguardStateObjects["AREAG_FORWARDCAMP_UNLOCKED"] = { state = LeaderState.InForwardCamp, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_dreegleader_02.dbr" }
	DreegLeaderVanguardStateObjects[""] = { state = LeaderState.Default, dbr = nil}
	
function gd.quests.areaGNPCCampSwap.DreegLeaderVanguardOnAddToWorld(objectId)

	if Server then
		leaderIds[4] = objectId;
		leaderStateObjects[4] = DreegLeaderVanguardStateObjects
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, DreegLeaderVanguardStateObjects)
		Shared.setUserdata(objectId, userdata)
		
		-- spawn the Rune circle if the objectId is not nil
		spawnFXRune(objectId, 2)
		
	end
	
end

gd.quests.areaGNPCCampSwap.DreegLeaderVanguardOnDestroy = ClearObjectUserdata

--
-- Solael Camp Character Swaps
--
-- Solael Leader
local LeaderState = { Default = 0, InForwardCamp = 1}
local SolaelLeaderConclaveId = 0
local SolaelLeaderVanguardId = 0

-- In Conclave
local SolaelLeaderConclaveStateObjects = orderedTable();
	SolaelLeaderConclaveStateObjects["AREAG_KORVAAK_KILLED"] = { state = LeaderState.KorvaakKilled, dbr = nil}
	SolaelLeaderConclaveStateObjects["AREAG_FORWARDCAMP_UNLOCKED"] = { state = LeaderState.InForwardCamp, dbr = nil }
	SolaelLeaderConclaveStateObjects[""] = { state = LeaderState.Default, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_solaelleader_01.dbr"}
	
function gd.quests.areaGNPCCampSwap.SolaelLeaderConclaveOnAddToWorld(objectId)

	if Server then
		leaderIds[5] = objectId;
		leaderStateObjects[5] = SolaelLeaderConclaveStateObjects
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, SolaelLeaderConclaveStateObjects)
		Shared.setUserdata(objectId, userdata)

		
	end
	
end

gd.quests.areaGNPCCampSwap.SolaelLeaderConclaveOnDestroy = ClearObjectUserdata

-- In Vanguard
local SolaelLeaderVanguardStateObjects = orderedTable();
	SolaelLeaderVanguardStateObjects["AREAG_KORVAAK_KILLED"] = { state = LeaderState.KorvaakKilled, dbr = nil}
	SolaelLeaderVanguardStateObjects["AREAG_FORWARDCAMP_UNLOCKED"] = { state = LeaderState.InForwardCamp, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_solaelleader_02.dbr" }
	SolaelLeaderVanguardStateObjects[""] = { state = LeaderState.Default, dbr = nil}
	
function gd.quests.areaGNPCCampSwap.SolaelLeaderVanguardOnAddToWorld(objectId)

	if Server then
		leaderIds[6] = objectId;
		leaderStateObjects[6] = SolaelLeaderVanguardStateObjects
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, SolaelLeaderVanguardStateObjects)
		Shared.setUserdata(objectId, userdata)
		
		-- spawn the Rune circle if the objectId is not nil
		spawnFXRune(objectId, 3)
		
	end
	
end

gd.quests.areaGNPCCampSwap.SolaelLeaderVanguardOnDestroy = ClearObjectUserdata


--
-- Mass transition to the Vanguard Base
--

-- Activated by all faction 02 quests when the player reaches the "return to" objective
function gd.quests.areaGNPCCampSwap.VanguardNPCTransition()
	
	if Server && not leadersTransitioned then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") then
			leadersTransitioned = true

			print "Do the transition"
			local leadersTotal = table.getn(leaderIds)
		
			for id = 1, leadersTotal do
				local entity = Entity.Get(leaderIds[id])
				
				if (entity != nil) then
					local coords = entity:GetCoords()
					local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (riftStart != nil) then
						riftStart:NetworkEnable()
						riftStart:SetCoords(coords)
					end
			
					UpdateObjectSwap(leaderIds[id], leaderStateObjects[id])
					
				end
			
			end
		
		end
		
	end
	
end




