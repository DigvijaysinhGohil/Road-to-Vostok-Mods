extends "res://Scripts/LootContainer.gd"

#const CONTAINER_JOKER_CHANCE_DATA_PATH = "res://mods/ContainerJokerChance/ContainerJokerChance/ContainerJokerChanceData.tres" # Testing
const CONTAINER_JOKER_CHANCE_DATA_PATH = "res://ContainerJokerChance/ContainerJokerChanceData.tres" # Deployment

var containerJokerChanceData = null

func _ready() -> void:
    containerJokerChanceData = load(CONTAINER_JOKER_CHANCE_DATA_PATH)
    if custom.is_empty() && !locked && !furniture:
        ClearBuckets()
        FillBuckets()
        GenerateLoot()

    if !custom.is_empty() && !force:
        table = custom.pick_random()
        ClearBuckets()
        FillBucketsCustom()
        GenerateLoot()

    if !custom.is_empty() && force:
        table = custom.pick_random()
        for index in table.items.size():
            CreateLoot(table.items[index])

    if stash:
        if randi_range(0, 100) >= containerJokerChanceData.specialCrateChance:
            process_mode = ProcessMode.PROCESS_MODE_DISABLED
            hide()

func GenerateLoot() -> void:
    rarityRoll = randi_range(1, 100)

    if !joker && rarityRoll <= containerJokerChanceData.jokerChance:
        joker = true

    if joker: rarityRoll = 100
    if corpse: rarityRoll = randi_range(1, 30)

    if rarityRoll == 1:
        if legendaryBucket.size() != 0 && randi_range(1, 10) == 1:
            for pick in 1:
                CreateLoot(legendaryBucket.pick_random())
    elif rarityRoll <= 5:
        if rareBucket.size() != 0:
            for pick in randi_range(0, 1):
                CreateLoot(rareBucket.pick_random())
    elif rarityRoll <= 25:
        if commonBucket.size() != 0:
            for pick in randi_range(0, 4):
                CreateLoot(commonBucket.pick_random())
    elif rarityRoll == 100:
        if legendaryBucket.size() != 0 && randi_range(1, 10) == 1:
            for pick in 1:
                CreateLoot(legendaryBucket.pick_random())
        if rareBucket.size() != 0:
            for pick in randi_range(1, 2):
                CreateLoot(rareBucket.pick_random())
        if commonBucket.size() != 0:
            for pick in randi_range(4, 10):
                CreateLoot(commonBucket.pick_random())
