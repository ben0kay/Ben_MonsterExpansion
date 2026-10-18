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
		defaultValue = "database\Templates\TemplateBase\Skill_Base.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Attack.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database\Templates\TemplateBase\Skill_Activated.tpl"
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
			defaultValue = "Skill_AttackLineFan"
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
			name = "skillTargetAngle"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillTargetNumber"
			class = "array"
			type = "int"
			description = ""
			value = ""
			defaultValue = "1"
		}

		Variable
		{
			name = "attackWidth"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "explosionDamageScale"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "lineLength"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "segmentLengthMin"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "segmentLengthMax"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "segmentRotationMin"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "segmentRotationMax"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "travelTime"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "lifeTime"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "trailEffect"
			class = "variable"
			type = "file_dbr"
			description = "TrailEffect"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textureWidthStart"
			class = "variable"
			type = "real"
			description = "TrailEffect"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textureWidthMiddle"
			class = "variable"
			type = "real"
			description = "TrailEffect"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "textureWidthEnd"
			class = "variable"
			type = "real"
			description = "TrailEffect"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "endEffect"
			class = "variable"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "fxMesh"
			class = "variable"
			type = "file_dbr"
			description = "FxMesh"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "fxMeshDistance"
			class = "variable"
			type = "real"
			description = "Distance between each FxMesh"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "explosionEffect"
			class = "variable"
			type = "file_dbr"
			description = "EffectEntity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "explosionDistance"
			class = "variable"
			type = "real"
			description = "Distance between each explosion"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "useTargetDir"
			class = "variable"
			type = "bool"
			description = "Shoot towards target instead of in front of caster"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "useHandLaunch"
			class = "variable"
			type = "bool"
			description = "Shoots from hand callback point instead of center of caster"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "launchAttachPointName"
			class = "variable"
			type = "string"
			description = "Shoots from attach point"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "launchOffset"
			class = "variable"
			type = "real"
			description = "Offsets launch point on Z axis"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "alternateLaunchRotation"
			class = "variable"
			type = "real"
			description = "Secondary launch rotation"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "followTerrain"
			class = "variable"
			type = "bool"
			description = ""
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "startSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "loopSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "endSound"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

}

