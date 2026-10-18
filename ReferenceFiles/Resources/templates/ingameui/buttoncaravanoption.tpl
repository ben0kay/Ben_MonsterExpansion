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
			defaultValue = "ButtonCaravanOption"
		}

	}

	Group
	{
		name = "Config"
		type = "list"

		Variable
		{
			name = "bitmapNameUp"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapNameUpMask"
			class = "variable"
			type = "file_tex"
			description = "Optional"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapNameDown"
			class = "variable"
			type = "file_tex"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapNameDownMask"
			class = "variable"
			type = "file_tex"
			description = "Optional"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapNameInFocus"
			class = "variable"
			type = "file_tex"
			description = "Uses Up Mask"
			value = ""
			defaultValue = ""
		}

	}

}

fileNameHistoryEntry
{
	"templates/ingameui/copy of buttoncaravansymbol.tpl"
}
