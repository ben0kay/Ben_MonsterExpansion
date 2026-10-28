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
		defaultValue = "database/templates/templatebase/fixedactor.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/questmarker.tpl"
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
			defaultValue = "AscendantAltar"
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
		name = "Altar Animations"
		type = "list"

		Variable
		{
			name = "dormantAnimation"
			class = "variable"
			type = "file_anm"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantAnimationSpeed"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "1.0"
		}

		Variable
		{
			name = "dormantToActivatedAnimation"
			class = "variable"
			type = "file_anm"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantToActivatedAnimationSpeed"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "1.0"
		}

		Variable
		{
			name = "activatedAnimation"
			class = "variable"
			type = "file_anm"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activatedAnimationSpeed"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "1.0"
		}

	}

	Group
	{
		name = "Altar Effects"
		type = "list"

		Variable
		{
			name = "dormantLoopingEffect"
			class = "variable"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantLoopingAttachment"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantToActivatedFxPakName"
			class = "variable"
			type = "file_dbr"
			description = "FxPak"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantToActivatedEffect"
			class = "variable"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantToActivatedEffectAttachment"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activatedLoopingEffect"
			class = "variable"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activatedLoopingAttachment"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Altar Sounds"
		type = "list"

		Variable
		{
			name = "dormantSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "dormantToActivatedSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activatedSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

