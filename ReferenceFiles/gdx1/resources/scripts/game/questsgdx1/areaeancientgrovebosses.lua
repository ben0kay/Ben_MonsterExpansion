/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaEAncientGroveBosses = {}


local doorBossA01 = 0
local doorBossA02 = 0
local doorBossB01 = 0
local doorBossB02 = 0
local doorPermaLocked = false
local doorLockedWarning = false
local doorBossDead = false



-- Ancient Grove Boss, unlocks access to Epic Door.
function gd.quests.areaEAncientGroveBosses.doorGuardianKilled()
	
	doorBossDead = true

end



-- Ancient Grove boss door initialization
function gd.quests.areaEAncientGroveBosses.doorBossA01OnAddToWorld(objectId)
	
	if Server then
		doorBossA01 = objectId
	
	end
	
end

function gd.quests.areaEAncientGroveBosses.doorBossA02OnAddToWorld(objectId)
	
	if Server then
		doorBossA02 = objectId
	
	end
	
end

function gd.quests.areaEAncientGroveBosses.doorBossB01OnAddToWorld(objectId)
	
	if Server then
		doorBossB01 = objectId
	
	end
	
end

function gd.quests.areaEAncientGroveBosses.doorBossB02OnAddToWorld(objectId)
	
	if Server then
		doorBossB02 = objectId
	
	end
	
end


function gd.quests.areaEAncientGroveBosses.Boss1Killed()
	
	if Server then
		local door01 = Door.Get(doorBossA01)
		local door02 = Door.Get(doorBossA02)
	
		if door01 != nil then
			door01:Open()
		
		end
	
		if door02 != nil then
			door02:Open()
		
		end
	
	end

end

-- final boss of dungeon
-- flames are activated when boss enters phase 2
-- at maxFlames, all flames become active on each sequence
local finalBossKilled = false
local bossPhase02Spawned = false
local flamesCooldown = 0
local flamesSequence = 0
local flameCounter = 0
local flamesActive = false

local flamesResetCount = 4
local maxFlames = 12

local bossFlameIds = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

function gd.quests.areaEAncientGroveBosses.Boss2Killed()

	GiveTokenToLocalPlayer("AREAE_ANCIENTGROVE_CLEARED")
	
	if Server then	
		finalBossKilled = true
		
		local door01 = Door.Get(doorBossB01)
		local door02 = Door.Get(doorBossB02)
	
		if door01 != nil then
			door01:Open()
		
		end
	
		if door02 != nil then
			door02:Open()
		
		end
		
		-- kill Flames
		local totalFlames = table.getn(bossFlameIds)
		
		for id = 1, totalFlames do
			local character = Character.Get(bossFlameIds[id])
			
			if (character != nil) then
				character:Kill()
				
			end
		
		end
	
	end

end

function gd.quests.areaEAncientGroveBosses.Boss2Phase2OnAddToWorld(objectId)
	if Server then
		bossPhase02Spawned = true
		
	end
	
end

function gd.quests.areaEAncientGroveBosses.bossFlames01OnAddToWorld(objectId)
	if Server then
		bossFlameIds[1] = objectId
		
		-- increase maximum sequences before all flames are active and # of triggers before new flame sequence starts, based on difficulty
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			maxFlames = 25
			flamesResetCount = 6
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			maxFlames = 16
			flamesResetCount = 6
		end
		
	end
	
end

function gd.quests.areaEAncientGroveBosses.bossFlames02OnAddToWorld(objectId)
	if Server then
		bossFlameIds[2] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames03OnAddToWorld(objectId)
	if Server then
		bossFlameIds[3] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames04OnAddToWorld(objectId)
	if Server then
		bossFlameIds[4] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames05OnAddToWorld(objectId)
	if Server then
		bossFlameIds[5] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames06OnAddToWorld(objectId)
	if Server then
		bossFlameIds[6] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames07OnAddToWorld(objectId)
	if Server then
		bossFlameIds[7] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames08OnAddToWorld(objectId)
	if Server then
		bossFlameIds[8] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames09OnAddToWorld(objectId)
	if Server then
		bossFlameIds[9] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames10OnAddToWorld(objectId)
	if Server then
		bossFlameIds[10] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames11OnAddToWorld(objectId)
	if Server then
		bossFlameIds[11] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames12OnAddToWorld(objectId)
	if Server then
		bossFlameIds[12] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames13OnAddToWorld(objectId)
	if Server then
		bossFlameIds[13] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames14OnAddToWorld(objectId)
	if Server then
		bossFlameIds[14] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames15OnAddToWorld(objectId)
	if Server then
		bossFlameIds[15] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames16OnAddToWorld(objectId)
	if Server then
		bossFlameIds[16] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames17OnAddToWorld(objectId)
	if Server then
		bossFlameIds[17] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames18OnAddToWorld(objectId)
	if Server then
		bossFlameIds[18] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames19OnAddToWorld(objectId)
	if Server then
		bossFlameIds[19] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.bossFlames20OnAddToWorld(objectId)
	if Server then
		bossFlameIds[20] = objectId
	end
end

function gd.quests.areaEAncientGroveBosses.triggerFlamesMP()

	if Server && bossPhase02Spawned && not finalBossKilled then
		if not flamesActive then
			flamesActive = true

			local totalFlames = table.getn(bossFlameIds)
			
			if flameCounter >= maxFlames then
				for id = 1, totalFlames do
					local flame = Character.Get(bossFlameIds[id])
					
					if flame != nil then
						flame:UseSkillAction("records/skills/nonplayerskillsgdx1/bossskills/ancientgrove/flameofgargabol_flamethrower.dbr", bossFlameIds[id], false)
					
					end
					
				end

			else
				flameCounter = flameCounter + 1
				flamesSequence = flamesSequence + 1

				if flamesSequence == 1 then
					for id = 1, totalFlames, 3 do
						local flame = Character.Get(bossFlameIds[id])
						
						if flame != nil then
							flame:UseSkillAction("records/skills/nonplayerskillsgdx1/bossskills/ancientgrove/flameofgargabol_flamethrower.dbr", bossFlameIds[id], false)
						
						end
					
					end
				
				elseif flamesSequence == 2 then
					totalFlames = totalFlames - totalFlames/2
					
					for id = 1, totalFlames do
						local flame = Character.Get(bossFlameIds[id])
						
						if flame != nil then
							flame:UseSkillAction("records/skills/nonplayerskillsgdx1/bossskills/ancientgrove/flameofgargabol_flamethrower.dbr", bossFlameIds[id], false)
						
						end
					
					end
				
				elseif flamesSequence == 3 then
					for id = 2, totalFlames, 3 do
						local flame = Character.Get(bossFlameIds[id])
						
						if flame != nil then
							flame:UseSkillAction("records/skills/nonplayerskillsgdx1/bossskills/ancientgrove/flameofgargabol_flamethrower.dbr", bossFlameIds[id], false)
						
						end
					
					end
				
				else
					flamesSequence = 0
					local startingFlame = totalFlames/2 + 1
					
					for id = startingFlame, totalFlames do
						local flame = Character.Get(bossFlameIds[id])
						
						if flame != nil then
							flame:UseSkillAction("records/skills/nonplayerskillsgdx1/bossskills/ancientgrove/flameofgargabol_flamethrower.dbr", bossFlameIds[id], false)
						
						end
					
					end
				
				end
			
			end
		
		else
			if flamesCooldown < flamesResetCount then
				flamesCooldown = flamesCooldown + 1
				
			else
				flamesCooldown = 0
				flamesActive = false
				
			end
		
		
		end
		
	end

end
	
function gd.quests.areaEAncientGroveBosses.triggerFlames(triggererId)

	QuestEvent("ancientGroveFinalBossFlames")

end

--
-- Exit Shortcut Control
-- Only opens after main chest is opened
-- 
local shortcutId = 0
local shortcutOpen = false

function gd.quests.areaEAncientGroveBosses.unlockShortcut()

	UI.Notify("tagNotificationStepsOfTormentShortcut")
	
	if Server then
		shortcutOpen = true
		
		local door = Door.Get(shortcutId)
		
		-- Unlock Shortcut
		if door != nil then
			door:SetLocked(false)
			door:Open()
		end
		
	
	end
	
end

function gd.quests.areaEAncientGroveBosses.exitShortcutOnAddToWorld(objectId)
	
	if Server then
		shortcutId = objectId
		
		if shortcutOpen then
			local door = Door.Get(objectId)
			
			if (door:IsLocked()) then
				door:SetLocked(false)
				door:Open()
				
			end
		
		end
		
	end
	
end

-- No Riftgate region warning trigger
function gd.quests.areaEAncientGroveBosses.warningNoRiftgates(triggererId)

	local player = Player.Get(triggererId)

	if (player != nil) && (player:HasToken("WARNING_ANCIENTGROVE") == false) then
		UI.Notify("tagNotification_WarningRiftgateDisabled")
		GiveTokenIfPlayer(triggererId, "WARNING_ANCIENTGROVE")
	end
	
end

--
-- Ancient Grove Entry door control
--

function gd.quests.areaEAncientGroveBosses.epicDoorOnInteractGlobalMP()

	doorPermaLocked = true

end

function gd.quests.areaEAncientGroveBosses.epicDoorOnInteract(objectId, userId)
	
	local player = Player.Get(userId)
	local door = Door.Get(objectId)
		
	if (door != nil) then
		
		if player:HasItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false) && doorPermaLocked == false && doorBossDead == true then
		
			-- Mark the door as locked permanently for all players
			doorPermaLocked = true
			QuestGlobalEvent("ancientGroveEpicDoor")
			
			-- Consume key to unlock door		
			door:Open()
			player:TakeItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false)
			
			UI.Notify("tagNotification_WarningAncientGroveGates")
				
		elseif player:HasItem("records/items/crafting/materials/craft_skeletonkey.dbr", 1, false) && doorLockedWarning == false && doorBossDead == true then
			doorLockedWarning = true
			UI.Notify("tagNotification_WarningAncientGroveGatesLocked")
		
		end
			
	end
	
end

--
-- Mogdrogen appearing in the world
--

function gd.quests.areaEAncientGroveBosses.mogdrogenOnAddToWorld(objectId)

	if Server then
		if (Game.GetGameDifficulty() == Game.Difficulty.Epic || Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
			local coords = Entity.Get(objectId):GetCoords()
			local spawn = Entity.Create("records/creatures/npcs/questnpcs/gdareae/npc_avatarofmogdrogen_01.dbr")
			spawn:SetCoords(coords)
		end
	
	end
	
end