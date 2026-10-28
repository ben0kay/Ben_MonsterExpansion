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
		defaultValue = "database/templates/templatebase/skill_base.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/skill_attack.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/skill_projectilebase.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/skill_secondary.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/skill_radius.tpl"
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
			defaultValue = "SkillSecondary_AttackProjectileDrop"
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
			name = "skillProjectileName"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillProjectileMaximumNumber"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillActiveDuration"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "projectileUsesAllDamage"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
		}

	}

	Group
	{
		name = "Drop"
		type = "list"

		Variable
		{
			name = "numProjectiles"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = "3"
		}

		Variable
		{
			name = "dropRadius"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "10.0"
		}

		Variable
		{
			name = "dropHeight"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "14.0"
		}

		Variable
		{
			name = "dropVariation"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "3.0"
		}

		Variable
		{
			name = "launchAboveTarget"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "projectilePeriod"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

