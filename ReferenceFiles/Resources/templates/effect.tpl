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
			defaultValue = "EffectEntity"
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
		name = "Effect"
		type = "list"

		Variable
		{
			name = "effectFile"
			class = "variable"
			type = "file_pfx"
			description = ""
			value = ""
			defaultValue = "Sandbox/Marcus/default.pfx"
		}

		Variable
		{
			name = "emitterType"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Standard;AllBones;BoneList"
		}

		Variable
		{
			name = "boneList"
			class = "array"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Bone_R_Weapon;Bone_L_Weapon"
		}

		Variable
		{
			name = "localOrientFix"
			class = "variable"
			type = "bool"
			description = "Local emitters will emit in a fixed(default XYZ) orientation"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "canBeSoft"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "decal"
			class = "array"
			type = "file_dbr"
			description = "Uses a dbr based on decal.tpl. Random selection."
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "decalChance"
			class = "variable"
			type = "int"
			description = "Chance (0,100) that a decal will be spawned. A value of 0 will always be spawned."
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "decalRotate"
			class = "variable"
			type = "bool"
			description = "If true, rotates the decal randomly around the Y axis before attachment"
			value = ""
			defaultValue = "1"
		}

		Variable
		{
			name = "cameraShakeDuration"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "cameraShakeAmplitude"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "0"
		}

	}

}

