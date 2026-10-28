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
		name = "Ascendant Altar"
		type = "list"

		Variable
		{
			name = "ultimateChallangeAdjustment"
			class = "variable"
			type = "file_dbr"
			description = "GameAdjustment for Ultimate+"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeTroveChance"
			class = "variable"
			type = "real"
			description = "Chance treasure troves will roll super, only used in Ultimate+ mode"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "troveEquation"
			class = "variable"
			type = "equation"
			description = "Chance treasure troves will roll super, only used when items are added to the Ascension Altar"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeTotemChance"
			class = "variable"
			type = "real"
			description = "Chance monster totems will roll super, only used in Ultimate+ mode"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "totemEquation"
			class = "variable"
			type = "equation"
			description = "Chance monster totems will roll super, only used when items are added to the Ascension Altar"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeSuperBossChance"
			class = "variable"
			type = "real"
			description = "Chance super boss will spawn, only used in Ultimate+ mode"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "superBossEquation"
			class = "variable"
			type = "equation"
			description = "Chance super boss will spawn, only used when items are added to the Ascension Altar"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "superBossKillsMin"
			class = "variable"
			type = "int"
			description = "Super boss will not spawn before this many kills"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeSuperBossSpawn"
			class = "array"
			type = "file_dbr"
			description = "Super boss to spawn, only used in Ultimate+ mode"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "superBossSpawnSound"
			class = "variable"
			type = "file_dbr"
			description = "Super boss spawn sound"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "altarInclusiveRecipes"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "altarExclusiveRecipes"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Crafting"
		type = "list"

		Variable
		{
			name = "awakenedRecipes"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Potions"
		type = "list"

		Variable
		{
			name = "healthPotionModifierCombos"
			class = "array"
			type = "file_dbr"
			description = "Health Potion"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "energyPotionModifierCombos"
			class = "array"
			type = "file_dbr"
			description = "Energy Potion"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "puritySkillCheck"
			class = "array"
			type = "file_dbr"
			description = ""
			value = ""
			defaultValue = ""
		}

	}

	Group
	{
		name = "Item Ascension"
		type = "list"

		Variable
		{
			name = "itemAscensionHero"
			class = "variable"
			type = "file_dbr"
			description = "Reagent for Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionHeroChance"
			class = "variable"
			type = "real"
			description = "Ascendant mode reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionHeroEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionBoss"
			class = "variable"
			type = "file_dbr"
			description = "Reagent for Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionBossChance"
			class = "variable"
			type = "real"
			description = "Ascendant mode reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionBossEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionNemesis"
			class = "variable"
			type = "file_dbr"
			description = "Reagent for Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionNemesisChance"
			class = "variable"
			type = "real"
			description = "Ascendant mode reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionNemesisEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionNemesis2"
			class = "variable"
			type = "file_dbr"
			description = "Reagent for Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionNemesisChance2"
			class = "variable"
			type = "real"
			description = "Ascendant mode reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionNemesisEquation2"
			class = "variable"
			type = "equation"
			description = "Ascendant altar reagent drop chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionCommonRecipe"
			class = "variable"
			type = "file_dbr"
			description = "Recipe for random Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionCommonChance"
			class = "variable"
			type = "real"
			description = "Ascendant mode item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionAltarCommonEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionRareRecipe"
			class = "variable"
			type = "file_dbr"
			description = "Recipe for random Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionRareChance"
			class = "variable"
			type = "real"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionAltarRareEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionEpicRecipe"
			class = "variable"
			type = "file_dbr"
			description = "Recipe for random Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionEpicChance"
			class = "variable"
			type = "real"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionAltarEpicEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionLegendaryRecipe"
			class = "variable"
			type = "file_dbr"
			description = "Recipe for random Item Ascension"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "ultimateChallengeItemAscensionLegendaryChance"
			class = "variable"
			type = "real"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

		Variable
		{
			name = "itemAscensionAltarLegendaryEquation"
			class = "variable"
			type = "equation"
			description = "Ascendant altar item ascension chance"
			value = ""
			defaultValue = ""
		}

	}

}

