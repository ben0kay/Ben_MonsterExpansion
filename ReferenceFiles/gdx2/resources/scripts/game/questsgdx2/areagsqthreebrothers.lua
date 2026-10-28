/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGThreeBrothers = {}


--
-- Three brothers sidequest. The player must find the first bother, who gives a key to unlock the tomb where the other brother's corpse can be found. 
-- The player interacts with the corpse which spawns the brother's ghost. The ghost explains the situation to the player which unlocks the secondary quest.
-- When the player kills the dude in the tomb the third brother's ghost is set free and he joins the other two.
--


local ThreeBrothersState = { PreQuest = 0, Rescued02 = 1, Found03 = 2, Rescued03 = 3 }
local Brother02LostId = 0
local Brother02RescuedId = 0
local Brother02FightingId = 0
local Brother03CorpseId = 0
local Brother03LostId = 0
local Brother03RescuedId = 0
local Brother03FightingId = 0

local Brother02Transition = false
local Brother03GhostTransition = false
local Brother03Transition = false



-- Brother 02 Injured
local brother02StateObjects = orderedTable();
	brother02StateObjects["AREAG_BOUNDSPIRITS_COMPLETE"] = { state = ThreeBrothersState.Rescued03, dbr = nil }
	brother02StateObjects["AREAG_3BROTHERS_RESCUED02"] = { state = ThreeBrothersState.Rescued02, dbr = nil }
	brother02StateObjects[""] = { state = ThreeBrothersState.PreQuest, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother02injured.dbr"}

function gd.quests.areaGThreeBrothers.brother02OnAddToWorld(objectId)
	
	if Server && not Brother02Transition then
		Brother02LostId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, brother02StateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGThreeBrothers.brother02OnDestroy = ClearObjectUserdata

-- Brother 02 Rescued
local brother02RescuedStateObjects = orderedTable();
	brother02RescuedStateObjects["AREAG_BOUNDSPIRITS_COMPLETE"] = { state = ThreeBrothersState.Rescued03, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother02rescued.dbr"}
	brother02RescuedStateObjects["AREAG_3BROTHERS_RESCUED02"] = { state = ThreeBrothersState.Rescued02, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother02rescued.dbr"}
	brother02RescuedStateObjects[""] = { state = ThreeBrothersState.PreQuest, dbr = nil }

function gd.quests.areaGThreeBrothers.brother02RescuedOnAddToWorld(objectId)
	
	if Server then
		Brother02RescuedId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if Brother02Transition then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother02rescued.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, brother02RescuedStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGThreeBrothers.brother02RescuedOnDestroy = ClearObjectUserdata

-- Brother 03 Corpse
local corpseSpawned = false

local brother03CorpseStateObjects = orderedTable();
	brother03CorpseStateObjects["AREAG_BOUNDSPIRITS_COMPLETE"] = { state = ThreeBrothersState.Rescued03, dbr = "records/items/lootchests/breakables/a01_bonepilehuman_01_break.dbr"}
	brother03CorpseStateObjects[""] = { state = ThreeBrothersState.PreQuest, dbr = "records/items/lootchests/questchests/questchest_areag_brother03corpse.dbr"}

function gd.quests.areaGThreeBrothers.brother03CorpseOnAddToWorld(objectId)
	
	if Server && not corpseSpawned then
		Brother03CorpseId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, brother03CorpseStateObjects)
		Shared.setUserdata(objectId, userdata);
		
		corpseSpawned =  true
	
	end
	
end

gd.quests.areaGThreeBrothers.brother03CorpseOnDestroy = ClearObjectUserdata

-- Brother 03 Ghost
local brother03LostStateObjects = orderedTable();
	brother03LostStateObjects["AREAG_BOUNDSPIRITS_COMPLETE"] = { state = ThreeBrothersState.Rescued03, dbr = nil }
	brother03LostStateObjects["AREAG_3BROTHERS_FOUND03"] = { state = ThreeBrothersState.Found03, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother03ghost_01.dbr"}
	brother03LostStateObjects[""] = { state = ThreeBrothersState.PreQuest, dbr = nil }

function gd.quests.areaGThreeBrothers.brother03GhostOnAddToWorld(objectId)
	
	if Server && not Brother03Transition then
		Brother03LostId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if Brother03GhostTransition then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother03ghost_01.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, brother03LostStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGThreeBrothers.brother03GhostOnDestroy = ClearObjectUserdata

-- Brother 03 Rescued
local brother03RescuedStateObjects = orderedTable();
	brother03RescuedStateObjects["AREAG_BOUNDSPIRITS_COMPLETE"] = { state = ThreeBrothersState.Rescued03, dbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother03ghost_02.dbr"}
	brother03RescuedStateObjects[""] = { state = ThreeBrothersState.PreQuest, dbr = nil }

function gd.quests.areaGThreeBrothers.brother03RescuedOnAddToWorld(objectId)
	
	if Server then
		Brother03RescuedId = objectId
		
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if Brother03Transition then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother03ghost_02.dbr"
			MPOverrideState = true
		
		end
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, brother03RescuedStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGThreeBrothers.brother03RescuedOnDestroy = ClearObjectUserdata

--
-- Rescue Brother 02 Transition
-- 
function gd.quests.areaGThreeBrothers.rescueBrother02()

	if Server && not Brother02Transition then
		local player = Game.GetLocalPlayer()

		Brother02Transition = true
			
		local brother02Lost = Entity.Get(Brother02LostId)
		local brother02Rescued = Entity.Get(Brother02RescuedId)
		local brother03Corpse = Entity.Get(Brother03CorpseId)
		
		local MPOverrideDbr01 = nil
		local MPOverrideDbr02 = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_3BROTHERS_RESCUED02") == false) then
			MPOverrideDbr02 = "records/creatures/npcs/questnpcs/gdareag/npc_brother02rescued.dbr"
			MPOverrideState = true
		end
	
		if (brother02Lost != nil) then
	
			local coords = brother02Lost:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(Brother02LostId, brother02StateObjects, nil, nil, MPOverrideState, MPOverrideDbr01)
		
		end
		
		if (brother02Rescued != nil) then
	
			local coords = brother02Rescued:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(Brother02RescuedId, brother02RescuedStateObjects, nil, nil, MPOverrideState, MPOverrideDbr02)
		
		end
		
		if (brother03Corpse != nil) then
	
			local coords = brother03Corpse:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(Brother03CorpseId, brother03CorpseStateObjects)
		
		end
		
	end

end
	
--
-- Brother 03 Corpse Interact
--
function gd.quests.areaGThreeBrothers.brother03CorpseInteract()

	QuestGlobalEvent("brother03FoundToken")

end

--
-- Brother 03 Found Token
--
function gd.quests.areaGThreeBrothers.Brother03FoundTokenMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x655E3E00
	local kTask = 0xAAB65A00
	
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState != QuestState.Complete) then
		GiveTokenToLocalPlayer("AREAG_3BROTHERS_FOUND03")
		
	end
	
end

--
-- Brother 03 Ghost Transition
--

function gd.quests.areaGThreeBrothers.Brother03GhostTransition()
	
	if Server && not Brother03GhostTransition then
		local player = Game.GetLocalPlayer()

		Brother03GhostTransition = true
		
		local brother03Lost = Entity.Get(Brother03LostId)
		
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAG_3BROTHERS_FOUND03") == false) then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareag/npc_brother03ghost_01.dbr"
			MPOverrideState = true
		end

		if (brother03Lost != nil) then
		
			print "brother transition"
			
			local coords = brother03Lost:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(Brother03LostId, brother03LostStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end
		
	end
	
end

--
-- Brother 03 Ghost Rescue Transition
--
function gd.quests.areaGThreeBrothers.rescueBrother03()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (Brother03Transition == false) then
			local player = Game.GetLocalPlayer()
			
			Brother03Transition = true
			
			local brother03Lost = Entity.Get(Brother03LostId)
			local brother03Rescued = Entity.Get(Brother03RescuedId)
			
			local MPOverrideDbr01 = nil
			local MPOverrideDbr02 = nil
			local MPOverrideState = false

			if (player:HasToken("AREAG_BOUNDSPIRITS_COMPLETE") == false) then
				MPOverrideDbr02 = "records/creatures/npcs/questnpcs/gdareag/npc_brother02rescued.dbr"
				MPOverrideState = true
			end
		
			if (brother03Lost != nil) then
		
				local coords = brother03Lost:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(Brother03LostId, brother03LostStateObjects, nil, nil, MPOverrideState, MPOverrideDbr01)
			
			end
			
			if (brother03Rescued != nil) then
		
				local coords = brother03Rescued:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(Brother03RescuedId, brother03RescuedStateObjects, nil, nil, MPOverrideState, MPOverrideDbr02)
			
			end
			
		end
		
	end

end

-- The Mad Priest - Kill credit.
function gd.quests.areaGThreeBrothers.madPriestKill()
	
	GiveTokenToLocalPlayer("AREAG_BOUNDSPIRITS_BOSSKILLED")
	
end
