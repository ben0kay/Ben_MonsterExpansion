/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestFactionWendigoWards = {}

--
-- Side Quest 01 - Wendigo Wards
--
local WendigoWard01Id = 0
local WendigoWard02Id = 0
local WendigoWard03Id = 0
local WendigoWardsState = {Inactive = 0, Active = 1}
local WendigoWard01Spawned = false
local WendigoWard02Spawned = false
local WendigoWard03Spawned = false

-- Wendigo Ward01
local WendigoWard01StateObjects = orderedTable();
	WendigoWard01StateObjects["AREAE_WENDIGOWARD01_ACTIVE"] = { state = WendigoWardsState.Active,  dbr = "records/creatures/enemies/faction/cult_wendigoward_01.dbr" }
	WendigoWard01StateObjects[""] = { state = WendigoWardsState.Inactive, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_wendigoward01.dbr" }


local function Ward01CharacterCreateArgs()

	return 0, Entity.Get(WendigoWard01Id):GetCoords().origin
	
end
	
function gd.quests.areaEQuestFactionWendigoWards.wendigoWard01OnAddToWorld(objectId)

	if Server then
	
		if (WendigoWard01Spawned == false) then
			WendigoWard01Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WendigoWard01StateObjects, Character, Ward01CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)

			-- Don't respawn if spawned as monster
			if (newState == WendigoWardsState.Active) then
				WendigoWard01Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigoWards.wendigoWard01OnDestroy = ClearObjectUserdata

-- Activate ward 01
function gd.quests.areaEQuestFactionWendigoWards.wendigoWard01Activate()

	if Server then
		WendigoWard01Spawned = true
		
		local player = Game.GetLocalPlayer()
		local kQuest = 0xE2200700
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
		if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WENDIGOWARD01_ACTIVE") == false) then
			GiveTokenToLocalPlayer("AREAE_WENDIGOWARD01_ACTIVE")
		end
		
		local Ward01 = Entity.Get(WendigoWard01Id)
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAE_WENDIGOWARD01_ACTIVE") == false) then
			MPOverrideDbr = "records/creatures/enemies/faction/cult_wendigoward_01.dbr"
			MPOverrideState = true
		end
		
		if (Ward01 != nil) then
		
			local coords = Ward01:GetCoords()		
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
		
			UpdateObjectSwap(WendigoWard01Id, WendigoWard01StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end
		
		QuestGlobalEvent("wendigoWard01Token")

	end

end

-- Ward 01 Token
function gd.quests.areaEQuestFactionWendigoWards.Ward01ActivateGlobalMP()

	
	local player = Game.GetLocalPlayer()
	local kQuest = 0xE2200700
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WENDIGOWARD01_ACTIVE") == false) then
		GiveTokenToLocalPlayer("AREAE_WENDIGOWARD01_ACTIVE")
	end
	
end

-- Wendigo Ward02
local WendigoWard02StateObjects = orderedTable();
	WendigoWard02StateObjects["AREAE_WENDIGOWARD02_ACTIVE"] = { state = WendigoWardsState.Active,  dbr = "records/creatures/enemies/faction/cult_wendigoward_01.dbr" }
	WendigoWard02StateObjects[""] = { state = WendigoWardsState.Inactive, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_wendigoward02.dbr" }


local function Ward02CharacterCreateArgs()

	return 0, Entity.Get(WendigoWard02Id):GetCoords().origin
	
end
	
function gd.quests.areaEQuestFactionWendigoWards.wendigoWard02OnAddToWorld(objectId)

	if Server then
	
		if (WendigoWard02Spawned == false) then
			WendigoWard02Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WendigoWard02StateObjects, Character, Ward02CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as monster
			if (newState == WendigoWardsState.Active) then
				WendigoWard02Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigoWards.wendigoWard02OnDestroy = ClearObjectUserdata

-- Activate ward 02
function gd.quests.areaEQuestFactionWendigoWards.wendigoWard02Activate()

	if Server then
		WendigoWard02Spawned = true
		
		local player = Game.GetLocalPlayer()
		local kQuest = 0xE2200700
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
		if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WENDIGOWARD02_ACTIVE") == false) then
			GiveTokenToLocalPlayer("AREAE_WENDIGOWARD02_ACTIVE")
		end
		
		local Ward02 = Entity.Get(WendigoWard02Id)
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAE_WENDIGOWARD02_ACTIVE") == false) then
			MPOverrideDbr = "records/creatures/enemies/faction/cult_wendigoward_01.dbr"
			MPOverrideState = true
		end
		
		if (Ward02 != nil) then
		
			local coords = Ward02:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
		
			UpdateObjectSwap(WendigoWard02Id, WendigoWard02StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end
		
		QuestGlobalEvent("wendigoWard02Token")

	end

end

-- Ward 02 Token
function gd.quests.areaEQuestFactionWendigoWards.Ward02ActivateGlobalMP()

	
	local player = Game.GetLocalPlayer()
	local kQuest = 0xE2200700
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WENDIGOWARD02_ACTIVE") == false) then
		GiveTokenToLocalPlayer("AREAE_WENDIGOWARD02_ACTIVE")
	end
	
end

-- Wendigo Ward03
local WendigoWard03StateObjects = orderedTable();
	WendigoWard03StateObjects["AREAE_WENDIGOWARD03_ACTIVE"] = { state = WendigoWardsState.Active,  dbr = "records/creatures/enemies/faction/cult_wendigoward_01.dbr" }
	WendigoWard03StateObjects[""] = { state = WendigoWardsState.Inactive, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areae_wendigoward03.dbr" }


local function Ward03CharacterCreateArgs()

	return 0, Entity.Get(WendigoWard03Id):GetCoords().origin
	
end
	
function gd.quests.areaEQuestFactionWendigoWards.wendigoWard03OnAddToWorld(objectId)

	if Server then
	
		if (WendigoWard03Spawned == false) then
			WendigoWard03Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WendigoWard03StateObjects, Character, Ward03CharacterCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as monster
			if (newState == WendigoWardsState.Active) then
				WendigoWard03Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWendigoWards.wendigoWard03OnDestroy = ClearObjectUserdata

-- Activate ward 03
function gd.quests.areaEQuestFactionWendigoWards.wendigoWard03Activate()

	if Server then
		WendigoWard03Spawned = true
		
		local player = Game.GetLocalPlayer()
		local kQuest = 0xE2200700
		local kTask = 0xEC4C5000
		local questTaskState = player:GetQuestTaskState(kQuest, kTask)
			
		if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WENDIGOWARD03_ACTIVE") == false) then
			GiveTokenToLocalPlayer("AREAE_WENDIGOWARD03_ACTIVE")
		end
		
		local Ward03 = Entity.Get(WendigoWard03Id)
		local MPOverrideDbr = nil
		local MPOverrideState = false

		if (player:HasToken("AREAE_WENDIGOWARD03_ACTIVE") == false) then
			MPOverrideDbr = "records/creatures/enemies/faction/cult_wendigoward_01.dbr"
			MPOverrideState = true
		end
		
		if (Ward03 != nil) then
		
			local coords = Ward03:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
		
			UpdateObjectSwap(WendigoWard03Id, WendigoWard03StateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end
		
		QuestGlobalEvent("wendigoWard03Token")

	end

end

-- Ward 03 Token
function gd.quests.areaEQuestFactionWendigoWards.Ward03ActivateGlobalMP()

	
	local player = Game.GetLocalPlayer()
	local kQuest = 0xE2200700
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WENDIGOWARD03_ACTIVE") == false) then
		GiveTokenToLocalPlayer("AREAE_WENDIGOWARD03_ACTIVE")
	end
	
end

