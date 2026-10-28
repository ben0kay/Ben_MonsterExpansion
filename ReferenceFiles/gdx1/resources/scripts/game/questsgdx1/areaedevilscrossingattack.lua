/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.devilsCrossingAttack = {}

--
-- transition for various parts of DC affected by the colossus attack
--

local aetherCracksId = 0
local gateEntranceId = 0
local merchantAreaId = 0
local mapleTreeId = 0
local tombstoneIds = {0, 0, 0, 0}
local tombstoneStateObjects = { }
local tombstoneSpawned = {false, false, false, false}

local AttackState = { Default = 0, Attacked = 1, AttackedFinal = 3 }

-- Tombstone 01
local tombstone01StateObjects = orderedTable();
	tombstone01StateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/signs/tombstone_sahdina_01.dbr"};
	tombstone01StateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/signs/tombstone_sahdina_01.dbr"};
	tombstone01StateObjects[""] 					= { state = AttackState.Default, dbr = nil };

function gd.quests.devilsCrossingAttack.tombstoneOneOnAddToWorld(objectId)

	if Server && not tombstoneSpawned[1] then
	
		tombstoneIds[1] = objectId;
		tombstoneStateObjects[1] = tombstone01StateObjects
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, tombstone01StateObjects);
		Shared.setUserdata(objectId, userdata);
			
		if (newState == AttackState.Attacked || newState == AttackState.AttackedFinal) then
			tombstoneSpawned[1] = true
		end
		
	end
	
end

gd.quests.devilsCrossingAttack.tombstoneOnDestroy = ClearObjectUserdata

-- Tombstone 02
local tombstone02StateObjects = orderedTable();
	tombstone02StateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/signs/tombstone_rook_01.dbr"};
	tombstone02StateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/signs/tombstone_rook_01.dbr"};
	tombstone02StateObjects[""] 					= { state = AttackState.Default, dbr = nil };

function gd.quests.devilsCrossingAttack.tombstoneTwoOnAddToWorld(objectId)

	if Server && not tombstoneSpawned[2] then
	
		tombstoneIds[2] = objectId;
		tombstoneStateObjects[2] = tombstone02StateObjects
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, tombstone02StateObjects);
		Shared.setUserdata(objectId, userdata);
	
		if (newState == AttackState.Attacked || newState == AttackState.AttackedFinal) then
			tombstoneSpawned[2] = true
		end
		
	end
	
end

-- Tombstone 03
local tombstone03StateObjects = orderedTable();
	tombstone03StateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/signs/tombstone_harmond_01.dbr"};
	tombstone03StateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/signs/tombstone_harmond_01.dbr"};
	tombstone03StateObjects[""] 					= { state = AttackState.Default, dbr = nil };

function gd.quests.devilsCrossingAttack.tombstoneThreeOnAddToWorld(objectId)

	if Server && not tombstoneSpawned[3] then
	
		tombstoneIds[3] = objectId;
		tombstoneStateObjects[3] = tombstone03StateObjects
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, tombstone03StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		if (newState == AttackState.Attacked || newState == AttackState.AttackedFinal) then
			tombstoneSpawned[3] = true
		end
		
	end
	
end

-- Tombstone 04
local tombstone04StateObjects = orderedTable();
	tombstone04StateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/signs/tombstone_kerrick_01.dbr"};
	tombstone04StateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/signs/tombstone_kerrick_01.dbr"};
	tombstone04StateObjects[""] 					= { state = AttackState.Default, dbr = nil };

function gd.quests.devilsCrossingAttack.tombstoneFourOnAddToWorld(objectId)

	if Server && not tombstoneSpawned[4] then
	
		tombstoneIds[4] = objectId;
		tombstoneStateObjects[4] = tombstone04StateObjects
		
		local userdata = {};
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, tombstone04StateObjects);
		Shared.setUserdata(objectId, userdata);
		
		if (newState == AttackState.Attacked || newState == AttackState.AttackedFinal) then
			tombstoneSpawned[4] = true
		end
		
	end
	
end

-- Aether Cracks
local aetherCracksStateObjects = orderedTable();
	aetherCracksStateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/questassets/dc_decalaether01_after.dbr"};
	aetherCracksStateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/questassets/dc_decalaether01_after.dbr"};
	aetherCracksStateObjects[""] 					= { state = AttackState.Default, dbr = nil };

function gd.quests.devilsCrossingAttack.aetherCracksOnAddToWorld(objectId)

	if Server then
	
		aetherCracksId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, aetherCracksStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.aetherCracksOnDestroy = ClearObjectUserdata


-- Gate Entrance
local gateEntranceStateObjects = orderedTable();
	gateEntranceStateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/questassets/dc_gateentrance01_after.dbr"};
	gateEntranceStateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/questassets/dc_gateentrance01_after.dbr"};
	gateEntranceStateObjects[""] 					= { state = AttackState.Default, dbr = "records/storyelements/questassets/dc_gateentrance01_before.dbr" };

function gd.quests.devilsCrossingAttack.gateEntranceOnAddToWorld(objectId)

	if Server then
	
		gateEntranceId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, gateEntranceStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.gateEntranceOnDestroy = ClearObjectUserdata


-- Merchant Area
local merchantAreaStateObjects = orderedTable();
	merchantAreaStateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/questassets/dc_merchantareanew_after.dbr"};
	merchantAreaStateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/questassets/dc_merchantareanew_after.dbr"};
	merchantAreaStateObjects[""] 					= { state = AttackState.Default, dbr = "records/storyelements/questassets/dc_merchantareanew_before.dbr" };

function gd.quests.devilsCrossingAttack.merchantAreaOnAddToWorld(objectId)

	if Server then
	
		merchantAreaId = objectId
		
		local player = Game.GetLocalPlayer()
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (player:HasToken("AREAE_INTRO") ||player:HasToken("AREAE_NPCS")) && Game.GetGameDifficulty() == Game.Difficulty.Legendary then
			MPOverrideDbr = "records/storyelements/questassets/dc_merchantareanew_afterultimate.dbr"
			MPOverrideState = true
			
		end

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, merchantAreaStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.merchantAreaOnDestroy = ClearObjectUserdata


-- Maple Tree
local mapleTreeStateObjects = orderedTable();
	mapleTreeStateObjects["AREAE_NPCS"]	= { state = AttackState.AttackedFinal,  dbr = "records/storyelements/questassets/dc_treemaple01_after.dbr"};
	mapleTreeStateObjects["AREAE_INTRO"] 	= { state = AttackState.Attacked,  dbr = "records/storyelements/questassets/dc_treemaple01_after.dbr"};
	mapleTreeStateObjects[""] 					= { state = AttackState.Default, dbr = "records/storyelements/questassets/dc_treemaple01_before.dbr" };

function gd.quests.devilsCrossingAttack.mapleTreeOnAddToWorld(objectId)

	if Server then
	
		mapleTreeId = objectId

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, mapleTreeStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.mapleTreeOnDestroy = ClearObjectUserdata




local gateGuardId = 0
local harmondId = 0
local vendorId = 0
local blackLegionIds = {0, 0, 0, 0, 0, 0}
local blackLegionStateObjects = { }

-- Gate Guard
local gateGuardStateObjects = orderedTable();
	gateGuardStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = nil }
	gateGuardStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	gateGuardStateObjects[""]			= { state = AttackState.Default,  dbr = "records/creatures/npcs/flavornpcs/devilscrossing/gateguard01.dbr" }
	
function gd.quests.devilsCrossingAttack.gateGuardOnAddToWorld(objectId)

	if Server then
	
		gateGuardId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, gateGuardStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.gateGuardOnDestroy = ClearObjectUserdata

-- Harmond
local harmondStateObjects = orderedTable();
	harmondStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = nil }
	harmondStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	harmondStateObjects[""]			= { state = AttackState.Default,  dbr = "records/creatures/npcs/questnpcs/npc_harmond_01.dbr" }
	
function gd.quests.devilsCrossingAttack.harmondOnAddToWorld(objectId)

	if Server then
	
		harmondId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, harmondStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.harmondOnDestroy = ClearObjectUserdata

-- Vendor
local vendorStateObjects = orderedTable();
	vendorStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = nil }
	vendorStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	vendorStateObjects[""]			= { state = AttackState.Default,  dbr = "records/creatures/npcs/merchants/merchanta01.dbr" }
	
function gd.quests.devilsCrossingAttack.vendorOnAddToWorld(objectId)

	if Server then
	
		vendorId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, vendorStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.vendorOnDestroy = ClearObjectUserdata


-- Black Legion
local guardsSpawned = {false, false, false, false, false, false }

local blackLegionOneStateObjects = orderedTable();
	blackLegionOneStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_blacklegion_dcsergeant_01.dbr" }
	blackLegionOneStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	blackLegionOneStateObjects[""]			= { state = AttackState.Default,  dbr = nil }
	
function gd.quests.devilsCrossingAttack.blackLegionOneOnAddToWorld(objectId)

	if Server then
	
		blackLegionIds[1] = objectId;
		blackLegionStateObjects[1] = blackLegionOneStateObjects
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, blackLegionOneStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.devilsCrossingAttack.blackLegionOnDestroy = ClearObjectUserdata


local blackLegionTwoStateObjects = orderedTable();
	blackLegionTwoStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr" }
	blackLegionTwoStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	blackLegionTwoStateObjects[""]			= { state = AttackState.Default,  dbr = nil }
	
function gd.quests.devilsCrossingAttack.blackLegionTwoOnAddToWorld(objectId)

	if Server then
		if (not guardsSpawned[2]) then
			blackLegionIds[2] = objectId;
			blackLegionStateObjects[2] = blackLegionTwoStateObjects
			
			local userdata = {};
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, blackLegionTwoStateObjects);
			Shared.setUserdata(objectId, userdata);
			
			if (newState == AttackState.AttackedFinal) then
				guardsSpawned[2] = true
			end
		
		end
		
	end
	
end


local blackLegionThreeStateObjects = orderedTable();
	blackLegionThreeStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = "records/creatures/npcs/guard/guard_blacklegion_ranged_female01.dbr" }
	blackLegionThreeStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	blackLegionThreeStateObjects[""]			= { state = AttackState.Default,  dbr = nil }
	
function gd.quests.devilsCrossingAttack.blackLegionThreeOnAddToWorld(objectId)

	if Server then
		if (not guardsSpawned[3]) then
			blackLegionIds[3] = objectId;
			blackLegionStateObjects[3] = blackLegionThreeStateObjects
			
			local userdata = {};
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, blackLegionThreeStateObjects);
			Shared.setUserdata(objectId, userdata);
			
			if (newState == AttackState.AttackedFinal) then
				guardsSpawned[3] = true
			end
		
		end
		
	end
	
end


local blackLegionFourStateObjects = orderedTable();
	blackLegionFourStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = "records/creatures/npcs/guard/guard_blacklegion_ranged01.dbr" }
	blackLegionFourStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	blackLegionFourStateObjects[""]			= { state = AttackState.Default,  dbr = nil }
	
function gd.quests.devilsCrossingAttack.blackLegionFourOnAddToWorld(objectId)

	if Server then
		if (not guardsSpawned[4]) then
			blackLegionIds[4] = objectId;
			blackLegionStateObjects[4] = blackLegionFourStateObjects
			
			local userdata = {};
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, blackLegionFourStateObjects);
			Shared.setUserdata(objectId, userdata);
			
			if (newState == AttackState.AttackedFinal) then
				guardsSpawned[4] = true
			end
		
		end
		
	end
	
end


local blackLegionFiveStateObjects = orderedTable();
	blackLegionFiveStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee_female01.dbr" }
	blackLegionFiveStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	blackLegionFiveStateObjects[""]			= { state = AttackState.Default,  dbr = nil }
	
function gd.quests.devilsCrossingAttack.blackLegionFiveOnAddToWorld(objectId)

	if Server then
		if (not guardsSpawned[5]) then
			blackLegionIds[5] = objectId;
			blackLegionStateObjects[5] = blackLegionFiveStateObjects
			
			local userdata = {};
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, blackLegionFiveStateObjects);
			Shared.setUserdata(objectId, userdata);
			
			if (newState == AttackState.AttackedFinal) then
				guardsSpawned[5] = true
			end
		
		end
		
	end
	
end


local blackLegionSixStateObjects = orderedTable();
	blackLegionSixStateObjects["AREAE_NPCS"] = { state = AttackState.AttackedFinal,  dbr = "records/creatures/npcs/guard/guard_blacklegion_melee01.dbr" }
	blackLegionSixStateObjects["AREAE_INTRO"] = { state = AttackState.Attacked,  dbr = nil }
	blackLegionSixStateObjects[""]			= { state = AttackState.Default,  dbr = nil }
	
function gd.quests.devilsCrossingAttack.blackLegionSixOnAddToWorld(objectId)

	if Server then
		if (not guardsSpawned[6]) then
			blackLegionIds[6] = objectId;
			blackLegionStateObjects[6] = blackLegionSixStateObjects
			
			local userdata = {};
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, blackLegionSixStateObjects);
			Shared.setUserdata(objectId, userdata);
			
			if (newState == AttackState.AttackedFinal) then
				guardsSpawned[6] = true
			end
		
		end
		
	end
	
end


-- Called by conversation, swaps DC to the attacked state
local DCAttacked = false

function gd.quests.devilsCrossingAttack.attackTransition()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAE_INTRO") ||player:HasToken("AREAE_NPCS")) && not DCAttacked then
			DCAttacked = true
			
			local aetherCracks = Entity.Get(aetherCracksId)
			local gateEntrance = Entity.Get(gateEntranceId)
			local merchantArea = Entity.Get(merchantAreaId)
			local mapleTree = Entity.Get(mapleTreeId)
			
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			if Game.GetGameDifficulty() == Game.Difficulty.Legendary then
				MPOverrideDbr = "records/storyelements/questassets/dc_merchantareanew_afterultimate.dbr"
				MPOverrideState = true
			
			end
			
			if (aetherCracks != nil) then
				UpdateObjectSwap(aetherCracksId, aetherCracksStateObjects)
			end
			
			if (gateEntrance != nil) then
				UpdateObjectSwap(gateEntranceId, gateEntranceStateObjects)
			end
			
			if (merchantArea != nil) then
				UpdateObjectSwap(merchantAreaId, merchantAreaStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			end
			
			if (mapleTree != nil) then
				UpdateObjectSwap(mapleTreeId, mapleTreeStateObjects)
			end
			
			-- despawn spirit guide
			gd.quests.devilsCrossingNPCSpiritGuide.attackDespawnSpiritGuide()
			
			local gateGuard = Entity.Get(gateGuardId)
			local harmond = Entity.Get(harmondId)
			local vendor = Entity.Get(vendorId)
	
			if (gateGuard != nil) then
		
				local coords = gateGuard:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(gateGuardId, gateGuardStateObjects)
			
			end
		
			if (harmond != nil) then
		
				local coords = harmond:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(harmondId, harmondStateObjects)
			
			end
			
			if (vendor != nil) then
		
				local coords = vendor:GetCoords()
				local riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftStart != nil) then
					riftStart:NetworkEnable()
					riftStart:SetCoords(coords)
				end
			
				UpdateObjectSwap(vendorId, vendorStateObjects)
			
			end
			
			local tombstones = { }			
			local tombstonesTotal = table.getn(tombstoneIds)
		
			for id = 1, tombstonesTotal do
				tombstones[id] = Entity.Get(tombstoneIds[id])
				
				if (tombstones[id] != nil) then
					coords = tombstones[id]:GetCoords()
					riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (riftStart != nil) then
						riftStart:NetworkEnable()
						riftStart:SetCoords(coords)
					end
			
					UpdateObjectSwap(tombstoneIds[id], tombstoneStateObjects[id])
					
				end
			
			end

		end
		
	end
	
end


-- Transition Black Legion NPCs to DC
local blackLegionReinforce = false

function gd.quests.devilsCrossingAttack.blackLegionTransition()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAE_NPCS")) && not blackLegionReinforce then
			blackLegionReinforce = true

			local blackLegion = { }			
			local blackLegionTotal = table.getn(blackLegionIds)
		
			for id = 1, blackLegionTotal do
				blackLegion[id] = Entity.Get(blackLegionIds[id])
				
				if (blackLegion[id] != nil && guardsSpawned[id] == false) then
					coords = blackLegion[id]:GetCoords()
					riftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
					if (riftStart != nil) then
						riftStart:NetworkEnable()
						riftStart:SetCoords(coords)
					end
					
					guardsSpawned[id] = true
			
					UpdateObjectSwap(blackLegionIds[id], blackLegionStateObjects[id])
					
				end
			
			end

		end
		
	end
	
end
