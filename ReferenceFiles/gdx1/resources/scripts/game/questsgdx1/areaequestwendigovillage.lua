/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com

*/


gd.quests.areaEQuestWendigoVillage = {}

--
-- Controls the spawning and transition of the various npcs in Barrowholm.
--

local VillageLeaderId = 0
local VillageLeaderRitualId = 0
local VillageLeaderState = {Friendly = 0, Hostile = 1, Ritual = 2, Final = 3, Dead = 4}
local VillageLeaderHostileSpawned = false

-- Scorv
local VillageLeaderStateObjects = orderedTable();
	VillageLeaderStateObjects["AREAE_VILLAGECELLAR_UNLOCKED"] = { state = VillageLeaderState.Dead,  dbr = nil }
	VillageLeaderStateObjects["AREAE_RAVAGERSPAWNED"] = { state = VillageLeaderState.Final,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogscorv_02.dbr" }
	VillageLeaderStateObjects["AREAE_VILLAGE_RITUAL"] = { state = VillageLeaderState.Ritual,  dbr = nil }
	VillageLeaderStateObjects["AREAE_VILLAGEHOSTILE"] = { state = VillageLeaderState.Hostile,  dbr = "records/creatures/enemies/faction/cult_wraith_villageleader_01.dbr" }
	VillageLeaderStateObjects[""] = { state = VillageLeaderState.Friendly, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogscorv_01.dbr" }


local function VillageLeaderCreateArgs()

	return 0, Entity.Get(VillageLeaderId):GetCoords().origin
	
end
	
function gd.quests.areaEQuestWendigoVillage.villageLeaderOnAddToWorld(objectId)

	if Server then
		QuestGlobalEvent("cultBountyReset")
		QuestGlobalEvent("cultFactionResetToken")
	
		if (VillageLeaderHostileSpawned == false) then

			VillageLeaderId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, VillageLeaderStateObjects, Character, VillageLeaderCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == VillageLeaderState.Hostile) then
				VillageLeaderHostileSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestWendigoVillage.villageLeaderOnDestroy = ClearObjectUserdata

local VillageLeaderRitualStateObjects = orderedTable();
	VillageLeaderRitualStateObjects["AREAE_VILLAGE_RITUAL"] = { state = VillageLeaderState.Ritual,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogscorv_ritual.dbr" }
	VillageLeaderRitualStateObjects[""] = { state = VillageLeaderState.Friendly, dbr = nil }

function gd.quests.areaEQuestWendigoVillage.villageLeaderRitualOnAddToWorld(objectId)

	if Server then
		VillageLeaderRitualId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VillageLeaderRitualStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

-- Ravager State based swap
local ravagerId = 0
local ravagerHostile = false
local ravagerSwap = false
local ravagerTyvaldChosen = false
local ravagerAurinChosen = false
local ravagerJordythChosen = false

local RavagerState = {Default = 0, Spawned = 1}

local ravagerStateObjects = orderedTable();
	ravagerStateObjects["AREAE_RAVAGERSPAWNED"] = { state = RavagerState.Spawned,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01c.dbr" }
	ravagerStateObjects[""] = { state = RavagerState.Default, dbr = nil }
	
local function RavagerCreateArgs()

	local averageLevel = Game.GetAveragePlayerLevel()
	local monsterLevel = 0
	local minLevel = 0
	local maxLevel = 0

	if (Game.GetGameDifficulty() == Game.Difficulty.Normal) then
		minLevel = 80
		maxLevel = 120
	elseif (Game.GetGameDifficulty() == Game.Difficulty.Epic) then
		minLevel = 105
		maxLevel = 120
	else
		minLevel = 105
		maxLevel = 120
	end
	
	if (averageLevel < minLevel) then
		monsterLevel = ((minLevel+(minLevel/50))+5)
	elseif (averageLevel > maxLevel) then
		monsterLevel = ((maxLevel+(maxLevel/50))+5)
	else
		monsterLevel = ((averageLevel+(averageLevel/50))+5)

	end

	return monsterLevel, nil

end
	
function gd.quests.areaEQuestWendigoVillage.ravagerOnAddToWorld(objectId)

	if Server then
		if not ravagerHostile then
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			local MPOverrideState = false
			
			-- spawns different ravager based on Chosen selected
			if player:HasToken("AREAE_TYVALDCHOSEN") || ravagerTyvaldChosen then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01a.dbr"
				MPOverrideState = true
			elseif player:HasToken("AREAE_AURINCHOSEN") || ravagerAurinChosen then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01b.dbr"
				MPOverrideState = true
			elseif player:HasToken("AREAE_JORDYTHCHOSEN") || ravagerJordythChosen then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01c.dbr"
				MPOverrideState = true
			end

			ravagerId = objectId;
				
			local userdata = {}
			TokenStateBasedObjectSwap(objectId, userdata, ravagerStateObjects, Character, RavagerCreateArgs, MPOverrideState, MPOverrideDbr)
			Shared.setUserdata(objectId, userdata)
			
		end
		
	end
	
end

gd.quests.areaEQuestWendigoVillage.ravagerOnDestroy = ClearObjectUserdata

function gd.quests.areaEQuestWendigoVillage.ravagerKilled()
	
	GiveTokenToLocalPlayer("RAVAGERAVATAR_KILLED")
	
end

function gd.quests.areaEQuestWendigoVillage.avatarHostileTokenMP()
	
	GiveTokenToLocalPlayer("RAVAGERAVATAR_HOSTILE")
	
end


-- Swap out Ravager to a boss for this session only
function gd.quests.areaEQuestWendigoVillage.ravagerHostileSwitch()
	
	if Server then
		if not ravagerHostile then
			ravagerHostile = true
			local player = Game.GetLocalPlayer()
			local MPOverrideDbr = nil
			
			if (Game.GetGameDifficulty() == Game.Difficulty.Normal || Game.GetGameDifficulty() == Game.Difficulty.Epic) then
				if player:HasToken("AREAE_TYVALDCHOSEN") || ravagerTyvaldChosen then
					MPOverrideDbr = "records/creatures/enemies/boss&quest/wendigo_ravager_flesh.dbr"
				elseif player:HasToken("AREAE_AURINCHOSEN") || ravagerAurinChosen then
					MPOverrideDbr = "records/creatures/enemies/boss&quest/wendigo_ravager_minds.dbr"
				else
					MPOverrideDbr = "records/creatures/enemies/boss&quest/wendigo_ravager_souls.dbr"
				end
			else
				if player:HasToken("AREAE_TYVALDCHOSEN") || ravagerTyvaldChosen then
					MPOverrideDbr = "records/creatures/enemies/boss&quest/wendigo_ravager_fleshb.dbr"
				elseif player:HasToken("AREAE_AURINCHOSEN") || ravagerAurinChosen then
					MPOverrideDbr = "records/creatures/enemies/boss&quest/wendigo_ravager_mindsb.dbr"
				else
					MPOverrideDbr = "records/creatures/enemies/boss&quest/wendigo_ravager_soulsb.dbr"
				end
			end
			
			local MPOverrideState = true

			UpdateObjectSwap(ravagerId, ravagerStateObjects, Character, RavagerCreateArgs, MPOverrideState, MPOverrideDbr)
			
			QuestGlobalEvent("ravagerHostileToken")
			GiveTokenToLocalPlayer("RAVAGERAVATAR_HOSTILE")

		end
	
	end

end

-- spawns ravager for the first time, called when dummy NPC dies.
function gd.quests.areaEQuestWendigoVillage.spawnRavager()
	if Server then
		if not ravagerSwap then
			ravagerSwap = true
			
			local player = Game.GetLocalPlayer()
			local MPOverrideState = false
			local MPOverrideDbr = nil
			
			-- spawns different ravager based on Chosen selected
			if player:HasToken("AREAE_TYVALDCHOSEN") || ravagerTyvaldChosen then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01a.dbr"
				MPOverrideState = true
			elseif player:HasToken("AREAE_AURINCHOSEN") || ravagerAurinChosen then
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01b.dbr"
				MPOverrideState = true
			else
				MPOverrideDbr = "records/creatures/npcs/questnpcs/gdareae/npc_ravager_01c.dbr"
				MPOverrideState = true
			end
			
			local Ravager = Entity.Get(ravagerId)
			
			if (Ravager != nil) then
				UpdateObjectSwap(ravagerId, ravagerStateObjects, Character, nil, MPOverrideState, MPOverrideDbr)
				
			end

		end
	
	end
	
end

local function DummyCreateArgs()

	return 1, nil
	
end

-- Bounty Table and Quartermaster only spawn if the host is friendly with this faction
local tableId = 0
local vendorId = 0
local TableState = {Default = 0, Friendly = 1, PostRavager = 2}

-- Table
local TableStateObjects = orderedTable();
	TableStateObjects["AREAE_RAVAGERSPAWNED"] = { state = TableState.PostRavager,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_bountytable_wendigo_01.dbr" }
	TableStateObjects["AREAE_VILLAGEFRIENDLY"] = { state = TableState.Friendly,  dbr = "records/creatures/npcs/questnpcs/interactiveobjects/npc_bountytable_wendigo_01.dbr" }
	TableStateObjects[""] = { state = TableState.Default, dbr = "records/level art/factions/barrowholm_table01a_light.dbr" }
	
function gd.quests.areaEQuestWendigoVillage.tableOnAddToWorld(objectId)

	if Server then

		tableId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, TableStateObjects)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaEQuestWendigoVillage.tableOnDestroy = ClearObjectUserdata

-- Quartermaster
local VendorStateObjects = orderedTable();
	VendorStateObjects["AREAE_RAVAGERSPAWNED"] = { state = TableState.PostRavager,  dbr = "records/creatures/npcs/merchants/merchantfaction_wendigo_01.dbr" }
	VendorStateObjects["AREAE_VILLAGE_RITUAL"] = { state = TableState.Friendly,  dbr = "records/creatures/npcs/merchants/merchantfaction_wendigo_01.dbr" }
	VendorStateObjects[""] = { state = TableState.Default, dbr = nil }
	
function gd.quests.areaEQuestWendigoVillage.vendorOnAddToWorld(objectId)

	if Server then

		tableId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, VendorStateObjects)
		Shared.setUserdata(objectId, userdata)

	end
	
end

gd.quests.areaEQuestWendigoVillage.vendorOnDestroy = ClearObjectUserdata


--
-- Chosen Villagers
-- Each villager has a default and a ritual position in the world. They return to their default position (if not selected) after the ritual is over, upon reload.
--

-- Tyvald Hallows - ravager of flesh
local TyvaldId  = 0
local TyvaldRitualId = 0
local ChosenState = {Friendly = 0, Hostile = 1, Ritual = 2, Chosen = 3, Final = 4, Dead = 5}
local tyvaldHostileSpawned = false

local TyvaldStateObjects = orderedTable();
	TyvaldStateObjects["AREAE_VILLAGECELLAR_UNLOCKED"] = { state = ChosenState.Dead,  dbr = nil }
	TyvaldStateObjects["AREAE_TYVALDCHOSEN"] = { state = ChosenState.Chosen,  dbr = nil } -- Chosen overrides Final state
	TyvaldStateObjects["AREAE_RAVAGERSPAWNED"] = { state = ChosenState.Final,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogtyvald_02.dbr" }
	TyvaldStateObjects["AREAE_VILLAGE_RITUAL"] = { state = ChosenState.Ritual,  dbr = nil }
	TyvaldStateObjects["AREAE_VILLAGEHOSTILE"] = { state = ChosenState.Hostile,  dbr = "records/creatures/enemies/faction/cult_wendigocannibal_b01.dbr" }
	TyvaldStateObjects[""] = { state = ChosenState.Friendly, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogtyvald_01.dbr" }


local function TyvaldCreateArgs()

	return 0, Entity.Get(TyvaldId):GetCoords().origin
	
end
	
function gd.quests.areaEQuestWendigoVillage.tyvaldOnAddToWorld(objectId)

	if Server then
	
		if (tyvaldHostileSpawned == false && ravagerTyvaldChosen == false) then

			TyvaldId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, TyvaldStateObjects, Character, TyvaldCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == ChosenState.Hostile) then
				tyvaldHostileSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestWendigoVillage.tyvaldOnDestroy = ClearObjectUserdata

local TyvaldRitualStateObjects = orderedTable();
	TyvaldRitualStateObjects["AREAE_TYVALDCHOSEN"] = { state = ChosenState.Chosen,  dbr = nil }
	TyvaldRitualStateObjects["AREAE_VILLAGE_RITUAL"] = { state = ChosenState.Ritual,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogtyvald_ritual.dbr" }
	TyvaldRitualStateObjects[""] = { state = ChosenState.Friendly, dbr = nil }

function gd.quests.areaEQuestWendigoVillage.tyvaldRitualOnAddToWorld(objectId)

	if Server && not ravagerTyvaldChosen then
		TyvaldRitualId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, TyvaldRitualStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end


-- Tyvald is chosen
function gd.quests.areaEQuestWendigoVillage.tyvaldChosenGlobalMP()
	
	local player = Game.GetLocalPlayer()
	local kQuest = 0x0969A8E0
	local kTask = 0x1501C060
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
	
	if ((questTaskState == QuestState.InProgress || questTaskState == QuestState.Complete) && player:HasToken("AREAE_TYVALDCHOSEN") == false && player:HasToken("AREAE_AURINCHOSEN") == false && player:HasToken("AREAE_JORDYTHCHOSEN") == false) then
		player:GiveToken("AREAE_TYVALDCHOSEN")	
		
	end		
	
end

function gd.quests.areaEQuestWendigoVillage.tyvaldChosenTransition()

	if Server then
		ravagerTyvaldChosen = true
		
		QuestGlobalEvent("tyvaldChosenToken")
		
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = "records/creatures/enemies/faction/cult_ritual_tyvaldchosen.dbr"
		local MPOverrideState = true

		UpdateObjectSwap(TyvaldRitualId, TyvaldRitualStateObjects, Character, DummyCreateArgs, MPOverrideState, MPOverrideDbr)
		
	end
	
end


-- Aurin - ravager of minds
local AurinId  = 0
local AurinRitualId = 0
local AurinHostileSpawned = false

local AurinStateObjects = orderedTable();
	AurinStateObjects["AREAE_VILLAGECELLAR_UNLOCKED"] = { state = ChosenState.Dead,  dbr = nil }
	AurinStateObjects["AREAE_AURINCHOSEN"] = { state = ChosenState.Chosen,  dbr = nil } -- Chosen overrides Final state
	AurinStateObjects["AREAE_RAVAGERSPAWNED"] = { state = ChosenState.Final,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogaurin_02.dbr" }
	AurinStateObjects["AREAE_VILLAGE_RITUAL"] = { state = ChosenState.Ritual,  dbr = nil }
	AurinStateObjects["AREAE_VILLAGEHOSTILE"] = { state = ChosenState.Hostile,  dbr = "records/creatures/enemies/faction/cult_wendigocannibal_b01.dbr" }
	AurinStateObjects[""] = { state = ChosenState.Friendly, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogaurin_01.dbr" }


local function AurinCreateArgs()

	return 0, Entity.Get(AurinId):GetCoords().origin
	
end
	
function gd.quests.areaEQuestWendigoVillage.aurinOnAddToWorld(objectId)

	if Server then
	
		if (AurinHostileSpawned == false && ravagerAurinChosen == false) then

			AurinId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, AurinStateObjects, Character, AurinCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == ChosenState.Hostile) then
				AurinHostileSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestWendigoVillage.aurinOnDestroy = ClearObjectUserdata

local AurinRitualStateObjects = orderedTable();
	AurinRitualStateObjects["AREAE_AURINCHOSEN"] = { state = ChosenState.Chosen,  dbr = nil }
	AurinRitualStateObjects["AREAE_VILLAGE_RITUAL"] = { state = ChosenState.Ritual,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogaurin_ritual.dbr" }
	AurinRitualStateObjects[""] = { state = ChosenState.Friendly, dbr = nil }

function gd.quests.areaEQuestWendigoVillage.aurinRitualOnAddToWorld(objectId)

	if Server && not ravagerAurinChosen then
		AurinRitualId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, AurinRitualStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end


-- Aurin is chosen
function gd.quests.areaEQuestWendigoVillage.aurinChosenGlobalMP()
	
	local player = Game.GetLocalPlayer()
	local kQuest = 0x0969A8E0
	local kTask = 0x1501C060
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if ((questTaskState == QuestState.InProgress || questTaskState == QuestState.Complete) && player:HasToken("AREAE_TYVALDCHOSEN") == false && player:HasToken("AREAE_AURINCHOSEN") == false && player:HasToken("AREAE_JORDYTHCHOSEN") == false) then
		player:GiveToken("AREAE_AURINCHOSEN")	
		
	end		
	
end

function gd.quests.areaEQuestWendigoVillage.aurinChosenTransition()

	if Server then
		ravagerAurinChosen = true
		
		QuestGlobalEvent("aurinChosenToken")
		
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = "records/creatures/enemies/faction/cult_ritual_aurinchosen.dbr"
		local MPOverrideState = true

		UpdateObjectSwap(AurinRitualId, AurinRitualStateObjects, Character, DummyCreateArgs, MPOverrideState, MPOverrideDbr)
		
	end
	
end


-- Jordyth - ravager of souls
local JordythId  = 0
local JordythRitualId = 0
local jordythHostileSpawned = false

local JordythStateObjects = orderedTable();
	JordythStateObjects["AREAE_VILLAGECELLAR_UNLOCKED"] = { state = ChosenState.Dead,  dbr = nil }
	JordythStateObjects["AREAE_JORDYTHCHOSEN"] = { state = ChosenState.Chosen,  dbr = nil } -- Chosen overrides Final state
	JordythStateObjects["AREAE_RAVAGERSPAWNED"] = { state = ChosenState.Final,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogjordyth_02.dbr" }
	JordythStateObjects["AREAE_VILLAGE_RITUAL"] = { state = ChosenState.Ritual,  dbr = nil }
	JordythStateObjects["AREAE_VILLAGEHOSTILE"] = { state = ChosenState.Hostile,  dbr = "records/creatures/enemies/faction/cult_wendigocannibal_b01.dbr" }
	JordythStateObjects[""] = { state = ChosenState.Friendly, dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogjordyth_01.dbr" }
	

local function JordythCreateArgs()

	return 0, Entity.Get(JordythId):GetCoords().origin
	
end
	
function gd.quests.areaEQuestWendigoVillage.jordythOnAddToWorld(objectId)

	if Server then
	
		if (jordythHostileSpawned == false && ravagerJordythChosen == false) then

			JordythId = objectId;
			
			local userdata = {}
			local didWork, newState = TokenStateBasedObjectSwap(objectId, userdata, JordythStateObjects, Character, JordythCreateArgs)
			Shared.setUserdata(objectId, userdata)
			
			-- Don't respawn if spawned as hostile
			if (newState == ChosenState.Hostile) then
				jordythHostileSpawned = true
			end
			
		end
		
	end
	
end

gd.quests.areaEQuestWendigoVillage.jordythOnDestroy = ClearObjectUserdata

local JordythRitualStateObjects = orderedTable();
	JordythRitualStateObjects["AREAE_JORDYTHCHOSEN"] = { state = ChosenState.Chosen,  dbr = nil }
	JordythRitualStateObjects["AREAE_VILLAGE_RITUAL"] = { state = ChosenState.Ritual,  dbr = "records/creatures/npcs/questnpcs/gdareae/npc_ugdenbogjordyth_ritual.dbr" }
	JordythRitualStateObjects[""] = { state = ChosenState.Friendly, dbr = nil }

function gd.quests.areaEQuestWendigoVillage.jordythRitualOnAddToWorld(objectId)

	if Server && not ravagerJordythChosen then
		JordythRitualId = objectId;
		
		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, JordythRitualStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end


-- Jordyth is chosen
function gd.quests.areaEQuestWendigoVillage.jordythChosenGlobalMP()
	
	local player = Game.GetLocalPlayer()
	local kQuest = 0x0969A8E0
	local kTask = 0x1501C060
	local questTaskState = player:GetQuestTaskState(kQuest, kTask)
		
	if ((questTaskState == QuestState.InProgress || questTaskState == QuestState.Complete) && player:HasToken("AREAE_TYVALDCHOSEN") == false && player:HasToken("AREAE_AURINCHOSEN") == false && player:HasToken("AREAE_JORDYTHCHOSEN") == false) then
		player:GiveToken("AREAE_JORDYTHCHOSEN")	
		
	end		
	
end

function gd.quests.areaEQuestWendigoVillage.jordythChosenTransition()

	if Server then
		ravagerJordythChosen = true
		
		QuestGlobalEvent("jordythChosenToken")
		
		local player = Game.GetLocalPlayer()
		local MPOverrideDbr = "records/creatures/enemies/faction/cult_ritual_jordythchosen.dbr"
		local MPOverrideState = true

		UpdateObjectSwap(JordythRitualId, JordythRitualStateObjects, Character, DummyCreateArgs, MPOverrideState, MPOverrideDbr)
		
	end
	
end

--
-- the major villagers go hostile - activate by dialogue
-- 
local villageHostileSwap = false

function gd.quests.areaEQuestWendigoVillage.VillagersHostileTransition()

	if Server && not villageHostileSwap then
		local player = Game.GetLocalPlayer()
		local MPOverrideState = false
		local MPOverrideDbrScorv = nil
		local MPOverrideDbrTyvald = nil
		local MPOverrideDbrAurin = nil
		local MPOverrideDbrJordyth = nil
		
		if (player:HasToken("AREAE_VILLAGEHOSTILE") == false) then
			MPOverrideState = true
			MPOverrideDbrScorv = "records/creatures/enemies/faction/cult_wraith_villageleader_01.dbr"
			MPOverrideDbrTyvald = "records/creatures/enemies/faction/cult_wendigocannibal_b01.dbr" 
			MPOverrideDbrAurin = "records/creatures/enemies/faction/cult_wendigocannibal_b01.dbr" 
			MPOverrideDbrJordyth = "records/creatures/enemies/faction/cult_wendigocannibal_b01.dbr" 
			
		end
		
		villageHostileSwap = true

		-- Scorv
		if not villageLeaderHostileSpawned then
			local Scorv = Entity.Get(VillageLeaderId)
			
			if (Scorv != nil) then
				villageLeaderHostileSpawned = true 
				
				local coords = Scorv:GetCoords();
				local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
				
				if rift ~= nil then
					rift:NetworkEnable()
					rift:SetCoords(coords)
					
				end
				UpdateObjectSwap(VillageLeaderId, VillageLeaderStateObjects, Character, VillageLeaderCreateArgs, MPOverrideState, MPOverrideDbrScorv)
			
			end
	
		end
		
		-- Tyvald
		if not tyvaldHostileSpawned then
			local Tyvald = Entity.Get (TyvaldId)
			
			if (Tyvald != nil) then
				tyvaldHostileSpawned = true
				
				local coords = Tyvald:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(TyvaldId, TyvaldStateObjects, Character, TyvaldCreateArgs, MPOverrideState, MPOverrideDbrTyvald)
			
			end

		end
		
		-- Aurin
		if not aurinHostileSpawned then
			local Aurin = Entity.Get (AurinId)
			
			if (Aurin != nil) then
				aurinHostileSpawned = true
				
				local coords = Aurin:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(AurinId, AurinStateObjects, Character, AurinCreateArgs, MPOverrideState, MPOverrideDbrAurin)

			end

		end
		
		-- Jordyth
		if not jordythHostileSpawned then
			local Jordyth = Entity.Get (JordythId)
			
			if (Jordyth != nil) then
				jordythHostileSpawned = true
			
				local coords = Jordyth:GetCoords()	
				local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (rift != nil) then
					rift:NetworkEnable()
					rift:SetCoords(coords)
				end
				
				UpdateObjectSwap(JordythId, JordythStateObjects, Character, JordythCreateArgs, MPOverrideState, MPOverrideDbrJordyth)
			
			end

		end
		
	end
	
end

-- Transition Villagers to Ritual Positions
local villageRitualSwap = false

function gd.quests.areaEQuestWendigoVillage.VillagersRitualTransition()

	if Server && not villageRitualSwap then
		local player = Game.GetLocalPlayer()

		if player:HasToken("AREAE_VILLAGE_RITUAL") then
			villageRitualSwap = true

			-- Scorv
			if not villageLeaderHostileSpawned then
				local Scorv = Entity.Get(VillageLeaderId)
				local ScorvRitual = Entity.Get(VillageLeaderRitualId)
				
				if (Scorv != nil) then
					local coords = Scorv:GetCoords();
					local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
					
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
					
					UpdateObjectSwap(VillageLeaderId, VillageLeaderStateObjects)
				
				end
				
				if (ScorvRitual != nil) then
					local coords = ScorvRitual:GetCoords();
					local rift = Entity.Create("records/fx/ui/riftgateghostlyopen_fx02pak.dbr")
					
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end

					UpdateObjectSwap(VillageLeaderRitualId, VillageLeaderRitualStateObjects)
				
				end
		
			end
			
			-- Tyvald
			if not tyvaldHostileSpawned then
				local Tyvald = Entity.Get (TyvaldId)
				local TyvaldRitual = Entity.Get (TyvaldRitualId)
				
				if (Tyvald != nil) then					
					local coords = Tyvald:GetCoords()	
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
					
					UpdateObjectSwap(TyvaldId, TyvaldStateObjects)
				
				end
				
				if (TyvaldRitual != nil) then					
					local coords = TyvaldRitual:GetCoords()	
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end

					UpdateObjectSwap(TyvaldRitualId, TyvaldRitualStateObjects)
				
				end

			end
			
			-- Aurin
			if not aurinHostileSpawned then
				local Aurin = Entity.Get (AurinId)
				local AurinRitual = Entity.Get (AurinRitualId)
				
				if (Aurin != nil) then
					local coords = Aurin:GetCoords()	
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
					
					UpdateObjectSwap(AurinId, AurinStateObjects)

				end
				
				if (AurinRitual != nil) then
					local coords = AurinRitual:GetCoords()	
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end

					UpdateObjectSwap(AurinRitualId, AurinRitualStateObjects)

				end

			end
			
			-- Jordyth
			if not jordythHostileSpawned then
				local Jordyth = Entity.Get (JordythId)
				local JordythRitual = Entity.Get (JordythRitualId)
				
				if (Jordyth != nil) then
					local coords = Jordyth:GetCoords()	
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end
					
					UpdateObjectSwap(JordythId, JordythStateObjects)
				
				end
				
				if (JordythRitual != nil) then
					local coords = JordythRitual:GetCoords()	
					local rift = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
				
					if (rift != nil) then
						rift:NetworkEnable()
						rift:SetCoords(coords)
					end

					UpdateObjectSwap(JordythRitualId, JordythRitualStateObjects)
				
				end

			end
			
		end
	
	end
	
end


-- Village Cellar Door 
local villageCellarDoorId = 0

function gd.quests.areaEQuestWendigoVillage.cellarDoorOnInteractGlobalMP()

	local player = Game.GetLocalPlayer()

	if (player:HasToken("AREAE_VILLAGEHOSTILE")) then
		GiveTokenToLocalPlayer("AREAE_VILLAGECELLAR_UNLOCKED")
		
	end 

end

function gd.quests.areaEQuestWendigoVillage.villageCellarOnAddToWorld(objectId)

	if Server then
	
		villageCellarDoorId = objectId;
		
		local door = Door.Get(objectId)
		local player = Game.GetLocalPlayer()

		if (player:HasToken("AREAE_VILLAGECELLAR_UNLOCKED")) then
			door:SetLocked(false)
			door:Open()
		end
		
	end
		
end

-- The cellar door is locked until the player finds the key
function gd.quests.areaEQuestWendigoVillage.cellarDoorOnInteract(objectId, userId)

	local player = Player.Get(userId)
	local door = Door.Get(objectId)
		
	if ((door != nil) && (door:IsLocked())) then
		if player:HasItem("records/items/questitems/quest_areae_barrowholm_cellarkey.dbr", 1, false) && player:HasToken("AREAE_VILLAGEHOSTILE") then

			-- Consume key to unlock door		
			door:SetLocked(false)
			door:Open()

			QuestGlobalEvent("unlockVillageCellarToken")
			
			player:TakeItem("records/items/questitems/quest_areae_barrowholm_cellarkey.dbr", 1, false)
			
			UI.Notify("tagNotification_AreaE_Barrowholm_CellarOpen")
			
		end
		
	end
	
end

-- Scorv's chest is locked until player helps Barrowholm.
local barrowholmChestId = 0

function gd.quests.areaEQuestWendigoVillage.unlockChest()
	
	if Server then
		local chest = Chest.Get(barrowholmChestId);
		
		-- Unlock chest if present
		if (chest != nil) then
			chest:SetLocked(false)
		end
	
	end
	
end

function gd.quests.areaEQuestWendigoVillage.scorvChestOnAddToWorld(objectId)
	
	if Server then
		local chestEntity = Entity.Get(objectId)
		barrowholmChestId = objectId
		player = Game.GetLocalPlayer()
	
		if (player != nil) && (chestEntity:IsReloaded() == false) && (player:HasToken("AREAE_COVENRITUAL_RETURNED") || player:HasToken("AREAE_COVENRITUAL_UNLOCKED") || player:HasToken("AREAE_COVENRITUAL_FINISHED")) then
			print "Destroying Chest"
			chestEntity:Destroy()
			
		elseif player:HasToken("AREAE_VILLAGEHELPED") || player:HasToken("AREAE_VILLAGERESET") then
			local chest = Chest.Get(objectId);
			
			-- Unlock chest if present
			if (chest != nil) then
				chest:SetLocked(false)
			end
			
		end
		
	end
	
end

-- Finding the village
function gd.quests.areaEQuestWendigoVillage.VillageTrigger(triggererId)

	local player = Player.Get(triggererId)
	local kQuest_SeekingUlgrimsPast = 0x8BE0D600
	local kTask_FindVilage = 0xBF320900
	
	local questTaskState = player:GetQuestTaskState(kQuest_SeekingUlgrimsPast, kTask_FindVilage)
	
	if (player != nil) && (questTaskState != QuestState.Complete) then

		GiveTokenIfPlayer(triggererId, "AREAE_VILLAGEFOUND");
		
	end
	
end

-- Trigger for in town clue 01
local screamTriggered = false

function gd.quests.areaEQuestWendigoVillage.villageClue01Trigger(triggererId)

	local player = Player.Get(triggererId)

	local door = Door.Get(villageCellarDoorId)
	
	if (not screamTriggered && not player:HasToken("AREAE_FOUNDALLVILLAGECLUES") && not player:HasToken("AREAE_VILLAGEFRIENDLY") && not player:HasToken("AREAE_VILLAGEHOSTILE")) then
		screamTriggered = true
		
		if (player != nil) then
			player:GiveToken("AREAE_VILLAGECLUE01")
			UI.Notify("tagNotification_AreaE_Barrowholm_Clue01")
			
			if (player:HasToken("AREAE_VILLAGECLUE01") && player:HasToken("AREAE_VILLAGECLUE02") && player:HasToken("AREAE_VILLAGECLUE03")) then
				player:GiveToken("AREAE_FOUNDALLVILLAGECLUES")
				player:RemoveToken("AREAE_VILLAGECLUE01")
				player:RemoveToken("AREAE_VILLAGECLUE02")
				player:RemoveToken("AREAE_VILLAGECLUE03")
			
			end

			local playerEntity = Entity.Get(triggererId)
			
			if (playerEntity != nil) then
			
				local coords = playerEntity:GetCoords()
				local pfx = Entity.Create("records/fx/creatures/wendigoclue01_sound.dbr")
				
				if (pfx != nil) then
					pfx:NetworkEnable()
					pfx:SetCoords(coords)
				end
				
			end
			
		end
		
	elseif (door != nil && door:IsLocked()) && player:HasToken("AREAE_VILLAGEHOSTILE") && player:HasToken("AREAE_VILLAGECELLAR_UNLOCKED") == false then
		if player:HasItem("records/items/questitems/quest_areae_barrowholm_cellarkey.dbr", 1, false) then

			-- Consume key to unlock door		
			door:SetLocked(false)
			door:Open()

			QuestGlobalEvent("unlockVillageCellarToken")
			
			player:TakeItem("records/items/questitems/quest_areae_barrowholm_cellarkey.dbr", 1, false)
			
			UI.Notify("tagNotification_AreaE_Barrowholm_CellarOpen")
			
		end
		
	end
	
end


-- Give Token when the player picks up the lore object in the bog
function gd.quests.areaEQuestWendigoVillage.villageClue02OnPickup()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAE_FOUNDALLVILLAGECLUES") && not player:HasToken("AREAE_VILLAGEFRIENDLY") && not player:HasToken("AREAE_VILLAGEHOSTILE")) then
		
		if (player != nil) then
			player:GiveToken("AREAE_VILLAGECLUE02")
			UI.Notify("tagNotification_AreaE_Barrowholm_Clue02")
			
			if (player:HasToken("AREAE_VILLAGECLUE01") && player:HasToken("AREAE_VILLAGECLUE02") && player:HasToken("AREAE_VILLAGECLUE03")) then
				player:GiveToken("AREAE_FOUNDALLVILLAGECLUES")
				player:RemoveToken("AREAE_VILLAGECLUE01")
				player:RemoveToken("AREAE_VILLAGECLUE02")
				player:RemoveToken("AREAE_VILLAGECLUE03")
			
			end
			
		end
		
	end
	
end

-- Give Token when the player picks up the in town lore object (Aurin's Recipe)
function gd.quests.areaEQuestWendigoVillage.villageClue03OnPickup()

	local player = Game.GetLocalPlayer()
	
	if (not player:HasToken("AREAE_FOUNDALLVILLAGECLUES") && not player:HasToken("AREAE_VILLAGEFRIENDLY") && not player:HasToken("AREAE_VILLAGEHOSTILE")) then
		
		if (player != nil) then
			player:GiveToken("AREAE_VILLAGECLUE03")
			UI.Notify("tagNotification_AreaE_Barrowholm_Clue03")
			
			if (player:HasToken("AREAE_VILLAGECLUE01") && player:HasToken("AREAE_VILLAGECLUE02") && player:HasToken("AREAE_VILLAGECLUE03")) then
				player:GiveToken("AREAE_FOUNDALLVILLAGECLUES")
				player:RemoveToken("AREAE_VILLAGECLUE01")
				player:RemoveToken("AREAE_VILLAGECLUE02")
				player:RemoveToken("AREAE_VILLAGECLUE03")
			
			end
			
		end
		
	end
	
end


-- Reset the player's faction status if they choose to on a higher difficulty
local factionReset = false
local factionResetTokens = false

-- Friendly Reset
function gd.quests.areaEQuestWendigoVillage.factionReset()

	if not factionReset then
		local player = Game.GetLocalPlayer()
		factionReset = true
		player:SetFaction("USER10", 0)
		
		player:GrantQuest(0xA617B600, 0x72DB6400)

	end

end

-- Hostile Reset
function gd.quests.areaEQuestWendigoVillage.factionHostileReset()

	if not factionReset then
		local player = Game.GetLocalPlayer()
		factionReset = true
		player:SetFaction("USER10", 0)
		
		player:GrantQuest(0xB3558700, 0xAC3CCE00)

	end

end

-- replace player tokens if they reset their faction and load on a previous difficulty
function gd.quests.areaEQuestWendigoVillage.factionResetTokens()

	if not factionResetTokens then
		local player = Game.GetLocalPlayer()
		
		if ((player:HasToken("AREAE_VILLAGEFRIENDLY") && player:GetFaction("USER10") < 0)) then
			factionResetTokens = true
			
			player:GiveToken("AREAE_VILLAGERESET")
			player:GiveToken("AREAE_VILLAGEHOSTILE")
			player:GiveToken("AREAE_VILLAGECELLAR_UNLOCKED")
			player:RemoveToken("AREAE_VILLAGEFRIENDLY")
			player:RemoveToken("AREAE_TRAVELERS_CAPTIVE")
			player:RemoveToken("AREAE_RAVAGERSPAWNED")
			player:RemoveToken("AREAE_VILLAGE_RITUAL")
			player:RemoveToken("AREAE_TYVALDCHOSEN")
			player:RemoveToken("AREAE_AURINCHOSEN")
			player:RemoveToken("AREAE_JORDYTHCHOSEN")
			
		elseif ((player:HasToken("AREAE_VILLAGEHOSTILE")) && player:GetFaction("USER10") > 0) then
			factionResetTokens = true
			
			player:GiveToken("AREAE_VILLAGERESET")
			player:GiveToken("AREAE_VILLAGEFRIENDLY")
			player:RemoveToken("AREAE_VILLAGEHOSTILE")
			player:RemoveToken("AREAE_VILLAGECELLAR_UNLOCKED")

		end
		
	end

end
