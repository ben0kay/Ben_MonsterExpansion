/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaENPCUlgrim = {}

local ulgrimId = 0
local ulgrimHostileId = 0
local ulgrimHostile = false
local ulgrimDespawned = false

--
-- Area E - Ulgrim Transitions
--- 

local UlgrimVoidState = { Default = 0, VoidExit = 1, Bridge = 2, Hideout = 3, Hideout01 = 4, RebBase01 = 5, InnerCity = 6, Fighting = 7,  RebBase02 = 8 }


-- Ulgrim in the Void
local ulgrimStateObjects = orderedTable();
	ulgrimStateObjects["AREAF_NPCULGIRM_REBELBASE02"] = { state = UlgrimVoidState.RebBase02,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_FIGHTING"] = { state = UlgrimVoidState.Fighting,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_INNERCITY"] = { state = UlgrimVoidState.InnerCity,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_REBELBASE01"] = { state = UlgrimVoidState.RebBase01,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT01"] = { state = UlgrimVoidState.Hideout01,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_HIDEOUT"] = { state = UlgrimVoidState.Hideout,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_BRIDGE"] = { state = UlgrimVoidState.Bridge,  dbr = nil }
	ulgrimStateObjects["AREAF_NPCULGIRM_VOIDEXIT"] = { state = UlgrimVoidState.VoidExit, dbr = nil }
	ulgrimStateObjects[""] = { state = UlgrimVoidState.Default, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ulgrim_07.dbr"}
	
local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local minLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		minLevel = 50
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		minLevel = 70
		maxLevel = 120
	else
		minLevel = 90
		maxLevel = 120
	end
	
	if (averageLevel < minLevel) then
		monsterLevel = ((minLevel+(minLevel/50))+5)
	elseif (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+5)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+5)

	end

	return monsterLevel, nil

end

function gd.quests.areaENPCUlgrim.voidOnAddToWorld(objectId)

	if Server then
		ulgrimId = objectId;
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, ulgrimStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaENPCUlgrim.voidOnDestroy = ClearObjectUserdata

-- transition Ulgrim out of the void
local ulgrimVoidTransition = false

function gd.quests.areaENPCUlgrim.inVoidTransition()
	
	if Server && not ulgrimVoidTransition then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_NPCULGIRM_VOIDEXIT") then
			ulgrimVoidTransition = true
			
			local ulgrimVoid = Entity.Get(ulgrimId)
			
			if (ulgrimVoid != nil) then
			
				local coords = ulgrimVoid:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(ulgrimId, ulgrimStateObjects)
			
			end
		
		end
		
	end

end

-- Swap out Ulgrim to hostile for this session only
function gd.quests.areaENPCUlgrim.ulgrimDefeated()
	
	GiveTokenToLocalPlayer("AREAE_ULGRIM_ATTACKED")
	
end


function gd.quests.areaENPCUlgrim.hostileSwitch()
	
	if Server then
		local ulgrimVoid = Entity.Get(ulgrimId)
		
		if (ulgrimVoid != nil) then
			local MPOverrideDbr = "records/creatures/enemies/faction/ulgrim_void.dbr"
			local MPOverrideState = true
			
			local coords = ulgrimVoid:GetCoords()	
			local rift = Entity.Create("records/fx/skillclass04/shadowstrike1_target_fxpak.dbr")
			
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end

			UpdateObjectSwap(ulgrimId, ulgrimStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)
		
		end
	
	end

end


-- Token for Convincing Ulgrim
function gd.quests.areaENPCUlgrim.ulgrimConvincedGlobalMP()
	
	GiveTokenToLocalPlayer("AREAE_ULGRIM_CONVINCED")
	
end
