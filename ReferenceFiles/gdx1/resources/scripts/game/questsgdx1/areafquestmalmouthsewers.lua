/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

--
-- The player finds the rebel base - Setting a token for Ulgrim's transition into the sewers.
-- A following token is set when the player speaks to the rebel captain, this transitions Ulgrim into the rebel hideout.
-- AREAF_ULGRIMINSEWERS
-- AREAF_ULGRIMINHIDEOUT

gd.quests.areaFQuestMalmouthSewers = {}



-- Unlock Slums Exit
local hideoutSlumsExitOpen = false
local slumsExitDoorId = 0

function gd.quests.areaFQuestMalmouthSewers.slumsExitOnAddToWorld(objectId)
	
	if Server && not hideoutSlumsExitOpen then
		
		slumsExitDoorId = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_SLUMSUNLOCKED")) then
			hideoutSlumsExitOpen = true
			
			local door = Door.Get(objectId)
			door:SetLocked(false)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaFQuestMalmouthSewers.slumsExitUnlock()

	if Server && not hideoutSlumsExitOpen then		
		local door01 = Door.Get(slumsExitDoorId)
		
		if door01 != nil then
			door01:SetLocked(false)
			door01:Open()
			hideoutSlumsExitOpen = true
			
		end
		
	end
	
end


--Door Setup - The player must be on or have completed the quest to retake the rebel base to open the door up to the surface.
local upperBaseDoorId = 0 
local upperBaseDoorOpen = false

function gd.quests.areaFQuestMalmouthSewers.upperHideoutDoorOnAddToWorld(objectId)
	if Server && not upperBaseDoorOpen then
		upperBaseDoorId = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAF_INDUSTRIALUNLOCKED")) then
			upperBaseDoorOpen = true
			
			local door = Door.Get(objectId)
			door:Open()
			door:SetLocked(false)

		end
	
	end
	
end

--The door to the industrial area opens after the player accepts - for the people


function gd.quests.areaFQuestMalmouthSewers.upperBaseUnlockDoor()
	if Server && not upperBaseDoorOpen then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAF_INDUSTRIALUNLOCKED")) then
			local door01 = Door.Get(upperBaseDoorId)
		
			if door01 != nil then
				upperBaseDoorOpen = true
				door01:Open()
				door01:SetLocked(false)
				
			end
		
		end
		
	end
	
end

-- Garrund's dialogue randomizer

local DialogueRandomizer = 0

function gd.quests.areaFQuestMalmouthSewers.garrundRandomizer()

	math.randomseed(Time.Now())
	DialogueRandomizer = random(1,4)
	
	return DialogueRandomizer

end
