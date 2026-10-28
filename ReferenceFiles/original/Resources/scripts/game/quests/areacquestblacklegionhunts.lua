/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaCQuestBlackLegionHunts = {}

function gd.quests.areaCQuestBlackLegionHunts.manticoreKilled()

	GiveTokenToLocalPlayer("AREAC_PRIDEJAGGEDWASTE_KILLED")
	
end

function gd.quests.areaCQuestBlackLegionHunts.thornedHorrorKilled()

	GiveTokenToLocalPlayer("AREAC_HUNTINGTHEHUNTER_KILLED")
	
end

function gd.quests.areaCQuestBlackLegionHunts.spiderKilled()

	GiveTokenToLocalPlayer("AREAC_GLOOMWEAVER_KILLED")
	
end

-- Tyrant's Hold
local bossDoor01Id = 0

function gd.quests.areaCQuestBlackLegionHunts.dranghoulKilled()

	GiveTokenToLocalPlayer("AREAC_GROBLETYRANT_KILLED")
	
	-- spawn faction emissaries in Homestead
	if Server then		
		-- Reopen doors to boss area
		local door01 = Door.Get(bossDoor01Id)
	
		if door01 != nil then
			door01:Open()
		end
		
	end
	
end


-- Boss Door
function gd.quests.areaCQuestBlackLegionHunts.bossDoor01OnAddToWorld(objectId)
	
	if Server then
		bossDoor01Id = objectId
		
	end
	
end

local bossId = 0

function gd.quests.areaCQuestBlackLegionHunts.bossOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaCQuestBlackLegionHunts.bossLeaveRoom()

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


