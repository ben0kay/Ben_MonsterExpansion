/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGSolaelFaction = {}

--
-- Side Quest 01 - ancient statues
--

local SolaelStatuesState = {Default = 0, Start = 1, Active = 2, AllActive = 3}
local SolaelStatue01Id = 0
local SolaelStatue02Id = 0
local SolaelStatue03Id = 0
local SolaelStatueNPC01Id = 0
local SolaelStatueNPC02Id = 0
local SolaelStatueNPC03Id = 0
local TabletPiece01SpawnId = 0
local TabletPiece02SpawnId = 0
local TabletPiece03SpawnId = 0
local SolaelStatue01Activated = false
local SolaelStatue02Activated = false
local SolaelStatue03Activated = false
local TabletPiece01Spawned = false
local TabletPiece02Spawned = false
local TabletPiece03Spawned = false

local SolaelStatueQuestStarted = false

local HiddenDoor01Open = false
local UGDoorId = 0
local HiddenDoorId = 0

--Unlock Both doors
local function solaelHiddenDoorUnlock()

	if Server then
		
		local door01 = Door.Get(HiddenDoorId)
		local door02 = Door.Get(UGDoorId)

		HiddenDoor01Open = true
		
		if ((door01 != nil) && (door02 != nil)) then
		print "Open the doors"	
			
			door01:SetLocked(false)
			door01:Open()
			
			door02:SetLocked(false)
			door02:Open()
			
		end
		
	end
	
end


-- Solael Statue01
local SolaelStatue01StateObjects = orderedTable();
	SolaelStatue01StateObjects["AREAG_SOLAELSTATUES_ALLACTIVE"] = { state = SolaelStatuesState.AllActive,  dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr" }
	SolaelStatue01StateObjects["AREAG_SOLAELSTATUE01_ACTIVE"] = { state = SolaelStatuesState.Active,  dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr" }
	SolaelStatue01StateObjects[""] = { state = SolaelStatuesState.Default, dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_inactive.dbr" }

function gd.quests.areaGSolaelFaction.solaelStatue01OnAddToWorld(objectId)

	if Server && not SolaelStatue01Activated then
		SolaelStatue01Id = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SolaelStatue01StateObjects)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaGSolaelFaction.solaelStatuesOnDestroy = ClearObjectUserdata

local SolaelStatueNPC01StateObjects = orderedTable();
	SolaelStatueNPC01StateObjects["AREAG_SOLAELSTATUES_ALLACTIVE"] = { state = SolaelStatuesState.AllActive,  dbr = nil }
	SolaelStatueNPC01StateObjects["AREAG_SOLAELSTATUE01_ACTIVE"] = { state = SolaelStatuesState.Active,  dbr = nil }
	SolaelStatueNPC01StateObjects["AREAG_SOLAELSTATUES_START"] = { state = SolaelStatuesState.Start, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc01.dbr" }
	SolaelStatueNPC01StateObjects[""] = { state = SolaelStatuesState.Default, dbr = nil }

function gd.quests.areaGSolaelFaction.solaelStatueNPC01OnAddToWorld(objectId)

	if Server && not SolaelStatue01Activated then
		local player = Game.GetLocalPlayer()
		
		SolaelStatueNPC01Id = objectId;
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if SolaelStatueQuestStarted && not player:HasToken("AREAG_SOLAELSTATUE01_ACTIVE") && not player:HasToken("AREAG_SOLAELSTATUES_ALLACTIVE") then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc01.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SolaelStatueNPC01StateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)

	end
	
end

-- Tablet Piece 01 spawns when the statue is activated
function gd.quests.areaGSolaelFaction.tabletPieceSpawn01(objectId)
	if Server then
		TabletPiece01SpawnId = objectId
		
		-- Create the tablet if the statue is active
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAG_SOLAELSTATUE01_ACTIVE") || SolaelStatue01Activated) && (TabletPiece01Spawned == false) then	
			TabletPiece01Spawned = true

			local coords = Entity.Get(objectId):GetCoords()
			local entity = Entity.Create("records/items/questitems/quest_areag_solaeltabletpiece_01.dbr")
			entity:SetCoords(coords)
			
		end
		
	end
	
end

-- Activate statue 01
function gd.quests.areaGSolaelFaction.statue01ActivateGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x4C906080
	local kTask = 0x1501C060
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
	if (questTaskState == QuestState.InProgress) then	
		if (player != nil) then
			player:GiveToken("AREAG_SOLAELSTATUE01_ACTIVE")
			
		end
		
	end
	
end

function gd.quests.areaGSolaelFaction.statue01Activate()

	if Server && not SolaelStatue01Activated then
		local player = Game.GetLocalPlayer()
		local statue = Entity.Get(SolaelStatue01Id)
		
		if (statue != nil) then
			SolaelStatue01Activated = true
			
			-- swap statue
			local MPOverrideDbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr"
			local MPOverrideState = true
		
			UpdateObjectSwap(SolaelStatue01Id, SolaelStatue01StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			-- swap NPC
			local MPOverrideNPCDbr = nil
		
			UpdateObjectSwap(SolaelStatueNPC01Id, SolaelStatueNPC01StateObjects, nil, nil, MPOverrideState, MPOverrideNPCDbr)
			
			local NPCCoords = Entity.Get(SolaelStatueNPC01Id):GetCoords()
			
			local spawnFX = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
			if (spawnFX != nil) then
				spawnFX:NetworkEnable()
				spawnFX:SetCoords(NPCCoords)
			end
			
			
			-- Create the tablet object in front of the statue.
			if not TabletPiece01Spawned then
				TabletPiece01Spawned = true
				
				local coords = Entity.Get(TabletPiece01SpawnId):GetCoords()
				local tabletPiece = Entity.Create("records/items/questitems/quest_areag_solaeltabletpiece_01.dbr")
				tabletPiece:SetCoords(coords)
				
				local spawnFX = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
				if (spawnFX != nil) then
					spawnFX:NetworkEnable()
					spawnFX:SetCoords(coords)
				end
			
			end
		
		end
		
		-- grant token for activating statue
		QuestGlobalEvent("solaelStatue01Token")
		
		-- unlock secret dungeon if all statues are activated
		if (player:HasToken("AREAG_SOLAELSTATUE01_ACTIVE") && player:HasToken("AREAG_SOLAELSTATUE02_ACTIVE") && player:HasToken("AREAG_SOLAELSTATUE03_ACTIVE")) || ((SolaelStatue01Activated == true) && (SolaelStatue02Activated == true) && (SolaelStatue03Activated == true)) then
			solaelHiddenDoorUnlock()
			
		end
		
	end

end


-- Solael Statue02
local SolaelStatue02StateObjects = orderedTable();
	SolaelStatue02StateObjects["AREAG_SOLAELSTATUES_ALLACTIVE"] = { state = SolaelStatuesState.AllActive,  dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr" }
	SolaelStatue02StateObjects["AREAG_SOLAELSTATUE02_ACTIVE"] = { state = SolaelStatuesState.Active,  dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr" }
	SolaelStatue02StateObjects[""] = { state = SolaelStatuesState.Default, dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_inactive.dbr" }

function gd.quests.areaGSolaelFaction.solaelStatue02OnAddToWorld(objectId)

	if Server && not SolaelStatue02Activated then
		SolaelStatue02Id = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SolaelStatue02StateObjects)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaGSolaelFaction.solaelStatuesOnDestroy = ClearObjectUserdata

local SolaelStatueNPC02StateObjects = orderedTable();
	SolaelStatueNPC02StateObjects["AREAG_SOLAELSTATUES_ALLACTIVE"] = { state = SolaelStatuesState.AllActive,  dbr = nil }
	SolaelStatueNPC02StateObjects["AREAG_SOLAELSTATUE02_ACTIVE"] = { state = SolaelStatuesState.Active,  dbr = nil }
	SolaelStatueNPC02StateObjects["AREAG_SOLAELSTATUES_START"] = { state = SolaelStatuesState.Start, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc02.dbr" }
	SolaelStatueNPC02StateObjects[""] = { state = SolaelStatuesState.Default, dbr = nil }

function gd.quests.areaGSolaelFaction.solaelStatueNPC02OnAddToWorld(objectId)

	if Server && not SolaelStatue02Activated then
		local player = Game.GetLocalPlayer()
		
		SolaelStatueNPC02Id = objectId;
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if SolaelStatueQuestStarted && not player:HasToken("AREAG_SOLAELSTATUE02_ACTIVE") && not player:HasToken("AREAG_SOLAELSTATUES_ALLACTIVE") then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc02.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SolaelStatueNPC02StateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)

	end
	
end

-- Tablet Piece 02 spawns when the statue is activated
function gd.quests.areaGSolaelFaction.tabletPieceSpawn02(objectId)
	if Server then
		TabletPiece02SpawnId = objectId
		
		-- Create the tablet if the statue is active
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAG_SOLAELSTATUE02_ACTIVE") || SolaelStatue02Activated) && (TabletPiece02Spawned == false) then	
			TabletPiece02Spawned = true

			local coords = Entity.Get(objectId):GetCoords()
			local entity = Entity.Create("records/items/questitems/quest_areag_solaeltabletpiece_02.dbr")
			entity:SetCoords(coords)
			
		end
		
	end
	
end

-- Activate statue 02
function gd.quests.areaGSolaelFaction.statue02ActivateGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x4C906080
	local kTask = 0x1501C060
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
	if (questTaskState == QuestState.InProgress) then	
		if (player != nil) then
			player:GiveToken("AREAG_SOLAELSTATUE02_ACTIVE")
			
		end
		
	end
	
end

function gd.quests.areaGSolaelFaction.statue02Activate()

	if Server && not SolaelStatue02Activated then
		local player = Game.GetLocalPlayer()
		local statue = Entity.Get(SolaelStatue02Id)
		
		if (statue != nil) then
			SolaelStatue02Activated = true
			
			local MPOverrideDbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr"
			local MPOverrideState = true
		
			UpdateObjectSwap(SolaelStatue02Id, SolaelStatue02StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			-- swap NPC
			local MPOverrideNPCDbr = nil
		
			UpdateObjectSwap(SolaelStatueNPC02Id, SolaelStatueNPC02StateObjects, nil, nil, MPOverrideState, MPOverrideNPCDbr)
			
			local NPCCoords = Entity.Get(SolaelStatueNPC02Id):GetCoords()
			
			local spawnFX = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
			if (spawnFX != nil) then
				spawnFX:NetworkEnable()
				spawnFX:SetCoords(NPCCoords)
			end
		
			-- Create the tablet object in front of the statue.
			if not TabletPiece02Spawned then
				TabletPiece02Spawned = true
				
				local coords = Entity.Get(TabletPiece02SpawnId):GetCoords()
				local tabletPiece = Entity.Create("records/items/questitems/quest_areag_solaeltabletpiece_02.dbr")
				tabletPiece:SetCoords(coords)
				
				local spawnFX = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
				if (spawnFX != nil) then
					spawnFX:NetworkEnable()
					spawnFX:SetCoords(coords)
				end
			
			end
		
		end
		
		-- grant token for activating statue
		QuestGlobalEvent("solaelStatue02Token")
		
		-- unlock secret dungeon if all statues are activated
		if (player:HasToken("AREAG_SOLAELSTATUE01_ACTIVE") && player:HasToken("AREAG_SOLAELSTATUE02_ACTIVE") && player:HasToken("AREAG_SOLAELSTATUE03_ACTIVE")) || ((SolaelStatue01Activated == true) && (SolaelStatue02Activated == true) && (SolaelStatue03Activated == true)) then
			solaelHiddenDoorUnlock()
			
		end
		
	end

end

-- Solael Statue03
local SolaelStatue03StateObjects = orderedTable();
	SolaelStatue03StateObjects["AREAG_SOLAELSTATUES_ALLACTIVE"] = { state = SolaelStatuesState.AllActive,  dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr" }
	SolaelStatue03StateObjects["AREAG_SOLAELSTATUE03_ACTIVE"] = { state = SolaelStatuesState.Active,  dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr" }
	SolaelStatue03StateObjects[""] = { state = SolaelStatuesState.Default, dbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_inactive.dbr" }

function gd.quests.areaGSolaelFaction.solaelStatue03OnAddToWorld(objectId)

	if Server && not SolaelStatue03Activated then
		SolaelStatue03Id = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SolaelStatue03StateObjects)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaGSolaelFaction.solaelStatuesOnDestroy = ClearObjectUserdata

local SolaelStatueNPC03StateObjects = orderedTable();
	SolaelStatueNPC03StateObjects["AREAG_SOLAELSTATUES_ALLACTIVE"] = { state = SolaelStatuesState.AllActive,  dbr = nil }
	SolaelStatueNPC03StateObjects["AREAG_SOLAELSTATUE03_ACTIVE"] = { state = SolaelStatuesState.Active,  dbr = nil }
	SolaelStatueNPC03StateObjects["AREAG_SOLAELSTATUES_START"] = { state = SolaelStatuesState.Start, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc03.dbr" }
	SolaelStatueNPC03StateObjects[""] = { state = SolaelStatuesState.Default, dbr = nil }

function gd.quests.areaGSolaelFaction.solaelStatueNPC03OnAddToWorld(objectId)

	if Server && not SolaelStatue03Activated then
		local player = Game.GetLocalPlayer()
		
		SolaelStatueNPC03Id = objectId;
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if SolaelStatueQuestStarted && not player:HasToken("AREAG_SOLAELSTATUE03_ACTIVE") && not player:HasToken("AREAG_SOLAELSTATUES_ALLACTIVE") then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc03.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SolaelStatueNPC03StateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)

	end
	
end

-- Tablet Piece 03 spawns when the statue is activated
function gd.quests.areaGSolaelFaction.tabletPieceSpawn03(objectId)
	if Server then
		TabletPiece03SpawnId = objectId
		
		-- Create the tablet if the statue is active
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAG_SOLAELSTATUE03_ACTIVE") || SolaelStatue03Activated) && (TabletPiece03Spawned == false) then	
			TabletPiece03Spawned = true

			local coords = Entity.Get(objectId):GetCoords()
			local entity = Entity.Create("records/items/questitems/quest_areag_solaeltabletpiece_03.dbr")
			entity:SetCoords(coords)
			
		end
		
	end
	
end

-- Activate statue 03
function gd.quests.areaGSolaelFaction.statue03ActivateGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x4C906080
	local kTask = 0x1501C060
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
	if (questTaskState == QuestState.InProgress) then	
		if (player != nil) then
			player:GiveToken("AREAG_SOLAELSTATUE03_ACTIVE")
			
		end
		
	end
	
end

function gd.quests.areaGSolaelFaction.statue03Activate()

	if Server && not SolaelStatue03Activated then
		local player = Game.GetLocalPlayer()
		local statue = Entity.Get(SolaelStatue03Id)
		
		if (statue != nil) then
			SolaelStatue03Activated = true
			
			local MPOverrideDbr = "records/storyelementsgdx2/questassets/areag_solaelstatue_active.dbr"
			local MPOverrideState = true
		
			UpdateObjectSwap(SolaelStatue03Id, SolaelStatue03StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			-- swap NPC
			local MPOverrideNPCDbr = nil
		
			UpdateObjectSwap(SolaelStatueNPC03Id, SolaelStatueNPC03StateObjects, nil, nil, MPOverrideState, MPOverrideNPCDbr)
			
			local NPCCoords = Entity.Get(SolaelStatueNPC03Id):GetCoords()
			
			local spawnFX = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
			if (spawnFX != nil) then
				spawnFX:NetworkEnable()
				spawnFX:SetCoords(NPCCoords)
			end
		
			-- Create the tablet object in front of the statue.
			if not TabletPiece03Spawned then
				TabletPiece03Spawned = true
				
				local coords = Entity.Get(TabletPiece03SpawnId):GetCoords()
				local tabletPiece = Entity.Create("records/items/questitems/quest_areag_solaeltabletpiece_03.dbr")
				tabletPiece:SetCoords(coords)
				
				local spawnFX = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				spawnFX:SetCoords(coords)
				
				if (spawnFX != nil) then
					spawnFX:NetworkEnable()
					spawnFX:SetCoords(coords)
				end
			
			end
		
		end
		
		-- grant token for activating statue
		QuestGlobalEvent("solaelStatue03Token")
		
		-- unlock secret dungeon if all statues are activated
		if (player:HasToken("AREAG_SOLAELSTATUE01_ACTIVE") && player:HasToken("AREAG_SOLAELSTATUE02_ACTIVE") && player:HasToken("AREAG_SOLAELSTATUE03_ACTIVE")) || ((SolaelStatue01Activated == true) && (SolaelStatue02Activated == true) && (SolaelStatue03Activated == true)) then
			solaelHiddenDoorUnlock()
			
		end
		
	end

end

-- Spawn Statue NPCs when quest begins
function gd.quests.areaGSolaelFaction.spawnStatueNPCs()

	if Server && not SolaelStatueQuestStarted then
		local player = Game.GetLocalPlayer()
		
		if not player:HasToken("AREAG_SOLAELSTATUES_ALLACTIVE") then
			SolaelStatueQuestStarted = true
			
			local player = Game.GetLocalPlayer()
			local npc01 = Entity.Get(SolaelStatue01Id)
			local npc02 = Entity.Get(SolaelStatue02Id)
			local npc03 = Entity.Get(SolaelStatue03Id)
			
			if (npc01 != nil) then			
				local MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc01.dbr"
				local MPOverrideState = true
			
				local coords = npc01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(SolaelStatue01Id, SolaelStatueNPC01StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
			
			if (npc02 != nil) then			
				local MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc02.dbr"
				local MPOverrideState = true
			
				local coords = npc02:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(SolaelStatue02Id, SolaelStatueNPC02StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
			
			if (npc03 != nil) then			
				local MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_solaelstatuenpc03.dbr"
				local MPOverrideState = true
			
				local coords = npc03:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(SolaelStatue03Id, SolaelStatueNPC03StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
			
		end

	end

end

--
-- Door Blocker and UG Door
--
-- UG Door Setup
function gd.quests.areaGSolaelFaction.UGDoorOnAddToWorld(objectId)

	if Server then
		UGDoorId = objectId;
		
		local door = Door.Get(objectId)
		local player = Game.GetLocalPlayer()

		-- Unlock the door if the player has the quest complete token or the door variable is set, or if the host is not part of the Solael faction but another player has the door unlocked
		if (player:HasToken("AREAG_SOLAELSTATUES_ALLACTIVE") || HiddenDoor01Open == true || (player:AnyoneHasToken("AREAG_SOLAELSTATUES_ALLACTIVE") && not player:HasToken("AREAG_CHOSEFACTION_SOLAEL"))) then
			door:SetLocked(false)
			door:Open()

		end
		
	end
	
end

--Sliding Rock Door Setup
function gd.quests.areaGSolaelFaction.hiddenDoorOnAddToWorld(objectId)
	
	if Server then
		
		HiddenDoorId = objectId
		
		local player = Game.GetLocalPlayer()
		local door = Door.Get(objectId)

		-- Unlock the door if the player has the quest complete token or the door variable is set, or if the host is not part of the Solael faction but another player has the door unlocked
		if (player:HasToken("AREAG_SOLAELSTATUES_ALLACTIVE") || HiddenDoor01Open == true || (player:AnyoneHasToken("AREAG_SOLAELSTATUES_ALLACTIVE") && not player:HasToken("AREAG_CHOSEFACTION_SOLAEL"))) then
			door:SetLocked(false)
			door:Open()

		end
	
	end
	
end

--
-- Sarcophagus Setup - There are three different sarcophagi only one of them isn't trapped. Their location is randomized.
-- If the player opens an incorrect sarcophagus another boss guardian is spawned. 
--
local SarcophagiSpawnIds = { 0, 0, 0 }

local Sarcophagus01Id = 0
local Sarcophagus02Id = 0 
local Sarcophagus03Id = 0


-- spawn locations for the sarcophagi
function gd.quests.areaGSolaelFaction.SarcophagiSpawn01(objectId)
	if Server then
		SarcophagiSpawnIds[1] = objectId
	end
end

gd.quests.areaGSolaelFaction.SarcophagiSpawn01OnDestroy = ClearObjectUserdata

function gd.quests.areaGSolaelFaction.SarcophagiSpawn02(objectId)
	if Server then
		SarcophagiSpawnIds[2] = objectId
	end
end

gd.quests.areaGSolaelFaction.SarcophagiSpawn02OnDestroy = ClearObjectUserdata

function gd.quests.areaGSolaelFaction.SarcophagiSpawn03(objectId)
	if Server then
		SarcophagiSpawnIds[3] = objectId
	end
end

gd.quests.areaGSolaelFaction.SarcophagiSpawn03OnDestroy = ClearObjectUserdata


-- The sarcophagi
function gd.quests.areaGSolaelFaction.Sarcophagus01(objectId)
	if Server then
		Sarcophagus01Id = objectId
	end
end

gd.quests.areaGSolaelFaction.Sarcophagi01OnDestroy = ClearObjectUserdata

function gd.quests.areaGSolaelFaction.Sarcophagus02(objectId)
	if Server then
		Sarcophagus02Id = objectId
	end
end

gd.quests.areaGSolaelFaction.Sarcophagi02OnDestroy = ClearObjectUserdata

function gd.quests.areaGSolaelFaction.Sarcophagus03(objectId)
	if Server then
		Sarcophagus03Id = objectId
	end
end

gd.quests.areaGSolaelFaction.Sarcophagi03OnDestroy = ClearObjectUserdata

-- The first room guardian is killed - unlocks the chests
function gd.quests.areaGSolaelFaction.solaelStatueGuardianBossKilled()
	
	UI.Notify("tagNotification_AreaG_SolaelStatueUnlocked")
	
	if Server then
		local sarcophagus01 = Chest.Get(Sarcophagus01Id);
		local sarcophagus02 = Chest.Get(Sarcophagus02Id);
		local sarcophagus03 = Chest.Get(Sarcophagus03Id);
		
		-- unlock the other sarcophagi
		if (sarcophagus01 ~= nil) then
			sarcophagus01:SetLocked(false)
		end
		
		if (sarcophagus02 ~= nil) then
			sarcophagus02:SetLocked(false)
		end
		
		if (sarcophagus03 ~= nil) then
			sarcophagus03:SetLocked(false)
		end
		
	end

end

-- Spawn Chests when player enters the area
local chestsSpawned = false

function gd.quests.areaGSolaelFaction.triggerChestSpawn()
	
	QuestEvent("SolaelChestsTrigger")

end

function gd.quests.areaGSolaelFaction.ChestsSpawnMP()
	
	if Server && not chestsSpawned then
		chestsSpawned = true
		
		local player = Game.GetLocalPlayer()
		
		local mainChest01DBR = "records/items/lootchests/questchests/questchest_areag_solaelsarcophagus_01a.dbr"
		local mainChest01OpenedDBR = "records/items/lootchests/questchests/questchest_areag_solaelsarcophagus_01.dbr"
		local fakeChest02DBR = "records/items/lootchests/questchests/questchest_areag_solaelsarcophagus_02.dbr"
		local fakeChest03DBR = "records/items/lootchests/questchests/questchest_areag_solaelsarcophagus_03.dbr"
		
		local sarcophagusDBRs = { nil, nil, nil }
		
		math.randomseed(Time.Now())
		local LocationRandomizer = random(1,3)

		if LocationRandomizer == 1 then
			print "creating at location 1"
			if (player:ServerHasToken("AREAG_RAHNCHEST01_OPENED")) then
				sarcophagusDBRs[1] = mainChest01OpenedDBR
			else
				sarcophagusDBRs[1] = mainChest01DBR
			end
			
			sarcophagusDBRs[2] = fakeChest02DBR
			
			sarcophagusDBRs[3] = fakeChest03DBR
		
		elseif LocationRandomizer == 2 then
			print "creating at location 2"
			if (player:ServerHasToken("AREAG_RAHNCHEST01_OPENED")) then
				sarcophagusDBRs[2] = mainChest01OpenedDBR
			else
				sarcophagusDBRs[2] = mainChest01DBR
			end
			
			sarcophagusDBRs[1] = fakeChest02DBR
			
			sarcophagusDBRs[3] = fakeChest03DBR
		
		else
			print "creating at location 3"
			if (player:ServerHasToken("AREAG_RAHNCHEST01_OPENED")) then
				sarcophagusDBRs[3] = mainChest01OpenedDBR
			else
				sarcophagusDBRs[3] = mainChest01DBR
			end
			
			sarcophagusDBRs[1] = fakeChest02DBR
			
			sarcophagusDBRs[2] = fakeChest03DBR
		
		end

		local chestsTotal = table.getn(SarcophagiSpawnIds)
	
		for id = 1, chestsTotal do
			local entity = Entity.Get(SarcophagiSpawnIds[id])
			
			if (entity != nil) then
				local coords = entity:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
		
				local chest = Entity.Create(sarcophagusDBRs[id])
				chest:SetCoords(coords)
				
			end
		
		end
	
	end
	
end

-- The player opens sarcophagus 01 - Token is given so a lesser chest can be spawned in later visits.
function gd.quests.areaGSolaelFaction.sarcophagus01OnOpen()
	
	UI.Notify("tagNotification_AreaG_SolaelStatueCorrect")
	
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("AREAG_RAHNCHEST01_OPENED") == false) && (player:HasToken("AREAG_MAPROOM_COMPLETED") == false) then	
		if (player != nil) then
			player:GiveToken("AREAG_RAHNCHEST01_OPENED")
			player:GiveToken("AREAG_MAPROOM_COMPLETED")
			
		end
		
	end
	
	if (player:HasToken("AREAG_MAPROOM_COMPLETED") == false) then	
		if (player != nil) then
			player:GiveToken("AREAG_MAPROOM_COMPLETED")
			
		end
		
	end
	
end

function gd.quests.areaGSolaelFaction.sarcophagus01AOnOpen()
	
	UI.Notify("tagNotification_AreaG_SolaelStatueCorrect")
	
	local player = Game.GetLocalPlayer()
	
	if (player:HasToken("AREAG_MAPROOM_COMPLETED") == false) then	
		if (player != nil) then
			player:GiveToken("AREAG_MAPROOM_COMPLETED")
			
		end
		
	end
	
end

--
-- Guardian setup for opening sarcophagus 02 & 03
--
local spawnedDestructible01 = false
local Destructible01Id = 0
local spawnedDestructible02 = false
local Destructible02Id = 0

-- Destructible for guardian 01
function gd.quests.areaGSolaelFaction.destructible01OnAddToWorld(objectId)

	if Server && not spawnedDestructible01 then
		spawnedDestructible01 = true
		
		local coords = Entity.Get(objectId):GetCoords()
		local entity = Entity.Create("records/storyelementsgdx2/questassets/areag_solaelfaction_statue01_break.dbr")
		entity:SetCoords(coords)
		
	end
	
end

function gd.quests.areaGSolaelFaction.destructible01AvatarOnAddToWorld(objectId)
	
	if Server then
		Destructible01Id = objectId
	
	end
	
end

-- Destructible for guardian 02
function gd.quests.areaGSolaelFaction.destructible02OnAddToWorld(objectId)

	if Server && not spawnedDestructible02 then
		spawnedDestructible02 = true
		
		local coords = Entity.Get(objectId):GetCoords()
		local entity = Entity.Create("records/storyelementsgdx2/questassets/areag_solaelfaction_statue02_break.dbr")
		entity:SetCoords(coords)
		
	end
	
end

function gd.quests.areaGSolaelFaction.destructible02AvatarOnAddToWorld(objectId)
	
	if Server then
		Destructible02Id = objectId
	
	end
	
end

-- The player opens sarcophagus 02
function gd.quests.areaGSolaelFaction.sarcophagus02OnOpen()

	QuestEvent("SolaelStatuesSpawnGuardian01")
	
	UI.Notify("tagNotification_AreaG_SolaelStatueWrong")

end

-- Spawn Guardian 01 when sarcohpagus 02 is opened
function gd.quests.areaGSolaelFaction.SolaelSpawnGuardian01()

	if Server then
		local sarcophagus01 = Chest.Get(Sarcophagus01Id);
		local sarcophagus03 = Chest.Get(Sarcophagus03Id);
		
		-- lock the other sarcophagi
		if (sarcophagus01 ~= nil) then
			sarcophagus01:SetLocked(true)
		end
		
		if (sarcophagus03 ~= nil) then
			sarcophagus03:SetLocked(true)
		end
		
		if Destructible01Id != 0 then
			local Destructible = Destructible.Get(Destructible01Id)
			local coords = Destructible:GetCoords()
			Destructible:Destroy(Vec(0,1,0), 1000, false)
			Destructible01Id = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
			local spawn = Character.Create ("records/creatures/enemies/boss&quest/statue_solaelfaction_02.dbr", 0, coords.origin)
			spawn:SetCoords(coords)
			
		end

	end

end

-- Guardian 01 is killed unlocking the remaining sarcophagi
function gd.quests.areaGSolaelFaction.solaelStatueGuardian01Killed()
	
		UI.Notify("tagNotification_AreaG_SolaelStatueUnlocked")
		
		if Server then
			local sarcophagus01 = Chest.Get(Sarcophagus01Id);
			local sarcophagus03 = Chest.Get(Sarcophagus03Id);
			
			-- unlock the other sarcophagi
			if (sarcophagus01 ~= nil) then
				sarcophagus01:SetLocked(false)
			end
			
			if (sarcophagus03 ~= nil) then
				sarcophagus03:SetLocked(false)
			end
		
		end
		
end

-- The player opens sarcophagus 03
function gd.quests.areaGSolaelFaction.sarcophagus03OnOpen()

	QuestEvent("SolaelStatuesSpawnGuardian02")
	
	UI.Notify("tagNotification_AreaG_SolaelStatueWrong")
	
end

-- Spawn Guardian 02 when sarcohpagus 03 is opened
function gd.quests.areaGSolaelFaction.SolaelSpawnGuardian02()

	if Server then
	
		local sarcophagus01 = Chest.Get(Sarcophagus01Id);
		local sarcophagus02 = Chest.Get(Sarcophagus02Id);
		
		-- lock the other sarcophagi
		if (sarcophagus01 ~= nil) then
			sarcophagus01:SetLocked(true)
		end
		
		if (sarcophagus02 ~= nil) then
			sarcophagus02:SetLocked(true)
		end
	
		if Destructible02Id != 0 then
			local Destructible = Destructible.Get(Destructible02Id)
			local coords = Destructible:GetCoords()
			Destructible:Destroy(Vec(0,1,0), 1000, false)
			Destructible02Id = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
			
			local spawn = Character.Create ("records/creatures/enemies/boss&quest/statue_solaelfaction_03.dbr", 0, coords.origin)
			spawn:SetCoords(coords)
			
		end

	end

end

-- Guardian 02 is killed unlocking the remaining sarcophagi
function gd.quests.areaGSolaelFaction.solaelStatueGuardian02Killed()
	
		UI.Notify("tagNotification_AreaG_SolaelStatueUnlocked")
		
		if Server then
			local sarcophagus01 = Chest.Get(Sarcophagus01Id);
			local sarcophagus02 = Chest.Get(Sarcophagus02Id);
			
			-- unlock the other sarcophagi
			if (sarcophagus01 ~= nil) then
				sarcophagus01:SetLocked(false)
			end
			
			if (sarcophagus02 ~= nil) then
				sarcophagus02:SetLocked(false)
			end
			
		end
		
end


-- Statue Riddle Randomization
local statueRandomizer1 = 0
local statueRandomizer2 = 0
local statueRandomizer3 = 0

function gd.quests.areaGSolaelFaction.statue01Randomizer()
	
	if statueRandomizer1 == 0 then
		math.randomseed(Time.Now())
		statueRandomizer1 = random(1,4)
	
	end
	
	return statueRandomizer1

end

function gd.quests.areaGSolaelFaction.statue02Randomizer()
	
	if statueRandomizer2 == 0 then
		math.randomseed(Time.Now())
		statueRandomizer2 = random(1,4)
	
	end
	
	return statueRandomizer2

end

function gd.quests.areaGSolaelFaction.statue03Randomizer()
	
	if statueRandomizer3 == 0 then
		math.randomseed(Time.Now())
		statueRandomizer3 = random(1,4)
	
	end
	
	return statueRandomizer3

end

