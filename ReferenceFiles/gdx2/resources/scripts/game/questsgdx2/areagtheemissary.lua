/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGTheEmissary = {}


--
-- The Emissary Spawns
--
local riftsOpened = false

local EmissaryIds = {0, 0, 0, 0, 0}
local EmissaryState = { Default = 0, GDX2Unlocked = 1, PortalOpened = 2}

local EmissaryRuneStateObjects = orderedTable();
	EmissaryRuneStateObjects["AREAG_COVENBASERIFT_OPENED"] = { state = EmissaryState.PortalOpened, dbr = nil}
	EmissaryRuneStateObjects["UNLOCKGDX2_TRUE"] = { state = EmissaryState.GDX2Unlocked, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_theemissary_01.dbr"}
	EmissaryRuneStateObjects[""] = { state = EmissaryState.Default, dbr = nil}

local EmissaryStateObjects = orderedTable();
	EmissaryStateObjects["AREAG_COVENBASERIFT_OPENED"] = { state = EmissaryState.PortalOpened, dbr = nil}
	EmissaryStateObjects["UNLOCKGDX2_TRUE"] = { state = EmissaryState.GDX2Unlocked, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_theemissary_01.dbr"}
	EmissaryStateObjects[""] = { state = EmissaryState.Default, dbr = nil}

-- test if Emissary should spawn for host, if so, begin breadcrumb quest for all players
local function emissarySpawnTest()
	if Server then
		local player = Game.GetLocalPlayer()
		
		local questId01 = 0xD631D200
		local taskId01 = 0xDC054F00
		local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
		
		local questId02 = 0xD631D200
		local taskId02 = 0x65B6A800
		local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
		
		if ((questTaskState01 == QuestState.Complete || questTaskState02 == QuestState.Complete || questTaskState01 == QuestState.InProgress || questTaskState02 == QuestState.InProgress) && (player:HasToken("AREAG_COVENBASERIFT_OPENED") == false)) then
			GiveTokenToLocalPlayer("UNLOCKGDX2_TRUE")

			QuestGlobalEvent("GDX2BreadcrumbBeginQuest")
			
		end
	
	end
	
end

local function spawnEmissary(objectId)
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, EmissaryStateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end

end

local function spawnFXRune(objectId)
	if Server then
		local player = Game.GetLocalPlayer()
	
		if player:HasToken("UNLOCKGDX2_TRUE") && not player:HasToken("AREAG_COVENBASERIFT_OPENED") then		
			local entity = Entity.Get(objectId)
			
			if (entity != nil) then
				local coords = entity:GetCoords()
				
				local rune = Entity.Create ("records/fx/decals/ambdecal_witch_glyphglowing02a_med.dbr")
				rune:SetCoords(coords)
			
			end
		
		end
	
	end

end


--DC
function gd.quests.areaGTheEmissary.EmissaryDCOnAddToWorld(objectId)

	if Server && not riftsOpened then
		EmissaryIds[1] = objectId
		
		-- test if Emissary should spawn for the host and give them the appropriate token, start breadcrumb quest for all players if applicable
		emissarySpawnTest()
		
		-- spawn the Emissary based on token state
		spawnEmissary(objectId)
		
		-- spawn the Rune circle based on token state
		spawnFXRune(objectId)

	end
	
end

gd.quests.areaGTheEmissary.EmissaryOnDestroy = ClearObjectUserdata

-- Homestead
function gd.quests.areaGTheEmissary.EmissaryHomesteadOnAddToWorld(objectId)

	if Server && not riftsOpened then
		EmissaryIds[2] = objectId
		
		-- test if Emissary should spawn for the host and give them the appropriate token, start breadcrumb quest for all players if applicable
		emissarySpawnTest()
		
		-- spawn the Emissary based on token state
		spawnEmissary(objectId)
		
		-- spawn the Rune circle based on token state
		spawnFXRune(objectId)

	end
	
end

-- Ikon
function gd.quests.areaGTheEmissary.EmissaryIkonOnAddToWorld(objectId)

	if Server && not riftsOpened then
		EmissaryIds[3] = objectId
		
		-- test if Emissary should spawn for the host and give them the appropriate token, start breadcrumb quest for all players if applicable
		emissarySpawnTest()
		
		-- spawn the Emissary based on token state
		spawnEmissary(objectId)
		
		-- spawn the Rune circle based on token state
		spawnFXRune(objectId)

	end
	
end

-- GDX1 Coven
function gd.quests.areaGTheEmissary.EmissaryCovenOnAddToWorld(objectId)

	if Server && not riftsOpened then
		EmissaryIds[4] = objectId
		
		-- test if Emissary should spawn for the host and give them the appropriate token, start breadcrumb quest for all players if applicable
		emissarySpawnTest()
		
		-- spawn the Emissary based on token state
		spawnEmissary(objectId)
		
		-- spawn the Rune circle based on token state
		spawnFXRune(objectId)

	end
	
end

-- GDX1 Malmouth
function gd.quests.areaGTheEmissary.EmissaryMalmouthOnAddToWorld(objectId)

	if Server && not riftsOpened then
		EmissaryIds[5] = objectId
		
		-- test if Emissary should spawn for the host and give them the appropriate token, start breadcrumb quest for all players if applicable
		emissarySpawnTest()
		
		-- spawn the Emissary based on token state
		spawnEmissary(objectId)
		
		-- spawn the Rune circle based on token state
		spawnFXRune(objectId)

	end
	
end

--
-- Locked riftgates
--
local korvanRifts = {0, 0, 0, 0, 0}

function gd.quests.areaGTheEmissary.lockedRiftInitialUpdate(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAG_COVENBASERIFT_OPENED") || riftsOpened) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

-- DC Rift
function gd.quests.areaGTheEmissary.lockedRiftDCOnAddToWorld(objectId)
	
	if Server then
		korvanRifts[1] = objectId
		
	end
	
end


-- Homestead Rift
function gd.quests.areaGTheEmissary.lockedRiftHomesteadOnAddToWorld(objectId)
	
	if Server then
		korvanRifts[2] = objectId
		
	end
	
end


-- Ikon Rift
function gd.quests.areaGTheEmissary.lockedRiftIkonOnAddToWorld(objectId)
	
	if Server then
		korvanRifts[3] = objectId
		
	end
	
end


-- Coven Rift
function gd.quests.areaGTheEmissary.lockedRiftCovenOnAddToWorld(objectId)
	
	if Server then
		korvanRifts[4] = objectId
		
	end
	
end

-- Malmouth Rift
function gd.quests.areaGTheEmissary.lockedRiftMalmouthOnAddToWorld(objectId)
	
	if Server then
		korvanRifts[5] = objectId
		
	end
	
end

-- Open the rifts and teleport Emissary away
function gd.quests.areaGTheEmissary.openKorvanRifts()

	if Server && not riftsOpened then
		riftsOpened = true
		
		local player = Game.GetLocalPlayer()
		
		-- open rifts to gdx2 content
		local RiftsTotal = table.getn(korvanRifts)
		
		for id = 1, RiftsTotal do
			local door = Door.Get(korvanRifts[id])
			
			if door ~= nil then
				door:SetLocked(false)
				door:Open()
				
				local coords = door:GetCoords()	
				local fx = Entity.Create("records/fx/ambient/emissaryrift_activate_fxpak01.dbr")
			
				if (fx != nil) then
					fx:NetworkEnable()
					fx:SetCoords(coords)
				end
				
			end
			
		end
		
		-- despawn Emissary in towns
		local MPOverrideDbr = nil
		local MPOverrideState = true
		
		local emissaryTotal = table.getn(EmissaryIds)
	
		for id = 1, emissaryTotal do
			local entity = Entity.Get(EmissaryIds[id])
			
			if (entity != nil) then
				local coords = entity:GetCoords()
				local riftStart = Entity.Create("records/fx/creatures/eldritchspawn01_fx.dbr")
		
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
		
				UpdateObjectSwap(EmissaryIds[id], EmissaryStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
				
			end
		
		end
		
	end
	
end


-- Spawn Emissary Initially
local emissarySpawned = false

function gd.quests.areaGTheEmissary.triggerEmissary()

	QuestEvent("spawnEmissary")

end

function gd.quests.areaGTheEmissary.spawnInitialEmissary()

	if Server && not emissarySpawned && not riftsOpened then
		emissarySpawnTest()
		
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("UNLOCKGDX2_TRUE") then
			local emissaryTotal = table.getn(EmissaryIds)
		
			for id = 1, emissaryTotal do
				local entity = Entity.Get(EmissaryIds[id])
				
				if (entity != nil) then
					local coords = entity:GetCoords()
					local riftStart = Entity.Create("records/fx/creatures/eldritchspawn01_fx.dbr")
			
					if (riftStart != nil) then
						riftStart:NetworkEnable()
						riftStart:SetCoords(coords)
					end
					
					emissarySpawned = true
			
					UpdateObjectSwap(EmissaryIds[id], EmissaryStateObjects)
					
				end
			
			end
		
		end
		
	end
	
end

-- FX for landing in the GDX2 content.
-- This is not networked intentionally so it appears for each player locally.

-- Burnt Decal
local BurntDecalId = 0
local BurntDecalState = {Default = 0, Added = 1}

local BurntDecalStateObjects = orderedTable();
	BurntDecalStateObjects["AREAG_ENTERED_GDX2"] = { state = BurntDecalState.Added,  dbr = "records/fx/decals/ambdecal_groundimpact_charredearth01_xlg.dbr" }
	BurntDecalStateObjects[""] = { state = BurntDecalState.Default,  dbr = nil }


function gd.quests.areaGTheEmissary.BurntDecalOnAddToWorld(objectId)

	if (not burntDecalCreated)then

		BurntDecalId = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, BurntDecalStateObjects)
		Shared.setUserdata(objectId, userdata)
	
		if (newState == BurntDecalState.Added) then
			burntDecalCreated = true
		end

	end

end

gd.quests.areaGTheEmissary.BurntDecalOnDestroy = ClearObjectUserdata

-- The player touches the GDX2 entrance trigger.
function gd.quests.areaGTheEmissary.GDX2EntranceTrigger(objectId)

	local player = Game.GetLocalPlayer()
	
	if (player != nil) && (not burntDecalCreated) && (not player:HasToken("AREAG_ENTERED_GDX2")) then

		GiveTokenToLocalPlayer("AREAG_ENTERED_GDX2")
	
		local FXLocation = Entity.Get(BurntDecalId)
	
		if (FXLocation != nil) then
		
			local coords = FXLocation:GetCoords()	
			local fx = Entity.Create("records/fx/skillclass05/arcaneblast4_large_radius_fxpak01.dbr")
		
			if (fx != nil) then
				fx:SetCoords(coords)
			end
		
			local MPOverrideDbr = "records/fx/decals/ambdecal_groundimpact_charredearth01_xlg.dbr"
			local MPOverrideState = true
			
			UpdateObjectSwap(BurntDecalId, BurntDecalStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)

			burntDecalCreated = true
		
		end
		
	end
	
end


