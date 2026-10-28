/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestFactionWitchRitual = {}


--
-- Necro Ritual
--

-- Fetish Site
local ritualFetishId = 0
local ritualFetishState = {Default = 0, PreRitual = 1, RitualStart = 2, DuringRitual = 3, RitualFinished = 4}
local ritualActive = false
local ritualFinished = false
local ritualUnlocked = false

-- Witch Ward01
local ritualFetishStateObjects = orderedTable();
	ritualFetishStateObjects["AREAE_COVENRITUAL_FINISHED"] = { state = ritualFetishState.DuringRitual,  dbr = "records/storyelements/questassets/areae_witchritualtotem_03.dbr" }
	ritualFetishStateObjects["AREAE_COVENRITUAL_UNLOCKED"] = { state = ritualFetishState.RitualStart,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_ritualfetish.dbr" }
	ritualFetishStateObjects["AREAE_COVENRITUAL_RETURNED"] = { state = ritualFetishState.PreRitual,  dbr = "records/storyelements/questassets/areae_witchritualtotem_01.dbr" }
	ritualFetishStateObjects[""] = { state = ritualFetishState.Default, dbr = "records/storyelements/questassets/areae_witchritualtotem_00.dbr" }


function gd.quests.areaEQuestFactionWitchRitual.witchFetishOnAddToWorld(objectId)
	
	if Server then
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		ritualFetishId = objectId
		
		if ritualFinished then
			MPOverrideDbr = "records/storyelements/questassets/areae_witchritualtotem_03.dbr"
			MPOverrideState = true
			
		elseif ritualActive then
			MPOverrideDbr = "records/storyelements/questassets/areae_witchritualtotem_02.dbr"
			MPOverrideState = true
		
		elseif ritualUnlocked then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_ritualfetish.dbr"
			MPOverrideState = true
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, ritualFetishStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWitchRitual.witchFetishOnDestroy = ClearObjectUserdata

-- Activate Fetish
local fetishRitualSwap = false

function gd.quests.areaEQuestFactionWitchRitual.witchFetishRitualSwap()

	if Server then
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
	
		if not fetishRitualSwap then
			if player:HasToken("AREAE_COVENRITUAL_FINISHED") || ritualFinished then
				fetishRitualSwap = true
				ritualActive = false
				
				MPOverrideDbr = "records/storyelements/questassets/areae_witchritualtotem_03.dbr"
				MPOverrideState = true
			end
			
			if ritualActive then
				MPOverrideDbr = "records/storyelements/questassets/areae_witchritualtotem_02.dbr"
				MPOverrideState = true
				
			end

			local FetishEntity = Entity.Get(ritualFetishId)
			if (FetishEntity != nil) then
			
				local coords = FetishEntity:GetCoords()
				local fx = nil
				
				if ritualFinished then
					fx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				else
					fx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				end
			
				if (fx != nil) then
					fx:NetworkEnable()
					fx:SetCoords(coords)
				end

				UpdateObjectSwap(ritualFetishId, ritualFetishStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
		
		end
	
	end

end

function gd.quests.areaEQuestFactionWitchRitual.witchFetishActivate()

	if Server then
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
	
		if not ritualUnlocked then
			if not player:HasToken("AREAE_COVENRITUAL_UNLOCKED") then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_ritualfetish.dbr"
				MPOverrideState = true
			end

			local FetishEntity = Entity.Get(ritualFetishId)
			
			if (FetishEntity != nil) then
			
				local coords = FetishEntity:GetCoords()
				local fx = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")

				if (fx != nil) then
					fx:NetworkEnable()
					fx:SetCoords(coords)
				end

				UpdateObjectSwap(ritualFetishId, ritualFetishStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
			
			ritualUnlocked = true
		
		end
	
	end

end





--Malostria at the ritual
local MalostriaId = 0

local MalostriaState = {Default = 0, Finished = 1}

local malostriaStateObjects = orderedTable()
	malostriaStateObjects["AREAE_COVENRITUAL_FINISHED"] = { state = MalostriaState.Finished,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchmalostria_01.dbr"}
	malostriaStateObjects[""] = { state = MalostriaState.Default,   dbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchmalostria_01.dbr" }
	
function gd.quests.areaEQuestFactionWitchRitual.malostriaOnAddToWorld(objectId)
	
	if Server then
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		MalostriaId = objectId
		
		if ritualActive then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchmalostria_02.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, malostriaStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.areaEQuestFactionWitchRitual.malostriaOnDestroy = ClearObjectUserdata

-- swap malostria during ritual
local malostriaSwap = false

function gd.quests.areaEQuestFactionWitchRitual.swapMalostria()

	if Server then
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
	
		if not malostriaSwap then
			if player:HasToken("AREAE_COVENRITUAL_FINISHED") || ritualFinished then
				malostriaSwap = true
				ritualActive = false
			end
			
			if ritualActive then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_witchmalostria_02.dbr"
				MPOverrideState = true
				
			end
			
			local MalostriaEntity = Entity.Get(MalostriaId)
		
			if (MalostriaEntity != nil) then
				UpdateObjectSwap(MalostriaId, malostriaStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
			
			end
		
		end
	
	end

end

function gd.quests.areaEQuestFactionWitchRitual.endRitual()
	if Server then
		
		-- swap Malostria back to dialogue NPC
		ritualFinished = true
		gd.quests.areaEQuestFactionWitchRitual.swapMalostria()
		
		-- Swap Fetish to Activated State
		gd.quests.areaEQuestFactionWitchRitual.witchFetishRitualSwap()
		
	end

end


-- Quest token for defeating boss while on quest
function gd.quests.areaEQuestFactionWitchRitual.bossKilled()
		local player = Game.GetLocalPlayer()

		if player:HasToken("AREAE_COVENRITUAL_UNLOCKED") then
			GiveTokenToLocalPlayer("AREAE_COVENRITUAL_FINISHED")
		end
		
end


-- Ritual Wave Event
local ritualObjectId = 0
local ritualStarted = false
local ritualKey = "AREAE_WITCHRITUAL_WAVEEVENT"

local ritualParameters = { }
	ritualParameters.waves = {"records/proxies/boss&questgdx1/proxy_areae_witchritualwave1.dbr", "records/proxies/boss&questgdx1/proxy_areae_witchritualwave2.dbr", "records/proxies/boss&questgdx1/proxy_areae_witchritualwave3.dbr", "records/proxies/boss&questgdx1/proxy_areae_witchritualwave4.dbr"}
	ritualParameters.endCallback = nil
	ritualParameters.key = ritualKey
	
function gd.quests.areaEQuestFactionWitchRitual.ritualOnAddToWorld(objectId)

	if Server then
		ritualObjectId = objectId
		WaveEvent_OnAddToWorld(objectId, ritualKey)
	
	end

end

function gd.quests.areaEQuestFactionWitchRitual.ritualOnRemoveFromWorld(objectId)

	if Server then
		WaveEvent_OnRemoveFromWorld(objectId)
	
	end
	
end
	
function gd.quests.areaEQuestFactionWitchRitual.startRitualMP()

	local player = Game.GetLocalPlayer()
	
	if player:HasToken("AREAE_COVENRITUAL_UNLOCKED") then
		GiveTokenToLocalPlayer("AREAE_COVENRITUAL_STARTED")
	end

	if Server then
		if (not ritualStarted) then
			ritualStarted = true
			WaveEvent_Start(ritualObjectId, ritualParameters)
			
			-- swap Malostria to ritual NPC
			ritualActive = true
			gd.quests.areaEQuestFactionWitchRitual.swapMalostria()
			-- Activate the fetish
			gd.quests.areaEQuestFactionWitchRitual.witchFetishRitualSwap()

		
		end
		
	end

end


