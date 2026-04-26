extends Resource
class_name LootSettings

var mcmEnabled = false

var min_condition = 25
var max_condition = 100

#-------------Container Loot-------------#

# Item drop chance
var common_chance = 0.25
var rare_chance = 0.05
var legendary_chance = 0.001
var joker_chance = 1

# Reroll chance and range
var loot_add_chance = 0.3
var min_loot_items = 1
var max_loot_items = 3

#-------------Floor Loot-------------#

# Item drop chance
var common_chance_floor = 0.25
var rare_chance_floor = 0.05
var legendary_chance_floor = 0.001

# Reroll chance and Guaranteed drop
var guaranteed_drop_floor = false
var reroll_chance_floor = 0.5
