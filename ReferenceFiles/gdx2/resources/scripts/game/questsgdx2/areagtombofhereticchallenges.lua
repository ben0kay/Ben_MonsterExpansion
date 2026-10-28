/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGTombOfHereticChallenges = {}


local doorRoomA01 = 0
local doorRoomA01Loaded = false

local function openDoors(door01ObjectId)
	
	print "Opening Door"
	local door01 = Door.Get(door01ObjectId)
	
	if door01 != nil then
		door01:Open()
		
	end
	
end

local function closeDoors(door01ObjectId)
	
	print "Closing Door"
	local door01 = Door.Get(door01ObjectId)
	
	if door01 != nil then
		door01:Close()
		
	end
	
end

-- Challenge room Door setup
function gd.quests.areaGTombOfHereticChallenges.doorRoomA01OnAddToWorld(objectId)
	
	if Server then
		doorRoomA01 = objectId
		local door = Door.Get(objectId)
	
		if (not doorRoomA01Loaded) then
			door:Open()
			doorRoomA01Loaded = true
			
		end
	
	end
	
end

-- Floor 2 Gauntlet
local GauntletEventStarted = false
local GauntletEventFinished = false
local gauntletChestId = 0

-- Gauntlet Wave Event
local gauntletWaveObjectId = 0

local gauntletWaveEventStarted = false
local gauntletWaveEventKey = "TOMBOFHERETIC_GAUNTLETEVENT"

function gd.quests.areaGTombOfHereticChallenges.gauntletChestOnAddToWorld(objectId)
	
	if Server then
		gauntletChestId = objectId
	
	end
	
end

function gd.quests.areaGTombOfHereticChallenges.gauntletChestOpened()

	GiveTokenToLocalPlayer("AREAG_TOMBOFHERETIC_GAUNTLET_COMPLETE")
	
end

function gd.quests.areaGTombOfHereticChallenges.gauntletWaveEventOnAddToWorld(objectId)

	if Server then
		gauntletWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, gauntletWaveEventKey)
	
	end

end

function gd.quests.areaGTombOfHereticChallenges.gauntletWaveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end

function gd.quests.areaGTombOfHereticChallenges.endgauntletWaveEvent(objectId)

	if Server then
		GauntletEventFinished = true
		
		local waveChest = Chest.Get(gauntletChestId);
		openDoors(doorRoomA01)
	
		if (waveChest != nil) then
			waveChest:SetLocked(false)
	
		end
		
		UI.Notify("tagNotification_WarningTombOfHereticChallenge")
	
	end
	
end

local gauntletWaveParameters = { }
	gauntletWaveParameters.waves = {"records/proxies/boss&questgdx2/proxy_areag_roguelike_gauntletwave1.dbr", "records/proxies/boss&questgdx2/proxy_areag_roguelike_gauntletwave2.dbr", "records/proxies/boss&questgdx2/proxy_areag_roguelike_gauntletwave3.dbr"}
	gauntletWaveParameters.endCallback = gd.quests.areaGTombOfHereticChallenges.endgauntletWaveEvent
	gauntletWaveParameters.key = gauntletWaveEventKey

function gd.quests.areaGTombOfHereticChallenges.startGauntletEventMP()

	if Server then
		if (not GauntletEventStarted) then
			GauntletEventStarted = true

			closeDoors(doorRoomA01)
			
			WaveEvent_Start(gauntletWaveObjectId, gauntletWaveParameters)
		
		end
		
	end

end
	
function gd.quests.areaGTombOfHereticChallenges.startGauntletEvent(triggererId)

	QuestEvent("tombOfHereticStartGauntletEvent")

end

