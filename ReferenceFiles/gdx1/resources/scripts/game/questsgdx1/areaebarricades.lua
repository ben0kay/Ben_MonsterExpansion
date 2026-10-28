/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.areaEBarricades = {}

--
-- The blockade north of Burrwitch granting access to GDX content
--

local BurrwitchBlockadeState = { Active = 0, Destroyed = 1}

local burrwitchBlockadeId = 0
local spawnedBlockade = false

local burrwitchBlockadeStateObjects = orderedTable();
	burrwitchBlockadeStateObjects["AREAE_BURRWITCHBLOCKADE_CLEARED"]	= { state = BurrwitchBlockadeState.Destroyed,  dbr = nil }
	burrwitchBlockadeStateObjects[""] 								= { state = BurrwitchBlockadeState.Active, dbr = "records/storyelements/questassets/areae_burrwitchblockade_break.dbr" }

function gd.areaEBarricades.burrwitchBlockadeOnAddToWorld(objectId)

	if Server then

		if (not spawnedBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, burrwitchBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	
			spawnedBlockade = true
	
		end
		
	end
	
end

function gd.areaEBarricades.blockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		burrwitchBlockadeId = objectId
	
	end
	
end

gd.areaEBarricades.burrwitchBlockadeOnDestroy = ClearObjectUserdata
	
-- Interaction Site
local burwitchInteractionSiteStateObjects = orderedTable();
	burwitchInteractionSiteStateObjects["AREAE_BURRWITCHBLOCKADE_CLEARED"] = { state = BurrwitchBlockadeState.Destroyed,  dbr = nil }
	burwitchInteractionSiteStateObjects[""] = { state = BurrwitchBlockadeState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_burrwitchblockade.dbr" }

function gd.areaEBarricades.interactionSiteOnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, burwitchInteractionSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.areaEBarricades.interactionSiteOnDestroy = ClearObjectUserdata

-- Destroy Blockade
function gd.areaEBarricades.burrwitchBlockadeDestroyGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x48342280
	local kTask = 0xE89BDF00
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) then
			GiveTokenToLocalPlayer("AREAE_BURRWITCHBLOCKADE_CLEARED")
	end

end

function gd.areaEBarricades.burrwitchBlockadeDestroy()

	if Server then
		if burrwitchBlockadeId != 0 then
			local Blockade = Destructible.Get(burrwitchBlockadeId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			burrwitchBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		QuestGlobalEvent("burrwitchBlockadeToken")
		
	end

end

--
-- The Kraken barricade
--

local KrakenBlockadeState = { Active = 0, Destroyed = 1}

local KrakenBlockadeId = 0
local spawnedKrakenBlockade = false

local KrakenBlockadeStateObjects = orderedTable();
	KrakenBlockadeStateObjects["AREAE_KRAKENBLOCKADE_CLEARED"]	= { state = KrakenBlockadeState.Destroyed,  dbr = nil }
	KrakenBlockadeStateObjects[""] = { state = KrakenBlockadeState.Active, dbr = "records/storyelements/questassets/areae_debriswall_kraken_break.dbr" }

function gd.areaEBarricades.krakenBlockadeOnAddToWorld(objectId)

	if Server then

		if (not spawnedKrakenBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, KrakenBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
	
			spawnedKrakenBlockade = true

		end
		
	end
	
end

gd.areaEBarricades.krakenBlockadeOnDestroy = ClearObjectUserdata

function gd.areaEBarricades.krakenBlockadeAvatarOnAddToWorld(objectId)
	
	if Server then
		KrakenBlockadeId = objectId
	
	end
	
end


-- Interaction Site
local krakenInteractionSiteStateObjects = orderedTable();
	krakenInteractionSiteStateObjects["AREAE_KRAKENBLOCKADE_CLEARED"] = { state = KrakenBlockadeState.Destroyed,  dbr = nil }
	krakenInteractionSiteStateObjects[""] = { state = KrakenBlockadeState.Active, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_kraken_detonationsite.dbr" }

function gd.areaEBarricades.krakenInteractionSiteOnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, krakenInteractionSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.areaEBarricades.krakenInteractionSiteOnDestroy = ClearObjectUserdata

-- Destroy Blockade
function gd.areaEBarricades.krakenBlockadeDestroyGlobalMP()

	local player = Game.GetLocalPlayer()
		
	if (player != nil) then
		GiveTokenToLocalPlayer("AREAE_KRAKENBLOCKADE_CLEARED")
	end

end

function gd.areaEBarricades.krakenBlockadeDestroy()

	if Server then
		if KrakenBlockadeId != 0 then
			local Blockade = Destructible.Get(KrakenBlockadeId)
			local coords = Blockade:GetCoords()
			Blockade:Destroy(Vec(0,1,0), 1000, false)
			KrakenBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end

		QuestGlobalEvent("krakenBarricadeToken")
		
	end

end
