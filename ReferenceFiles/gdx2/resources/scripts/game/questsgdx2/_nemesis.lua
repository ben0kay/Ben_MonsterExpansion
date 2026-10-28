/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.nemesisGDX2 = {}

-- Grim Dawn Nemesis Bosses
 local eldritchSpawned = false
 local monsterId = 0

 local eldritchKilled = false

 local eldritchChestDestroyed = false

 local function CharacterCreateArgs()

	 local averageLevel = Game.GetAveragePlayerLevel()
	 local monsterLevel = 0
	 local minLevel = 0
	 local maxLevel = 0

	 if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		 minLevel = 40
		 maxLevel = 100
	 elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		 minLevel = 55
		 maxLevel = 100
	 else
		 minLevel = 65
		 maxLevel = 200
	 end
	
	 if (averageLevel < minLevel) then
		 monsterLevel = ((minLevel+(minLevel/50))+4)
	 elseif (averageLevel > maxLevel) then
		 monsterLevel = ((maxLevel+(maxLevel/50))+4)
	 else
		 monsterLevel = ((averageLevel+(averageLevel/50))+4)

	 end

	 return monsterLevel, nil
	
 end

 function gd.nemesisGDX2.eldritchNemesisOnAddToWorld(objectId)

	 if Server then
		 local player = Game.GetLocalPlayer()
		 if (player:GetFaction("USER16") == -20000 && eldritchSpawned == false && eldritchChestDestroyed == false) then
			 eldritchSpawned = true
			 monsterId = objectId
			 local coords = Entity.Get(objectId):GetCoords()
			
			 local spawn = Character.Create ("records/creatures/enemies/nemesis/nemesis_eldritch_01.dbr", CharacterCreateArgs())
			 spawn:SetCoords(coords)
		
		 end
	
	 end
	
 end

 -- Chests
 local eldritchChestId = 0

 function gd.nemesisGDX2.eldritchChestOnAddToWorld(objectId)
	
	 if Server then	
		 eldritchChestId = objectId
		 local chestEntity = Entity.Get(objectId)
		 local player = Game.GetLocalPlayer()
	
		 -- Destroy chest if this is the initial load and the player does not meet the faction requirements to spawn the Nemesis
		 if (player != nil) && (chestEntity:IsReloaded() == false) && (player:GetFaction("USER16") > -20000) then
			 chestEntity:Destroy()
			 eldritchChestDestroyed = true
		 elseif eldritchKilled then
			 local chest = Chest.Get(objectId)
			 chest:SetLocked(false)
		
		 end
	
	 end
	
 end

 function gd.nemesisGDX2.eldritchNemesisKilled()
	
	 if Server then
		 local chest = Chest.Get(eldritchChestId);
		
		 eldritchKilled = true
		
		 -- Unlock chest if present
		 if (chest != nil) then
			 chest:SetLocked(false)
		 end
		
	 end
	
 end
 
 
 
 