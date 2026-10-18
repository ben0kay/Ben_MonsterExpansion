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

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Buff.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Bonus.tpl"
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
			defaultValue = "Skill_Shapeshift"
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
			name = "instantCast"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
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
			name = "skillActiveLifeCost"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillActiveManaCost"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "replacementMeshMale"
			class = "variable"
			type = "file_msh"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "replacementMeshFemale"
			class = "variable"
			type = "file_msh"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "replacementSounds"
			class = "variable"
			type = "file_dbr"
			description = "CharacterSounds"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "replacementAnims"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "replacementFootsteps"
			class = "variable"
			type = "file_dbr"
			description = "FootstepSet"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activeSkillSet"
			class = "variable"
			type = "int"
			description = "Skill set to enable (0 = default)"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "grantedSkills"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "allowedSkillTypes"
			class = "array"
			type = "string"
			description = "Allowed skill classes for this shapeshift, leave empty to use the global list"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "attackTrail"
			class = "variable"
			type = "file_dbr"
			description = "Unarmed attack WeaponTrail"
			value = ""
			defaultValue = ""
		}

	}

}

