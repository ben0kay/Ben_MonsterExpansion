/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.quests.areaGFatherKymon = {}

-- 
--Father kymon - The player must first speak with father kymon if he is on the korvaak tomb quest.
-- 
local KymonBossId = 0
local KymonBossSpawned = false
local KymonState = {Default = 0, Talk = 1}

local KymonBossStateObjects = orderedTable();
	KymonBossStateObjects["AREAG_KORVAAKTOMB_KYMONTALK"] = { state = KymonState.Talk,  dbr = "records/creatures/npcs/questnpcs/gdareag/npc_fatherkymon_01.dbr" }
	KymonBossStateObjects[""] = { state = KymonState.Default, dbr = "records/creatures/enemies/boss&quest/fatherkymon.dbr" }

local function CharacterCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local maxLevel = 0
	local originPoint = Entity.Get(KymonBossId):GetCoords().origin

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		maxLevel = 100
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		maxLevel = 100
	else
		maxLevel = 200
	end
	
	if (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+4)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+4)

	end
	
	if monsterLevel > maxLevel then
		originPoint = nil
	
	end

	return monsterLevel, originPoint
	
end
	
function gd.quests.areaGFatherKymon.kymonBossOnAddToWorld(objectId)

	if Server && not KymonBossSpawned then
		KymonBossId = objectId;
		
		local userdata = {}
		local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, KymonBossStateObjects, Character, CharacterCreateArgs)
		Shared.setUserdata(objectId, userdata)
		
		-- Don't respawn if spawned as hostile
		if (newState == KymonState.Default) then
			KymonBossSpawned = true
		end
		
	end
	
end

gd.quests.areaGFatherKymon.kymonBossOnDestroy = ClearObjectUserdata

-- Kymon hostile transition - called by conversation with Kymon
function gd.quests.areaGFatherKymon.kymonHostileSwitchGlobalMP()

	local player = Game.GetLocalPlayer()
	
	if (player != nil) && player:HasToken("AREAG_KORVAAKTOMB_KYMONTALK") then
		player:RemoveToken("AREAG_KORVAAKTOMB_KYMONTALK")
		
	end

end

function gd.quests.areaGFatherKymon.kymonHostileSwitch()
	
	if Server && not KymonBossSpawned then
		KymonBossSpawned = true
		
		QuestGlobalEvent("kymonHostileSwitchGlobalMP")

		local MPOverrideDbr = "records/creatures/enemies/boss&quest/fatherkymon.dbr"
		local MPOverrideState = true
		
		local coords = Entity.Get(KymonBossId):GetCoords()	

		UpdateObjectSwap(KymonBossId, KymonBossStateObjects, Character, CharacterCreateArgs, MPOverrideState, MPOverrideDbr)

		local fx = Entity.Create("records/fx/ambient/fatherkymon_transition_fxpak01.dbr")
	
		if (fx != nil) then
			fx:NetworkEnable()
			fx:SetCoords(coords)
		end
		
	end

end


-- Scripted Magma Bursts
-- flames trigger randomly and with increasing quantity over duration of the encounter, based on difficulty
-- at maxFlames, all flames become active on each sequence
local kymonKilled = false
local flamesCooldown = 0
local flamesSequence = 0
local flameCounter = 0
local flamesActive = false

local korvaakVO = false

local flamesResetCount = 0
local maxFlames = 0

local bossFlameIds = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

function gd.quests.areaGFatherKymon.bossFlames01OnAddToWorld(objectId)
	if Server then
		bossFlameIds[1] = objectId
		
		-- increase maximum sequences before all flames are active and # of triggers before new flame sequence starts, based on difficulty
		if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
			flamesResetCount = 3
		elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
			flamesResetCount = 3
		else
			flamesResetCount = 1
		end
		
	end
	
end

function gd.quests.areaGFatherKymon.bossFlames02OnAddToWorld(objectId)
	if Server then
		bossFlameIds[2] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames03OnAddToWorld(objectId)
	if Server then
		bossFlameIds[3] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames04OnAddToWorld(objectId)
	if Server then
		bossFlameIds[4] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames05OnAddToWorld(objectId)
	if Server then
		bossFlameIds[5] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames06OnAddToWorld(objectId)
	if Server then
		bossFlameIds[6] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames07OnAddToWorld(objectId)
	if Server then
		bossFlameIds[7] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames08OnAddToWorld(objectId)
	if Server then
		bossFlameIds[8] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames09OnAddToWorld(objectId)
	if Server then
		bossFlameIds[9] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames10OnAddToWorld(objectId)
	if Server then
		bossFlameIds[10] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames11OnAddToWorld(objectId)
	if Server then
		bossFlameIds[11] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames12OnAddToWorld(objectId)
	if Server then
		bossFlameIds[12] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames13OnAddToWorld(objectId)
	if Server then
		bossFlameIds[13] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames14OnAddToWorld(objectId)
	if Server then
		bossFlameIds[14] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames15OnAddToWorld(objectId)
	if Server then
		bossFlameIds[15] = objectId
	end
end

function gd.quests.areaGFatherKymon.bossFlames16OnAddToWorld(objectId)
	if Server then
		bossFlameIds[16] = objectId
	end
end

function gd.quests.areaGFatherKymon.triggerFlamesMP()

	if Server && KymonBossSpawned && not kymonKilled then
		if not flamesActive then
			flamesActive = true

			local totalFlames = table.getn(bossFlameIds)
			
			-- if maxFlames is reached, activate all the flames at once on each sequence. Only on Ultimate difficulty.
			if flameCounter >= maxFlames && maxFlames != 0 then
				for id = 1, totalFlames do
					local flame = Character.Get(bossFlameIds[id])

					if flame != nil then
						flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower_02.dbr", bossFlameIds[id], false)
					
					end
					
				end

			else
				flameCounter = flameCounter + 1
				flamesSequence = flamesSequence + 1

				if flamesSequence == 1 then
					-- outer flames only
					for id = 1, totalFlames/2 do
						local flame = Character.Get(bossFlameIds[id])
						
						if flame != nil then
							if (Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower_02.dbr", bossFlameIds[id], false)
							else
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower.dbr", bossFlameIds[id], false)
							end
						
						end
					
					end
				
				elseif flamesSequence == 2 then
					-- inside flames only
					for id = 9, totalFlames do
						local flame = Character.Get(bossFlameIds[id])
						
						if flame != nil then
							if (Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower_02.dbr", bossFlameIds[id], false)
							else
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower.dbr", bossFlameIds[id], false)
							end
						
						end
					
					end
				
				elseif flamesSequence == 3 then
					-- left side flames only
					local flamesActive = { 1, 2, 3, 7, 8, 9, 10, 15, 16 }
					totalFlames = table.getn(flamesActive)
					
					for id = 1, totalFlames do
						local flame = Character.Get(bossFlameIds[flamesActive[id]])
						
						if flame != nil then
							if (Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower_02.dbr", bossFlameIds[flamesActive[id]], false)
							else
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower.dbr", bossFlameIds[flamesActive[id]], false)
							end
						
						end
					
					end
				
				elseif flamesSequence == 4 then
					-- right side flames only
					local flamesActive = { 3, 4, 5, 6, 7, 11, 12, 13, 14 }
					totalFlames = table.getn(flamesActive)
					
					for id = 1, totalFlames do
						local flame = Character.Get(bossFlameIds[flamesActive[id]])
						
						if flame != nil then
							if (Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower_02.dbr", bossFlameIds[flamesActive[id]], false)
							else
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower.dbr", bossFlameIds[flamesActive[id]], false)
							end
						
						end
					
					end
				
				else
					flamesSequence = 0
					-- cardinal flames
					local flamesActive = { 1, 3, 5, 7, 9, 11, 13, 15 }
					totalFlames = table.getn(flamesActive)
					
					for id = 1, totalFlames do
						local flame = Character.Get(bossFlameIds[flamesActive[id]])
						
						if flame != nil then
							if (Game.GetGameDifficulty() == Game.Difficulty.Legendary) then
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower_02.dbr", bossFlameIds[flamesActive[id]], false)
							else
								flame:UseSkillAction("records/skills/nonplayerskillsgdx2/bossskills/pets/fatherkymongeyser_flamethrower.dbr", bossFlameIds[flamesActive[id]], false)
							end
						
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
		
	elseif not korvaakVO && kymonKilled then
		korvaakVO = true
		
		local player = Game.GetLocalPlayer()
		local playerID = player:GetId()
		
		local coords = Entity.Get(playerID):GetCoords()
		local pfx = Entity.Create("records/fx/anomalies/korvaakvo_kymon.dbr")
		
		if (pfx != nil) then
			pfx:NetworkEnable()
			pfx:SetCoords(coords)
		end
		
		QuestGlobalEvent("korvaakVOKymon")
	
	end
	
end

function gd.quests.areaGFatherKymon.korvaakVOGlobalMP()

	korvaakVO = true

end
	
function gd.quests.areaGFatherKymon.triggerFlames(triggererId)

	QuestEvent("fatherKymonFlames")

end



-- Kymon Doors
local doorBossA01 = 0
local doorBossA02 = 0
local kymonExitDoorId = 0

local TombGuardDoor01Open = false
local TombGuardDoor01Id = 0

function gd.quests.areaGFatherKymon.doorKymonA01OnAddToWorld(objectId)
	
	if Server then
		doorBossA01 = objectId
	
	end
	
end

function gd.quests.areaGFatherKymon.doorKymonA02OnAddToWorld(objectId)
	
	if Server then
		doorBossA02 = objectId
	
	end
	
end

function gd.quests.areaGFatherKymon.kymonExitDoorInitialUpdate(objectId)
	
	if Server && kymonKilled then
		local door = Door.Get(objectId)
		
		door01:SetLocked(false)
		door01:Open()
	
	end
	
end

function gd.quests.areaGFatherKymon.kymonExitDoorOnAddToWorld(objectId)
	
	if Server then
		kymonExitDoorId = objectId
		
	end
	
end


-- kymon is Killed
function gd.quests.areaGFatherKymon.kymonKilled()
	GiveTokenToLocalPlayer("AREAG_KYMON_KILLED")
	
	if Server then
		kymonKilled = true
		
		print "unlock the door"
		local bossDoor01 = Door.Get(doorBossA01)
		local bossDoor02 = Door.Get(doorBossA02)
		
		-- unlock boss room
		if bossDoor01 != nil then
			bossDoor01:Open()
		
		end
	
		if bossDoor02 != nil then
			bossDoor02:Open()
		
		end
		
		-- open exit UG door
		local exitDoor01 = Door.Get(kymonExitDoorId)
		
		if exitDoor01 != nil then
			exitDoor01:SetLocked(false)
			exitDoor01:Open()
			
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

-- Boss reset
local bossId = 0

function gd.quests.areaGFatherKymon.kymonAvatarOnAddToWorld(objectId)

	if Server then
		bossId = objectId
	
	end

end

function gd.quests.areaGFatherKymon.bossLeaveRoom()

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


--
-- Unlock The Eldritch Gate
--
local EldritchGateState = { Default = 0, Opened = 1}

local EldritchGateSiteStateObjects = orderedTable();
	EldritchGateSiteStateObjects["AREAG_ELDRITCHGATE_OPENED"] = { state = EldritchGateState.Opened,  dbr = nil }
	EldritchGateSiteStateObjects[""] = { state = EldritchGateState.Default, dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_areag_eldritchgate.dbr" }

function gd.quests.areaGFatherKymon.interactionSiteOnAddToWorld(objectId)
	
	if Server then
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, EldritchGateSiteStateObjects);
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

gd.quests.areaGFatherKymon.interactionSiteOnDestroy = ClearObjectUserdata

-- Initial Door FX
local eldritchGateFXId = 0
local eldritchGateFXSpawned = false

local EldritchGateFXStateObjects = orderedTable();
	EldritchGateFXStateObjects["AREAG_ELDRITCHGATE_OPENED"] = { state = EldritchGateState.Opened,  dbr = nil }
	EldritchGateFXStateObjects[""] = { state = EldritchGateState.Default, dbr = "records/storyelementsgdx2/questassets/areag_eldritchgatefx_break.dbr" }

function gd.quests.areaGFatherKymon.eldritchGateFXOnAddToWorld(objectId)

	if Server && not eldritchGateFXSpawned then
		eldritchGateFXSpawned = true
		
		local userdata = {};
		TokenStateBasedObjectSwap(objectId, userdata, EldritchGateFXStateObjects)
		Shared.setUserdata(objectId, userdata);
	
	end
	
end

function gd.quests.areaGFatherKymon.eldritchGateFXAvatarOnAddToWorld(objectId)
	
	if Server then
		eldritchGateFXId = objectId
	
	end
	
end

gd.quests.areaGFatherKymon.eldritchGateFXOnDestroy = ClearObjectUserdata


-- Token for opening the gate
function gd.quests.areaGFatherKymon.RiftOpenedGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x85B30C00
	local kTask = 0x27CC5080
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_ELDRITCHGATE_OPENED")
		
	end

end

-- Open The Gate
function gd.quests.areaGFatherKymon.RiftOpened()

	if Server then
		local Blockade = Destructible.Get(eldritchGateFXId)
		Blockade:Destroy(Vec(0,1,0), 1000, false)
		eldritchGateFXId = 0
		
		QuestGlobalEvent("eldritchGateOpenedGlobalMP")
		
	end
	
end


-- Token for arriving on the far side of the eldritch gate
-- Eldritch Realm trigger

-- Grant Token
function gd.quests.areaGFatherKymon.eldritchGateTriggerGlobalMP()

	local player = Game.GetLocalPlayer()
	local kQuest = 0x85B30C00
	local kTask = 0x7173CF80
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if (player != nil) && (questTaskState == QuestState.InProgress) then
		GiveTokenToLocalPlayer("AREAG_ENTERED_ELDRITCHREALM")
	end

end

function gd.quests.areaGFatherKymon.eldritchGateTrigger()

	QuestGlobalEvent("eldritchGateTriggerGlobalMP")

end


