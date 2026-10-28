/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGCovenBase = {}


--The witch god base door opens after the player has choosen a faction to side with.

--Door Setup
local covenbaseDoor01Open = false
local covenBaseDoor01Id = 0

function gd.quests.areaGCovenBase.covenBaseDoor01OnAddToWorld(objectId)
	if Server && not covenbaseDoor01Open then
		covenBaseDoor01Id = objectId
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAG_COVENBASE_UNLOCKED")) then
			covenbaseDoor01Open = true
			
			local door = Door.Get(objectId)
			door:Open()

		end
	
	end
	
end

function gd.quests.areaGCovenBase.covenBaseUnlockDoors()

	if Server then
		local player = Game.GetLocalPlayer()
		
		if (player:HasToken("AREAG_COVENBASE_UNLOCKED")) then			
			local door01 = Door.Get(covenBaseDoor01Id)
			
			if door01 != nil && not covenbaseDoor01Open then
				covenbaseDoor01Open = true
				door01:Open()
				
			end
			
		end
		
	end
	
end


-- Difficulty Merits NPC
function gd.quests.areaGCovenBase.meritsNPCOnAddToWorld(objectId)

	if Server && Game.GetGameDifficulty() != Game.Difficulty.Normal then
		local coords = Entity.Get(objectId):GetCoords()
		local npc = Character.Create("records/creatures/npcs/questnpcs/gdareag/npc_difficultymerits_01.dbr")
		npc:SetCoords(coords)

	end
	
end


