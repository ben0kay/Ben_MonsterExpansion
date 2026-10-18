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
		name = "Bonus"
		type = "list"

		Variable
		{
			name = "skillLifeBonus"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillLifePercent"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillLifePercentSlow"
			class = "array"
			type = "real"
			description = "Slow use only for potions"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillLifeBonusBuffDuration"
			class = "array"
			type = "real"
			description = "Triggers on Buff tick"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillLifePercentBuffDuration"
			class = "array"
			type = "real"
			description = "Triggers on Buff tick"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillManaBonus"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillManaPercent"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillManaPercentSlow"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillBonusEffectName"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

