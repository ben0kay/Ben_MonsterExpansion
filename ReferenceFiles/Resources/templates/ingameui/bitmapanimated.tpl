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
		defaultValue = "database/templates/ingameui/bitmapsingle.tpl"
	}

	Group
	{
		name = "Config"
		type = "list"

		Variable
		{
			name = "xFrames"
			class = "variable"
			type = "int"
			description = "Number of frame columns"
			value = ""
			defaultValue = "1"
		}

		Variable
		{
			name = "yFrames"
			class = "variable"
			type = "int"
			description = "Num of frame rows"
			value = ""
			defaultValue = "1"
		}

		Variable
		{
			name = "totalFrames"
			class = "variable"
			type = "int"
			description = "Total number of frames"
			value = ""
			defaultValue = "1"
		}

		Variable
		{
			name = "xSpacing"
			class = "variable"
			type = "int"
			description = "Spacing to the right of each frame"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "ySpacing"
			class = "variable"
			type = "int"
			description = "Spacing to the bottom of each frame"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "framesPerSecond"
			class = "variable"
			type = "int"
			description = "Animation FPS"
			value = ""
			defaultValue = "30"
		}

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
			defaultValue = "BitmapAnimated"
		}

	}

}

