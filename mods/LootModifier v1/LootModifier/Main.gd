extends Node

var _lib = null
var container_handler = null
var simulation_handler = null

func _ready():
	# Create instances of your handlers
	container_handler = preload("res://LootModifier/LM_LootContainer.gd").new()
	simulation_handler = preload("res://LootModifier/LM_LootSimulation.gd").new()
	
	if Engine.has_meta("RTVModLib"):
		var lib = Engine.get_meta("RTVModLib")
		if lib._is_ready:
			_on_lib_ready()
		else:
			lib.frameworks_ready.connect(_on_lib_ready)

func _on_lib_ready():
	_lib = Engine.get_meta("RTVModLib")
	
	# Loot Container Hooks - runs code in LootContainerHandler.gd
	_lib.hook("lootcontainer-generateloot-post", container_handler.on_container_generateloot)
	_lib.hook("lootcontainer-createloot-post", container_handler.on_container_createloot)
	
	# Loot Simulation Hooks - runs code in LootSimulationHandler.gd
	_lib.hook("lootsimulation-_ready-post", simulation_handler.on_lootsimulation_ready)
	_lib.hook("lootsimulation-spawnitems-post", simulation_handler.on_simulation_spawnitems)
	
	print("LootModifier hooks registered!")
