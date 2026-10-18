Group
{
	name = "All Groups"
	type = "list"

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\SkillChanneled.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Radius.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Cast.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Parameters_Character.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/parameters_defensive.tpl"
	}

	Group
	{
		name = "Header"
		type = "system"

		Variable
		{
			name = "ActorName"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "Class"
			class = "static"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Skill_AttackRadiusGrow"
		}

		Variable
		{
			name = "FileDescription"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Skill Config"
		type = "list"

		Variable
		{
			name = "timeBetweenAttacks"
			class = "variable"
			type = "int"
			description = "Time between hits to enemies along the path"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "timeBetweenGrow"
			class = "variable"
			type = "int"
			description = "Time between radius growth"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "radiusIncrement"
			class = "variable"
			type = "real"
			description = "Amount radius will grow"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "explosionRadius"
			class = "array"
			type = "real"
			description = "Max radius"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "startSound"
			class = "variable"
			type = "file_dbr"
			description = "SoundPak to play when start animation plays"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "loopSound"
			class = "variable"
			type = "file_dbr"
			description = "SoundPak to loop while loop animation plays"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "rotationSpeedMultiplier"
			class = "variable"
			type = "real"
			description = "Multiplier applied to player rotation speed while skill is active"
			value = ""
			defaultValue = "1.0"
		}

	}

	Group
	{
		name = "Skill Effects"
		type = "list"

		Variable
		{
			name = "radiusEffectSize"
			class = "array"
			type = "real"
			description = "Radius size EffectEntity will be used"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "radiusEffectNames"
			class = "array"
			type = "file_dbr"
			description = "EffectEntity to use at or above size"
			value = ""
			defaultValue = ""
		}

	}

}

