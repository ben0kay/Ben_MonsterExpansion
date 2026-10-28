/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFCelestialSmith = {}

--
-- Special Smith that only spawns on Elite/Ultimate difficulty
--

function gd.quests.areaFCelestialSmith.smithOnAddToWorld(objectId)

	if Server then
		if (Game.GetGameDifficulty() == Game.Difficulty.Epic || Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Entity.Create("records/creatures/npcs/merchants/areaf_blacksmithb102.dbr")
			spawn:SetCoords(coords)
		end
	
	end
	
end