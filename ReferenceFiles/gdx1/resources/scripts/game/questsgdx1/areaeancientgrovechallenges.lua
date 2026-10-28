/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEAncientGroveChallenges = {}


local doorRoomA01 = 0
local doorRoomA01Loaded = false
local doorRoomA02 = 0
local doorRoomA02Loaded = false

local function openDoors(door01ObjectId, door02ObjectId)
	
	print "Opening Doors"
	local door01 = Door.Get(door01ObjectId)
	local door02 = Door.Get(door02ObjectId)
	
	if door01 != nil then
		door01:Open()
		
	end
	
	if door02 != nil then
		door02:Open()
		
	end
	
end

local function closeDoors(door01ObjectId, door02ObjectId)
	
	print "Closing Doors"
	local door01 = Door.Get(door01ObjectId)
	local door02 = Door.Get(door02ObjectId)
	
	if door01 != nil then
		door01:Close()
		
	end
	
	if door02 != nil then
		door02:Close()
		
	end
	
end

-- Challenge room Door setup
function gd.quests.areaEAncientGroveChallenges.doorRoomA01OnAddToWorld(objectId)
	
	if Server then
		doorRoomA01 = objectId
		local door = Door.Get(objectId)
	
		if (not doorRoomA01Loaded) then
			door:Open()
			doorRoomA01Loaded = true
			
		end
	
	end
	
end

function gd.quests.areaEAncientGroveChallenges.doorRoomA02OnAddToWorld(objectId)
	
	if Server then
		doorRoomA02 = objectId
		local door = Door.Get(objectId)
	
	end
	
end


-- Floor 2 Gauntlet
local GauntletEventStarted = false
local GauntletEventFinished = false
local gauntletChestId = 0

-- spawn data for randomized traps
local aetherTrapPointSpawned = {false, false, false, false, false, false, false, false, false, false}
local aetherTrapCoords = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local aetherTrapObjects = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local aetherTrapDbr = { "records/creatures/anomalies/trap_aethershard_aetheraura_a01.dbr", "records/creatures/anomalies/trap_aethershard_aetherrain_a01.dbr" }
local aetherTrapsActivated = false
local aetherTrapsSpawned = 0

local chaosTrapPointSpawned = {false, false, false, false, false, false, false, false, false, false}
local chaosTrapCoords = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local chaosTrapObjects = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local chaosTrapDbr = { "records/creatures/anomalies/trap_chthonicshard_chaosburst_a01.dbr", "records/creatures/anomalies/trap_chthonicshard_chaosring_a01.dbr" }
local chaosTrapsActivated = false
local chaosTrapsSpawned = 0


local function DespawnTraps()
	
	if Server then
		-- Despawn aether traps, if any are active.
		local totalAetherTraps = table.getn(aetherTrapCoords)
		
		if totalAetherTraps > 0 then
			for id = 1, totalAetherTraps do
				if aetherTrapObjects[id] != nil then
					aetherTrapPointSpawned[id] = false
					aetherTrapObjects[id]:Destroy()
					aetherTrapObjects[id] = nil
				end
			end
		end
		
		-- Despawn chaos traps, if any are active.
		local totalChaosTraps = table.getn(chaosTrapCoords)
		
		if totalChaosTraps > 0 then
			for id = 1, totalChaosTraps do
				if chaosTrapObjects[id] != nil then
					chaosTrapPointSpawned[id] = false
					chaosTrapObjects[id]:Destroy()
					chaosTrapObjects[id] = nil
				end
			end
		end
	
	end

end


function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint01OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[1] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint02OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[2] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint03OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[3] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint04OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[4] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint05OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[5] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint06OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[6] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint07OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[7] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint08OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[8] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint09OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[9] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.aetherTrapPoint10OnAddToWorld(objectId)

	if Server then
		aetherTrapCoords[10] = Entity.Get(objectId):GetCoords()
	
	end

end


function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint01OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[1] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint02OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[2] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint03OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[3] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint04OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[4] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint05OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[5] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint06OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[6] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint07OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[7] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint08OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[8] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint09OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[9] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaEAncientGroveChallenges.chaosTrapPoint10OnAddToWorld(objectId)

	if Server then
		chaosTrapCoords[10] = Entity.Get(objectId):GetCoords()
	
	end

end


function gd.quests.areaEAncientGroveChallenges.gauntletEventAetherTrapMP()

	if Server && GauntletEventStarted && not GauntletEventFinished then
		-- Check to Spawn Random Traps
		
		-- if Traps were not spawned last trigger
		if not aetherTrapsActivated then
			print "spawning Aether Traps"
			local totalTraps = table.getn(aetherTrapCoords)
			aetherTrapsActivated = true
			
			-- increment traps spawned
			if aetherTrapsSpawned < totalTraps then
				aetherTrapsSpawned = aetherTrapsSpawned + 1
			
			end
			
			if aetherTrapsSpawned > 0 && aetherTrapsSpawned <= totalTraps then
				-- trap level data
				local averageLevel = Game.GetAveragePlayerLevel()
				local trapLevel = ((averageLevel+(averageLevel/50))+1)
				
				local selectedTrapId = 0

				math.randomseed(Time.Now())
				
				local attempts = 0

				while selectedTrapId == 0 && attempts < 50 do
					local rand = random(1,totalTraps)

					if rand < totalTraps then
						if aetherTrapPointSpawned[rand] == false then
							selectedTrapId = rand
						
						else
							attempts = attempts + 1
							
						end
					
					end
				
				end
				
				if not aetherTrapPointSpawned[selectedTrapId] && selectedTrapId <= totalTraps && selectedTrapId != 0 then
					local randDbr = random(1,2)
					
					if randDbr <= table.getn(aetherTrapDbr) then
						aetherTrapPointSpawned[selectedTrapId] = true
						aetherTrapObjects[selectedTrapId] = Character.Create (aetherTrapDbr[randDbr], trapLevel, nil)
						aetherTrapObjects[selectedTrapId]:SetCoords(aetherTrapCoords[selectedTrapId])
					
					end
					
				end
			
			end
		
		-- if traps were spawned last trigger, reset for next trigger, allowing a spawn
		else
			print "resetting Aether Traps"
			aetherTrapsActivated = false
		
		end
	
	end

end
	
function gd.quests.areaEAncientGroveChallenges.gauntletEventAetherTrapTriggered(triggererId)

	QuestEvent("ancientGroveGauntletEventAetherTrap")

end


function gd.quests.areaEAncientGroveChallenges.gauntletEventChaosTrapMP()

	if Server && GauntletEventStarted && not GauntletEventFinished then
		-- if Traps were not spawned last trigger
		if not chaosTrapsActivated then
			print "spawning Chaos Traps"
			local totalTraps = table.getn(chaosTrapCoords)
			chaosTrapsActivated = true
			
			-- increment traps spawned
			if chaosTrapsSpawned < totalTraps then
				chaosTrapsSpawned = chaosTrapsSpawned + 1
			
			end
			
			if chaosTrapsSpawned > 0 && chaosTrapsSpawned <= totalTraps then
				-- trap level data
				local averageLevel = Game.GetAveragePlayerLevel()
				local trapLevel = ((averageLevel+(averageLevel/50))+1)
				
				local selectedTrapId = 0

				math.randomseed(Time.Now())
				
				local attempts = 0
				
				while selectedTrapId == 0 && attempts < 50 do
					local rand = random(1,totalTraps)

					if rand < totalTraps then
						if chaosTrapPointSpawned[rand] == false then
							selectedTrapId = rand
						
						else
							attempts = attempts + 1
							
						end
					
					end
				
				end
				
				if not chaosTrapPointSpawned[selectedTrapId] && selectedTrapId <= totalTraps && selectedTrapId != 0 then
					local randDbr = random(1,2)
					
					if randDbr <= table.getn(chaosTrapDbr) then
						chaosTrapPointSpawned[selectedTrapId] = true
						chaosTrapObjects[selectedTrapId] = Character.Create (chaosTrapDbr[randDbr], trapLevel, nil)
						chaosTrapObjects[selectedTrapId]:SetCoords(chaosTrapCoords[selectedTrapId])
					
					end
					
				end
			
			end
		
		-- if traps were spawned last trigger, reset for next trigger, allowing a spawn
		else
			print "resetting Chaos Traps"
			chaosTrapsActivated = false
		
		end
	
	end

end
	
function gd.quests.areaEAncientGroveChallenges.gauntletEventChaosTrapTriggered(triggererId)

	QuestEvent("ancientGroveGauntletEventChaosTrap")

end

-- Gauntlet Wave Event
local gauntletWaveObjectId = 0

local gauntletWaveEventStarted = false
local gauntletWaveEventKey = "ANCIENTGROVE_GAUNTLETEVENT"

function gd.quests.areaEAncientGroveChallenges.gauntletChestOnAddToWorld(objectId)
	
	if Server then
		gauntletChestId = objectId
	
	end
	
end

function gd.quests.areaEAncientGroveChallenges.gauntletChestOpened()

	GiveTokenToLocalPlayer("AREAE_ANCIENTGROVE_GAUNTLET_COMPLETE")
	
end

function gd.quests.areaEAncientGroveChallenges.gauntletWaveEventOnAddToWorld(objectId)

	if Server then
		gauntletWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, gauntletWaveEventKey)
	
	end

end

function gd.quests.areaEAncientGroveChallenges.gauntletWaveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end

function gd.quests.areaEAncientGroveChallenges.endgauntletWaveEvent(objectId)

	if Server then
		GauntletEventFinished = true
		
		local waveChest = Chest.Get(gauntletChestId);
		openDoors(doorRoomA01, doorRoomA02)
	
		if (waveChest != nil) then
			waveChest:SetLocked(false)
	
		end
		
		-- Despawn traps
		DespawnTraps()
		
		UI.Notify("tagNotification_WarningAncientGroveChallenge")
	
	end
	
end

local gauntletWaveParameters = { }
	gauntletWaveParameters.waves = {"records/proxies/boss&questgdx1/proxy_areae_roguelike_gauntletwave1.dbr", "records/proxies/boss&questgdx1/proxy_areae_roguelike_gauntletwave2.dbr", "records/proxies/boss&questgdx1/proxy_areae_roguelike_gauntletwave3.dbr"}
	gauntletWaveParameters.endCallback = gd.quests.areaEAncientGroveChallenges.endgauntletWaveEvent
	gauntletWaveParameters.key = gauntletWaveEventKey

function gd.quests.areaEAncientGroveChallenges.startGauntletEventMP()

	if Server then
		if (not GauntletEventStarted) then
			GauntletEventStarted = true

			closeDoors(doorRoomA01, doorRoomA02)
			
			WaveEvent_Start(gauntletWaveObjectId, gauntletWaveParameters)
		
		end
		
	end

end
	
function gd.quests.areaEAncientGroveChallenges.startGauntletEvent(triggererId)

	QuestEvent("ancientGroveStartGauntletEvent")

end


-- Trapped Chest event
local TrappedChestCoords01 = nil
local TrappedChestCoords02 = nil
local TrappedChestCoords03 = nil
local TrappedChestCoords04 = nil
local TrappedChestRandomizer01 = 0
local TrappedChestRandomizer02 = 0
local TrappedChestRandomizer03 = 0
local TrappedChestRandomizer04 = 0

function gd.quests.areaEAncientGroveChallenges.trappedChest01OnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		TrappedChestCoords01 = entity:GetCoords()
	
		if (TrappedChestRandomizer01 == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer01 = random(1,100)
			
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest01OpenedMP()
	
	if Server then		
		if TrappedChestRandomizer01 > 60 then
			local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areae_ancientgrove_trappedchest_01.dbr", TrappedChestCoords01.origin)
			proxy:SetCoords(TrappedChestCoords01)
		
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest01Opened()
	
	QuestEvent("ancientGroveTriggerTrappedChest01")

end


function gd.quests.areaEAncientGroveChallenges.trappedChest02OnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		TrappedChestCoords02 = entity:GetCoords()
	
		if (TrappedChestRandomizer02 == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer02 = random(1,100)
			
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest02OpenedMP()
	
	if Server then		
		if TrappedChestRandomizer02 > 60 then
			local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areae_ancientgrove_trappedchest_01.dbr", TrappedChestCoords02.origin)
			proxy:SetCoords(TrappedChestCoords02)
		
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest02Opened()
	
	QuestEvent("ancientGroveTriggerTrappedChest02")

end


function gd.quests.areaEAncientGroveChallenges.trappedChest03OnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		TrappedChestCoords03 = entity:GetCoords()
	
		if (TrappedChestRandomizer03 == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer03 = random(1,100)
			
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest03OpenedMP()
	
	if Server then		
		if TrappedChestRandomizer03 > 60 then
			local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areae_ancientgrove_trappedchest_01.dbr", TrappedChestCoords03.origin)
			proxy:SetCoords(TrappedChestCoords03)
		
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest03Opened()
	
	QuestEvent("ancientGroveTriggerTrappedChest03")

end


function gd.quests.areaEAncientGroveChallenges.trappedChest04OnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		TrappedChestCoords04 = entity:GetCoords()
	
		if (TrappedChestRandomizer04 == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer04 = random(1,100)
			
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest04OpenedMP()
	
	if Server then		
		if TrappedChestRandomizer04 > 60 then
			local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areae_ancientgrove_trappedchest_01.dbr", TrappedChestCoords04.origin)
			proxy:SetCoords(TrappedChestCoords04)
		
		end
	
	end

end

function gd.quests.areaEAncientGroveChallenges.trappedChest04Opened()
	
	QuestEvent("ancientGroveTriggerTrappedChest04")

end


