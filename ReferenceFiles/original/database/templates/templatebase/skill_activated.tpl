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
		defaultValue = "database\Templates\TemplateBase\Parameters_Skill.tpl"
	}

	Variable
	{
		name = "Include File"
		class = "static"
		type = "include"
		description = ""
		value = ""
		defaultValue = "database/templates/templatebase/skill_refresh.tpl"
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
		name = "Skill Config"
		type = "list"

		Variable
		{
			name = "skillCooldownTime"
			class = "array"
			type = "real"
			description = "Seconds"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillManaCost"
			class = "array"
			type = "real"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "cooldownCharges"
			class = "array"
			type = "int"
			description = "Amount of times skill can be used in a row"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "propName"
			class = "variable"
			type = "file_dbr"
			description = "Attaches between Swipe and Hit"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "propName1"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "propName2"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "distanceProfile"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Melee;Short;Moderate;Long;Maximum;Boss;"
		}

	}

	Group
	{
		name = "Skill Sound"
		type = "list"

		Variable
		{
			name = "skillSwipeSound"
			class = "variable"
			type = "file_dbr"
			description = "Played at Swipe callback"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillHitSound"
			class = "variable"
			type = "file_dbr"
			description = "Played at Hit callback"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillSound1"
			class = "variable"
			type = "file_dbr"
			description = "Played at SkillSound1 callback"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "skillSound2"
			class = "variable"
			type = "file_dbr"
			description = "Played at SkillSound2 callback"
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Skill Effects"
		type = "list"

		Variable
		{
			name = "particleEffectName1"
			class = "variable"
			type = "file_dbr"
			description = "PS1Start PS1End"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "particleEffectAttachPoint1"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Body;Head;HeadFXUP;HeadEffect;FXCentered;FXForward;FXForwardUp;FXForwardGround;FXUnParentedCenter;Mouth;Target;SpecialHit01;SpecialHit02;SpecialHit03;SpecialHit04;L Hand;R Hand;"
		}

		Variable
		{
			name = "particleEffectName2"
			class = "variable"
			type = "file_dbr"
			description = "PS2Start PS2End"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "particleEffectAttachPoint2"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Body;Head;HeadFXUP;HeadEffect;FXCentered;FXForward;FXForwardUp;FXForwardGround;FXUnParentedCenter;Mouth;Target;SpecialHit01;SpecialHit02;SpecialHit03;SpecialHit04;L Hand;R Hand;"
		}

		Variable
		{
			name = "particleEffectName3"
			class = "variable"
			type = "file_dbr"
			description = "PS3Start PS3End"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "particleEffectAttachPoint3"
			class = "picklist"
			type = "string"
			description = ""
			value = ""
			defaultValue = "Body;Head;HeadFXUP;HeadEffect;FXCentered;FXForward;FXForwardUp;FXForwardGround;FXUnParentedCenter;Mouth;Target;SpecialHit01;SpecialHit02;SpecialHit03;SpecialHit04;L Hand;R Hand;"
		}

		Variable
		{
			name = "additionalProjectileFX"
			class = "variable"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "cameraShakeDurationSecs"
			class = "variable"
			type = "real"
			description = "PS4Start PS4End"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "cameraShakeAmplitude"
			class = "variable"
			type = "real"
			description = ""
			value = ""
			defaultValue = "0.12"
		}

		Variable
		{
			name = "targetFxFirstOnly"
			class = "variable"
			type = "bool"
			description = "TargetFxPak only for first target hit in projectile explosions"
			value = ""
			defaultValue = "0"
		}

	}

	Group
	{
		name = "Special Sound"
		type = "list"

		Variable
		{
			name = "playSpecialAttackSound1"
			class = "variable"
			type = "bool"
			description = "Plays character special attack sound on skill activation"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "playSpecialAttackSound2"
			class = "variable"
			type = "bool"
			description = "Plays character special attack sound on skill activation"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "playSpecialAttackSound3"
			class = "variable"
			type = "bool"
			description = "Plays character special attack sound on skill activation"
			value = ""
			defaultValue = "0"
		}

		Variable
		{
			name = "playSpecialAttackSound4"
			class = "variable"
			type = "bool"
			description = "Plays character special attack sound on skill activation"
			value = ""
			defaultValue = "0"
		}

	}

}

