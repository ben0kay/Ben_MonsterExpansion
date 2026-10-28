/*
	
	GRIM DAWN
	scripts/quests/devilscrossing.lua
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.wightmireCultistCellar = {}


local bossDoorEnter = 0
local bossDoorExit = 0

function gd.quests.wightmireCultistCellar.bossDoorEnterOnAddToWorld(objectId)
	
	if Server then
		bossDoorEnter = objectId
		
	end
	
end

function gd.quests.wightmireCultistCellar.bossDoorExitOnAddToWorld(objectId)

	if Server then
		bossDoorExit = objectId

	end
	
end




function gd.quests.wightmireCultistCellar.bossDoorOpen()
	
	if Server then
		local door01 = Door.Get(bossDoorEnter)	
		local door02 = Door.Get(bossDoorExit)
	
		if door01 ~= nil then
			door01:Open()
		
		end
	
		if door02 ~= nil then
			door02:Open()
		
		end
		
	end

end

-- Teleport Salazar back in if he is removed from room
local bossId = 0

function gd.quests.wightmireCultistCellar.bossOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.wightmireCultistCellar.bossLeaveRoom()

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

