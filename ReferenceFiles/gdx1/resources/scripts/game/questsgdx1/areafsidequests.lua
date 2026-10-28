/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFSideQuests = {}

--
-- Area F
--

-- Candle District - Savior
-- AREAF_SAVIOR_SAVED
-- AREAF_SAVIOR_HOSTILE
-- AREAF_SAVIOR_HOSTILESAVED
-- rescueSaviorPortal
-- hostileSaviorPortal
-- hostileSaviorSwap
-- saviorHostileBeginQuest
-- saviorFriendlyBeginQuest
-- HostileSaviorSwapToken
-- AREAF_SAVIOR_NICOCHOSEHOSTILE
-- AREAF_SAVIOR_NICOCHOSEFRIENDLY

local SaviorMan01Id = 0
local SaviorMan02Id = 0
local SaviorManHostile = false
local SaviorChildF01Id = 0
local SaviorChildF02Id = 0
local SaviorchildM01Id = 0
local SaviorchildM02Id = 0

local SaviorStates = {InSlums = 0, InHideout = 1, SaviorHostile = 2, SaviorDead = 3, HostileRescued = 4}

local function CharacterCreateArgs()

	return 0, Entity.Get(SaviorMan01Id):GetCoords().origin
	
end


-- Savior Man - In slums
local SaviorMan01StateObjects = orderedTable();
	SaviorMan01StateObjects["AREAF_SAVIOR_HOSTILESAVED"] = { state = SaviorStates.HostileRescued,  dbr = nil }
	SaviorMan01StateObjects["AREAF_SAVIOR_DEAD"] = { state = SaviorStates.SaviorDead,  dbr = nil }
	SaviorMan01StateObjects["AREAF_SAVIOR_HOSTILE"] = { state = SaviorStates.SaviorHostile,  dbr = "records/creatures/enemies/boss&quest/savior_nicoherin_01.dbr"}
	SaviorMan01StateObjects["AREAF_SAVIOR_SAVED"] = { state = SaviorStates.InHideout,  dbr = nil}
	SaviorMan01StateObjects[""] = { state = SaviorStates.InSlums, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorman_01.dbr" }

	
function gd.quests.areaFSideQuests.saviorMan01OnAddToWorld(objectId)

	if Server && not SaviorManHostile then
		
		SaviorMan01Id = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SaviorMan01StateObjects, Character, CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as hostile
		if (newState == SaviorStates.SaviorHostile) then
			SaviorManHostile = true
		end

	end
	
end

gd.quests.areaFSideQuests.saviorMan01OnDestroy = ClearObjectUserdata

-- Savior Man - In RebelHideout
local SaviorMan02StateObjects = orderedTable();
	SaviorMan02StateObjects["AREAF_SAVIOR_SAVED"] = { state = SaviorStates.InHideout, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorman_02.dbr" }
	SaviorMan02StateObjects[""] = { state = SaviorStates.InSlums, dbr = nil }

	
function gd.quests.areaFSideQuests.saviorMan02OnAddToWorld(objectId)

	if Server then
		
		SaviorMan02Id = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SaviorMan02StateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.saviorMan02OnDestroy = ClearObjectUserdata

-- Savior ChildF01 - In Slums
local SaviorChildF01StateObjects = orderedTable();
	SaviorChildF01StateObjects["AREAF_SAVIOR_HOSTILESAVED"] = { state = SaviorStates.HostileRescued,  dbr = nil }
	SaviorChildF01StateObjects["AREAF_SAVIOR_SAVED"] = { state = SaviorStates.InHideout,  dbr = nil }
	SaviorChildF01StateObjects[""] = { state = SaviorStates.InSlums, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorchildf_01.dbr"}

	
function gd.quests.areaFSideQuests.saviorChildF01OnAddToWorld(objectId)

	if Server then
	
		SaviorChildF01Id = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SaviorChildF01StateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.saviorChildF01OnDestroy = ClearObjectUserdata

-- Savior ChildF02 - In Hideout
local SaviorChildF02StateObjects = orderedTable();
	SaviorChildF02StateObjects["AREAF_SAVIOR_HOSTILESAVED"] = { state = SaviorStates.HostileRescued, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorchildf_02.dbr" }
	SaviorChildF02StateObjects["AREAF_SAVIOR_SAVED"] = { state = SaviorStates.InHideout, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorchildf_02.dbr" }
	SaviorChildF02StateObjects[""] = { state = SaviorStates.InSlums, dbr = nil }

	
function gd.quests.areaFSideQuests.saviorChildF02OnAddToWorld(objectId)

	if Server then
	
		SaviorChildF02Id = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SaviorChildF02StateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.saviorChildF02OnDestroy = ClearObjectUserdata

-- Savior ChildM01 - In Slums
local SaviorChildM01StateObjects = orderedTable();
	SaviorChildM01StateObjects["AREAF_SAVIOR_HOSTILESAVED"] = { state = SaviorStates.HostileRescued,  dbr = nil}
	SaviorChildM01StateObjects["AREAF_SAVIOR_SAVED"] = { state = SaviorStates.InHideout,  dbr = nil }
	SaviorChildM01StateObjects[""] = { state = SaviorStates.InSlums, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorchildm_01.dbr"}

	
function gd.quests.areaFSideQuests.saviorChildM01OnAddToWorld(objectId)

	if Server then
		
		SaviorChildM01Id = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SaviorChildM01StateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.saviorChildM01OnDestroy = ClearObjectUserdata

-- Savior ChildM02 - In Hideout
local SaviorChildM02StateObjects = orderedTable();
	SaviorChildM02StateObjects["AREAF_SAVIOR_HOSTILESAVED"] = { state = SaviorStates.HostileRescued,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorchildm_02.dbr" }
	SaviorChildM02StateObjects["AREAF_SAVIOR_SAVED"] = { state = SaviorStates.InHideout,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_saviorchildm_02.dbr" }
	SaviorChildM02StateObjects[""] = { state = SaviorStates.InSlums, dbr = nil }

	
function gd.quests.areaFSideQuests.saviorChildM02OnAddToWorld(objectId)

	if Server then
		
		SaviorChildM02Id = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, SaviorChildM02StateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.saviorChildM02OnDestroy = ClearObjectUserdata

-- Triggered by conversation. Hostile transition moves only the children
local HostilePortal = false

function gd.quests.areaFSideQuests.saviorHostilePortal()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_SAVIOR_HOSTILESAVED") && not HostilePortal then
			HostilePortal = true
			
			local ChildF01Slums = Entity.Get(SaviorChildF01Id)
			local ChildM01Slums = Entity.Get(SaviorChildM01Id)
			local ChildF02hideout = Entity.Get(SaviorChildF02Id)
			local ChildM02hideout = Entity.Get(SaviorChildM02Id)
	
			if ChildF01Slums != nil then
				local ChildF01SlumsCoords = ChildF01Slums:GetCoords();
				local ChildM02RiftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM02RiftStart != nil then
					ChildM02RiftStart:NetworkEnable()
					ChildM02RiftStart:SetCoords(ChildF01SlumsCoords)
				end
		
				UpdateObjectSwap(SaviorChildF01Id, SaviorChildF01StateObjects)
		
			end
	
			if ChildF02hideout != nil then
				local ChildF02hideoutCoords = ChildF02hideout:GetCoords()
				local ChildF02RiftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				if ChildF02RiftEnd != nil then
					ChildF02RiftEnd:NetworkEnable()
					ChildF02RiftEnd:SetCoords(ChildF02hideoutCoords)
				end
		
				UpdateObjectSwap(SaviorChildF02Id, SaviorChildF02StateObjects)
	
			end

			if ChildM01Slums != nil then
				local ChildM01SlumsCoords = ChildM01Slums:GetCoords();
				local ChildM01SlumsRiftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM01SlumsRiftStart != nil then
					ChildM01SlumsRiftStart:NetworkEnable()
					ChildM01SlumsRiftStart:SetCoords(ChildM01SlumsCoords)
				end
		
				UpdateObjectSwap(SaviorChildM01Id, SaviorChildM01StateObjects)
		
			end
		
			if ChildM02hideout != nil then
				local ChildM02hideoutCoords = ChildM02hideout:GetCoords()
				local ChildM02hideoutRiftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM02hideoutRiftEnd != nil then
					ChildM02hideoutRiftEnd:NetworkEnable()
					ChildM02hideoutRiftEnd:SetCoords(ChildM02hideoutCoords)
				end
		
				UpdateObjectSwap(SaviorChildM02Id, SaviorChildM02StateObjects)
		
			end
	
		end
	
	end
	
end

-- Triggered by conversation. Friendly transition moves all 3
local FriendlyPortal = false

function gd.quests.areaFSideQuests.saviorFriendlyPortal()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_SAVIOR_SAVED") && not FriendlyPortal then
			FriendlyPortal = true
			local NicohSlums = Entity.Get(SaviorMan01Id)
			local ChildF01Slums = Entity.Get(SaviorChildF01Id)
			local ChildM01Slums = Entity.Get(SaviorChildM01Id)
			local NicohHideout = Entity.Get(SaviorMan02Id)
			local ChildF02hideout = Entity.Get(SaviorChildF02Id)
			local ChildM02hideout = Entity.Get(SaviorChildM02Id)
	
			if NicohSlums != nil then
				local NicohSlumsCords = NicohSlums:GetCoords();
				local NicohRiftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if NicohRiftStart != nil then
					NicohRiftStart:NetworkEnable()
					NicohRiftStart:SetCoords(NicohSlumsCords)
				end
		
				UpdateObjectSwap(SaviorMan01Id, SaviorMan01StateObjects)
		
			end
		
			if NicohHideout != nil then
				local NicohHideoutCoords = NicohHideout:GetCoords()
				local NicohRiftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")

				if NicohRiftEnd != nil then
					NicohRiftEnd:NetworkEnable()
					NicohRiftEnd:SetCoords(NicohHideoutCoords)
				end
		
				UpdateObjectSwap(SaviorMan02Id, SaviorMan02StateObjects)
		
			end

			if ChildF01Slums != nil then
				local ChildF01SlumsCoords = ChildF01Slums:GetCoords();
				local ChildM02RiftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM02RiftStart != nil then
					ChildM02RiftStart:NetworkEnable()
					ChildM02RiftStart:SetCoords(ChildF01SlumsCoords)
				end
		
				UpdateObjectSwap(SaviorChildF01Id, SaviorChildF01StateObjects)
		
			end
	
			if ChildF02hideout != nil then
				local ChildF02hideoutCoords = ChildF02hideout:GetCoords()
				local ChildF02RiftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				if ChildF02RiftEnd != nil then
					ChildF02RiftEnd:NetworkEnable()
					ChildF02RiftEnd:SetCoords(ChildF02hideoutCoords)
				end
		
				UpdateObjectSwap(SaviorChildF02Id, SaviorChildF02StateObjects)
	
			end

			if ChildM01Slums != nil then
				local ChildM01SlumsCoords = ChildM01Slums:GetCoords();
				local ChildM01SlumsRiftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM01SlumsRiftStart != nil then
					ChildM01SlumsRiftStart:NetworkEnable()
					ChildM01SlumsRiftStart:SetCoords(ChildM01SlumsCoords)
				end
		
				UpdateObjectSwap(SaviorChildM01Id, SaviorChildM01StateObjects)
		
			end
		
			if ChildM02hideout != nil then
				local ChildM02hideoutCoords = ChildM02hideout:GetCoords()
				local ChildM02hideoutRiftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM02hideoutRiftEnd != nil then
					ChildM02hideoutRiftEnd:NetworkEnable()
					ChildM02hideoutRiftEnd:SetCoords(ChildM02hideoutCoords)
				end
		
				UpdateObjectSwap(SaviorChildM02Id, SaviorChildM02StateObjects)
		
			end
	
		end
	
	end
	
end

--- Nicoh hostile swap
function gd.quests.areaFSideQuests.saviorHostileSwap()
	
	if Server && not SaviorManHostile then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_SAVIOR_HOSTILE") then
			SaviorManHostile = true
			
			UpdateObjectSwap(SaviorMan01Id, SaviorMan01StateObjects, Character, CharacterCreateArgs)
	
		end
	
	end

end

--- Nicoh's dialogue randomizer
local DialogueRandomizer = 0
local randomizerRan = false

function gd.quests.areaFSideQuests.nicohRandomizerTest()

	if not randomizerRan then
		randomizerRan = true
		math.randomseed(Time.Now())
		DialogueRandomizer = random(1,2)
		
	end

end


function gd.quests.areaFSideQuests.nicohRandomizer()
	
	return DialogueRandomizer

end


--
-- Area F Trap Chests
--

-- Mourndale
local ChestState = { Default = 0, Looted = 1 }
local MourndaleChestCoords = nil

local trappedChestMourndaleStateObjects = orderedTable()
	trappedChestMourndaleStateObjects["AREAF_TRAPPEDCHESTMOURNDALE_FOUND"	] = { state = ChestState.Looted, dbr = nil}
	trappedChestMourndaleStateObjects[""] = { state = ChestState.Default, dbr = "records/items/lootchests/questchests/mourndaletrap_02.dbr"}

local trappedChestmourndaleSpawned = false

function gd.quests.areaFSideQuests.trappedChestMourndaleOnAddToWorld(objectId)

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (not trappedChestmourndaleSpawned && player:GetLevel() > 2) then
			
			local entity = Entity.Get(objectId)
			MourndaleChestCoords = entity:GetCoords()
			trappedChestmourndaleSpawned = true
		
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, trappedChestMourndaleStateObjects)
			Shared.setUserdata(objectId, userdata)
		
		end
		
	end
	
end

gd.quests.areaFSideQuests.trappedChestMourndaleOnDestroy = ClearObjectUserdata

function gd.quests.areaFSideQuests.trappedChestMourndaleOpenedMP()
	
	if Server then		

		local fx = Entity.Create("records/fx/skillsother/fxpak_attackradius_riftblast01.dbr")
		
		if (fx != nil) then
			fx:NetworkEnable()
			fx:SetCoords(MourndaleChestCoords)
		end

		local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areaf_trapchest_01.dbr", MourndaleChestCoords.origin)
		proxy:SetCoords(MourndaleChestCoords)
		

	end

end

function gd.quests.areaFSideQuests.trappedChestMourndaleOpened()

	GiveTokenToLocalPlayer("AREAF_TRAPPEDCHESTMOURNDALE_FOUND")
	QuestEvent("mourndaleTrappedChest")
	
end



-- Malmouth - Aether Storm Chest
local MalmouthTrappedChestCoords = nil
local TrappedChestRandomizer = 0
local trappedChestOpened = false

function gd.quests.areaFSideQuests.trappedChestMalmouthOnAddToWorld(objectId)
	
	if Server then
		local entity = Entity.Get(objectId)
		MalmouthTrappedChestCoords = entity:GetCoords()
	
		if (TrappedChestRandomizer == 0) then
			math.randomseed(Time.Now())
			TrappedChestRandomizer = random(1,100)
			
		end
	
	end

end

function gd.quests.areaFSideQuests.malmouthTrappedChestOpenedMP()
	if Server && not trappedChestOpened then		
		if TrappedChestRandomizer > 40 then
			trappedChestOpened = true
			
			local fx = Entity.Create("records/fx/skillsother/aoe/aethernova_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(MalmouthTrappedChestCoords)
			end
			
			local proxy = Proxy.Create("records/proxies/boss&questgdx1/proxy_areaf_trapchest_02.dbr", MalmouthTrappedChestCoords.origin)
			proxy:SetCoords(MalmouthTrappedChestCoords)

		
		end
	
	end

end

function gd.quests.areaFSideQuests.malmouthTrappedChestOpened()

	QuestEvent("malmouthTrappedChest")

end

-- Malmouth Survivors
-- sqSurvivorsRescue
local Survivor01CityId = 0
local Survivor01BaseId = 0
local Survivor02CityId = 0

local SurvivorStates = {InCity = 0, InBase = 1}

-- Survivor 01 in city
local Survivor01InCityStateObjects = orderedTable();
	Survivor01InCityStateObjects["AREAF_SQSURVIVORS_SAVED"] = { state = SurvivorStates.InBase,  dbr = nil}
	Survivor01InCityStateObjects[""] = { state = SurvivorStates.InCity, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_sq_vivien_01.dbr" }

	
function gd.quests.areaFSideQuests.survivor01InCityOnAddToWorld(objectId)

	if Server then
		
		Survivor01CityId = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Survivor01InCityStateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.survivor01InCityOnDestroy = ClearObjectUserdata

-- Survivor 01 in base
local Survivor01InBaseStateObjects = orderedTable();
	Survivor01InBaseStateObjects["AREAF_SQSURVIVORS_SAVED"] = { state = SurvivorStates.InBase,  dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_sq_vivien_02.dbr"}
	Survivor01InBaseStateObjects[""] = { state = SurvivorStates.InCity, dbr = nil}

	
function gd.quests.areaFSideQuests.survivor01InBaseOnAddToWorld(objectId)

	if Server then
		
		Survivor01BaseId = objectId
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Survivor01InBaseStateObjects, Character)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaFSideQuests.survivor01InBaseOnDestroy = ClearObjectUserdata

-- Survivor 02 in city - Disappears once his stash has been collected.
local rictorChest = false

local Survivor02InCityStateObjects = orderedTable();
	Survivor02InCityStateObjects["AREAF_MALMOUTHSTASH_OPENED"] = { state = SurvivorStates.InBase,  dbr = "records/items/lootchests/breakables/a01_bonepilehuman_01_break.dbr" }
	Survivor02InCityStateObjects[""] = { state = SurvivorStates.InCity, dbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_sq_rictor_01.dbr" }

	
function gd.quests.areaFSideQuests.survivor02InCityOnAddToWorld(objectId)

	if Server && not rictorChest then
		
		Survivor02CityId = objectId
		
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = nil
		local MPOverrideState = false
		local class = Character

		if (player:HasToken("AREAF_MALMOUTHSTASH_OPENED") && player:HasToken("AREAF_SQSURVIVORS_SAVED") == false) then
			MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareaf/npc_captive_sq_rictor_01.dbr"
			MPOverrideState = true
		elseif player:HasToken("AREAF_MALMOUTHSTASH_OPENED") then
			class = Destructible
		end
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, Survivor02InCityStateObjects, class, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
		
		-- If Rictor is spawned as a chest, do not respawn
		if (newState == SurvivorStates.InBase && player:HasToken("AREAF_SQSURVIVORS_SAVED")) then
			rictorChest = true
		end

	end
	
end

gd.quests.areaFSideQuests.Survivor02InCityOnDestroy = ClearObjectUserdata

-- Triggered by conversation. Transitions survivor 01 back to the base.
local SurvivorsPortal = false

function gd.quests.areaFSideQuests.malmouthSurvivorsPortal()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if player:HasToken("AREAF_SQSURVIVORS_SAVED") && not SurvivorsPortal then
			SurvivorsPortal = true
			
			local Survivor01City = Entity.Get(Survivor01CityId)
			local Survivor01Base = Entity.Get(Survivor01BaseId)
	
			if Survivor01City != nil then
				local Survivor01CityCoords = Survivor01City:GetCoords();
				local ChildM02RiftStart = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
		
				if ChildM02RiftStart != nil then
					ChildM02RiftStart:NetworkEnable()
					ChildM02RiftStart:SetCoords(Survivor01CityCoords)
				end
		
				UpdateObjectSwap(Survivor01CityId, Survivor01InCityStateObjects)
		
			end
	
			if Survivor01Base != nil then
				local Survivor01BaseCoords = Survivor01Base:GetCoords()
				local ChildF02RiftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				if ChildF02RiftEnd != nil then
					ChildF02RiftEnd:NetworkEnable()
					ChildF02RiftEnd:SetCoords(Survivor01BaseCoords)
				end
		
				UpdateObjectSwap(Survivor01BaseId, Survivor01InBaseStateObjects)
	
			end

		end
	
	end
	
end

-- Survivor 02 Tells the player about a hidden stash - Unlocks the barricade interaction site.

-- Malmouth Stash blockade
-- malmouthStashBarricadeDestroy
-- AREAF_MALMOUTHSTASH_OPENED


local StashBlockadeState = { locked = 0, Active = 1, Destroyed = 2}

local StashBlockadeId = 0
local StashInteractiveId = 0
local spawnedStashBlockade = false
local chestId = 0

-- Blockade
local StashBlockadeStateObjects = orderedTable();
	StashBlockadeStateObjects["AREAF_MALMOUTHSTASH_OPENED"] = { state = StashBlockadeState.Destroyed,  dbr = nil }
	StashBlockadeStateObjects[""] = { state = StashBlockadeState.locked, dbr = "records/storyelements/questassets/areaf_malmouthstash_break.dbr" }

function gd.quests.areaFSideQuests.StashBlockadeOnAddToWorld(objectId)

	if Server then
		if (not spawnedStashBlockade) then

			local userdata = {};
			TokenStateBasedObjectSwap(objectId, userdata, StashBlockadeStateObjects);
			Shared.setUserdata(objectId, userdata);
		
			spawnedStashBlockade = true
		
		end
		
	end
	
end

gd.quests.areaFSideQuests.StashBlockadeOnDestroy = ClearObjectUserdata

function gd.quests.areaFSideQuests.StashBlockadeAvatarOnAddToWorld(objectId)

	if Server then
		StashBlockadeId = objectId
		
	end
	
end

-- Detonation Site - This remains invisible until the player has spoken with the wounded survivor.
local StashDetonationSiteStateObjects = orderedTable();
	StashDetonationSiteStateObjects["AREAF_MALMOUTHSTASH_OPENED"]	= { state = StashBlockadeState.Destroyed,  dbr = nil }
	StashDetonationSiteStateObjects["AREAF_MALMOUTHSTASH_UNLOCKED"]	= { state = StashBlockadeState.Active,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_malmouthstash_detonationsite.dbr" }
	StashDetonationSiteStateObjects[""] = { state = StashBlockadeState.locked, dbr = nil }

function gd.quests.areaFSideQuests.StashDetonationSiteOnAddToWorld(objectId)

	if Server then
		
		StashInteractiveId = objectId
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, StashDetonationSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
		
	end
	
end

gd.quests.areaFSideQuests.StashDetonationSiteOnDestroy = ClearObjectUserdata

-- Swap the detonation site object
local RictorsStashUnlocked = false

function gd.quests.areaFSideQuests.stashupdate()

	if Server then
		
		local player = Game.GetLocalPlayer()
		if player:HasToken("AREAF_MALMOUTHSTASH_UNLOCKED") && not RictorsStashUnlocked then
			RictorsStashUnlocked = true
			
			local StashInteractive = Entity.Get(StashInteractiveId)
	
			if StashInteractive != nil then

				UpdateObjectSwap(StashInteractiveId, StashDetonationSiteStateObjects)
		
			end
	
		end
	
	end
	
end


-- Destroy Blockade
function gd.quests.areaFSideQuests.StashBlockadeDestroyGlobalMP()

	GiveTokenToLocalPlayer("AREAF_MALMOUTHSTASH_OPENED")

end

function gd.quests.areaFSideQuests.StashBlockadeDestroy()

	if Server then
		
		if StashBlockadeId != 0 then
		
			local StashBlockade = Destructible.Get(StashBlockadeId)
			local coords = StashBlockade:GetCoords()
			StashBlockade:Destroy(Vec(0,1,0), 1000, false)
			StashBlockadeId = 0
		
			local pfx = Entity.Create("records/fx/skillsother/attackradius/detonatelarge_fxpak01.dbr")
			if pfx != nil then
				pfx:NetworkEnable()
				pfx:SetCoords(coords)
				
			end
			
		end
		
		-- Unlock chest
		local chest = Chest.Get(chestId);
		if (chest != nil) then
			chest:SetLocked(false)
		end
	
		QuestGlobalEvent("MalmouthStashToken")
	
	end
	
end

-- Called when chest opened
function gd.quests.areaFSideQuests.chestFound()
	
	GiveTokenToLocalPlayer("DUNGEONCHEST_MALMOUTHSTASH")
	
end

function gd.quests.areaFSideQuests.chestOnAddToWorld(objectId)

	if Server then
		chestId = objectId
		local chestEntity = Entity.Get(objectId)
		local chest = Chest.Get(objectId)
		local player = Game.GetLocalPlayer()
	
		-- Destroy chest if this is the initial load and the player has the open token from a previous session
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:ServerHasToken("DUNGEONCHEST_MALMOUTHSTASH")) then
			chestEntity:Destroy()
		elseif (player:HasToken("AREAF_MALMOUTHSTASH_OPENED") && chest != nil) then
			chest:SetLocked(false)
		end
	
	end
	
end



