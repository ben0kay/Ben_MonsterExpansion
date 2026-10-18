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
		defaultValue = "database\Templates\InGameUI\ButtonStatic.tpl"
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
			defaultValue = ""
		}

	}

	Group
	{
		name = "Config"
		type = "list"

		Variable
		{
			name = "slotSelectSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "slotDropSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "highlightBlue"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "highlightRed"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "overlayBitmap"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "overlayBitmapPosX"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "overlayBitmapPosY"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "buttonDefaultRollover"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapWidth"
			class = "variable"
			type = "int"
			description = "Forced render size"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "bitmapHeight"
			class = "variable"
			type = "int"
			description = "Forced render size"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "disableCooldownRadial"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
		}

	}

	Group
	{
		name = "Quantity"
		type = "list"

		Variable
		{
			name = "style"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "rollover"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textBoxX"
			class = "variable"
			type = "int"
			description = "Quantity text, relative to center"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textBoxY"
			class = "variable"
			type = "int"
			description = "Quantity text, relative to center"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textBoxXSize"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textBoxYSize"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textAlignmentX"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Left;Center;Right"
		}

		Variable
		{
			name = "textAlignmentY"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Top;Center;Botton"
		}

	}

	Group
	{
		name = "KeyText"
		type = "list"

		Variable
		{
			name = "keyTextTable"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "CooldownText"
		type = "list"

		Variable
		{
			name = "cooldownTextTable"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Charges"
		type = "list"

		Variable
		{
			name = "twoCharges"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "threeCharges"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "fourCharges"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "fiveCharges"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

