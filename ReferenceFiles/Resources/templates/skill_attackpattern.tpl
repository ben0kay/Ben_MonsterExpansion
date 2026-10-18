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
		defaultValue = "database\Templates\TemplateBase\Skill_Base.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Activated.tpl"
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
			defaultValue = "Skill_AttackPattern"
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
		name = "Pattern Config"
		type = "list"

		Variable
		{
			name = "pattern"
			class = "picklist"
			type = "string"
			description = "Determines pattern for skill secondary activation"
			value = ""
			defaultValue = "Grid;Lines;Ring;Circle;"
		}

		Variable
		{
			name = "placementRadius"
			class = "variable"
			type = "real"
			description = "Maximum radius for points"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "spawnRadius"
			class = "variable"
			type = "real"
			description = "Maximum radius for each spawn point"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "spawnLocations"
			class = "array"
			type = "int"
			description = "Number of spawn points"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "selfTarget"
			class = "variable"
			type = "bool"
			description = "Use caster as center point"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "randomPoints"
			class = "variable"
			type = "bool"
			description = "Random vs evenly spaced points"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "alternateSpawn"
			class = "variable"
			type = "bool"
			description = "Alternate/offset spacing"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "forceCenterPoint"
			class = "variable"
			type = "bool"
			description = "Forces center point to be included (only works for some pattern types)"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "minDelay"
			class = "variable"
			type = "real"
			description = "Min delay (s) before skill secondary activation"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "maxDelay"
			class = "variable"
			type = "real"
			description = "Max delay (s) before skill secondary activation"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "groundEffect"
			class = "variable"
			type = "file_dbr"
			description = "Ground effect entity for each spawn location"
			value = ""
			defaultValue = ""
		}

	}

}

