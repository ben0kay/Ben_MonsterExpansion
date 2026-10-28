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
		name = "Config"
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
			name = "textBoxX"
			class = "variable"
			type = "int"
			description = "Upper Left Corner"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textBoxY"
			class = "variable"
			type = "int"
			description = "Upper Left Corner"
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
			name = "bitmapName"
			class = "variable"
			type = "file_tex"
			description = "Scales with text size"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapXPadding"
			class = "variable"
			type = "int"
			description = "Width adjustment"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bitmapYPadding"
			class = "variable"
			type = "int"
			description = "Height adjustment"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "additiveBitmapName"
			class = "variable"
			type = "file_tex"
			description = "Additive rendering, scales with text size"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "additiveBitmapXPadding"
			class = "variable"
			type = "int"
			description = "Width adjustment"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "additiveBitmapYPadding"
			class = "variable"
			type = "int"
			description = "Height adjustment"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "forceAdditiveBitmap"
			class = "variable"
			type = "bool"
			description = "Always renders the additive bitmap"
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
			defaultValue = "Left;Center;Right;"
		}

		Variable
		{
			name = "textAlignmentY"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Top;Center;Botton;"
		}

	}

}

