/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.areaFBarricades = {}

--
-- The inner city gate must be destroyed with the rebel explosive
--

local BlockadeState = { Active = 0, Destroyed = 1}

local innerCityGateId = 0
local spawnedGate = false

-- Gate
local innerCityBlockadeStateObjects = orderedTable();
	innerCityBlockadeStateObjects[""] 								= { state = BlockadeState.Active, dbr = "records/storyelements/questassets/areaf_debriswall_innercitygates_break.dbr" }

function gd.areaFBarricades.innerCityGateOnAddToWorld(objectId)

	if Server then

		if (not spawnedGate) then
			spawnedGate = true

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, innerCityBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	

		end
		
	end
	
end

gd.areaFBarricades.innerCityGateOnDestroy = ClearObjectUserdata

function gd.areaFBarricades.innerCityBlockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		innerCityGateId = objectId
		
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAF_INNERCITYGATEDESTROYED")) then
			local Blockade = Destructible.Get(innerCityGateId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			innerCityGateId = 0
		
		end
	
	end
	
end
	
-- Detonation Site
local innerCityDetonationSiteStateObjects = orderedTable();
	innerCityDetonationSiteStateObjects["AREAF_INNERCITYGATEDESTROYED"]	= { state = BlockadeState.Destroyed,  dbr = nil }
	innerCityDetonationSiteStateObjects[""] 								= { state = BlockadeState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_innercitygate_detonationsite.dbr" }

function gd.areaFBarricades.innerCityDetonationSiteOnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, innerCityDetonationSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.areaFBarricades.innerCityDetonationSiteOnDestroy = ClearObjectUserdata

-- Destroy Blockade
function gd.areaFBarricades.innerCityBlockadeDestroyGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xDD67A400
	local kTask = 0xAC3CCE00
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.Complete) && (player:HasToken("AREAF_INNERCITYGATEDESTROYED") == false) then
		GiveTokenToLocalPlayer("AREAF_INNERCITYGATEDESTROYED")
	end

end

function gd.areaFBarricades.innerCityBlockadeDestroy()

	if Server then
		if innerCityGateId != 0 then
			local Blockade = Destructible.Get(innerCityGateId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			innerCityGateId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		QuestGlobalEvent("detonationInnerCityGatesToken")
		
	end

end


--
-- The blockade in the sewers, blocking off secret area
--
local sewerBlockadeId = 0
local spawnedSewerBlockade = false

local sewerBlockadeStateObjects = orderedTable();
	sewerBlockadeStateObjects["AREAF_SEWERBLOCKADE_CLEARED"]	= { state = BlockadeState.Destroyed,  dbr = nil }
	sewerBlockadeStateObjects[""] 								= { state = BlockadeState.Active, dbr = "records/storyelements/questassets/areaf_debriswall_sewer_break.dbr" }

function gd.areaFBarricades.sewerBlockadeOnAddToWorld(objectId)

	if Server then

		if (not spawnedSewerBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, sewerBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	
			spawnedSewerBlockade = true
	
		end
		
	end
	
end

function gd.areaFBarricades.sewerBlockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		sewerBlockadeId = objectId
	
	end
	
end

gd.areaFBarricades.sewerBlockadeOnDestroy = ClearObjectUserdata
	
-- Interaction Site
local sewerInteractionSiteStateObjects = orderedTable();
	sewerInteractionSiteStateObjects["AREAF_SEWERBLOCKADE_CLEARED"] = { state = BlockadeState.Destroyed,  dbr = nil }
	sewerInteractionSiteStateObjects[""] = { state = BlockadeState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_sewer_detonationsite.dbr" }

function gd.areaFBarricades.sewerInteractionSiteOnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, sewerInteractionSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.areaFBarricades.interactionSiteOnDestroy = ClearObjectUserdata

-- Destroy Blockade
function gd.areaFBarricades.sewerBlockadeDestroyGlobalMP()

	GiveTokenToLocalPlayer("AREAF_SEWERBLOCKADE_CLEARED")

end

function gd.areaFBarricades.sewerBlockadeDestroy()

	if Server then
		if sewerBlockadeId != 0 then
			local Blockade = Destructible.Get(sewerBlockadeId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			sewerBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		QuestGlobalEvent("sewerBarricadeToken")
		
	end

end

--
-- Steelcap shortcut blockade
--

local SteelcapBlockadeState = { Active = 0, Destroyed = 1}

local SteelcapBlockadeId = 0
local spawnedSteelcapBlockade = false

-- Blockade
local SteelcapBlockadeStateObjects = orderedTable();
	SteelcapBlockadeStateObjects["STEELCAPSHORTCUT_CLEARED"] = { state = SteelcapBlockadeState.Destroyed,  dbr = nil }
	SteelcapBlockadeStateObjects[""] = { state = SteelcapBlockadeState.Active, dbr = "records/storyelements/questassets/areaf_steelcapshortcut_break.dbr" }

function gd.areaFBarricades.SteelcapBlockadeOnAddToWorld(objectId)

	if Server then
		if (not spawnedSteelcapBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, SteelcapBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
		
			spawnedSteelcapBlockade = true
		
		end
		
	end
	
end

gd.areaFBarricades.SteelcapBlockadeOnDestroy = ClearObjectUserdata

function gd.areaFBarricades.SteelcapBlockadeAvatarOnAddToWorld(objectId)

	if Server then
		SteelcapBlockadeId = objectId
		
	end
	
end

-- Detonation Site
local SteelcapDetonationSiteStateObjects = orderedTable();
	SteelcapDetonationSiteStateObjects["STEELCAPSHORTCUT_CLEARED"]	= { state = SteelcapBlockadeState.Destroyed,  dbr = nil }
	SteelcapDetonationSiteStateObjects[""] 								= { state = SteelcapBlockadeState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_steelcapshortcut_detonationsite.dbr" }

function gd.areaFBarricades.SteelcapDetonationSiteOnAddToWorld(objectId)

	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, SteelcapDetonationSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.areaFBarricades.SteelcapDetonationSiteOnDestroy = ClearObjectUserdata

-- Destroy Blockade
function gd.areaFBarricades.SteelcapBlockadeDestroyGlobalMP()

	GiveTokenToLocalPlayer("STEELCAPSHORTCUT_CLEARED")

end

function gd.areaFBarricades.SteelcapBlockadeDestroy()

	if Server then
		
		if SteelcapBlockadeId != 0 then
		
			local SteelcapBlockade = Destructible.Get(SteelcapBlockadeId)
			local coords = SteelcapBlockade:GetCoords()
			SteelcapBlockade:Destroy(Vec(0,1,0), 1000, false)
			SteelcapBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end
	
		QuestGlobalEvent("steelcapShortcutToken")
	
	end
	
end
