/*
	
	GRIM DAWN
	
	For more information, visit us at http://www.grimdawn.com
	
*/

--
-- John Bourbon movement
--
-- John Bourbon begins the game outside of the prison and moves inside to the 
-- office area when the player progresses far enough along in the storyline.
--

gd.quests.devilsCrossing.johnBourbon = {}

local bourbonIntroId = 0
local bourbonOfficeId = 0

local BourbonLocation = { Intro = 0, Office = 1, FortIkon = 2, GDX1 = 3 }

gd.quests.devilsCrossing.johnBourbon.introOnDestroy = ClearObjectUserdata

-- John Bourbon outside the prison
local bourbonIntroStateObjects = orderedTable()
	bourbonIntroStateObjects["AREAE_NPCS"]	= { state = BourbonLocation.GDX1,  dbr = nil }
	bourbonIntroStateObjects["AREAE_INTRO"]	= { state = BourbonLocation.FortIkon,  dbr = nil }
	bourbonIntroStateObjects["DC_BOURBON_OFFICE"]	= { state = BourbonLocation.Office,  dbr = nil }
	bourbonIntroStateObjects[""]					= { state = BourbonLocation.Intro,   dbr = "records/creatures/npcs/questnpcs/npc_johnbourbon_01.dbr" }
	
function gd.quests.devilsCrossing.johnBourbon.introOnAddToWorld(objectId)
	
	if Server then
	
		bourbonIntroId = objectId

		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, bourbonIntroStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end
	
end

gd.quests.devilsCrossing.johnBourbon.introOnDestroy = ClearObjectUserdata

-- John Bourbon in his office inside the prison
local bourbonOfficeStateObjects = orderedTable()
	bourbonOfficeStateObjects["AREAE_NPCS"]	= { state = BourbonLocation.GDX1,  dbr = nil }
	bourbonOfficeStateObjects["AREAE_INTRO"]	= { state = BourbonLocation.FortIkon,  dbr = nil }
	bourbonOfficeStateObjects["DC_BOURBON_OFFICE"]	= { state = BourbonLocation.Office,  dbr = "records/creatures/npcs/questnpcs/npc_johnbourbon_01.dbr" }
	bourbonOfficeStateObjects[""]					= { state = BourbonLocation.Intro,   dbr = nil }
	
function gd.quests.devilsCrossing.johnBourbon.officeOnAddToWorld(objectId)

	if Server then
	
		bourbonOfficeId = objectId

		local userdata = {}
		TokenStateBasedObjectSwap(objectId, userdata, bourbonOfficeStateObjects)
		Shared.setUserdata(objectId, userdata)
		
	end

end

gd.quests.devilsCrossing.johnBourbon.officeOnDestroy = ClearObjectUserdata

-- Called by quest, teleports John Bourbon to the office location in the prison
local bourbonOfficeMove = false
local bourbonDespawnOffice = false

function gd.quests.devilsCrossing.johnBourbon.moveToOfficeGlobalMP()
	
	local player = Game.GetLocalPlayer()
	
	if ((player != nil) && player:HasToken("DC_HELPED_BARNABAS") && player:HasToken("DC_HELPED_KASPAROV") && player:HasToken("DC_BOURBON_OFFICE") == false) then
		player:GiveToken("DC_BOURBON_OFFICE")
			
	end

end

function gd.quests.devilsCrossing.johnBourbon.moveToOffice()

	if Server then
		if not bourbonOfficeMove then
			QuestGlobalEvent("bourbonMoveToOfficeToken")
			
			local player = Game.GetLocalPlayer()
			
			if player:HasToken("DC_BOURBON_OFFICE") then
				bourbonOfficeMove = true
				UpdateObjectSwap(bourbonIntroId, bourbonIntroStateObjects)
				UpdateObjectSwap(bourbonOfficeId, bourbonOfficeStateObjects)
				
			end

		end
		
	end

end

function gd.quests.devilsCrossing.johnBourbon.despawnOffice()

	if Server then
		if not bourbonDespawnOffice then
		
			local bourbonOffice = Entity.Get(bourbonOfficeId)			
			
			if (bourbonOffice != nil) then
				bourbonDespawnOffice = true
		
				local coords = bourbonOffice:GetCoords()	
				local riftEnd = Entity.Create("records/fx/ui/riftgatepersonalopen_fxpak.dbr")
			
				if (riftEnd != nil) then
					riftEnd:NetworkEnable()
					riftEnd:SetCoords(coords)
				end
			
				UpdateObjectSwap(bourbonOfficeId, bourbonOfficeStateObjects)
			
			end
			
		end
		
	end

end

