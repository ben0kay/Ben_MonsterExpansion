/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestFactionMalmouthDocks = {}

--
-- Rebel Fighters
--
local FighterStates = { Default = 0, Fighting = 1, Final = 2}
local fighterIds = {0, 0, 0, 0}
local fighterStateObjects = {nil, nil, nil, nil}
local fighterTargetId = 0
local fighterTargetCoords = nil

local function GuardCharacterCreateArgs()

	local maxLevel = 0
	local playerLevel = Game.GetAveragePlayerLevel()

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 110
	end
	
	if (playerLevel < maxLevel) then
		if playerLevel < 50 then
			maxLevel = 50
			
		else
			maxLevel = 0
		
		end
		
	end

	return maxLevel, nil
	
end

-- Fighter Target
function gd.quests.areaFQuestFactionMalmouthDocks.fighter01TargetOnAddToWorld(objectId)

	if Server then
		fighterTargetId = objectId
		fighterTargetCoords = Entity.Get(objectId):GetCoords()
	
	end

end

--Fighter 01
local RebelFighter01StateObjects = orderedTable();
	RebelFighter01StateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = nil}
	RebelFighter01StateObjects["AREAF_DOCKSFIGHTERS_ACTIVE"] = { state = FighterStates.Fighting,  dbr = "records/creatures/enemies/faction/malmouth_scriptdocks_melee_a01.dbr"}
	RebelFighter01StateObjects[""] = { state = FighterStates.Default, dbr = nil}

function gd.quests.areaFQuestFactionMalmouthDocks.Fighter01OnAddToWorld(objectId)
	
	if Server then
	
		fighterIds[1] = objectId
		fighterStateObjects[1] = RebelFighter01StateObjects
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelFighter01StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaFQuestFactionMalmouthDocks.FightersOnDestory = ClearObjectUserdata


--Fighter 02
local RebelFighter02StateObjects = orderedTable();
	RebelFighter02StateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final, dbr = nil}
	RebelFighter02StateObjects["AREAF_DOCKSFIGHTERS_ACTIVE"] = { state = FighterStates.Fighting, dbr = "records/creatures/enemies/faction/malmouth_scriptdocks_meleef_a01.dbr"}
	RebelFighter02StateObjects[""] = { state = FighterStates.Default, dbr = nil}

function gd.quests.areaFQuestFactionMalmouthDocks.Fighter02OnAddToWorld(objectId)
	
	if Server then
	
		fighterIds[2] = objectId
		fighterStateObjects[2] = RebelFighter02StateObjects
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelFighter02StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

--Fighter 03
local RebelFighter03StateObjects = orderedTable();
	RebelFighter03StateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = nil}
	RebelFighter03StateObjects["AREAF_DOCKSFIGHTERS_ACTIVE"] = { state = FighterStates.Fighting,  dbr = "records/creatures/enemies/faction/malmouth_scriptdocks_ranged_a01.dbr"}
	RebelFighter03StateObjects[""] = { state = FighterStates.Default, dbr = nil }

function gd.quests.areaFQuestFactionMalmouthDocks.Fighter03OnAddToWorld(objectId)
	
	if Server then
	
		fighterIds[3] = objectId
		fighterStateObjects[3] = RebelFighter03StateObjects
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelFighter03StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

--Fighter 04
local RebelFighter04StateObjects = orderedTable();
	RebelFighter04StateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = ""}
	RebelFighter04StateObjects["AREAF_DOCKSFIGHTERS_ACTIVE"] = { state = FighterStates.Fighting,  dbr = "records/creatures/enemies/faction/malmouth_scriptdocks_casterf_b01.dbr"}
	RebelFighter04StateObjects[""] = { state = FighterStates.Default, dbr = nil }

function gd.quests.areaFQuestFactionMalmouthDocks.Fighter04OnAddToWorld(objectId)
	
	if Server then
	
		fighterIds[4] = objectId
		fighterStateObjects[4] = RebelFighter04StateObjects
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, RebelFighter04StateObjects, Character, GuardCharacterCreateArgs)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

-- Aetherial Sentries
local sentry01Id = 0
local sentry01AvatarId = 0
local sentry02Id = 0
local sentry02AvatarId = 0
local sentry01Spawned = false
local sentry02Spawned = false

local Sentry01StateObjects = orderedTable();
	Sentry01StateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = nil}
	Sentry01StateObjects["AREAF_DOCKSFIGHTERS_ACTIVE"] = { state = FighterStates.Fighting,  dbr = "records/creatures/enemies/boss&quest/aetherialsentry_docks_01.dbr"}
	Sentry01StateObjects[""] = { state = FighterStates.Default, dbr = "records/creatures/enemies/boss&quest/aetherialsentry_docks_01.dbr"}
	
local Sentry02StateObjects = orderedTable();
	Sentry02StateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = nil}
	Sentry02StateObjects["AREAF_DOCKSFIGHTERS_ACTIVE"] = { state = FighterStates.Fighting,  dbr = "records/creatures/enemies/boss&quest/aetherialsentry_docks_02.dbr"}
	Sentry02StateObjects[""] = { state = FighterStates.Default, dbr = "records/creatures/enemies/boss&quest/aetherialsentry_docks_02.dbr"}

local function Sentry01CreateArgs()

	return 0, Entity.Get(sentry01Id):GetCoords().origin
	
end

local function Sentry02CreateArgs()

	return 0, Entity.Get(sentry02Id):GetCoords().origin
	
end
	
function gd.quests.areaFQuestFactionMalmouthDocks.sentry01OnAddToWorld(objectId)

	if Server && not sentry01Spawned then
		sentry01Spawned = true
		sentry01Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Sentry01StateObjects, Character, Sentry01CreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.sentry01AvatarOnAddToWorld(objectId)

	if Server then
		sentry01AvatarId = objectId;

	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.sentry02OnAddToWorld(objectId)

	if Server && not sentry02Spawned then
		sentry02Spawned = true
		sentry02Id = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, Sentry02StateObjects, Character, Sentry02CreateArgs)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.sentry02AvatarOnAddToWorld(objectId)

	if Server then
		sentry02AvatarId = objectId;

	end
	
end

gd.quests.areaFQuestFactionMalmouthDocks.sentryOnDestroy = ClearObjectUserdata

--
-- Wave Event within the Blackiron Docks
--
local DocksWaveObjectId = 0
local DocksWaveEventStarted = false
local DocksWaveEventKey = "AREAF_DOCKS_WAVEEVENT"


--Wave Object 
function gd.quests.areaFQuestFactionMalmouthDocks.waveEventOnAddToWorld(objectId)

	if Server then
		DocksWaveObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, DocksWaveEventKey)
	
	end

end

function gd.quests.areaFQuestFactionMalmouthDocks.waveEventOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end

--Wave event ends
local docksEvenFinished = false

function gd.quests.areaFQuestFactionMalmouthDocks.endDocksWaveEventGlobalMP()
	
	if not docksEvenFinished then
		
		local player = Game.GetLocalPlayer()
		docksEvenFinished = true

		local kQuest = 0x9CF4C900
		local kTask = 0xEC4C5000
		
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
		if (questTaskState == QuestState.InProgress) then
			GiveTokenToLocalPlayer("AREAF_MALMOUTHDOCKS_CLEARED")
		end
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.endDocksWaveEvent(objectId)

	if Server then
		QuestGlobalEvent("MalmouthDocksEndEvent")
		UI.Notify("tagNotification_AreaF_DocksEventFinished")
		
		local sentry01 = Character.Get(sentry01AvatarId)
		local sentry02 = Character.Get(sentry02AvatarId)
			
		if (sentry01 != nil) then
			sentry01:Kill()
			
		end
		
		if (sentry02 != nil) then
			sentry02:Kill()
			
		end
		
	end
	
end

--Wave event

local DocksWaveParameters = { }
	DocksWaveParameters.waves = {"records/proxies/boss&questgdx1/questproxy_waveevent_malmouthdocks_wave01.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthdocks_wave02.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthdocks_wave03.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthdocks_wave04.dbr", "records/proxies/boss&questgdx1/questproxy_waveevent_malmouthdocks_wave05.dbr"}
	DocksWaveParameters.endCallback = gd.quests.areaFQuestFactionMalmouthDocks.endDocksWaveEvent
	DocksWaveParameters.key = DocksWaveEventKey

--Player touches the event start trigger
local eventTriggered = false

function gd.quests.areaFQuestFactionMalmouthDocks.triggerWaveEvent(triggererId)

	if not eventTriggered then
		local player = Player.Get(triggererId)
		local questId = 0x9CF4C900
		local taskId = 0xEC4C5000
		
		local questTaskState = player:GetQuestTaskState(questId, taskId)

		if (player:HasToken("AREAF_MALMOUTHDOCKS_CLEARED") == false && questTaskState == QuestState.InProgress) then
			eventTriggered = true
			
			UI.Notify("tagNotification_AreaF_DocksRiftgateEvent")
			QuestEvent("MalmouthDocksStartEvent")
		
		end
		
	end
	
end
	
function gd.quests.areaFQuestFactionMalmouthDocks.startEventMP()

	if Server && not DocksWaveEventStarted then

		DocksWaveEventStarted = true

		WaveEvent_Start(DocksWaveObjectId, DocksWaveParameters)

		
		local fightersTotal = table.getn(fighterIds)
	
		
		for id = 1, fightersTotal do
			
			local NPCEntity = Entity.Get(fighterIds[id])
			
			if (NPCEntity != nil) then
				local coords = NPCEntity:GetCoords()
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
		
				UpdateObjectSwap(fighterIds[id], fighterStateObjects[id], Character, GuardCharacterCreateArgs)
				
				local fighter = Character.Get(fighterIds[id])
			
				if fighter != nil && fighterTargetCoords != nil then
					fighter:MoveAction(fighterTargetId, fighterTargetCoords, true)
				end
				
				
			end
		
		end

	end

end

-- Resistance Guards, spawned on subsequent visit after the docks are cleared
local guardSpawned01A = false
local guardSpawned02A = false
local guardSpawned01B = false
local guardSpawned02B = false

local guard01AStateObjects = orderedTable();
	guard01AStateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_melee01.dbr" }
	guard01AStateObjects[""] 			= { state = FighterStates.Default, dbr = nil }

function gd.quests.areaFQuestFactionMalmouthDocks.guard01AOnAddToWorld(objectId)

	if Server then
		if (not guardSpawned01A) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, guard01AStateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == FighterStates.Final) then
				guardSpawned01A = true
			end
			
		end
		
	end
	
end

gd.quests.areaFQuestFactionMalmouthDocks.guardsOnOnDestroy = ClearObjectUserdata

local guard02AStateObjects = orderedTable();
	guard02AStateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_melee_female01.dbr" }
	guard02AStateObjects[""] 			= { state = FighterStates.Default, dbr = nil }

function gd.quests.areaFQuestFactionMalmouthDocks.guard02AOnAddToWorld(objectId)

	if Server then
		if (not guardSpawned02A) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, guard02AStateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == FighterStates.Final) then
				guardSpawned02A = true
			end
			
		end
		
	end
	
end


local guard01BStateObjects = orderedTable();
	guard01BStateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_ranged01.dbr" }
	guard01BStateObjects[""] 			= { state = FighterStates.Default, dbr = nil }

function gd.quests.areaFQuestFactionMalmouthDocks.guard01BOnAddToWorld(objectId)

	if Server then
		if (not guardSpawned01B) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, guard01BStateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == FighterStates.Final) then
				guardSpawned01B = true
			end
			
		end
		
	end
	
end


local guard02BStateObjects = orderedTable();
	guard02BStateObjects["AREAF_MALMOUTHDOCKS_CLEARED"] = { state = FighterStates.Final,  dbr = "records/creatures/npcs/guard/areaf_guard_rebel_caster_female01.dbr" }
	guard02BStateObjects[""] 			= { state = FighterStates.Default, dbr = nil }

function gd.quests.areaFQuestFactionMalmouthDocks.guard02BOnAddToWorld(objectId)

	if Server then
		if (not guardSpawned02B) then
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, guard02BStateObjects, Character, GuardCharacterCreateArgs)
			
			Shared.setUserdata(objectId, userdata)
			
			if (newState == FighterStates.Final) then
				guardSpawned02B = true
			end
			
		end
		
	end
	
end

-- Door exit from the docks area
local docksExitDoorOpened = false
local docksExitDoorID =0

function gd.quests.areaFQuestFactionMalmouthDocks.docksExitDoorOnAddToWorld(objectId)
	
	if Server && not docksExitDoorOpened then
		
		docksExitDoorID = objectId
		
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_MALMOUTHDOCKS_CLEARED")) then
			docksExitDoorOpened = true
			
			local ExitDoor = Door.Get(docksExitDoorID)
			ExitDoor:SetLocked(false)
			Exitdoor:Open()

		end
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.docksExitDoorUnlock()
	
	local player = Game.GetLocalPlayer()
	
	if Server && not docksExitDoorOpened then
		
		if (player:HasToken("AREAF_MALMOUTHDOCKS_CLEARED")) then
			
			local Exitdoor01 = Door.Get(docksExitDoorID)
			
			if Exitdoor01 != nil then
				Exitdoor01:SetLocked(false)
				Exitdoor01:Open()
				docksExitDoorOpened = true
				
			end
		
		end
		
	end
	
end

-- Door to Docks Area
local docksDoorOpened = false
local docksDoorId = 0

function gd.quests.areaFQuestFactionMalmouthDocks.docksDoorInitialUpdate(objectId)
	
	if Server && not docksDoorOpened then
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_MALMOUTHDOCKS_CLEARED") || player:HasToken("AREAF_DOCKSFIGHTERS_ACTIVE")) then
			docksDoorOpened = true
			
			local door = Door.Get(objectId)
			door:SetLocked(false)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.docksDoorOnAddToWorld(objectId)
	
	if Server then
		docksDoorId = objectId
	
	end
	
end

function gd.quests.areaFQuestFactionMalmouthDocks.docksDoorUnlock()
	
	local player = Game.GetLocalPlayer()
	
	if Server && not docksDoorOpened then
		
		if (player:HasToken("AREAF_MALMOUTHDOCKS_CLEARED") || player:HasToken("AREAF_DOCKSFIGHTERS_ACTIVE")) then
			
			local door01 = Door.Get(docksDoorId)
			
			if door01 != nil then
				door01:SetLocked(false)
				door01:Open()
				docksDoorOpened = true
				
			end
		
		end
		
	end
	
end

