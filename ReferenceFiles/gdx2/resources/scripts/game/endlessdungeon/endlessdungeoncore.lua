/*
	
	GRIM DAWN SURVIVAL MODE
	
	For more information, visit us at http://www.grimdawn.com
	
*/

gd.endlessDungeon.core = {}


--
-- Controls for the Endless Dungeon
-- Starts new dungeons and allows for skipping to checkpoints
-- Control NPC states
-- Check whether event is active
--

local endlessDungeonFinished = false
local endlessDungeonActive = false
local giveUpTest = false
local teleportCoords = nil

local bossFloorCleared = false

--
-- Portal Control
-- Main portal into the dungeon from the Witch God Camp
-- Treasure Room portals from Boss Rooms, increment array and function list if more boss rooms added
--
local spawnPointCoords = nil

function gd.endlessDungeon.core.spawnPointOnAddToWorld(objectId)

	spawnPointCoords = Entity.Get(objectId):GetCoords()
	
end

local portalDoorId = 0
local portalDoorOpen = false

local treasurePortalIds = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

function gd.endlessDungeon.core.portalOnAddToWorld(objectId)
	
	if Server then
		portalDoorId = objectId
		
	end
	
end

function gd.endlessDungeon.core.setTreasurePortalState(objectId)
	
	if Server then
		local door = Door.Get(objectId)
		
		if endlessDungeonFinished then
			door:SetLocked(false)
			door:Open()
		
		else
			door:SetLocked(true)
			door:Close()
		
		end
		
	end

end

function gd.endlessDungeon.core.treasurePortal01OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[1] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal02OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[2] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal03OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[3] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal04OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[4] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal05OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[5] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal06OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[6] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal07OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[7] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal08OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[8] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal09OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[9] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal10OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[10] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal11OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[11] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal12OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[12] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal13OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[13] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal14OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[14] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal15OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[15] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal16OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[16] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal17OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[17] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal18OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[18] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal19OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[19] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal20OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[20] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal21OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[21] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal22OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[22] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal23OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[23] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal24OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[24] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal25OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[25] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal26OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[26] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal27OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[27] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal28OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[28] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal29OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[29] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal30OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[30] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal31OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[31] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal32OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[32] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal33OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[33] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal34OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[34] = objectId
		
	end
	
end

function gd.endlessDungeon.core.treasurePortal35OnAddToWorld(objectId)
	
	if Server then
		treasurePortalIds[35] = objectId
		
	end
	
end

--
-- NPC Control
--
local dungeonNPCIds = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
local dungeonNPCCoords = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
local dungeonNPCEntities = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}

-- Dungeon NPC
-- Spawn different versions of Dungeon NPC based on dungeon state
function gd.endlessDungeon.core.dungeonNPC01OnAddToWorld(objectId)
	if Server then
		dungeonNPCIds[1] = objectId
		dungeonNPCCoords[1] = Entity.Get(objectId):GetCoords()

		if endlessDungeonActive && not endlessDungeonFinished then
			dungeonNPCEntities[1] = Entity.Create ("records/endlessdungeon/creatures/npcs/npc_dungeon_01b.dbr")
		else
			dungeonNPCEntities[1] = Entity.Create ("records/endlessdungeon/creatures/npcs/npc_dungeon_01a.dbr")
		end

		dungeonNPCEntities[1]:SetCoords(dungeonNPCCoords[1])
	
	end

end

-- spawn control for NPC02, which is in the boss rooms
local function spawnNPC02(npcNumber)
	if Server then
		if endlessDungeonActive && Game.IsEndlessDungeonBossDead() && not endlessDungeonFinished then
			dungeonNPCEntities[npcNumber] = Entity.Create ("records/endlessdungeon/creatures/npcs/npc_dungeon_02a.dbr")
			
			local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
			
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(dungeonNPCCoords[npcNumber])
			end
			
			dungeonNPCEntities[npcNumber]:SetCoords(dungeonNPCCoords[npcNumber])

		end

	end

end

function gd.endlessDungeon.core.dungeonNPC02AOnAddToWorld(objectId)
	if Server then
		local npcNumber = 2
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[2] = objectId
		dungeonNPCCoords[2] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02BOnAddToWorld(objectId)
	if Server then
		local npcNumber = 3
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[3] = objectId
		dungeonNPCCoords[3] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02COnAddToWorld(objectId)
	if Server then
		local npcNumber = 4
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[4] = objectId
		dungeonNPCCoords[4] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02DOnAddToWorld(objectId)
	if Server then
		local npcNumber = 5
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[5] = objectId
		dungeonNPCCoords[5] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02EOnAddToWorld(objectId)
	if Server then
		local npcNumber = 6
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[6] = objectId
		dungeonNPCCoords[6] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02FOnAddToWorld(objectId)
	if Server then
		local npcNumber = 7
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[7] = objectId
		dungeonNPCCoords[7] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02GOnAddToWorld(objectId)
	if Server then
		local npcNumber = 8
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[8] = objectId
		dungeonNPCCoords[8] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02HOnAddToWorld(objectId)
	if Server then
		local npcNumber = 9
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[9] = objectId
		dungeonNPCCoords[9] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02IOnAddToWorld(objectId)
	if Server then
		local npcNumber = 10
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[10] = objectId
		dungeonNPCCoords[10] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02JOnAddToWorld(objectId)
	if Server then
		local npcNumber = 11
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[11] = objectId
		dungeonNPCCoords[11] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02KOnAddToWorld(objectId)
	if Server then
		local npcNumber = 12
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[12] = objectId
		dungeonNPCCoords[12] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02LOnAddToWorld(objectId)
	if Server then
		local npcNumber = 13
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[13] = objectId
		dungeonNPCCoords[13] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02MOnAddToWorld(objectId)
	if Server then
		local npcNumber = 14
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[14] = objectId
		dungeonNPCCoords[14] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02NOnAddToWorld(objectId)
	if Server then
		local npcNumber = 15
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[15] = objectId
		dungeonNPCCoords[15] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02OOnAddToWorld(objectId)
	if Server then
		local npcNumber = 16
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[16] = objectId
		dungeonNPCCoords[16] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02POnAddToWorld(objectId)
	if Server then
		local npcNumber = 17
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[17] = objectId
		dungeonNPCCoords[17] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02QOnAddToWorld(objectId)
	if Server then
		local npcNumber = 18
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[18] = objectId
		dungeonNPCCoords[18] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ROnAddToWorld(objectId)
	if Server then
		local npcNumber = 19
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[19] = objectId
		dungeonNPCCoords[19] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02SOnAddToWorld(objectId)
	if Server then
		local npcNumber = 20
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[20] = objectId
		dungeonNPCCoords[20] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02TOnAddToWorld(objectId)
	if Server then
		local npcNumber = 21
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[21] = objectId
		dungeonNPCCoords[21] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02UOnAddToWorld(objectId)
	if Server then
		local npcNumber = 22
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[22] = objectId
		dungeonNPCCoords[22] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02VOnAddToWorld(objectId)
	if Server then
		local npcNumber = 23
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[23] = objectId
		dungeonNPCCoords[23] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02WOnAddToWorld(objectId)
	if Server then
		local npcNumber = 24
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[24] = objectId
		dungeonNPCCoords[24] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02XOnAddToWorld(objectId)
	if Server then
		local npcNumber = 25
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[25] = objectId
		dungeonNPCCoords[25] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02YOnAddToWorld(objectId)
	if Server then
		local npcNumber = 26
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[26] = objectId
		dungeonNPCCoords[26] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZOnAddToWorld(objectId)
	if Server then
		local npcNumber = 27
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[27] = objectId
		dungeonNPCCoords[27] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZAOnAddToWorld(objectId)
	if Server then
		local npcNumber = 28
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[28] = objectId
		dungeonNPCCoords[28] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZBOnAddToWorld(objectId)
	if Server then
		local npcNumber = 29
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[29] = objectId
		dungeonNPCCoords[29] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZCOnAddToWorld(objectId)
	if Server then
		local npcNumber = 30
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[30] = objectId
		dungeonNPCCoords[30] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZDOnAddToWorld(objectId)
	if Server then
		local npcNumber = 31
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[31] = objectId
		dungeonNPCCoords[31] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZEOnAddToWorld(objectId)
	if Server then
		local npcNumber = 32
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[32] = objectId
		dungeonNPCCoords[32] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZFOnAddToWorld(objectId)
	if Server then
		local npcNumber = 33
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[33] = objectId
		dungeonNPCCoords[33] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZGOnAddToWorld(objectId)
	if Server then
		local npcNumber = 34
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[34] = objectId
		dungeonNPCCoords[34] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZHOnAddToWorld(objectId)
	if Server then
		local npcNumber = 35
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[35] = objectId
		dungeonNPCCoords[35] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

function gd.endlessDungeon.core.dungeonNPC02ZIOnAddToWorld(objectId)
	if Server then
		local npcNumber = 36
		local npcCoords = Entity.Get(objectId):GetCoords()
		dungeonNPCIds[36] = objectId
		dungeonNPCCoords[36] = npcCoords
		
		-- Spawn NPC02 at this location, if applicable
		spawnNPC02(npcNumber)

	end

end

-- Swap Dungeon NPC to new state
local function swapDungeonNPCs()
	if Server then
		
		if dungeonNPCEntities[1] != nil then
			dungeonNPCEntities[1]:Destroy()
		
		end
		
		-- swap main dungeon npc, if loaded
		local entity1 = Entity.Get(dungeonNPCIds[1])
		
		if entity1 != nil then
			if endlessDungeonActive then
				dungeonNPCEntities[1] = Character.Create ("records/endlessdungeon/creatures/npcs/npc_dungeon_01b.dbr")
			else
				dungeonNPCEntities[1] = Character.Create ("records/endlessdungeon/creatures/npcs/npc_dungeon_01a.dbr")
			end

			dungeonNPCEntities[1]:SetCoords(dungeonNPCCoords[1])
		
		end
		
		-- swap post-boss dungeon npc, if loaded
		print "beginning second NPC Loop"
		local NPCTotal = table.getn(dungeonNPCIds)
		
		for id = 2, NPCTotal do
			if dungeonNPCEntities[id] != nil then
				dungeonNPCEntities[id]:Destroy()
			
			end
			
			local entity2 = Entity.Get(dungeonNPCIds[id])
			print "spawning second NPC"
			print (id)
			
			if entity2 != nil then
				print "second NPC not nil"
				if endlessDungeonActive && Game.IsEndlessDungeonBossDead() && not endlessDungeonFinished then
					dungeonNPCEntities[id] = Entity.Create ("records/endlessdungeon/creatures/npcs/npc_dungeon_02a.dbr")

					dungeonNPCEntities[id]:SetCoords(dungeonNPCCoords[id])
					print "second NPC successfully spawned"

				else
					print "second NPC FAILED conditions"
				end
				
				local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
				
				-- play fx whether npc spawns in or not as it may be despawning
				if (fx != nil) then
					fx:NetworkEnable()
					fx:SetCoords(dungeonNPCCoords[id])
				end
			
			end
		
		end

	end

end

-- Despawn Dungeon NPC when loading next section of Dungeon
local function despawnDungeonNPC()
	if Server then
		local NPCTotal = table.getn(dungeonNPCIds)
		
		for id = 2, NPCTotal do
			if dungeonNPCEntities[id] != nil then
				if dungeonNPCEntities[id] != nil then
					dungeonNPCEntities[id]:Destroy()
					
					local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
				
					-- play fx whether npc spawns in or not as it may be despawning
					if (fx != nil) then
						fx:NetworkEnable()
						fx:SetCoords(dungeonNPCCoords[id])
					end
				
				end
			
			end
		
		end
	
	end

end


-- Checks for whether dungeon is in progress
-- Activate and Deactivate the Dungeon
function gd.endlessDungeon.core.activateEndlessDungeonGlobalMP()

	endlessDungeonActive = true
	
end

function gd.endlessDungeon.core.deactivateEndlessDungeonGlobalMP()

	endlessDungeonActive = false
	
end

function gd.endlessDungeon.core.activateEndlessDungeon()
	if Server then
		endlessDungeonActive = true
		
		LuaGlobalEvent("activateEndlessDungeon")
		
	end

end

function gd.endlessDungeon.core.deactivateEndlessDungeon()
	if Server then
		endlessDungeonActive = false
		
		LuaGlobalEvent("deactivateEndlessDungeon")
	
	end

end

function gd.endlessDungeon.core.endlessDungeonStatus()

	return endlessDungeonActive

end

-- Player Teleportation
-- Check for existing players in dungeon, if present, teleport them out
local playerTeleportList = { }

local function teleportPlayersInDungeon(coords)

	if Server then
		local totalPlayers = table.getn(playerTeleportList)
		
		for id = 1, totalPlayers do
			local player = playerTeleportList[id]
			
			if player!= nil then
				local playerCoords = player:GetCoords()
				
				local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
				local endFx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
				
				if (fx != nil) then
					fx:NetworkEnable()
					fx:SetCoords(playerCoords)
				end

				if (endFx != nil) then
					endFx:NetworkEnable()
					endFx:SetCoords(coords)
				end
				
				Game.TeleportPlayer(player:GetId(), coords)
				
			end
			
		end
		
	end
	
end

local function checkPlayersInDungeon()
	
	if Server then
		-- reset players actively in dungeon list
		playerTeleportList = { }
		
		local totalPlayers = Game.GetNumPlayers()
		
		for id = 1, totalPlayers do
			local player = Game.GetPlayer(id - 1)
			if player!= nil && player:InEndlessDungeon() then
				playerTeleportList[id] = player
				
			end
			
		end
	
	end

end

-- Sets the dungeon to finished so loot can be dispensed and no more enemies are spawned.
function gd.endlessDungeon.core.endlessDungeonFinishedGlobalMP()

	endlessDungeonFinished = true
	
end

function gd.endlessDungeon.core.endlessDungeonFinished()
	if Server then
		
		endlessDungeonFinished = true
		
		LuaGlobalEvent("endlessDungeonFinished")
		
		-- Deactivate Dungeon Status
		gd.endlessDungeon.core.deactivateEndlessDungeon()
		
		-- Swap Dungeon NPC to End State
		swapDungeonNPCs()

		-- Open treasure room
		print "dungeon finished"
		
		-- Open Portal to Treasure Room
		local totalPortals = table.getn(treasurePortalIds)
		
		for id = 1, totalPortals do
			local portal = Door.Get(treasurePortalIds[id])
			
			if portal != nil then
				portal:SetLocked(false)
				portal:Open()
			
			end
		
		end
		
		-- update checkpoint variables for clients and dispense exp based on tier reached
		gd.endlessDungeon.rewards.checkpointRewardCheck()

	end

end

-- Set the dungeon to finished and teleport players out to start a fresh dungeon. Only used as a hard reset if player is stuck.
function gd.endlessDungeon.core.endlessDungeonQGiveUpGlobalMP()

	giveUpTest = true
	
end

function gd.endlessDungeon.core.quitEndlessDungeon()
	if Server then
		
		endlessDungeonFinished = true
		giveUpTest = true
		
		LuaGlobalEvent("endlessDungeonGiveUp")
		LuaGlobalEvent("endlessDungeonFinished")
		
		-- Deactivate Dungeon Status
		gd.endlessDungeon.core.deactivateEndlessDungeon()
		
		-- Swap Dungeon NPC to End State
		swapDungeonNPCs()
		
		-- Teleport players to entrance
		-- check for players still in dungeon
		checkPlayersInDungeon()
		
		teleportPlayersInDungeon(spawnPointCoords)
		
		-- Close portal to dungeon
		local portal = Door.Get(portalDoorId)
			
		if portal != nil then
			portal:SetLocked(true)
			portal:Close()
			portalDoorOpen = false
		
		end
	
	end
	
end


function gd.endlessDungeon.core.checkEndlessDungeonFinished()

	return endlessDungeonFinished

end


--
-- Start the Next Dungeon
-- Check for existing players in dungeon, if present, teleport them out
-- Reset dungeon variables if this is a new dungeon
-- Activate a checkpoint if applicable
--

-- Initiate Dungeon Cleanup for a fresh dungeon to be generated
function gd.endlessDungeon.core.resetDungeonGlobalMP()

	-- Reset Local Variables
	endlessDungeonFinished = false
	giveUpTest = false

end

local function resetDungeonVariables()

	if Server then
		endlessDungeonFinished = false
		bossFloorCleared = false
		
		LuaGlobalEvent("resetDungeonVariables")
		
		-- Reset Reward Variables, Despawn Chests
		gd.endlessDungeon.rewards.resetVariables()
		
		-- check for players still in dungeon
		checkPlayersInDungeon()
		
		-- reset Mutator variables
		gd.endlessDungeon.mutatorControl.resetMutatorVariables()
		
		-- reset code-end variables 
		Game.ResetEndlessDungeon()

	end
	
end

local function dungeonRulesetCheck(tier)
		-- check which ruleset is needed based on the tier of the dungeon, or based on checkpoint
		local dbr = nil

		if tier <= 1 then
			dbr = "records/endlessdungeon/rulesets/dungeonset01.dbr"
		elseif tier <= 3 then
			dbr = "records/endlessdungeon/rulesets/dungeonset02.dbr"
		elseif tier == 4 then
			dbr = "records/endlessdungeon/rulesets/dungeonset03.dbr"
		elseif tier <= 5 then
			dbr = "records/endlessdungeon/rulesets/dungeonset04.dbr"
		elseif tier <= 7 then
			dbr = "records/endlessdungeon/rulesets/dungeonset05.dbr"
		elseif tier == 8 then
			dbr = "records/endlessdungeon/rulesets/dungeonset06.dbr"
		elseif tier <= 11 then
			dbr = "records/endlessdungeon/rulesets/dungeonset07.dbr"
		elseif tier == 12 then
			dbr = "records/endlessdungeon/rulesets/dungeonset08.dbr"
			print "ruleset 08"
		elseif tier <= 16 then
			dbr = "records/endlessdungeon/rulesets/dungeonset09.dbr"
			print "ruleset 09"
		elseif tier <= 17 then
			dbr = "records/endlessdungeon/rulesets/dungeonset10.dbr"
			print "ruleset 10"
		elseif tier == 18 then
			dbr = "records/endlessdungeon/rulesets/dungeonset11.dbr"
			print "ruleset 11"
		elseif tier <= 23 then
			dbr = "records/endlessdungeon/rulesets/dungeonset12.dbr"
			print "ruleset 12"
		elseif tier == 24 then
			dbr = "records/endlessdungeon/rulesets/dungeonset13.dbr"
			print "ruleset 13"
		elseif tier <= 32 then
			dbr = "records/endlessdungeon/rulesets/dungeonset14.dbr"
			print "ruleset 14"
		else
			dbr = "records/endlessdungeon/rulesets/dungeonset15.dbr"
			print "ruleset 15"
		end
		
		return dbr

end

function gd.endlessDungeon.core.startEndlessDungeonQuestsGlobalMP()
	local player = Game.GetLocalPlayer()
	
	local questId01 = 0x7F342C80
	local taskId01 = 0x1501C060
	
	local questId02 = 0xA1A40E00
	local taskId02 = 0x1501C060
	
	local questId03 = 0xAC38BA00
	local taskId03 = 0x1501C060
	
	local questId04 = 0xB66D7C00
	local taskId04 = 0x1501C060

	local questTaskState01 = player:GetQuestTaskState(questId01, taskId01)
	local questTaskState02 = player:GetQuestTaskState(questId02, taskId02)
	local questTaskState03 = player:GetQuestTaskState(questId03, taskId03)
	local questTaskState04 = player:GetQuestTaskState(questId04, taskId04)
	
	-- bestow quest01 if no quest was started before, bestow other quests as a backup (by default, they begin as soon as previous quest is completed)
	if questTaskState04 != QuestState.Complete && questTaskState04 != QuestState.InProgress then
		if questTaskState03 == QuestState.Complete && questTaskState02 == QuestState.Complete && questTaskState01 == QuestState.Complete then
			player:GrantQuest(questId04, taskId04)
		elseif questTaskState03 != QuestState.Complete && questTaskState03 != QuestState.InProgress && questTaskState02 == QuestState.Complete && questTaskState01 == QuestState.Complete then
			player:GrantQuest(questId03, taskId03)
		elseif questTaskState02 != QuestState.Complete && questTaskState02 != QuestState.InProgress && questTaskState01 == QuestState.Complete then
			player:GrantQuest(questId02, taskId02)
		elseif questTaskState01 != QuestState.Complete && questTaskState01 != QuestState.InProgress then
			player:GrantQuest(questId01, taskId01)
		end	
	
	end

end

local function generateEndlessDungeon()
	
	if Server then
		-- Open portal to dungeon, close portal first if it's already open
		local portal = Door.Get(portalDoorId)
		
		if portal != nil then
			if portalDoorOpen then
				portal:SetLocked(true)
				portal:Close()
			
			end
			
			portal:SetLocked(false)
			portal:Open()
			portalDoorOpen = true
			
			local coords = portal:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/endlessdungeonrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
		
		end

		local tier = Game.GetEndlessDungeonsGenerated() + 1
		
		-- start new dungeon section based on tier
		gd.endlessDungeon.core.activateEndlessDungeon()
		
		local dungeonRulesetDBR = dungeonRulesetCheck(tier)
		
		teleportCoords = Game.GenerateEndlessDungeon(dungeonRulesetDBR, portalDoorId)
		
		-- teleport any players actively in the dungeon to the new one
		teleportPlayersInDungeon(teleportCoords)
		
		-- activate Mutators based on dungeon tier
		gd.endlessDungeon.mutatorControl.addMutators(tier)
		
		-- start Endless Dungeon Quests, if applicable
		LuaGlobalEvent("startEndlessDungeonQuests")
	
	end

end

function gd.endlessDungeon.core.startEndlessDungeon()
	
	if Server then
		-- reset previous Dungeon, if any had been generated
		resetDungeonVariables()
		
		-- generate first section of dungeon
		generateEndlessDungeon()
		
		-- swap out dungeon NPC for new dialogues
		swapDungeonNPCs()
		
	end

end

function gd.endlessDungeon.core.clearSoulBuffGlobalMP()
	-- Clear Shattered Soul Buffs
	Game.RemoveEndlessSoulBuffs()

end

function gd.endlessDungeon.core.continueEndlessDungeon()
	
	if Server then
		bossFloorCleared = false
		
		-- Clear Shattered Soul Buffs for all players
		LuaGlobalEvent("clearShatteredSoulBuff")
		
		-- Generate list of players already in dungeon for teleport
		checkPlayersInDungeon()
		
		-- generate next section of dungeon
		generateEndlessDungeon()
		
		-- despawn dungeon NPC
		despawnDungeonNPC()
	
	end

end


-- Start a new Dungeon at a higher floor using a checkpoint
local function startDungeonCheckpoint(startingDungeon)

	if Server then
		-- Open portal to dungeon, close portal first if it's already open
		local portal = Door.Get(portalDoorId)
		
		if portal != nil then
			if portalDoorOpen then
				portal:SetLocked(true)
				portal:Close()
			
			end
			
			portal:SetLocked(false)
			portal:Open()
			portalDoorOpen = true
			
			local coords = portal:GetCoords()	
			local fx = Entity.Create("records/fx/ambient/endlessdungeonrift_activate_fxpak01.dbr")
		
			if (fx != nil) then
				fx:NetworkEnable()
				fx:SetCoords(coords)
			end
		
		end
		
		-- reset previous Dungeon, if any had been generated
		resetDungeonVariables()
		
		-- Generate list of players already in dungeon for teleport
		checkPlayersInDungeon()
		
		-- start new dungeon based on tier set by checkpoint
		gd.endlessDungeon.core.activateEndlessDungeon()
		
		local dungeonRulesetDBR = dungeonRulesetCheck(startingDungeon)
		
		teleportCoords = Game.GenerateEndlessDungeon(dungeonRulesetDBR, portalDoorId, startingDungeon)
		
		-- set checkpoint variable for rewards
		gd.endlessDungeon.rewards.checkpointUsed(startingDungeon)
		
		-- teleport any players actively in the dungeon to the new one
		teleportPlayersInDungeon(teleportCoords)
		
		swapDungeonNPCs()
		
		-- activate Mutators based on dungeon tier
		gd.endlessDungeon.mutatorControl.addMutators(startingDungeon)
		
		-- start Endless Dungeon Quests, if applicable
		LuaGlobalEvent("startEndlessDungeonQuests")
		
	end

end

-- Start the Dungeon at Shard 5
function gd.endlessDungeon.core.startShard05()
	if Server then
		startDungeonCheckpoint(2)
	end
end

-- Start the Dungeon at Shard 10
function gd.endlessDungeon.core.startShard10()
	if Server then
		startDungeonCheckpoint(4)
	end
end

-- Start the Dungeon at Shard 15
function gd.endlessDungeon.core.startShard15()
	if Server then
		startDungeonCheckpoint(6)
	end
end

-- Start the Dungeon at Shard 20
function gd.endlessDungeon.core.startShard20()
	if Server then
		startDungeonCheckpoint(8)
	end
end

-- Start the Dungeon at Shard 25
function gd.endlessDungeon.core.startShard25()
	if Server then
		startDungeonCheckpoint(10)
	end
end

-- Start the Dungeon at Shard 30
function gd.endlessDungeon.core.startShard30()
	if Server then
		startDungeonCheckpoint(12)
	end
end

-- Start the Dungeon at Shard 35
function gd.endlessDungeon.core.startShard35()
	if Server then
		startDungeonCheckpoint(14)
	end
end

-- Start the Dungeon at Shard 40
function gd.endlessDungeon.core.startShard40()
	if Server then
		startDungeonCheckpoint(16)
	end
end

-- Start the Dungeon at Shard 45
function gd.endlessDungeon.core.startShard45()
	if Server then
		startDungeonCheckpoint(18)
	end
end

-- Start the Dungeon at Shard 50
function gd.endlessDungeon.core.startShard50()
	if Server then
		startDungeonCheckpoint(20)
	end
end

-- Start the Dungeon at Shard 55
function gd.endlessDungeon.core.startShard55()
	if Server then
		startDungeonCheckpoint(22)
	end
end

-- Start the Dungeon at Shard 60
function gd.endlessDungeon.core.startShard60()
	if Server then
		startDungeonCheckpoint(24)
	end
end

-- Start the Dungeon at Shard 65
function gd.endlessDungeon.core.startShard65()
	if Server then
		startDungeonCheckpoint(26)
	end
end

-- Start the Dungeon at Shard 70
function gd.endlessDungeon.core.startShard70()
	if Server then
		startDungeonCheckpoint(28)
	end
end

-- Start the Dungeon at Shard 75
function gd.endlessDungeon.core.startShard75()
	if Server then
		startDungeonCheckpoint(30)
	end
end

-- Start the Dungeon at Shard 80
function gd.endlessDungeon.core.startShard80()
	if Server then
		startDungeonCheckpoint(32)
	end
end

-- Start the Dungeon at Shard 85
function gd.endlessDungeon.core.startShard85()
	if Server then
		startDungeonCheckpoint(34)
	end
end

-- Start the Dungeon at Shard 90
function gd.endlessDungeon.core.startShard90()
	if Server then
		startDungeonCheckpoint(36)
	end
end

-- Start the Dungeon at Shard 95
function gd.endlessDungeon.core.startShard95()
	if Server then
		startDungeonCheckpoint(38)
	end
end

-- Start the Dungeon at Shard 100
function gd.endlessDungeon.core.startShard100()
	if Server then
		startDungeonCheckpoint(40)
	end
end


-- Teleport Player Out of Treasure Room if they do not belong there
-- Dispense loot if applicable
function gd.endlessDungeon.core.removeInvalidPlayer(triggererId)
	-- Purge Shrine Buffs
	Game.RemoveEndlessShrineBuffs()

	-- Teleport an invalid player
	local test = gd.endlessDungeon.core.checkEndlessDungeonFinished()
	
	if not test || giveUpTest then
		local player = Entity.Get(triggererId)
		local playerCoords = player:GetCoords()
		
		local fx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
		local endFx = Entity.Create("records/fx/ui/riftgateendlessopen_fxpak.dbr")
		
		if (fx != nil) then
			fx:NetworkEnable()
			fx:SetCoords(playerCoords)
		end

		if (endFx != nil) then
			endFx:NetworkEnable()
			endFx:SetCoords(spawnPointCoords)
		end
		
		Game.TeleportPlayer(player:GetId(), spawnPointCoords)
	
	end

end

function gd.endlessDungeon.core.dispenseTreasure(triggererId)

	local test = gd.endlessDungeon.core.checkEndlessDungeonFinished()
	
	if test && not giveUpTest then
		-- Trigger Reward Spawning, if applicable
		QuestEvent("dispenseReward")
	
	end

end



function gd.endlessDungeon.core.closeportals()

	-- Close Portal to Treasure Room if open
	local totalPortals = table.getn(treasurePortalIds)
	
	for id = 1, totalPortals do
		local portal = Door.Get(treasurePortalIds[id])
		
		if portal != nil then
			portal:SetLocked(true)
			portal:Close()
		
		end
	
	end
	
end

function gd.endlessDungeon.core.openportals()

	-- Open Portal to Treasure Room
	local totalPortals = table.getn(treasurePortalIds)
	
	for id = 1, totalPortals do
		local portal = Door.Get(treasurePortalIds[id])
		
		if portal != nil then
			portal:SetLocked(false)
			portal:Open()
		
		end
	
	end
	
end

-- Check if Boss Floor is cleared, spawn NPC and dispense XP if true
function gd.endlessDungeon.core.isBossFloorClearedOnEnterMP()
	
	if Server then
		if Game.IsEndlessDungeonBossDead() && not bossFloorCleared then
			bossFloorCleared = true
			
			-- Grant player exp for current dungeon level
			LuaGlobalEvent("playerProgressExperience")
			
			-- spawn dungeon NPC on boss floor
			swapDungeonNPCs()	
		end
		
		-- close portals in case they remained open
		if not endlessDungeonFinished then
			gd.endlessDungeon.core.closeportals()
			
		end
			
	end
	
end

function gd.endlessDungeon.core.isBossFloorClearedMP()
	
	if Server then
		if Game.IsEndlessDungeonBossDead() && not bossFloorCleared then
			bossFloorCleared = true
			
			-- Grant player exp for current dungeon level
			LuaGlobalEvent("playerProgressExperience")
			
			-- spawn dungeon NPC on boss floor
			swapDungeonNPCs()	
		end
			
	end
	
end

function gd.endlessDungeon.core.isBossFloorClearedOnEnter(triggererId)
	-- Purge Shrine Buffs
	Game.RemoveEndlessShrineBuffs()
	
	-- have host check if boss floor has been cleared
	QuestEvent("endlessDungeonCheckBossDeadOnEnter")
	
end

function gd.endlessDungeon.core.isBossFloorCleared(triggererId)

	-- have host check if boss floor has been cleared
	QuestEvent("endlessDungeonCheckBossDead")
	
end

-- Start Dungeon with Death's Waystone, disabling rewards

-- Start the Dungeon at Shard 80
function gd.endlessDungeon.core.startShard80NoLoot()
	if Server then
		startDungeonCheckpoint(32)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 85
function gd.endlessDungeon.core.startShard85NoLoot()
	if Server then
		startDungeonCheckpoint(34)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 90
function gd.endlessDungeon.core.startShard90NoLoot()
	if Server then
		startDungeonCheckpoint(36)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 95
function gd.endlessDungeon.core.startShard95NoLoot()
	if Server then
		startDungeonCheckpoint(38)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 100
function gd.endlessDungeon.core.startShard100NoLoot()
	if Server then
		startDungeonCheckpoint(40)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 105
function gd.endlessDungeon.core.startShard105NoLoot()
	if Server then
		startDungeonCheckpoint(42)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 110
function gd.endlessDungeon.core.startShard110NoLoot()
	if Server then
		startDungeonCheckpoint(44)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 115
function gd.endlessDungeon.core.startShard115NoLoot()
	if Server then
		startDungeonCheckpoint(46)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 120
function gd.endlessDungeon.core.startShard120NoLoot()
	if Server then
		startDungeonCheckpoint(48)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 125
function gd.endlessDungeon.core.startShard125NoLoot()
	if Server then
		startDungeonCheckpoint(50)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 130
function gd.endlessDungeon.core.startShard130NoLoot()
	if Server then
		startDungeonCheckpoint(52)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 135
function gd.endlessDungeon.core.startShard135NoLoot()
	if Server then
		startDungeonCheckpoint(54)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 140
function gd.endlessDungeon.core.startShard140NoLoot()
	if Server then
		startDungeonCheckpoint(56)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 145
function gd.endlessDungeon.core.startShard145NoLoot()
	if Server then
		startDungeonCheckpoint(58)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 150
function gd.endlessDungeon.core.startShard150NoLoot()
	if Server then
		startDungeonCheckpoint(60)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 155
function gd.endlessDungeon.core.startShard155NoLoot()
	if Server then
		startDungeonCheckpoint(62)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 160
function gd.endlessDungeon.core.startShard160NoLoot()
	if Server then
		startDungeonCheckpoint(64)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 165
function gd.endlessDungeon.core.startShard165NoLoot()
	if Server then
		startDungeonCheckpoint(66)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 170
function gd.endlessDungeon.core.startShard170NoLoot()
	if Server then
		startDungeonCheckpoint(68)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 175
function gd.endlessDungeon.core.startShard175NoLoot()
	if Server then
		startDungeonCheckpoint(70)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 180
function gd.endlessDungeon.core.startShard180NoLoot()
	if Server then
		startDungeonCheckpoint(72)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 185
function gd.endlessDungeon.core.startShard185NoLoot()
	if Server then
		startDungeonCheckpoint(74)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 190
function gd.endlessDungeon.core.startShard190NoLoot()
	if Server then
		startDungeonCheckpoint(76)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 195
function gd.endlessDungeon.core.startShard195NoLoot()
	if Server then
		startDungeonCheckpoint(78)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 200
function gd.endlessDungeon.core.startShard200NoLoot()
	if Server then
		startDungeonCheckpoint(80)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 205
function gd.endlessDungeon.core.startShard205NoLoot()
	if Server then
		startDungeonCheckpoint(82)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

-- Start the Dungeon at Shard 210
function gd.endlessDungeon.core.startShard210NoLoot()
	if Server then
		startDungeonCheckpoint(84)
		-- disable rewards
		gd.endlessDungeon.rewards.disableRewards()
	end
end

