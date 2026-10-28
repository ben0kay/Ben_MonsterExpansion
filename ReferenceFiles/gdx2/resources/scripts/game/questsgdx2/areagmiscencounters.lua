/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGMiscEncounters = {}

--
-- Osyr Mummy Boss
--

-- Boss Door Control
local mummyOsyrDoor01 = 0
local mummyOsyrDoor02 = 0

function gd.quests.areaGMiscEncounters.mummyOsyrShortcutOnAddToWorld(objectId)
	
	if Server then
		mummyOsyrDoor01 = objectId
		
	end
	
end



function gd.quests.areaGMiscEncounters.mummyOsyrEntranceOnAddToWorld(objectId)
	
	if Server then
		mummyOsyrDoor02 = objectId
		
	end
	
end

-- Turrets
local turretIDs = { 0, 0, 0, 0 }

function gd.quests.areaGMiscEncounters.mummyTurretOnAddToWorld(objectId)

	if Server then
		local found = false
		local turretsTotal = table.getn(turretIDs)
		
		for id = 1, turretsTotal do
			if (turretIDs[id] == 0 && not found) then
				turretIDs[id] = objectId
				found = true
				
			end
			
		end
		
	end
	
end

function gd.quests.areaGMiscEncounters.mummyOsyrOnKill()
	
	-- open door
	if Server then
		local door01 = Door.Get(mummyOsyrDoor01)
		local door02 = Door.Get(mummyOsyrDoor02)	
	
		if door01 ~= nil then
			door01:Open()
		
		end
		
		if door02 ~= nil then
			door02:Open()
		
		end
		
		-- destroy turrets
		local turretsTotal = table.getn(turretIDs)
		
		for id = 1, turretsTotal do
			local character = Character.Get(turretIDs[id])
			
			if (character != nil) then
				character:Kill()
				
			end
		
		end
		
	end

end

-- Boss reset
local mummyOsyrId = 0

function gd.quests.areaGMiscEncounters.mummyOsyrAvatarOnAddToWorld(objectId)

	if Server then
		mummyOsyrId = objectId
	
	end

end

function gd.quests.areaGMiscEncounters.mummyOsyrLeaveRoom()

	if Server then
		-- Teleport boss back to spawn point if he is somehow kited out of boss room
		if (mummyOsyrId != 0) then
			local bossEntity = Character.Get(mummyOsyrId)

			if bossEntity != nil then
				local coords = bossEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				bossEntity:TeleportHome()
			
			end
			
		end
	
	end

end


-- Kymon Deserters
local kymonDeserter02LostId = 0
local kymonDeserter02RescueId = 0

local KymonDeserterState = { Lost = 0, Base = 1}

-- Kymon Deserter in Korvan
local KymonDeserter02LostStateObjects = orderedTable();
	KymonDeserter02LostStateObjects["AREAG_KYMONDESERTER02_RESCUED"] = { state = KymonDeserterState.Base, dbr = nil}
	KymonDeserter02LostStateObjects[""] = { state = KymonDeserterState.Lost, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_kymondeserter_01.dbr" }

function gd.quests.areaGMiscEncounters.KymonDeserter02LostOnAddToWorld(objectId)

	if Server then
		kymonDeserter02LostId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, KymonDeserter02LostStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaGMiscEncounters.KymonDeserter02OnDestroy = ClearObjectUserdata

-- Kymon Deserter in Sorrow's Bastion
local KymonDeserter02RescueStateObjects = orderedTable();
	KymonDeserter02RescueStateObjects["AREAG_KYMONDESERTER02_RESCUED"] = { state = KymonDeserterState.Base, dbr = "records/creatures/npcs/flavornpcs/gdareag/npc_kymondeserter_01b.dbr" }
	KymonDeserter02RescueStateObjects[""] = { state = KymonDeserterState.Lost, dbr = nil }

function gd.quests.areaGMiscEncounters.KymonDeserter02RescueOnAddToWorld(objectId)

	if Server then
		kymonDeserter02RescueId = objectId
	
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, KymonDeserter02RescueStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end


--Activated by conversation, teleports Deserter
local kymonDeserter02Rescued = false

function gd.quests.areaGMiscEncounters.kymonDeserter02TransitionGlobalMP()
	
	GiveTokenToLocalPlayer("AREAG_KYMONDESERTER02_RESCUED")

end

function gd.quests.areaGMiscEncounters.kymonDeserter02Transition()

	if Server && not kymonDeserter02Rescued then
		local player = Game.GetLocalPlayer()
		
		GiveTokenToLocalPlayer("AREAG_KYMONDESERTER02_RESCUED")
		
		QuestGlobalEvent("areaGKymonDeserter02RiftGlobalMP")

		kymonDeserter02Rescued = true
		
		local deserterLost = Entity.Get(kymonDeserter02LostId)
		local deserterRescued = Entity.Get(kymonDeserter02RescueId)
	
		if (deserterLost != nil) then
	
			local coords = deserterLost:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(kymonDeserter02LostId, KymonDeserter02LostStateObjects)
		
		end
		
		if (deserterRescued != nil) then
	
			local coords = deserterRescued:GetCoords()	
			local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (riftEnd != nil) then
				riftEnd:NetworkEnable()
				riftEnd:SetCoords(coords)
			end
		
			UpdateObjectSwap(kymonDeserter02RescueId, KymonDeserter02RescueStateObjects)
		
		end
		
	end

end



