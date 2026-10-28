/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGSQKorvaakMessenger = {}


--
-- Credit for killing the messenger
--
local doorBossA01 = 0

function gd.quests.areaGSQKorvaakMessenger.messengerOnKill()

	GiveTokenToLocalPlayer("AREAG_KORVAAKMESSENGER_KILLED")
	
	if Server then		
		print "unlock the door"
		local bossDoor01 = Door.Get(doorBossA01)
		
		-- unlock boss room
		if bossDoor01 != nil then
			bossDoor01:Open()
		
		end
		
	end

end

function gd.quests.areaGSQKorvaakMessenger.doorA01OnAddToWorld(objectId)
	
	if Server then
		doorBossA01 = objectId
	
	end
	
end


-- Boss reset
local bossId = 0

function gd.quests.areaGSQKorvaakMessenger.messengerAvatarOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaGSQKorvaakMessenger.bossLeaveRoom()

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

