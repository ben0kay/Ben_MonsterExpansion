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
		defaultValue = "database\Templates\TemplateBase\SkillBuff.tpl"
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
			defaultValue = "SkillBuff_DebufProjectile"
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
			name = "debufSkill"
			class = "static"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "1"
		}

		Variable
		{
			name = "debufAttackTime"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

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
			name = "projectileUsesAllDamage"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
		}

	}

}

