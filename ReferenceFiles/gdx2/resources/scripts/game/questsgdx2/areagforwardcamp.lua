/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGForwardCamp = {}


--The forward base door opens after the player has progressed in the plot

--Door Setup
local forwardCampDoor01Open = false
local forwardCampDoor02Open = false
local forwardCampDoor01Id = 0
local forwardCampDoor02Id = 0

function gd.quests.areaGForwardCamp.Door01OnAddToWorld(objectId)
	
	if Server then
		-- disabled, front gate permanently open
		--forwardCampDoor01Id = objectId
		
		--local player = Game.GetLocalPlayer()

		--if (player:HasToken("AREAG_FORWARDCAMP_UNLOCKED") || forwardCampDoor01Open == true) then
			
			local door = Door.Get(objectId)
			door:Open()

		--end
	
	end
	
end

function gd.quests.areaGForwardCamp.Door02OnAddToWorld(objectId)
	
	if Server then
		
		forwardCampDoor02Id = objectId
		
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAG_FORWARDCAMP_KORVAAKUNLOCKED") || forwardCampDoor02Open == true) then
			
			local door = Door.Get(objectId)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaGForwardCamp.UnlockDoors()

	if Server then
			-- disabled, front gate permanently open
			--local door01 = Door.Get(forwardCampDoor01Id)
			
			--if door01 != nil && not forwardCampDoor01Open then
				--forwardCampDoor01Open = true
				--door01:Open()
			--end
			
	end
		
end

function gd.quests.areaGForwardCamp.UnlockDoorsKorvaak()

	if Server then

			local door02 = Door.Get(forwardCampDoor02Id)
			
			if door02 != nil && not forwardCampDoor02Open then
				forwardCampDoor02Open = true
				door02:Open()
			end
			
	end
		
end
	
