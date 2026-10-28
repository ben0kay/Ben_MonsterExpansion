/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestFactionWitchWards = {}


--
-- Side Quest 01 - Wendigo Wards
--

-- Ward Guardians
local WardGuard01Id = 0
local WardGuard02Id = 0
local WardGuard03Id = 0
local WardGuardState = {NotSpawned = 0, Spawned = 1, Dead = 2}
local WardGuardsSpawned = false
local WardGuard01Spawned = false
local WardGuard02Spawned = false
local WardGuard03Spawned = false

-- Ward Guardian 01
local WardGuard01StateObjects = orderedTable();
	WardGuard01StateObjects["AREAE_WITCHWARD01_ACTIVE"] = { state = WardGuardState.Dead,  dbr = nil }
	WardGuard01StateObjects["AREAE_WARDGUARDS_ACTIVE"] = { state = WardGuardState.Spawned,  dbr = "records/creatures/enemies/boss&quest/wendigo_wardwraith_01.dbr" }
	WardGuard01StateObjects[""] = { state = WardGuardState.NotSpawned, dbr = nil }


local function Guard01CreateArgs()

	return 0, Entity.Get(WardGuard01Id):GetCoords().origin
	
end
	
function gd.quests.areaEQuestFactionWitchWards.wardGuard01OnAddToWorld(objectId)

	if Server then
	
		if (WardGuard01Spawned == false) then
			
			WardGuard01Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WardGuard01StateObjects, Character, Guard01CreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WardGuardState.Spawned) then
				WardGuard01Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWitchWards.WardGuard01OnDestroy = ClearObjectUserdata


-- Ward Guardian 02
local WardGuard02StateObjects = orderedTable();
	WardGuard02StateObjects["AREAE_WITCHWARD02_ACTIVE"] = { state = WardGuardState.Dead,  dbr = nil }
	WardGuard02StateObjects["AREAE_WARDGUARDS_ACTIVE"] = { state = WardGuardState.Spawned,  dbr = "records/creatures/enemies/boss&quest/wendigo_wardwraith_02.dbr" }
	WardGuard02StateObjects[""] = { state = WardGuardState.NotSpawned, dbr = nil }


local function Guard02CreateArgs()

	return 0, Entity.Get(WardGuard02Id):GetCoords().origin
	
end
	
function gd.quests.areaEQuestFactionWitchWards.wardGuard02OnAddToWorld(objectId)

	if Server then
	
		if (WardGuard02Spawned == false) then
			
			WardGuard02Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WardGuard02StateObjects, Character, Guard02CreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WardGuardState.Spawned) then
				WardGuard02Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWitchWards.WardGuard02OnDestroy = ClearObjectUserdata


-- Ward Guardian 03
local WardGuard03StateObjects = orderedTable();
	WardGuard03StateObjects["AREAE_WITCHWARD03_ACTIVE"] = { state = WardGuardState.Dead,  dbr = nil }
	WardGuard03StateObjects["AREAE_WARDGUARDS_ACTIVE"] = { state = WardGuardState.Spawned,  dbr = "records/creatures/enemies/boss&quest/wendigo_wardwraith_03.dbr" }
	WardGuard03StateObjects[""] = { state = WardGuardState.NotSpawned, dbr = nil }


local function Guard03CreateArgs()

	return 0, Entity.Get(WardGuard03Id):GetCoords().origin
	
end
	
function gd.quests.areaEQuestFactionWitchWards.wardGuard03OnAddToWorld(objectId)

	if Server then
	
		if (WardGuard03Spawned == false) then
			
			WardGuard03Id = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WardGuard03StateObjects, Character, Guard03CreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == WardGuardState.Spawned) then
				WardGuard03Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWitchWards.WardGuard03OnDestroy = ClearObjectUserdata

-- Activate Guardians
function gd.quests.areaEQuestFactionWitchWards.wardGuardiansActivate()

	if Server then
		if (not WardGuardsSpawned) then
			local player = Game.GetLocalPlayer()
			
			local MPOverrideDbr1 = nil
			local MPOverrideDbr2 = nil
			local MPOverrideDbr3 = nil
			local MPOverrideState = false

			if (player:HasToken("AREAE_WARDGUARDS_ACTIVE") == false) then
				MPOverrideDbr1 = "records/creatures/enemies/boss&quest/wendigo_wardwraith_01.dbr"
				MPOverrideDbr2 = "records/creatures/enemies/boss&quest/wendigo_wardwraith_02.dbr"
				MPOverrideDbr3 = "records/creatures/enemies/boss&quest/wendigo_wardwraith_03.dbr"
				MPOverrideState = true
			end
			
			WardGuardsSpawned = true
			
			local WardGuard01 = Entity.Get(WardGuard01Id)
		
			if (WardGuard01 != nil) then
			
				local coords = WardGuard01:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(WardGuard01Id, WardGuard01StateObjects, Character, Guard01CreateArgs, MPOverrideState, MPOverrideDbr1)
				
				WardGuard01Spawned = true

			end

			local WardGuard02 = Entity.Get(WardGuard02Id)
			
			if (WardGuard02 != nil) then
			
				local coords = WardGuard02:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
			
				UpdateObjectSwap(WardGuard02Id, WardGuard02StateObjects, Character, Guard02CreateArgs, MPOverrideState, MPOverrideDbr2)
				
				WardGuard02Spawned = true
			
			end
			
			local WardGuard03 = Entity.Get(WardGuard03Id)
			
			if (WardGuard03 != nil) then
			
				local coords = WardGuard03:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end

				UpdateObjectSwap(WardGuard03Id, WardGuard03StateObjects, Character, Guard03CreateArgs, MPOverrideState, MPOverrideDbr3)
				
				WardGuard03Spawned = true

			end
		
		end

	end

end


-- Ward Sites
local WitchWard01Id = 0
local WitchWard02Id = 0
local WitchWard03Id = 0
local WitchWardsState = {Inactive = 0, Active = 1}
local WitchWard01Spawned = false
local WitchWard02Spawned = false
local WitchWard03Spawned = false

-- Witch Ward01
local WitchWard01StateObjects = orderedTable();
	WitchWard01StateObjects["AREAE_WITCHWARD01_ACTIVE"] = { state = WitchWardsState.Active,  dbr = "records/creatures/enemies/faction/witch_ward_01.dbr" }
	WitchWard01StateObjects[""] = { state = WitchWardsState.Inactive, dbr = "records/storyelements/questassets/areae_witchward_01.dbr" }


local function WardCreateArgs()

	return 0, nil
	
end
	
function gd.quests.areaEQuestFactionWitchWards.witchWard01OnAddToWorld(objectId)
	
	if Server then
	
		if (WitchWard01Spawned == false) then
			
			WitchWard01Id = objectId;
			
			local player = Game.GetLocalPlayer()
			local ClassState =  nil
			local Args = nil
			
			if player:HasToken("AREAE_WITCHWARD01_ACTIVE") then
				ClassState = Character
				Args = WardCreateArgs
			end
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WitchWard01StateObjects, ClassState, Args)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as monster
			if (newState == WitchWardsState.Active) then
				WitchWard01Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWitchWards.witchWard01OnDestroy = ClearObjectUserdata

-- Witch Ward02
local WitchWard02StateObjects = orderedTable();
	WitchWard02StateObjects["AREAE_WITCHWARD02_ACTIVE"] = { state = WitchWardsState.Active,  dbr = "records/creatures/enemies/faction/witch_ward_01.dbr" }
	WitchWard02StateObjects[""] = { state = WitchWardsState.Inactive, dbr = "records/storyelements/questassets/areae_witchward_01.dbr" }

function gd.quests.areaEQuestFactionWitchWards.witchWard02OnAddToWorld(objectId)

	if Server then
	
		if (WitchWard02Spawned == false) then
			
			WitchWard02Id = objectId;
			
			local player = Game.GetLocalPlayer()
			local ClassState =  nil
			local Args = nil
			
			if player:HasToken("AREAE_WITCHWARD02_ACTIVE") then
				ClassState = Character
				Args = WardCreateArgs
			end
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WitchWard02StateObjects, ClassState, Args)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as monster
			if (newState == WitchWardsState.Active) then
				WitchWard02Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWitchWards.witchWard02OnDestroy = ClearObjectUserdata

-- Witch Ward03
local WitchWard03StateObjects = orderedTable();
	WitchWard03StateObjects["AREAE_WITCHWARD03_ACTIVE"] = { state = WitchWardsState.Active,  dbr = "records/creatures/enemies/faction/witch_ward_01.dbr" }
	WitchWard03StateObjects[""] = { state = WitchWardsState.Inactive, dbr = "records/storyelements/questassets/areae_witchward_01.dbr" }

function gd.quests.areaEQuestFactionWitchWards.witchWard03OnAddToWorld(objectId)

	if Server then
	
		if (WitchWard03Spawned == false) then
			
			WitchWard03Id = objectId;
			
			local player = Game.GetLocalPlayer()
			local ClassState =  nil
			local Args = nil
			
			if player:HasToken("AREAE_WITCHWARD03_ACTIVE") then
				ClassState = Character
				Args = WardCreateArgs
			end
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, WitchWard03StateObjects, ClassState, Args)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as monster
			if (newState == WitchWardsState.Active) then
				WitchWard03Spawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestFactionWitchWards.witchWard03OnDestroy = ClearObjectUserdata

--
-- The Ward Guards Are Killed
--

function gd.quests.areaEQuestFactionWitchWards.wardGuard01OnKill()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xCF77D200
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WITCHWARD01_ACTIVE") == false) then
			GiveTokenToLocalPlayer("AREAE_WITCHWARD01_ACTIVE")
	end

	if Server then
		WitchWard01Spawned = true
		
		local WitchWard01 = Entity.Get(WitchWard01Id)
	
		if (WitchWard01 != nil) then
			local MPOverrideDbr = "records/creatures/enemies/faction/witch_ward_01.dbr"
			local MPOverrideState = true
		
			local coords = WitchWard01:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end
			
			UpdateObjectSwap(WitchWard01Id, WitchWard01StateObjects, Character, WardCreateArgs, MPOverrideState, MPOverrideDbr)

		end

	end
	
end

function gd.quests.areaEQuestFactionWitchWards.wardGuard02OnKill()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xCF77D200
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WITCHWARD02_ACTIVE") == false) then
			GiveTokenToLocalPlayer("AREAE_WITCHWARD02_ACTIVE")
	end

	if Server then
		WitchWard02Spawned = true
		
		local WitchWard02 = Entity.Get(WitchWard02Id)
	
		if (WitchWard02 != nil) then
			local MPOverrideDbr = "records/creatures/enemies/faction/witch_ward_01.dbr"
			local MPOverrideState = true
		
			local coords = WitchWard02:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end

			UpdateObjectSwap(WitchWard02Id, WitchWard02StateObjects, Character, WardCreateArgs, MPOverrideState, MPOverrideDbr)
			
		end
		
	end
	
end

function gd.quests.areaEQuestFactionWitchWards.wardGuard03OnKill()

	local player = Game.GetLocalPlayer()
	local kQuest = 0xCF77D200
	local kTask = 0xEC4C5000
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) && (player:HasToken("AREAE_WITCHWARD03_ACTIVE") == false) then
			GiveTokenToLocalPlayer("AREAE_WITCHWARD03_ACTIVE")
	end

	if Server then
		WitchWard03Spawned = true
		
		local WitchWard03 = Entity.Get(WitchWard03Id)
	
		if (WitchWard03 != nil) then
			local MPOverrideDbr = "records/creatures/enemies/faction/witch_ward_01.dbr"
			local MPOverrideState = true
		
			local coords = WitchWard03:GetCoords()	
			local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
			if (rift != nil) then
				rift:NetworkEnable()
				rift:SetCoords(coords)
			end

			UpdateObjectSwap(WitchWard03Id, WitchWard03StateObjects, Character, WardCreateArgs, MPOverrideState, MPOverrideDbr)

		end
		
	end
	
end

