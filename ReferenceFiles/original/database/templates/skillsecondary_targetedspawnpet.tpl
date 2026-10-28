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
		defaultValue = "database\Templates\TemplateBase\Skill_Attack.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Secondary.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_ProjectileBase.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Spawning.tpl"
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
			defaultValue = "SkillSecondary_TargetedSpawnPet"
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
		name = "Spawn Config"
		type = "list"

		Variable
		{
			name = "petBurstSpawn"
			class = "array"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "petLimit"
			class = "array"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "petPadding"
			class = "variable"
			type = "real"
			description = "Overrides the default padding in between pet spawn locations"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "spawnObjectsTimeToLive"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "selfTarget"
			class = "variable"
			type = "bool"
			description = "Ignores current target and spawns at caster position"
			value = ""
			defaultValue = "0"
		}

	}

}

