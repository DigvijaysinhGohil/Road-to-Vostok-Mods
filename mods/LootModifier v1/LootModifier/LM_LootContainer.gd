extends Node

var lootSettings = preload("res://LootModifier/LootSettings.tres")

func on_container_generateloot():
	var lib = Engine.get_meta("RTVModLib")
	var container = lib._caller
	
	container.loot.clear()
	var loot_before = container.loot.size()

	var rarityRoll = randf()
	
	if rarityRoll * 100.0 < lootSettings.joker_chance:
		container.joker = true
	
	if container.joker: 
		rarityRoll = 1.0

	if rarityRoll <= lootSettings.legendary_chance:
		if container.legendaryBucket.size() != 0:
			for pick in 1:
				on_container_createloot(container, container.legendaryBucket.pick_random())

	elif rarityRoll <= lootSettings.rare_chance:
		if container.rareBucket.size() != 0:
			for pick in randi_range(0, 1):
				on_container_createloot(container, container.rareBucket.pick_random())

	elif rarityRoll <= lootSettings.common_chance:
		if container.commonBucket.size() != 0:
			for pick in randi_range(0, 4):
				on_container_createloot(container, container.commonBucket.pick_random())

	elif rarityRoll == 1.0:
		if container.rareBucket.size() != 0:
			for pick in randi_range(1, 2):
				on_container_createloot(container, container.rareBucket.pick_random())

		if container.commonBucket.size() != 0:
			for pick in randi_range(4, 10):
				on_container_createloot(container, container.commonBucket.pick_random())

	# Add items to meet minimum if needed
	if lootSettings.min_loot_items > 0:
		var current_loot_count = container.loot.size() - loot_before
		
		if current_loot_count < lootSettings.min_loot_items:
			var items_to_add = randi_range(lootSettings.min_loot_items, lootSettings.max_loot_items) - current_loot_count
			
			for i in items_to_add:
				if randf() <= lootSettings.loot_add_chance:
					var item = _get_weighted_random_item(container)
					if item:
						on_container_createloot(container, item)
					else:
						break

# Helper function
func _get_weighted_random_item(container):
	var roll = randf()
	
	if roll <= 0.001:
		if container.legendaryBucket.size() > 0:
			return container.legendaryBucket.pick_random()
	elif roll <= 0.05:
		if container.rareBucket.size() > 0:
			return container.rareBucket.pick_random()
	else:
		if container.commonBucket.size() > 0:
			return container.commonBucket.pick_random()
	
	var all_items = []
	all_items.append_array(container.commonBucket)
	all_items.append_array(container.rareBucket)
	all_items.append_array(container.legendaryBucket)
	
	if all_items.is_empty():
		return null
	
	return all_items.pick_random()

func on_container_createloot(container, item):
	var newSlotData = SlotData.new()
	newSlotData.itemData = item

	var gameData = container.get_node("/root/GameData")
	
	if gameData and gameData.tutorial:
		if item.defaultAmount != 0 and item.subtype != "Magazine":
			newSlotData.amount = item.defaultAmount
	else:
		if item.defaultAmount != 0:
			newSlotData.amount = randi_range(1, item.defaultAmount)
			
			# Condition is all I modify so far, I will modify the rest at some later date
		if item.type == "Weapon" or item.subtype == "Light" or item.subtype == "NVG":
			newSlotData.condition = randi_range(lootSettings.min_condition, lootSettings.max_condition)

	if Simulation and Simulation.season == 2:
		if newSlotData.itemData.freezable:
			if randi_range(0, 100) < 10:
				newSlotData.state = "Frozen"

	container.loot.append(newSlotData)
