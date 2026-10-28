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
		defaultValue = "database\Templates\TemplateBase\Armor.tpl"
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
			defaultValue = "ArmorProtective_Head"
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
		name = "Armor Config"
		type = "list"

		Variable
		{
			name = "armorClassification"
			class = "picklist"
			type = "string"
			description = "Armor Type"
			value = ""
			defaultValue = "Caster;Light;Heavy;"
		}

	}

	Group
	{
		name = "Armor Parameters"
		type = "list"

		Variable
		{
			name = "headMaleMesh"
			class = "variable"
			type = "file_msh"
			description = "Replaces default head"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "headMaleBaseTexture"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "headMaleBumpTexture"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "headFemaleMesh"
			class = "variable"
			type = "file_msh"
			description = "Replaces default head"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "headFemaleBaseTexture"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "headFemaleBumpTexture"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

