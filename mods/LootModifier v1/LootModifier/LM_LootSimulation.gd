extends Node

var lootSettings = preload("res://LootModifier/LootSettings.tres")

# Handles the _ready hook
func on_lootsimulation_ready():
	var lib = Engine.get_meta("RTVModLib")
	
	# sim is just short for simulation
	var sim = lib._caller
	
	var kill_text = sim.get_child(0)
	kill_text.hide()
	
	if !sim.custom:
		sim.ClearBuckets()
		sim.FillBuckets()
		sim.RerollLootGeneration()
		sim.SpawnItems()
	
	if sim.custom and !sim.force:
		sim.ClearBuckets()
		sim.FillBucketsCustom()
		sim.RerollLootGeneration()
	
	if sim.custom and sim.force:
		for index in sim.custom.items.size():
			sim.loot.append(sim.custom.items[index])
			sim.SpawnItems()

func reroll_loot_generation(sim):
	on_simulation_generateloot()  # Nolonger calls the original GenerateLoot, no point in doing so
	
	if sim.loot.size() == 0:
		if lootSettings.guaranteed_drop_floor:
			var roll = randf()
			
			if roll <= 0.001:
				if sim.legendaryBucket.size() > 0:
					sim.loot.append(sim.legendaryBucket.pick_random())
			elif roll <= 0.05:
				if sim.rareBucket.size() > 0:
					sim.loot.append(sim.rareBucket.pick_random())
			else:
				if sim.commonBucket.size() > 0:
					sim.loot.append(sim.commonBucket.pick_random())
		elif randf() <= lootSettings.reroll_chance_floor:
			sim.loot.clear()
			on_simulation_generateloot()  # Try again

# I replace loot generation, so I clear the loot
func on_simulation_generateloot():
	var lib = Engine.get_meta("RTVModLib")
	var sim = lib._caller
	
	sim.loot.clear()
	
	var rarityRoll = randf()
	if sim.joker:
		rarityRoll = 1.0
	
	if rarityRoll == lootSettings.legendary_chance_floor:
		if sim.legendaryBucket.size() != 0:
			for pick in 1:
				sim.loot.append(sim.legendaryBucket.pick_random())
	elif rarityRoll <= lootSettings.rare_chance_floor:
		if sim.rareBucket.size() != 0:
			for pick in randi_range(0, 1):
				sim.loot.append(sim.rareBucket.pick_random())
	elif rarityRoll <= lootSettings.common_chance_floor:
		if sim.commonBucket.size() != 0:
			for pick in randi_range(0, 4):
				sim.loot.append(sim.commonBucket.pick_random())
	elif rarityRoll == 1.0:
		if sim.rareBucket.size() != 0:
			for pick in randi_range(1, 2):
				sim.loot.append(sim.rareBucket.pick_random())
		if sim.commonBucket.size() != 0:
			for pick in randi_range(4, 10):
				sim.loot.append(sim.commonBucket.pick_random())
	
	# Call reroll logic if needed
	if sim.loot.size() == 0:
		reroll_loot_generation(sim)

# Handles the SpawnItems hook
func on_simulation_spawnitems():
	var lib = Engine.get_meta("RTVModLib")
	var sim = lib._caller
	
	if sim.loot.size() != 0:
		for itemData in sim.loot:
			var file = Database.get(itemData.file)
			if !file:
				print("File not found: " + itemData.file)
				return
			
			var pickup = Database.get(itemData.file).instantiate()
			sim.add_child(pickup)
			
			var dropDirection = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
			pickup.Unfreeze()
			pickup.linear_velocity = dropDirection * 10.0
			
			var newSlotData = SlotData.new()
			newSlotData.itemData = itemData
			
			if itemData.defaultAmount != 0:
				newSlotData.amount = randi_range(1, itemData.defaultAmount)
			
			# Condition is all I modify so far, I will modify the rest at some later date
			if itemData.type == "Weapon" or itemData.subtype == "Light" or itemData.subtype == "NVG":
				newSlotData.condition = randi_range(lootSettings.min_condition, lootSettings.max_condition)
			
			if Simulation.season == 2:
				if newSlotData.itemData.freezable:
					if randi_range(0, 100) < 10:
						newSlotData.state = "Frozen"
			
			pickup.slotData = newSlotData
