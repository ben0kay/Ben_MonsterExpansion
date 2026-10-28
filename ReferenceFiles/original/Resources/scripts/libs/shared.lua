/*
	
	GRIM DAWN	
	scripts/libs/shared.lua
	
	For more information, visit us at http://www.grimdawn.com
	
*/

-- Put math functions into globals table
sqrt = math.sqrt
min = math.min
max = math.max
pow = math.pow
sin = math.sin
cos = math.cos
tan = math.tan

function random()
	return math.random();
end

function random(u)
	return math.random(u);
end

function random(l, u)
	if (u > l) then
		return math.random(l, u);
	else
		return l;
	end
end

-- Load libs
Script.Load("scripts/libs/vector.lua")
Script.Load("scripts/libs/userdata.lua")
Script.Load("scripts/libs/table.lua")
Script.Load("scripts/libs/misc.lua")