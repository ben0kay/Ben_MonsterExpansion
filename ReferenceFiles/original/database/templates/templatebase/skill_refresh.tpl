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
		name = "Refresh Skill Duration"
		type = "list"

		Variable
		{
			name = "refreshDurationSkill"
			class = "variable"
			type = "file_dbr"
			description = "Skill to be refreshed"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "refreshDurationTrigger"
			class = "picklist"
			type = "string"
			description = "Activation trigger"
			value = ""
			defaultValue = "OnEquip;OnKill;LowHealth;LowMana;AttackEnemy;CastBuff;CastDebuf;HitByEnemy;HitByMelee;HitByProjectile;HitByCrit;AttackEnemyCrit;Block"
		}

		Variable
		{
			name = "refreshDurationChance"
			class = "array"
			type = "int"
			description = "Activation chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "refreshDurationAmount"
			class = "array"
			type = "real"
			description = "Refresh amount per activation (Seconds)"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "refreshDurationMax"
			class = "array"
			type = "real"
			description = "Max refresh amount per buff (Seconds)"
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Refresh Skill Cooldown"
		type = "list"

		Variable
		{
			name = "refreshCooldownSkill"
			class = "variable"
			type = "file_dbr"
			description = "Skill to be refreshed"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "refreshCooldownTrigger"
			class = "picklist"
			type = "string"
			description = "Activation trigger"
			value = ""
			defaultValue = "OnEquip;OnKill;LowHealth;LowMana;AttackEnemy;CastBuff;CastDebuf;HitByEnemy;HitByMelee;HitByProjectile;HitByCrit;AttackEnemyCrit;Block"
		}

		Variable
		{
			name = "refreshCooldownChance"
			class = "array"
			type = "int"
			description = "Activation chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "refreshCooldownAmount"
			class = "array"
			type = "real"
			description = "Refresh amount per activation (Seconds)"
			value = ""
			defaultValue = ""
		}

	}

}
