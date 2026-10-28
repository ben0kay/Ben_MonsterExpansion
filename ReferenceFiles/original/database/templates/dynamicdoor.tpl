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
		defaultValue = "database/templates/doorhookpack.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/fixedactor.tpl"
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
			defaultValue = "DynamicDoor"
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
		name = "DynamicDoor"
		type = "list"

		Variable
		{
			name = "open"
			class = "variable"
			type = "bool"
			description = "Door starts open?"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "locked"
			class = "variable"
			type = "bool"
			description = "Door starts locked?"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "interaction"
			class = "picklist"
			type = "string"
			description = "Possible interactions"
			value = ""
			defaultValue = "OpenClose;Open;Close"
		}

		Variable
		{
			name = "direction"
			class = "picklist"
			type = "string"
			description = "Side from which interactions are allowed"
			value = ""
			defaultValue = "Any;Front;Back"
		}

		Variable
		{
			name = "autoClose"
			class = "variable"
			type = "bool"
			description = "Automatically close the door after opening"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "autoClosePeriod"
			class = "variable"
			type = "real"
			description = "Time in seconds after which the door automatically closes."
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "lockedSound"
			class = "variable"
			type = "file_dbr"
			description = "Sound to play when locked door is used"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "lockedTag"
			class = "variable"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Activate"
		type = "list"

		Variable
		{
			name = "activateSound"
			class = "variable"
			type = "file_dbr"
			description = "Sound to play when door activates"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activateAnimation"
			class = "variable"
			type = "file_anm"
			description = "Animation to play when door activates"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activateAnimationSpeed"
			class = "variable"
			type = "real"
			description = "Speed at which to play activate animation"
			value = ""
			defaultValue = "1.0"
		}

		Variable
		{
			name = "activateFxPakName"
			class = "variable"
			type = "file_dbr"
			description = "FxPak"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activateEffects"
			class = "array"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "activateEffectAttachments"
			class = "array"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Open"
		type = "list"

		Variable
		{
			name = "openMeshName"
			class = "variable"
			type = "file_msh"
			description = "Mesh when door opens"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openSound"
			class = "variable"
			type = "file_dbr"
			description = "Sound to play when door opens"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openAnimation"
			class = "variable"
			type = "file_anm"
			description = "Animation to play when door opens"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openAnimationSpeed"
			class = "variable"
			type = "real"
			description = "Speed at which to play open animation"
			value = ""
			defaultValue = "1.0"
		}

		Variable
		{
			name = "openFxPakName"
			class = "variable"
			type = "file_dbr"
			description = "FxPak"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openEffects"
			class = "array"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openEffectAttachments"
			class = "array"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Opened"
		type = "list"

		Variable
		{
			name = "openedLoopSound"
			class = "variable"
			type = "file_dbr"
			description = "Sound to loop after door opens"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openedLoopAnimation"
			class = "variable"
			type = "file_anm"
			description = "Animation to loop after door opens"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openedLoopAnimationSpeed"
			class = "variable"
			type = "real"
			description = "Speed at which to play open loop animation"
			value = ""
			defaultValue = "1.0"
		}

		Variable
		{
			name = "openedLoopFxPakName"
			class = "variable"
			type = "file_dbr"
			description = "FxPak"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openedLoopEffects"
			class = "array"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "openedLoopEffectAttachments"
			class = "array"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Close"
		type = "list"

		Variable
		{
			name = "closeMeshName"
			class = "variable"
			type = "file_msh"
			description = "Mesh when door is closed"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "closeSound"
			class = "variable"
			type = "file_dbr"
			description = "Sound to play when door closes"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "closeAnimation"
			class = "variable"
			type = "file_anm"
			description = "Animation to play when door closes"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "closeAnimationSpeed"
			class = "variable"
			type = "real"
			description = "Speed at which to play door close animation"
			value = ""
			defaultValue = "1.0"
		}

		Variable
		{
			name = "closeFxPakName"
			class = "variable"
			type = "file_dbr"
			description = "FxPak"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "closeEffects"
			class = "array"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "closeEffectAttachments"
			class = "array"
			type = "string"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

