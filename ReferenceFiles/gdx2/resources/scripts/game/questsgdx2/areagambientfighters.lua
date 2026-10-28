/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGAmbientFighters = {}

--Faction tokens
--AREAG_CHOSEFACTION_BYSMIEL
--AREAG_CHOSEFACTION_DREEG
--AREAG_CHOSEFACTION_SOLAEL

--AREAG_COVENBASERIFT_OPENED
--AREAG_COVENBASE_UNLOCKED
--AREAG_FORWARDCAMP_UNLOCKED
--AREAG_KORVAAKTOMB_STARTED



--
-- Ambient fighters for Korvan Plateau
--

local PlateauProxy01Spawned = false
local PlateauProxy02Spawned = false
local PlateauProxy03Spawned = false

function gd.quests.areaGAmbientFighters.plateauProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASERIFT_OPENED") && not PlateauProxy01Spawned then
			PlateauProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.plateauProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASERIFT_OPENED") && not PlateauProxy02Spawned then
			PlateauProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.plateauProxy03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASERIFT_OPENED") && not PlateauProxy03Spawned then
			PlateauProxy03Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

--
-- Ambient fighters for Cairan Docks & Sunbane Oasis
--

local CairanProxy01Spawned = false
local CairanProxy02Spawned = false
local CairanProxy03Spawned = false
local CairanProxy04Spawned = false

function gd.quests.areaGAmbientFighters.cairanProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASE_UNLOCKED") && not CairanProxy01Spawned then
			CairanProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end
		
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.cairanProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASE_UNLOCKED") && not CairanProxy02Spawned then
			CairanProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.cairanProxy03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASE_UNLOCKED") && not CairanProxy03Spawned then
			CairanProxy03Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.cairanProxy04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_COVENBASE_UNLOCKED") && not CairanProxy04Spawned then
			CairanProxy04Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

--
-- Ambient fighters for Ruins of Abyd, Basalt Crags, Forward Base
--
local basaltCragsProxy01Spawned = false
local basaltCragsProxy02Spawned = false
local basaltCragsProxy03Spawned = false
local basaltCragsProxy04Spawned = false

function gd.quests.areaGAmbientFighters.basaltCragsProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not basaltCragsProxy01Spawned then
			basaltCragsProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.basaltCragsProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not basaltCragsProxy02Spawned then
			basaltCragsProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.basaltCragsProxy03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not basaltCragsProxy03Spawned then
			basaltCragsProxy03Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.basaltCragsProxy04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not basaltCragsProxy04Spawned then
			basaltCragsProxy04Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

--
-- Ambient fighters for Infernal Wastes
--
local InfernalWastesProxy01Spawned = false
local InfernalWastesProxy02Spawned = false

function gd.quests.areaGAmbientFighters.infernalWastesProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not InfernalWastesProxy01Spawned then
			InfernalWastesProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end	
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.infernalWastesProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") && not InfernalWastesProxy02Spawned then
			InfernalWastesProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end	
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end


--
-- Ambient fighters for Korvan City
--
local KorvanCityProxy01Spawned = false
local KorvanCityProxy02Spawned = false
local KorvanCityProxy03Spawned = false
local KorvanCityProxy04Spawned = false

function gd.quests.areaGAmbientFighters.korvanCityProxy01OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_STARTED") && not KorvanCityProxy01Spawned then
			KorvanCityProxy01Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			-- Contains the quest summon, spawned as a champion.
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambientsummon_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end	
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.korvanCityProxy02OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_STARTED") && not KorvanCityProxy02Spawned then
			KorvanCityProxy02Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			local proxy = nil
			
			if player:HasToken("AREAG_CHOSEFACTION_BYSMIEL") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			elseif player:HasToken("AREAG_CHOSEFACTION_DREEG") then
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultdreeg_ambient_t.dbr", coords.origin)
			else
				proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			end	
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.korvanCityProxy03OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_STARTED") && not KorvanCityProxy03Spawned then
			KorvanCityProxy03Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultbysmiel_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end

function gd.quests.areaGAmbientFighters.korvanCityProxy04OnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAG_KORVAAKTOMB_STARTED") && not KorvanCityProxy04Spawned then
			KorvanCityProxy04Spawned = true
			local entity = Entity.Get(objectId)
			local coords = entity:GetCoords()
			
			local proxy = Proxy.Create("records/proxies/factionspawnsgdx2/faction_cultsolael_ambient_t.dbr", coords.origin)
			
			proxy:SetCoords(coords)
			
		end
		
	end
	
end


