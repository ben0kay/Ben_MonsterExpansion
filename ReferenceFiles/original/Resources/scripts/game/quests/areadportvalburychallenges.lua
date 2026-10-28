/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaDPortValburyChallenges = {}


local doorRoomA01 = 0
local doorRoomA01Loaded = false
local doorRoomA02 = 0
local doorRoomA02Loaded = false
local doorRoomB01 = 0
local doorRoomB01Loaded = false
local doorRoomB02 = 0
local doorRoomB02Loaded = false
local doorRoomC01 = 0
local doorRoomC01Loaded = false
local doorRoomC02 = 0
local doorRoomC02Loaded = false

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
function gd.quests.areaDPortValburyChallenges.doorRoomA01OnAddToWorld(objectId)
	
	if Server then
		doorRoomA01 = objectId
		local door = Door.Get(objectId)
		
		if (not doorRoomA01Loaded) then
			door:Open()
			doorRoomA01Loaded = true
			
		end
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.doorRoomA02OnAddToWorld(objectId)
	
	if Server then
		doorRoomA02 = objectId
		local door = Door.Get(objectId)
		
		if (not doorRoomA02Loaded) then
			door:Open()
			doorRoomA02Loaded = true
			
		end
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.doorRoomB01OnAddToWorld(objectId)
	
	if Server then
		doorRoomB01 = objectId
		local door = Door.Get(objectId)
	
		if (not doorRoomB01Loaded) then
			door:Open()
			doorRoomB01Loaded = true
			
		end
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.doorRoomB02OnAddToWorld(objectId)
	
	if Server then
		doorRoomB02 = objectId
		local door = Door.Get(objectId)
	
		if (not doorRoomB02Loaded) then
			door:Open()
			doorRoomB02Loaded = true
			
		end
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.doorRoomC01OnAddToWorld(objectId)
	
	if Server then
		doorRoomC01 = objectId
		local door = Door.Get(objectId)
	
		if (not doorRoomC01Loaded) then
			door:Open()
			doorRoomC01Loaded = true
			
		end
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.doorRoomC02OnAddToWorld(objectId)
	
	if Server then
		doorRoomC02 = objectId
		local door = Door.Get(objectId)
	
		if (not doorRoomC02Loaded) then
			door:Open()
			doorRoomC02Loaded = true
			
		end
	
	end
	
end

-- Flames of Valbury
-- spawn data for randomized traps
local trapPointSpawned = {false, false, false, false, false, false, false, false, false, false, false, false}
local trapCoords = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local trapObjects = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local trapDbr = "records/creatures/anomalies/aetherfireflare_01.dbr"
local trapsActivated = false
local trapCooldown = 0

function gd.quests.areaDPortValburyChallenges.trapPoint01OnAddToWorld(objectId)

	if Server then
		trapCoords[1] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint02OnAddToWorld(objectId)

	if Server then
		trapCoords[2] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint03OnAddToWorld(objectId)

	if Server then
		trapCoords[3] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint04OnAddToWorld(objectId)

	if Server then
		trapCoords[4] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint05OnAddToWorld(objectId)

	if Server then
		trapCoords[5] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint06OnAddToWorld(objectId)

	if Server then
		trapCoords[6] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint07OnAddToWorld(objectId)

	if Server then
		trapCoords[7] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint08OnAddToWorld(objectId)

	if Server then
		trapCoords[8] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint09OnAddToWorld(objectId)

	if Server then
		trapCoords[9] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint10OnAddToWorld(objectId)

	if Server then
		trapCoords[10] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint11OnAddToWorld(objectId)

	if Server then
		trapCoords[11] = Entity.Get(objectId):GetCoords()
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapPoint12OnAddToWorld(objectId)

	if Server then
		trapCoords[12] = Entity.Get(objectId):GetCoords()
	
	end

end

-- Gauntlet Wave Event
local gauntletWaveChestId = 0
local gauntletWaveObjectId = 0

local gauntletWaveEventStarted = false
local gauntletWaveEventKey = "PORTVALBURY_GAUNTLETEVENT"

function gd.quests.areaDPortValburyChallenges.gauntletWaveEventChestOnAddToWorld(objectId)
	
	if Server then
		gauntletWaveChestId = objectId
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.gauntletWaveEventChestOpened()

	GiveTokenToLocalPlayer("AREAD_PORTVALBURY_GAUNTLET_COMPLETE")
	
end

function gd.quests.areaDPortValburyChallenges.gauntletWaveEventOnAddToWorld(objectId)

	if Server then
		gauntletWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, gauntletWaveEventKey)
	
	end

end

function gd.quests.areaDPortValburyChallenges.gauntletWaveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end

local function DespawnTraps()
	
	if Server then
		-- Despawn traps, if any are active.
		local totalTraps = table.getn(trapCoords)
		
		if totalTraps > 0 then
			for id = 1, totalTraps do
				if trapObjects[id] != nil && trapPointSpawned[id] then
					trapPointSpawned[id] = false
					trapObjects[id]:Destroy()
					trapObjects[id] = nil
				end
			end
		end
	
	end

end

function gd.quests.areaDPortValburyChallenges.endgauntletWaveEvent(objectId)

	if Server then
		local waveChest = Chest.Get(gauntletWaveChestId);
		openDoors(doorRoomA01, doorRoomA02)
	
		if (waveChest != nil) then
			waveChest:SetLocked(false)
		
			local coords = waveChest:GetCoords()
			local pfx = Entity.Create("records/fx/skillclass05/arcaneblast1_huge_radius_fxpak01.dbr")
			UI.Notify("tagNotification_WarningValburyFlames")
			
			if (pfx != nil) then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
			end
		
		end
		
		-- Despawn traps
		DespawnTraps()
	
	end
	
end

-- Periodic update to spawn and despawn traps
local trapsSpawned = 3
local trapSpawnChanceBonus = 80

function gd.quests.areaDPortValburyChallenges.updategauntletWaveEvent()

	if Server then
		-- Check to Spawn Random Traps
		local rand = random(1,100)
		
		local test = 20 + trapSpawnChanceBonus
		
		if rand <= test && not trapsActivated then
			-- Despawn existing traps
			DespawnTraps()
			
			-- reset bonus chance
			trapSpawnChanceBonus = 0
			
			local totalTraps = table.getn(trapCoords)
			trapsActivated = true
			
			-- increment traps spawned
			if trapsSpawned < totalTraps then
				trapsSpawned = trapsSpawned + 2
			
			end
			
			if trapsSpawned > 0 && trapsSpawned <= totalTraps then
				-- trap level data
				local averageLevel = Game.GetAveragePlayerLevel()
				local trapLevel = ((averageLevel+(averageLevel/50))+1)
				
				local selectedList = {}

				math.randomseed(Time.Now())
				
				while table.getn(selectedList) != trapsSpawned do
					local rand = random(1,totalTraps)
					local found = false
					
					if rand < totalTraps then
						for id = 1, table.getn(selectedList) do
							if rand == selectedList[id] then
								found = true
							
							end
						
						end
						
						if not found then
							table.insert(selectedList, rand)
						
						end
					
					end
				
				end
				
				for id = 1, table.getn(selectedList) do
					local spawnId = selectedList[id]
					if not trapPointSpawned[spawnId] then
						trapPointSpawned[spawnId] = true
						trapObjects[spawnId] = Character.Create (trapDbr, trapLevel, nil)
						trapObjects[spawnId]:SetCoords(trapCoords[spawnId])
						
					end
				
				end
			
			end
		
		elseif trapsActivated then
			trapCooldown = trapCooldown + 1
			
			if trapCooldown > 18 then
				trapCooldown = 0
				trapsActivated = false
			
			end
			
		else
			trapSpawnChanceBonus = trapSpawnChanceBonus + 20
		
		end
	
	end

end

local gauntletWaveParameters = { }
	gauntletWaveParameters.waves = {"records/proxies/boss&quest/proxy_aread_portvalbury_gauntletwave1.dbr", "records/proxies/boss&quest/proxy_aread_portvalbury_gauntletwave2.dbr", "records/proxies/boss&quest/proxy_aread_portvalbury_gauntletwave3.dbr"}
	gauntletWaveParameters.endCallback = gd.quests.areaDPortValburyChallenges.endgauntletWaveEvent
	gauntletWaveParameters.updateCallback = gd.quests.areaDPortValburyChallenges.updategauntletWaveEvent
	gauntletWaveParameters.key = gauntletWaveEventKey

function gd.quests.areaDPortValburyChallenges.startGauntletWaveEventMP()

	if Server then
		if (not gauntletWaveEventStarted) then
			gauntletWaveEventStarted = true

			closeDoors(doorRoomA01, doorRoomA02)
			
			WaveEvent_Start(gauntletWaveObjectId, gauntletWaveParameters)
		
		end
		
	end

end
	
function gd.quests.areaDPortValburyChallenges.startgauntletWaveEvent(triggererId)

	QuestEvent("portValburyStartGauntletEvent")

end


-- Challenge Rooms, randomized locations and events
-- Randomizes between Room B and Room C. Only spawns in one or the other

-- Determines which event is loaded
local ChallengeTrapRoomRandomizer = 0
local RoomLoaded = 0

local trapRoomStarted = false
local trapRoomCoords = nil
local trapRoomObjectId = 0
local trapRoomProxy = nil
local trapRoomChest = 0

local trapRoomFinished = false

local trapRoomEventKey = "PORTVALBURY_WAVEEVENTA"

local trapRoomReanimatorProxy = "records/proxies/boss&quest/proxy_aread_portvalbury_traproomreanimators.dbr"
local trapRoomHeroProxy = "records/proxies/boss&quest/proxy_aread_portvalbury_traproomheroes.dbr"
local trapRoomFillerProxy = "records/proxies/boss&quest/proxy_aread_portvalbury_traproomfiller.dbr"


function gd.quests.areaDPortValburyChallenges.endTrapRoomWaveEvent(objectId)
	
	if Server then
		local waveChest = Chest.Get(trapRoomChest)
		
		if RoomLoaded == 1 then
			openDoors(doorRoomB01, doorRoomB02)
		else
			openDoors(doorRoomC01, doorRoomC02)
	
		end
		
		if (waveChest != nil) then
			waveChest:SetLocked(false)
		
		end
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.endTrapRoomEvent()
	
	if Server then
		local waveChest = Chest.Get(trapRoomChest)

		Script.UnregisterForUpdate(trapRoomObjectId, "gd.quests.areaDPortValburyChallenges.updateStatus")
	
		if RoomLoaded == 1 then
			openDoors(doorRoomB01, doorRoomB02)
		else
			openDoors(doorRoomC01, doorRoomC02)
	
		end
	
		if (waveChest != nil) then
			waveChest:SetLocked(false)
		
		end
	
	end

end

function gd.quests.areaDPortValburyChallenges.updateStatus()
	
	if Server then
		if (not trapRoomFinished) then
			if trapRoomProxy != nil && trapRoomProxy:AllKilled() == true then
				trapRoomFinished = true
				gd.quests.areaDPortValburyChallenges.endTrapRoomEvent()
			
			end
		
		end
		
	end
	
end

local trapRoomWaveParameters = { }
	trapRoomWaveParameters.waves = {"records/proxies/boss&quest/proxy_aread_portvalbury_traproomwave1.dbr", "records/proxies/boss&quest/proxy_aread_portvalbury_traproomwave2.dbr", "records/proxies/boss&quest/proxy_aread_portvalbury_traproomwave3.dbr"}
	trapRoomWaveParameters.endCallback = gd.quests.areaDPortValburyChallenges.endTrapRoomWaveEvent
	trapRoomWaveParameters.key = trapRoomEventKey	

local function startTrapRoomEvent()

	if (not trapRoomStarted) then
		trapRoomStarted = true
		
		if RoomLoaded == 1 then
			closeDoors(doorRoomB01, doorRoomB02)
			
		else
			closeDoors(doorRoomC01, doorRoomC02)
			
		end

		if ChallengeTrapRoomRandomizer <= 40 then
			-- Event 1: Reanimators spawn
			trapRoomProxy = Proxy.Create(trapRoomReanimatorProxy, trapRoomCoords.origin)
			
		elseif ChallengeTrapRoomRandomizer <= 80 then
			-- Event 2: 2+ hero spawn
			trapRoomProxy = Proxy.Create(trapRoomHeroProxy, trapRoomCoords.origin)
			
		else
			-- Event 3: big waves of chthonians spawn
			WaveEvent_Start(trapRoomObjectId, trapRoomWaveParameters)
		end
	
		if trapRoomProxy != nil then
			trapRoomProxy:SetCoords(trapRoomCoords)
		
		end
		
	end

end

local function trapRoomSetup(objectId)

	trapRoomObjectId = objectId

	local entity = Entity.Get(objectId)
	trapRoomCoords = entity:GetCoords()
	
	if (ChallengeTrapRoomRandomizer == 0) then
		math.randomseed(Time.Now())
		ChallengeTrapRoomRandomizer = random(1,100)
	end
	
	if ChallengeTrapRoomRandomizer > 80 then
		WaveEvent_OnAddToWorld(objectId, trapRoomEventKey)
	
	elseif (ChallengeTrapRoomRandomizer <= 80 && trapRoomFinished == false) then
		Script.RegisterForUpdate(objectId, "gd.quests.areaDPortValburyChallenges.updateStatus", 1000)
		
	end

end

local function trapRoomCleanup(objectId)
		
	if ChallengeTrapRoomRandomizer > 80 then
		WaveEvent_OnRemoveFromWorld(objectId)
		
	elseif trapRoomFinished == false then
		Script.UnregisterForUpdate(objectId, "gd.quests.areaDPortValburyChallenges.updateStatus")
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.trapRoomChestOnAddToWorld(objectId)
	
	if Server then
		trapRoomChest = objectId
	
	end
	
end

-- Determine which room needs to be loaded

function gd.quests.areaDPortValburyChallenges.triggerTrapRoomEventMP()

	if Server then
		startTrapRoomEvent()
	
	end

end

function gd.quests.areaDPortValburyChallenges.triggerTrapRoomB(triggererId)
	
	QuestEvent("portValburyStartTrapRoomEvent")

end

function gd.quests.areaDPortValburyChallenges.triggerTrapRoomC(triggererId)

	QuestEvent("portValburyStartTrapRoomEvent")

end

function gd.quests.areaDPortValburyChallenges.trapRoomBOnAddToWorld(objectId)
	
	if Server then
		RoomLoaded = 1
		
		trapRoomSetup(objectId)
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapRoomCOnAddToWorld(objectId)
	
	if Server then
		RoomLoaded = 2
		
		trapRoomSetup(objectId)
	
	end

end

function gd.quests.areaDPortValburyChallenges.trapRoomBOnRemoveFromWorld(objectId)
	
	if Server then
		trapRoomCleanup(objectId)
	
	end
	
end

function gd.quests.areaDPortValburyChallenges.trapRoomCOnRemoveFromWorld(objectId)
	
	if Server then
		trapRoomCleanup(objectId)
	
	end
	
end
	

-- Trapped Chest event
local TrappedChestCoords01 = nil
local TrappedChestCoords02 = nil
local TrappedChestRandomizer01 = 0
local TrappedChestRandomizer02 = 0

function gd.quests.areaDPortValburyChallenges.trappedChest01OnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		TrappedChestCoords01 = entity:GetCoords()
	
		if (TrappedChestRandomizer01 == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer01 = random(1,100)
			
		end
	
	end

end

function gd.quests.areaDPortValburyChallenges.trappedChest01OpenedMP()
	
	if Server then		
		if TrappedChestRandomizer01 > 60 then
			local proxy = Proxy.Create("records/proxies/boss&quest/proxy_aread_portvalbury_trappedchest01.dbr", TrappedChestCoords01.origin)
			proxy:SetCoords(TrappedChestCoords01)
		
		end
	
	end

end

function gd.quests.areaDPortValburyChallenges.trappedChest01Opened()
	
	QuestEvent("portValburyTriggerTrappedChest01")

end


function gd.quests.areaDPortValburyChallenges.trappedChest02OnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		TrappedChestCoords02 = entity:GetCoords()
	
		if (TrappedChestRandomizer02 == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer02 = random(1,100)
			
		end
	
	end

end

function gd.quests.areaDPortValburyChallenges.trappedChest02OpenedMP()
	
	if Server then		
		if TrappedChestRandomizer02 > 60 then
			local proxy = Proxy.Create("records/proxies/boss&quest/proxy_aread_portvalbury_trappedchest02.dbr", TrappedChestCoords02.origin)
			proxy:SetCoords(TrappedChestCoords02)
		
		end
	
	end

end

function gd.quests.areaDPortValburyChallenges.trappedChest02Opened()
	
	QuestEvent("portValburyTriggerTrappedChest02")

end
