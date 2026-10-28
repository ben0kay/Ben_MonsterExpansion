/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestMalmouthFactory = {}

local KilledGuardian01 = false
local KilledGuardian02 = false
local innerFactoryUgOpen = false
local innerFactoryOpen = false
local innerFactoryUgDoorId = 0
local innerFactoryDoorId = 0

local factoryExitShortcut = 0
local factoryOutsideShortcut = 0

local shortcutOpen = false


-- unlock factory door if guardians have been killed
local function unlockInnerFactoryDoor()
	
	if Server && not innerFactoryOpen then
		
		if not innerFactoryOpen then
			local door = Door.Get(innerFactoryDoorId)
			
			if door ~= nil then
				door:SetLocked(false)
				innerFactoryOpen = true

			end
		
		end
		
		if not innerFactoryUgOpen then
			local door01 = Door.Get(innerFactoryUgDoorId)
			
			if door01 ~= nil then
				door01:SetLocked(false)
				door01:Open()
				innerFactoryUgOpen = true
			end
		
		end

	end
	
end

-- Inner Factory UgDoor
function gd.quests.areaFQuestMalmouthFactory.innerFactoryUgDoorOnAddToWorld(objectId)
	
	if Server then
		innerFactoryUgDoorId = objectId
		
		if (KilledGuardian01 == true && KilledGuardian02 == true && not innerFactoryUgOpen) then
			
			local door = Door.Get(objectId)
			if door ~= nil then
				door:SetLocked(false)
				door:Open()
				innerFactoryUgOpen = true
			end
		
		end
		
	end
	
end

-- Inner Factory Door
function gd.quests.areaFQuestMalmouthFactory.innerFactoryDoorOnAddToWorld(objectId)
	
	if Server then
		innerFactoryDoorId = objectId
		
		if (KilledGuardian01 == true && KilledGuardian02 == true && not innerFactoryOpen) then
			
			local door = Door.Get(objectId)
			if door ~= nil then
				door:SetLocked(false)
				door:Open()
				innerFactoryOpen = true
			end
		
		end
		
	end
	
end


-- Shortcut back to the surface
local function openShortcut()

	if Server then
		local shortcut01 = Door.Get(factoryExitShortcut)
		local shortcut02 = Door.Get(factoryOutsideShortcut)
		
		-- Unlock Shortcut outside, works both ways
		if shortcut01 ~= nil then
			shortcut01:SetLocked(false)
			shortcut01:Open()
		end
		
		if shortcut02 ~= nil then
			shortcut02:SetLocked(false)
			shortcut02:Open()
		end
		
	end
	
end

function gd.quests.areaFQuestMalmouthFactory.factoryShortcutEnterOnAddToWorld(objectId)
	
	if Server then
		factoryExitShortcut = objectId
		
		if shortcutOpen then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

function gd.quests.areaFQuestMalmouthFactory.factoryShortcutExitOnAddToWorld(objectId)
	
	if Server then
		factoryOutsideShortcut = objectId
		
		if shortcutOpen then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end


-- The player kills factory guardian 01
function gd.quests.areaFQuestMalmouthFactory.guardiansKilledGlobalMP()
	
	GiveTokenToLocalPlayer("AREAF_FACTORYBOSS_OPENED")

end

function gd.quests.areaFQuestMalmouthFactory.killGuardian01()
	
	if Server then
		print "01 Killed"
		KilledGuardian01 = true

		--If both are dead, open door
		if (KilledGuardian01 && KilledGuardian02) then
			shortcutOpen =  true
			print "Opening Doors"
			unlockInnerFactoryDoor()
			openShortcut()
			
			QuestGlobalEvent("fleshFactoryBossDoorToken")
		
		end
	
	end
	
end

function gd.quests.areaFQuestMalmouthFactory.killGuardian02()

	if Server then
		print "02 Killed"
		KilledGuardian02 = true

		--If both are dead, open door
		if (KilledGuardian01 && KilledGuardian02) then
			shortcutOpen =  true
			unlockInnerFactoryDoor()
			openShortcut()
			
			QuestGlobalEvent("fleshFactoryBossDoorToken")
		
		end
	
	end
	
end

--
-- Sidquest  Burn the birthing chamber
-- AREAF_DESTROYEDTHEWOMB
-- startBirthingChamberFires
-- burnTheWombBeginQuest

local ChamberInteractiveId = 0
local ChamberFire01Id = 0
local ChamberFire02Id = 0
local ChamberFire03Id = 0
local ChamberFire04Id = 0
local kriegKilled = false

local BirthingChamberState = { KriegLiving = 0, KriegKilled = 1, ChamberDestroyed = 2} 

-- Interactive Object
local chamberInteractiveStateObjects = orderedTable();
	chamberInteractiveStateObjects["AREAF_DESTROYEDTHEWOMB"] = { state = BirthingChamberState.ChamberDestroyed, dbr = nil}
	chamberInteractiveStateObjects["AREAF_KRIEGKILLED"] = { state = BirthingChamberState.KriegKilled, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_burnthewomb.dbr"}
	chamberInteractiveStateObjects[""] = { state = BirthingChamberState.KriegLiving, dbr = nil}

	
function gd.quests.areaFQuestMalmouthFactory.birthingChamberInteractiveOnAddToWorld(objectId)
	
	if Server then

		ChamberInteractiveId = objectId;
		local MPOverrideDbr = nil
		local MPOverrideState = false
		
		if (kriegKilled == false) then
			
			MPOverrideDbr = "records/level art/monstercamp/troll_animalbones01a.dbr"
			MPOverrideState = true
			
		end
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, chamberInteractiveStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		Shared.setUserdata(objectId, userdata)
	
	end
	
end

gd.quests.areaFQuestMalmouthFactory.birthingChamberInteractiveOnDestroy = ClearObjectUserdata

--Fire Objects
local chamberFire01StateObjects = orderedTable();
	chamberFire01StateObjects["AREAF_DESTROYEDTHEWOMB"] = { state = BirthingChamberState.ChamberDestroyed, dbr = "records/fx/ambient/fx_firebonfire01.dbr"}
	chamberFire01StateObjects[""] = { state = BirthingChamberState.KriegKilled, dbr = nil}
	chamberFire01StateObjects[""] = { state = BirthingChamberState.KriegLiving, dbr = nil}

function gd.quests.areaFQuestMalmouthFactory.birthingChamberFire01OnAddToWorld(objectId)
	
	if Server then
		ChamberFire01Id = objectId;

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, chamberFire01StateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaFQuestMalmouthFactory.birthingChamberFire01OnDestroy = ClearObjectUserdata

local chamberFire02StateObjects = orderedTable();
	chamberFire02StateObjects["AREAF_DESTROYEDTHEWOMB"] = { state = BirthingChamberState.ChamberDestroyed, dbr = "records/fx/ambient/fx_firebonfire01.dbr"}
	chamberFire02StateObjects[""] = { state = BirthingChamberState.KriegKilled, dbr = nil}
	chamberFire02StateObjects[""] = { state = BirthingChamberState.KriegLiving, dbr = nil}

function gd.quests.areaFQuestMalmouthFactory.birthingChamberFire02OnAddToWorld(objectId)
	
	if Server then
		ChamberFire02Id = objectId;

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, chamberFire02StateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaFQuestMalmouthFactory.birthingChamberFire02OnDestroy = ClearObjectUserdata

local chamberFire03StateObjects = orderedTable();
	chamberFire03StateObjects["AREAF_DESTROYEDTHEWOMB"] = { state = BirthingChamberState.ChamberDestroyed, dbr = "records/fx/ambient/fx_firebonfire01.dbr"}
	chamberFire03StateObjects[""] = { state = BirthingChamberState.KriegKilled, dbr = nil}
	chamberFire03StateObjects[""] = { state = BirthingChamberState.KriegLiving, dbr = nil}

function gd.quests.areaFQuestMalmouthFactory.birthingChamberFire03OnAddToWorld(objectId)
	
	if Server then
		ChamberFire03Id = objectId;

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, chamberFire03StateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaFQuestMalmouthFactory.birthingChamberFire01OnDestroy = ClearObjectUserdata

local chamberFire04StateObjects = orderedTable();
	chamberFire04StateObjects["AREAF_DESTROYEDTHEWOMB"] = { state = BirthingChamberState.ChamberDestroyed, dbr = "records/fx/ambient/fx_firebonfire01.dbr"}
	chamberFire04StateObjects[""] = { state = BirthingChamberState.KriegKilled, dbr = nil}
	chamberFire04StateObjects[""] = { state = BirthingChamberState.KriegLiving, dbr = nil}

function gd.quests.areaFQuestMalmouthFactory.birthingChamberFire04OnAddToWorld(objectId)
	
	if Server then
		ChamberFire04Id = objectId;

		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, chamberFire04StateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaFQuestMalmouthFactory.birthingChamberFire04OnDestroy = ClearObjectUserdata

-- The player starts the fires.
function gd.quests.areaFQuestMalmouthFactory.fireActivation()

	if Server then
		
		local fire01 = Entity.Get(ChamberFire01Id)
		local fire02 = Entity.Get(ChamberFire02Id)
		local fire03 = Entity.Get(ChamberFire03Id)
		local fire04 = Entity.Get(ChamberFire04Id)
		
		if (fire01 != nil) then
			UpdateObjectSwap(ChamberFire01Id, chamberFire01StateObjects)
		end
		
		if (fire02 != nil) then
			UpdateObjectSwap(ChamberFire02Id, chamberFire02StateObjects)
		end
		
		if (fire03 != nil) then
			UpdateObjectSwap(ChamberFire03Id, chamberFire03StateObjects)
		end
		
		if (fire04 != nil) then
			UpdateObjectSwap(ChamberFire04Id, chamberFire04StateObjects)
		end
	
	end

end

-- Fleshshaper Krieg Doors
local kriegDoor01 = 0
local kriegDoor02 = 0

function gd.quests.areaFQuestMalmouthFactory.kriegDoor01OnAddToWorld(objectId)
	
	if Server then
		kriegDoor01 = objectId
	
	end
	
end

function gd.quests.areaFQuestMalmouthFactory.kriegDoor02OnAddToWorld(objectId)
	
	if Server then
		kriegDoor02 = objectId
	
	end
	
end

function gd.quests.areaFQuestMalmouthFactory.kriegKilled()
	
	GiveTokenToLocalPlayer("AREAF_KRIEGKILLED")
	
	if Server then
	
		kriegKilled = true
	
		local door01 = Door.Get(kriegDoor01)
		local door02 = Door.Get(kriegDoor02)
	
		if door01 != nil then
			door01:Open()
		
		end
	
		if door02 != nil then
			door02:Open()
		
		end
		
		local player = Game.GetLocalPlayer()
		local ChamberInteractive = Entity.Get(ChamberInteractiveId)
	
		if ((ChamberInteractive != nil) && (player:HasToken("AREAF_DESTROYEDTHEWOMB") == false)) then
		
			MPOverrideDbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areaf_burnthewomb.dbr"
			MPOverrideState = true

			UpdateObjectSwap(ChamberInteractiveId, chamberInteractiveStateObjects, nil, nil, MPOverrideState, MPOverrideDbr)
		
		end
	
	end

end

-- Prevent Fleshshaper Krieg from Leaving Room
local bossId = 0

function gd.quests.areaFQuestMalmouthFactory.kriegOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaFQuestMalmouthFactory.bossLeaveRoom()

	if Server then
		-- Teleport boss back to spawn point if he is somehow kited out of boss room
		if (bossId != 0) then
			local bossEntity = Character.Get(bossId)

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

