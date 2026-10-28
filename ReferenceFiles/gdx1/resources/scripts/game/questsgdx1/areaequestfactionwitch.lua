/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEQuestFactionWitch = {}

--
-- Allure of the Wendigo - Witch betrayer
--

-- Boss Door Control
local witchDoorEnter = 0

function gd.quests.areaEQuestFactionWitch.witchDoorEnterOnAddToWorld(objectId)
	
	if Server then
		witchDoorEnter = objectId
		
	end
	
end

function gd.quests.areaEQuestFactionWitch.witchBetrayerOnKill()

	GiveTokenToLocalPlayer("AREAE_WITCHBETRAYER_KILLED")
	
	-- open door
	if Server then
		local door01 = Door.Get(witchDoorEnter)	
	
		if door01 ~= nil then
			door01:Open()
		
		end
		
	end

end

-- Prevent Witch from Leaving Room
local bossId = 0

function gd.quests.areaEQuestFactionWitch.witchOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaEQuestFactionWitch.witchLeaveRoom()

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

-- Sylvarria, plant boss
-- Boss Door Control
local plantDoorEnter = 0

function gd.quests.areaEQuestFactionWitch.plantDoorEnterOnAddToWorld(objectId)
	
	if Server then
		plantDoorEnter = objectId
		
	end
	
end

function gd.quests.areaEQuestFactionWitch.sylvarriaOnKill()

	GiveTokenToLocalPlayer("AREAE_SYLVARRIA_KILLED")
	
	-- open door
	if Server then
		local door01 = Door.Get(plantDoorEnter)	
	
		if door01 ~= nil then
			door01:Open()
		
		end
		
	end

end

--
-- Cook in the coven
--

-- Checks if the player has used the give restore ritual dialogue in the coven
local RestoreRitual = false

function gd.quests.areaEQuestFactionWitch.ritualCheck()

	local test = false
	
	if not RestoreRitual then
		test = true
	
	end
	
	return test

end

function gd.quests.areaEQuestFactionWitch.giveRitual()
	
	local player = Game.GetLocalPlayer()
	
	if (player != nil) && (player:HasToken("AREAE_RESTORERITUAL_UNLOCKED") == false) then
			GiveTokenToLocalPlayer("AREAE_RESTORERITUAL_UNLOCKED")
	end

	if not RestoreRitual then
		RestoreRitual = true
		
	end

end