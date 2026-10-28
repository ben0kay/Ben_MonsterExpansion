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
		defaultValue = "database/templates/ingameui/buttonstatic.tpl"
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
			defaultValue = ""
		}

		Variable
		{
			name = "FileDescription"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = "ButtonStatic"
		}

	}

	Group
	{
		name = "Config"
		type = "list"

		Variable
		{
			name = "customDBR"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "customColor.R"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "customColor.G"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "customColor.B"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "customColor.A"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

