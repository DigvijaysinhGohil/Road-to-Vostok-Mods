class_name InventoryHotKeysData extends Resource

const UNLOAD_MAG_ACTION: String = "unloadMagInventoryHotKeys"
const REMOVE_MAG_ACTION: String = "removeMagInventoryHotKeys"
const REMOVE_OPTIC_ACTION: String = "removeOpticInventoryHotKeys"
const REMOVE_LASER_ACTION: String = "removeLaserInventoryHotKeys"
const REMOVE_MUZZLE_ACTION: String = "removeMuzzleInventoryHotKeys"
const SPLIT_ACTION: String = "splitInventoryHotKeys"
const TAKE_ACTION: String = "takeInventoryHotKeys"

# 1 = Shift, 2 = Alt, 3 = Ctrl
@export var unloadModifierKey: int = 1
@export var removeMagModifierKey: int = 2
@export var removeOpticModifierKey: int = 1
@export var removeLaserModifierKey: int = 1
@export var removeMuzzleModifierKey: int = 2
@export var splitModifierKey: int = 1
@export var takeModifierKey: int = 2

@export var unloadKey: int = KEY_R
@export var removeMagKey: int = KEY_R
@export var removeOpticKey: int = KEY_F
@export var removeLaserKey: int = KEY_T
@export var removeMuzzleKey: int = KEY_F
@export var splitKey: int = KEY_S
@export var takeKey: int = KEY_S
