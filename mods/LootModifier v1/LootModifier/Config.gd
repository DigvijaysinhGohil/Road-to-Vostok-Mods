extends Node

var LootSettings = preload("res://LootModifier/LootSettings.tres")
var McmHelpers = load("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")

const MOD_ID = "LootModifier"
const FILE_PATH = "user://MCM/LootModifier"

func _ready():
	var _config = ConfigFile.new()
	_config.set_value("Float", "common_chance", {
		"name": "Container Item Chance: Common",
		"tooltip": "Higher = more common items.",
		"menu_pos": 0,
		"default": 0.25,
		"value": 0.25,
		"step": 0.0001,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Float", "rare_chance", {
		"name": "Container Item Chance: Rare",
		"tooltip": "Higher = more rare items.",
		"menu_pos": 1,
		"default": 0.05,
		"value": 0.05,
		"step": 0.0001,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Float", "legendary_chance", {
		"name": "Container Item Chance: Legendary",
		"tooltip": "Higher = more legendary items.",
		"menu_pos": 2,
		"default": 0.001,
		"value": 0.001,
		"step": 0.0001,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Int", "joker_chance", {
		"name": "Container will be Joker Chance",
		"tooltip": "Higher = more Joker chance.",
		"menu_pos": 3,
		"default": 1,
		"value": 1,
		"step": 1,
		"minRange": 1,
		"maxRange": 100
	})

	_config.set_value("Float", "common_chance_floor", {
		"name": "Floor Item Chance: Common",
		"tooltip": "Higher = more common items.",
		"menu_pos": 8,
		"default": 0.25,
		"value": 0.25,
		"step": 0.0001,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Float", "rare_chance_floor", {
		"name": "Floor Item Chance: Rare",
		"tooltip": "Higher = more rare items.",
		"menu_pos": 9,
		"default": 0.05,
		"value": 0.05,
		"step": 0.0001,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Float", "legendary_chance_floor", {
		"name": "Floor Item Chance: Legendary",
		"tooltip": "Higher = more legendary items.",
		"menu_pos": 10,
		"default": 0.001,
		"value": 0.001,
		"step": 0.0001,
		"minRange": 0.0,
		"maxRange": 1.0
	})

	_config.set_value("Bool", "guaranteed_drop_floor", {
		"name": "Guaranteed floor item drop",
		"tooltip": "Guarantees item spawns on floor, skips reroll chance",
		"menu_pos": 7,
		"default": false,
		"value": false
	})

	_config.set_value("Float", "reroll_chance_floor", {
		"name": "Floor Loot Reroll chance",
		"tooltip": "Chance to add items between min and max if min items aren't in container",
		"menu_pos": 11,
		"default": 0.5,
		"value": 0.5,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Float", "loot_add_chance", {
		"name": "Container Loot add chance",
		"tooltip": "Chance to add items between min and max if min items aren't in container",
		"menu_pos": 4,
		"default": 0.3,
		"value": 0.3,
		"minRange": 0.0,
		"maxRange": 1.0
	})
	
	_config.set_value("Int", "min_loot_items", {
		"name": "Minimum items in container",
		"tooltip": "Min items in a container if the loot add chance succeeds",
		"menu_pos": 5,
		"default": 1,
		"value": 1,
		"minRange": 0,
		"maxRange": 15
	})

	_config.set_value("Int", "max_loot_items", {
		"name": "Maximum items in container",
		"tooltip": "Max items in a container if the loot add chance succeeds",
		"menu_pos": 6,
		"default": 3,
		"value": 3,
		"minRange": 0,
		"maxRange": 15
	})

	_config.set_value("Int", "min_condition", {
		"name": "Minimum item spawn condition",
		"tooltip": "The minimum condition items spawn at",
		"menu_pos": 12,
		"default": 25,
		"value": 25,
		"minRange": 0,
		"maxRange": 100
	})

	_config.set_value("Int", "max_condition", {
		"name": "Maximum item spawn condition",
		"tooltip": "The maximum condition items spawn at",
		"menu_pos": 13,
		"default": 100,
		"value": 100,
		"minRange": 0,
		"maxRange": 100
	})


	if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
		DirAccess.open("user://").make_dir(FILE_PATH)
		_config.save(FILE_PATH + "/config.ini")
	else:
		McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
		_config.load(FILE_PATH + "/config.ini")
	
	McmHelpers.RegisterConfiguration(
		MOD_ID,
		"LootModifier",
		FILE_PATH,
		"A simple tool for modifying loot drops",
		{
			"config.ini": _on_config_updated
		}
	)

func apply_config_values(_config: ConfigFile):
	# Apply all values to your loot settings resource
	LootSettings.common_chance = _config.get_value("Float", "common_chance")["value"]
	LootSettings.rare_chance = _config.get_value("Float", "rare_chance")["value"]
	LootSettings.legendary_chance = _config.get_value("Float", "legendary_chance")["value"]
	LootSettings.joker_chance = _config.get_value("Int", "joker_chance")["value"]

	LootSettings.common_chance_floor = _config.get_value("Float", "common_chance_floor")["value"]
	LootSettings.rare_chance_floor = _config.get_value("Float", "rare_chance_floor")["value"]
	LootSettings.legendary_chance_floor = _config.get_value("Float", "legendary_chance_floor")["value"]

	LootSettings.reroll_chance_floor = _config.get_value("Float", "reroll_chance_floor")["value"]
	LootSettings.guaranteed_drop_floor = _config.get_value("Bool", "guaranteed_drop_floor")["value"]

	LootSettings.loot_add_chance = _config.get_value("Float", "loot_add_chance")["value"]
	LootSettings.min_loot_items = _config.get_value("Int", "min_loot_items")["value"]
	LootSettings.max_loot_items = _config.get_value("Int", "max_loot_items")["value"]

	LootSettings.min_condition = _config.get_value("Int", "min_condition")["value"]
	LootSettings.max_condition = _config.get_value("Int", "max_condition")["value"]

	LootSettings.mcmEnabled = true

func _on_config_updated(_config: ConfigFile):
	print("LootModifier: Config updated by MCM")
	apply_config_values(_config)
