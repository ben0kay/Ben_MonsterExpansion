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
		defaultValue = "database\Templates\TemplateBase\ItemBase.tpl"
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
			defaultValue = "AscendantAltarFormula"
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
		name = "Formula Config"
		type = "list"

		Variable
		{
			name = "reagentBaseBaseName"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "reagentBaseQuantity"
			class = "variable"
			type = "int"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "reagentBaseTag"
			class = "variable"
			type = "string"
			description = "Tag for reagent display in UI"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "reagentBaseTagRef"
			class = "array"
			type = "real"
			description = "Optional list for base tag reference"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "reagentBaseTagRefUltimateVeteran"
			class = "array"
			type = "real"
			description = "Optional list for base tag reference, used on Ultimate Veteran difficulty"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "reagentHeaderTag"
			class = "variable"
			type = "string"
			description = "Header tag for first reagent of this type"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "masterTableCheckList"
			class = "array"
			type = "file_dbr"
			description = "Match index with override list"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "masterTableOverrideList"
			class = "array"
			type = "file_dbr"
			description = "Match index with check list"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "luaToken"
			class = "variable"
			type = "string"
			description = "Token name for LUA checks"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "prefixSwaps"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "suffixSwaps"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "rarePrefixSwaps"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "rareSuffixSwaps"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "monsterAttributePak"
			class = "variable"
			type = "file_dbr"
			description = "AttributePak for monster bonuses"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "nonBossMonsterAttributePak"
			class = "variable"
			type = "file_dbr"
			description = "AttributePak for non boss monster bonuses"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bossMonsterAttributePak"
			class = "variable"
			type = "file_dbr"
			description = "AttributePak for Boss monster bonuses"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "goldModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "reputationModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "experienceModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "doubleRareWeightModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bonusTroveChanceModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "bonusTotemChanceModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "equippedItemDropModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "nemesisSpawnModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ascensionReagentModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "superBossChanceModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "superBossSpawnModifier"
			class = "array"
			type = "real"
			description = "Percent modifier - Index corresponds to reagent quantity"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "superBossSpawn"
			class = "array"
			type = "file_dbr"
			description = "Super boss to spawn"
			value = ""
			defaultValue = ""
		}

	}

}

