Group
{
	name = "All Groups"
	type = "list"

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
			defaultValue = ""
		}

	}

	Group
	{
		name = "Skill Config"
		type = "list"

		Variable
		{
			name = "skillComboChargeLevel"
			class = "array"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillComboChargeDuration"
			class = "array"
			type = "real"
			description = "Seconds"
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Skill Sound"
		type = "list"

		Variable
		{
			name = "skillComboChargeSound"
			class = "variable"
			type = "file_dbr"
			description = "Played at max charge level"
			value = ""
			defaultValue = ""
		}

	}

}

