extends "res://Scripts/Character.gd"

#const LOW_VITAL_DRAIN_DATA_PATH = "res://Mods/LowVitalDrain/LowVitalDrain/LowVitalDrainData.tres" # Testing
const LOW_VITAL_DRAIN_DATA_PATH = "res://LowVitalDrain/LowVitalDrainData.tres" # Deployment

var lowVitalDrainData = null

func _ready() -> void:
    lowVitalDrainData = load(LOW_VITAL_DRAIN_DATA_PATH)

func _physics_process(delta):
    if gameData.isTransitioning || gameData.isCaching: return

    var deltaModifier: float = lowVitalDrainData.drainSpeed

    Health(delta)
    Stamina(delta)
    Energy(delta * deltaModifier)
    Hydration(delta * deltaModifier)
    Mental(delta * deltaModifier)
    Temperature(delta * deltaModifier)
    Cat(delta * deltaModifier)
    Oxygen(delta)
    BurnDamage(delta)
    PoisonDamage(delta)
    RazorDamage(delta)
    Reputation(delta)
    Clamp()
