/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGDreegQuests = {}


--
-- Dreeg Quest 01 - Credit for clearing the temples
--

local corruptionProxySpawned = { false, false, false, false, false, false, false, false, false, false, false, false, false, false, false }
local corruptionDBRS = { "records/proxies/boss&questgdx2/proxy_areag_dreegcorrupted_01.dbr", "records/proxies/boss&questgdx2/proxy_areag_dreegcorrupted_02.dbr", "records/proxies/boss&questgdx2/proxy_areag_dreegcorrupted_03.dbr" }

local function spawnCorruptionQuest(id, dbrId)
	local entity = Entity.Get(id)
	
	if entity != nil then
		local coords = entity:GetCoords()	
		local proxy = Proxy.Create(corruptionDBRS[dbrId], coords.origin)
		
		proxy:SetCoords(coords)
	
	end

end 

-- Armor Corruptions
function gd.quests.areaGDreegQuests.corruptionQuest01OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[1] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[1] = true
			spawnCorruptionQuest(objectId, 3)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest02OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[2] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[2] = true
			spawnCorruptionQuest(objectId, 3)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest03OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[3] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[3] = true
			spawnCorruptionQuest(objectId, 3)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest04OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[4] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[4] = true
			spawnCorruptionQuest(objectId, 3)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest05OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[5] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[5] = true
			spawnCorruptionQuest(objectId, 3)
		end
		
	end
	
end

-- Hound Corruptions
function gd.quests.areaGDreegQuests.corruptionQuest06OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[6] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[6] = true
			spawnCorruptionQuest(objectId, 2)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest07OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[7] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[7] = true
			spawnCorruptionQuest(objectId, 2)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest08OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[8] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[8] = true
			spawnCorruptionQuest(objectId, 2)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest09OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[9] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[9] = true
			spawnCorruptionQuest(objectId, 2)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest10OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[10] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[10] = true
			spawnCorruptionQuest(objectId, 2)
		end
		
	end
	
end

-- Wraith Corruptions
function gd.quests.areaGDreegQuests.corruptionQuest11OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[11] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[11] = true
			spawnCorruptionQuest(objectId, 1)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest12OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[12] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[12] = true
			spawnCorruptionQuest(objectId, 1)
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.corruptionQuest13OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[13] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[13] = true
			spawnCorruptionQuest(objectId, 1)
		end
		
	end
	
end


function gd.quests.areaGDreegQuests.corruptionQuest14OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[14] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[14] = true
			spawnCorruptionQuest(objectId, 1)
		end
		
	end
	
end


function gd.quests.areaGDreegQuests.corruptionQuest15OnAddToWorld(objectId)

	if Server && not corruptionProxySpawned[15] then
		local player = Game.GetLocalPlayer()
		
		if player:AnyoneHasToken("AREAG_CHOSEFACTION_DREEG") then
			corruptionProxySpawned[15] = true
			spawnCorruptionQuest(objectId, 1)
		end
		
	end
	
end


-- Site 01 
local Site01Killed = 0

function gd.quests.areaGDreegQuests.dreegCorruption01GlobalMP()

	GiveTokenToLocalPlayer("AREAG_DREEGCORRUPTED01_ALLKILLED")

end

function gd.quests.areaGDreegQuests.corrupt01OnKill()
	local player = Game.GetLocalPlayer()
	
	Site01Killed = Site01Killed + 1
	
	if (Site01Killed >= 15 && player:ServerHasToken("AREAG_DREEGCORRUPTED01_ALLKILLED") == false) then
	
		QuestGlobalEvent("dreegCorruption01")
	
	end

end

-- Site 02
local Site02Killed = 0

function gd.quests.areaGDreegQuests.dreegCorruption02GlobalMP()

	GiveTokenToLocalPlayer("AREAG_DREEGCORRUPTED02_ALLKILLED")

end

function gd.quests.areaGDreegQuests.corrupt02OnKill()
	local player = Game.GetLocalPlayer()
	
	Site02Killed = Site02Killed + 1
	
	if (Site02Killed >= 15 && player:ServerHasToken("AREAG_DREEGCORRUPTED02_ALLKILLED") == false) then
	
		QuestGlobalEvent("dreegCorruption02")
	
	end
	

end

-- Site 03
local Site03Killed = 0

function gd.quests.areaGDreegQuests.dreegCorruption03GlobalMP()

	GiveTokenToLocalPlayer("AREAG_DREEGCORRUPTED03_ALLKILLED")

end

function gd.quests.areaGDreegQuests.corrupt03OnKill()
	local player = Game.GetLocalPlayer()
	
	Site03Killed = Site03Killed + 1
	
	if (Site03Killed >= 15 && player:ServerHasToken("AREAG_DREEGCORRUPTED03_ALLKILLED") == false) then
	
		QuestGlobalEvent("dreegCorruption03")
	
	end
	

end

--
-- Dreeg Quest 02 - Credit for killing the usurper
--
function gd.quests.areaGDreegQuests.dreegUsurperOnKill()

	GiveTokenToLocalPlayer("AREAG_DREEGUSURPER_KILLED")

end


--
-- Dreeg Quest 03 - Foretold Future
--

-- Riftgate to DC
local lockedVoidRiftId = 0
local riftOpened = false

-- Rift
function gd.quests.areaGDreegQuests.lockedChaosRiftOnAddToWorld(objectId)
	
	if Server then
		
		local player = Game.GetLocalPlayer()
		lockedVoidRiftId = objectId

		-- Unlock the door if the player has the token or the door variable is set, or if the host is not part of the Bysmiel faction but another player has the door unlocked
		if (player:HasToken("AREAG_DREEGQUESTRIFT_OPENED") || riftOpened == true || (player:AnyoneHasToken("AREAG_DREEGQUESTRIFT_OPENED") && not player:HasToken("AREAG_CHOSEFACTION_DREEG"))) then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

-- Open The Rift
function gd.quests.areaGDreegQuests.RiftOpened()

	if Server then
		local player = Game.GetLocalPlayer()
		riftOpened= true
		
		local door = Door.Get(lockedVoidRiftId)
		
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/eldritchrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
	end
	
end

-- Credit for killing the monster and shortcut back out
local lockedEldritchShortcutRift = 0
local shortcutRiftOpened = false

function gd.quests.areaGDreegQuests.lockedShortcutRiftOnAddToWorld(objectId)
	
	if Server then
		lockedEldritchShortcutRift = objectId

		if shortcutRiftOpened then
			local door = Door.Get(objectId)
		
			if door ~= nil then
				door:SetLocked(false)
				door:Open()

			end
		
		end
		
	end
	
end

function gd.quests.areaGDreegQuests.dreegDCBossKill()

	GiveTokenToLocalPlayer("AREAG_DREEGDCBOSS_KILLED")
	
	if Server then		
		local door = Door.Get(lockedEldritchShortcutRift)
			
		if door ~= nil then
			door:SetLocked(false)
			door:Open()
			shortcutRiftOpened= true
			
			local coords = door:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/eldritchrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
			
		end
		
	end

end



