/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaFQuestMalmouthInner = {}

--
-- The player claims the portal behind the city gates
-- 

function gd.quests.areaFQuestMalmouthInner.ClaimedPortal(triggererId)

	local player = Player.Get(triggererId)
	
	if (player:HasToken("AREAF_INNERCITYRIFTGATECLAIMED") == false) then
	
		GiveTokenIfPlayer(triggererId, "AREAF_INNERCITYRIFTGATECLAIMED")
	
	end
	
end



--
-- The player must destroy the factory vents to unlock the factory door
--
local bossFactoryEntrance = 0
local bossFactoryUgDoor = 0
local bossFactoryOpen = false
local bossFactoryUGOpen = false

local Vent01Destroyed = false
local Vent02Destroyed = false
local Vent03Destroyed = false

-- Called from object when vent is killed
function gd.quests.areaFQuestMalmouthInner.VentOneKilled()

	Vent01Destroyed = true
	
	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED")) then
		if (player != nil) then
			player:GiveToken("AREAF_FACTORYVENT01")
			
		end
		
		if (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) then
			player:GiveToken("AREAF_FACTORYVENTS_ALLDESTROYED")
			
		end
		
	end
	
	if (Vent01Destroyed && Vent02Destroyed && Vent03Destroyed) || (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) || player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED") then
		-- Open the factory if all 3 vents are destroyed, or if the player is on/has done final boss fight
		local door = Door.Get(bossFactoryEntrance)
		local door01 = Door.Get(bossFactoryUgDoor)
	
		if door ~= nil && player:HasToken("AREAF_FINALFACTORY") then
			door:SetLocked(false)
			door:Open()
			bossFactoryOpen = true
			
			door01:SetLocked(false)
			door01:Open()
			bossFactoryUGOpen = true
		end
	
	end

end

-- Called from object when vent is killed
function gd.quests.areaFQuestMalmouthInner.VentTwoKilled()

	Vent02Destroyed = true
	
	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED")) then
		if (player != nil) then
			player:GiveToken("AREAF_FACTORYVENT02")
			
		end
		
		if (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) then
			player:GiveToken("AREAF_FACTORYVENTS_ALLDESTROYED")
			
		end
		
	end
	
	if (Vent01Destroyed && Vent02Destroyed && Vent03Destroyed) || (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) || player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED") then
		-- Open the factory if all 3 vents are destroyed, or if the player is on/has done final boss fight
		local door = Door.Get(bossFactoryEntrance)
		local door01 = Door.Get(bossFactoryUgDoor)
	
		if door ~= nil && player:HasToken("AREAF_FINALFACTORY") then
			door:SetLocked(false)
			door:Open()
			bossFactoryOpen = true
			
			door01:SetLocked(false)
			door01:Open()
			bossFactoryUGOpen = true
		end
	
	end

end

-- Called from object when vent is killed
function gd.quests.areaFQuestMalmouthInner.VentThreeKilled()

	Vent03Destroyed = true
	
	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED")) then
		if (player != nil) then
			player:GiveToken("AREAF_FACTORYVENT03")
			
		end
		
		if (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) then
			player:GiveToken("AREAF_FACTORYVENTS_ALLDESTROYED")
			
		end
		
	end
	
	if (Vent01Destroyed && Vent02Destroyed && Vent03Destroyed) || (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) || player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED") then
		-- Open the factory if all 3 vents are destroyed, or if the player is on/has done final boss fight
		local door = Door.Get(bossFactoryEntrance)
		local door01 = Door.Get(bossFactoryUgDoor)
	
		if door ~= nil && player:HasToken("AREAF_FINALFACTORY") then
			door:SetLocked(false)
			door:Open()
			bossFactoryOpen = true
			
			door01:SetLocked(false)
			door01:Open()
			bossFactoryUGOpen = true
		end
	
	end

end

-- Factory UG Door
function gd.quests.areaFQuestMalmouthInner.bossFactoryUgDoorOnAddToWorld(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		bossFactoryUgDoor = objectId
		
		if (Vent01Destroyed && Vent02Destroyed && Vent03Destroyed) || (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) ||(player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED")) then
			-- Open Final Boss Crypt if player is on, or has done, the final quest
			local door = Door.Get(objectId)
		
			if door ~= nil && player:HasToken("AREAF_FINALFACTORY") then
				door:SetLocked(false)
				door:Open()
				bossFactoryUGOpen = true
			end
		
		end
		
	end
	
end

-- Factory Door Object
function gd.quests.areaFQuestMalmouthInner.bossFactoryDoorOnAddToWorld(objectId)
	
	if Server then
		local player = Game.GetLocalPlayer()
		
		bossFactoryEntrance = objectId
		
		if (Vent01Destroyed && Vent02Destroyed && Vent03Destroyed) || (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) ||(player:HasToken("AREAF_FACTORYVENTS_ALLDESTROYED")) then
			-- Open Final Boss Crypt if player is on, or has done, the final quest
			local door = Door.Get(objectId)
		
			if door ~= nil && player:HasToken("AREAF_FINALFACTORY") then
				door:SetLocked(false)
				door:Open()
				bossFactoryOpen = true
			end
		
		end
		
	end
	
end

function gd.quests.areaFQuestMalmouthInner.unlockBossFactoryDoor()
	
	if Server && not bossFactoryOpen && not bossFactoryUGOpen then
		local player = Game.GetLocalPlayer()
		
		if (Vent01Destroyed && Vent02Destroyed && Vent03Destroyed) || (player:HasToken("AREAF_FACTORYVENT01") && player:HasToken("AREAF_FACTORYVENT02") && player:HasToken("AREAF_FACTORYVENT03")) ||(player:AnyoneHasToken("AREAF_FACTORYVENTS_ALLDESTROYED")) then
			
			local door = Door.Get(bossFactoryEntrance)
			local door01 = Door.Get(bossFactoryUgDoor)
		
			if door ~= nil && door01 ~= nil then
				door:SetLocked(false)
				door:Open()
				bossFactoryOpen = true
				
				door01:SetLocked(false)
				door01:Open()
				bossFactoryUGOpen = true
			end
		
		end
		
	end
	
end


