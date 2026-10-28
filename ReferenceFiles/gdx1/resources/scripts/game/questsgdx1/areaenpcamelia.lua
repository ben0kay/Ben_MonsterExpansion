/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaENPCAmelia = {}


--
-- Amelia starts in Fort Ikon, for the GDX1 Intro, then transitions to Devil's Crossing
--

local ameliaFortIkonId = 0
local ameliaDevilsCrossingId = 0

local AmeliaState = { Default = 0, FortIkon = 1, DevilsCrossing = 2 }

-- Amelia in Devil's Crossing
local devilsCrossingAmeliaStateObjects = orderedTable();
	devilsCrossingAmeliaStateObjects["AREAE_NPCS"]			= { state = AmeliaState.DevilsCrossing, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_amelia_02.dbr" }
	devilsCrossingAmeliaStateObjects["AREAE_INTRO"] = { state = AmeliaState.FortIkon,  dbr = nil }
	devilsCrossingAmeliaStateObjects[""]			= { state = AmeliaState.Default, dbr = nil }
	
function gd.quests.areaENPCAmelia.devilsCrossingAmeliaOnAddToWorld(objectId)

	if Server then
	
		ameliaDevilsCrossingId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, devilsCrossingAmeliaStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaENPCAmelia.devilsCrossingAmeliaOnDestroy = ClearObjectUserdata

-- Amelia in Fort Ikon
local fortIkonAmeliaStateObjects = orderedTable();
	fortIkonAmeliaStateObjects["AREAE_NPCS"]			= { state = AmeliaState.DevilsCrossing, dbr = nil }
	fortIkonAmeliaStateObjects["AREAE_INTRO"] = { state = AmeliaState.FortIkon,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_amelia_01.dbr" }
	fortIkonAmeliaStateObjects[""]			= { state = AmeliaState.Default, dbr = nil }
	
function gd.quests.areaENPCAmelia.fortIkonAmeliaOnAddToWorld(objectId)

	if Server then
	
		ameliaFortIkonId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, fortIkonAmeliaStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaENPCAmelia.fortIkonAmeliaOnDestroy = ClearObjectUserdata



-- Teleport Amelia from Fort Ikon to Devil's Crossing

local ameliaTransition = false

function gd.quests.areaENPCAmelia.transition()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAE_NPCS") && ameliaTransition == false then
			ameliaTransition = true
			
			local ameliaFortIkon = Entity.Get(ameliaFortIkonId)
			local ameliaDevilsCrossing = Entity.Get(ameliaDevilsCrossingId)
	
			if (ameliaFortIkon != nil) then
		
				local coords = ameliaFortIkon:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(ameliaFortIkonId, fortIkonAmeliaStateObjects)
			
			end
		
			if (ameliaDevilsCrossing != nil) then
		
				local coords = ameliaDevilsCrossing:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(ameliaDevilsCrossingId, devilsCrossingAmeliaStateObjects)
			
			end
		
		end
		
	end
	
end



--
-- Amelia's Father transition states
--

local FatherState = { Default = 0, Intro = 1, Lost = 2, Found = 3}
local fatherLostId = 0
local fatherDevilsCrossingId = 0

--Father in the Ugdenbog
local fatherForestStateObjects = orderedTable();
	fatherForestStateObjects["AREAE_LOSTFATHERFOUND"] = { state = FatherState.Found,  dbr = nil }
	fatherForestStateObjects["AREAE_NPCS"] = { state = FatherState.Lost, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_lostfather_01.dbr"}
	fatherForestStateObjects["AREAE_INTRO"] = { state = FatherState.Intro, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_lostfather_01.dbr"}
	fatherForestStateObjects[""] = { state = FatherState.Default, dbr = nil }

function gd.quests.areaENPCAmelia.fatherForestOnAddToWorld(objectId)

	if Server then
	
		fatherLostId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, fatherForestStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaENPCAmelia.fatherForestOnDestroy = ClearObjectUserdata

--Father in Devil's Crossing
local fatherDevilsCrossingStateObjects = orderedTable();
	fatherDevilsCrossingStateObjects["AREAE_LOSTFATHERFOUND"] = { state = FatherState.Found,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_lostfather_02.dbr" }
	fatherDevilsCrossingStateObjects[""] = { state = FatherState.Default, dbr = nil }

function gd.quests.areaENPCAmelia.fatherDevilsCrossingOnAddToWorld(objectId)

	if Server then
	
		fatherDevilsCrossingId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, fatherDevilsCrossingStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaENPCAmelia.fatherDevilsCrossingOnDestroy = ClearObjectUserdata

-- Father transitions back to DC
local fatherTeleported = false

function gd.quests.areaENPCAmelia.lostFatherTransitionGlobalMP()

	GiveTokenToLocalPlayer("AREAE_LOSTFATHERFOUND")
	
end

function gd.quests.areaENPCAmelia.lostFatherTransition()
	
	if Server && not fatherTeleported then
		fatherTeleported = true
		
		local fatherLost = Entity.Get(fatherLostId)
		local fatherDevilsCrossing = Entity.Get(fatherDevilsCrossingId)
		
		GiveTokenToLocalPlayer("AREAE_LOSTFATHERFOUND")
		
		QuestGlobalEvent("lostFatherRescueToken")
	
		if (fatherLost != nil) then
		
			local coords = fatherLost:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(fatherLostId, fatherForestStateObjects)
		
		end
		
		if (fatherDevilsCrossing != nil) then
		
			local coords = fatherDevilsCrossing:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(fatherDevilsCrossingId, fatherDevilsCrossingStateObjects)
		
		end

	end

end

-- Teleports Amelia to Fort Ikon and the father to Darkwood
local introSpawn = false

function gd.quests.areaENPCAmelia.introTransition()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAE_INTRO") && introSpawn == false then
			introSpawn = true
			
			local ameliaFortIkon = Entity.Get(ameliaFortIkonId)
			local father = Entity.Get(fatherLostId)
		
			if (ameliaFortIkon != nil) then
		
				local coords = ameliaFortIkon:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(ameliaFortIkonId, fortIkonAmeliaStateObjects)
			
			end

			if (father != nil) then
		
				local coords = father:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(fatherLostId, fatherForestStateObjects)
			
			end
		
		end
		
	end
	
end
