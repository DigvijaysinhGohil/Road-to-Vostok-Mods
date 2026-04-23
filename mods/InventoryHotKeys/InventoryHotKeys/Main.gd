class_name InventoryHotKeysMain extends Node

const MCM_HELPERS_PATH := "res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres"
const MCM_MOD_ID = "InventoryHotKeys"
const MCM_FILE_PATH = "user://MCM/InventoryHotKeys"
const HOT_KEYS_DATA_PATH = "InvetoryHotKeysData.tres"

var McmHelpers = null
var inventoryHotKeys

func _ready() -> void:
    inventoryHotKeys = load(get_script().resource_path.get_base_dir().path_join(HOT_KEYS_DATA_PATH))

    var interfaceScript = load(get_script().resource_path.get_base_dir().path_join("Interface.gd"))
    interfaceScript.reload()
    var parentScript = interfaceScript.get_base_script()
    interfaceScript.take_over_path(parentScript.resource_path)
    McmHelpers = TryToLoadMCM()
    if McmHelpers:
        RegisterToMCM()

    AddInputActions()

func TryToLoadMCM() -> Object:
    if ResourceLoader.exists(MCM_HELPERS_PATH):
        return load(MCM_HELPERS_PATH)
    return null

func BuildMCMConfig() -> ConfigFile:
    var config = ConfigFile.new()
    config.set_value("Dropdown", "unloadDropdown", {
        "name" = "Unload Mag Modifier Key",
        "tooltip" = "Hold this key while pressing the unload mag key to trigger an Unload Mag. None to trigger with only unload mag key.",
        "default" = 2,
        "value" = 2,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 1
    })

    config.set_value("Keycode", "unloadKeyCode", {
        "name" = "Unload Mag Keycode",
        "tooltip" = "A key to unload Mag.",
        "default" = KEY_R,
        "default_type" = "Key",
        "value" = KEY_R,
        "type" = "Key",
        "menu_pos" = 2
    })

    config.set_value("Dropdown", "removeMagDropdown", {
        "name" = "Remove Mag Modifier Key",
        "tooltip" = "Hold this key while pressing the remove mag key to trigger Remove Mag. None to trigger with only remove mag key.",
        "default" = 1,
        "value" = 1,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 3
    })

    config.set_value("Keycode", "removeMagKeyCode", {
        "name" = "Remove Mag Keycode",
        "tooltip" = "A key to Remove Mag.",
        "default" = KEY_R,
        "default_type" = "Key",
        "value" = KEY_R,
        "type" = "Key",
        "menu_pos" = 4
    })

    config.set_value("Dropdown", "removeOpticDropdown", {
        "name" = "Remove Optic Modifier Key",
        "tooltip" = "Hold this key while pressing the remove optic key to trigger Remove Optic. None to trigger with only remove optic key.",
        "default" = 1,
        "value" = 1,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 5
    })

    config.set_value("Keycode", "removeOpticKeyCode", {
        "name" = "Remove Optic Keycode",
        "tooltip" = "A key to Remove Optic Sight.",
        "default" = KEY_F,
        "default_type" = "Key",
        "value" = KEY_F,
        "type" = "Key",
        "menu_pos" = 6
    })

    config.set_value("Dropdown", "removeLaserDropdown", {
        "name" = "Remove Laser Modifier Key",
        "tooltip" = "Hold this key while pressing the remove laser key to trigger Remove Laser. None to trigger with only remove laser key.",
        "default" = 1,
        "value" = 1,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 7
    })

    config.set_value("Keycode", "removeLaserKeyCode", {
        "name" = "Remove Laser Keycode",
        "tooltip" = "A key to Remove Laser.",
        "default" = KEY_T,
        "default_type" = "Key",
        "value" = KEY_T,
        "type" = "Key",
        "menu_pos" = 8
    })

    config.set_value("Dropdown", "removeMuzzleDropdown", {
        "name" = "Remove Muzzle Modifier Key",
        "tooltip" = "Hold this key while pressing the remove muzzle key to trigger Remove Muzzle. None to trigger with only remove muzzle key.",
        "default" = 2,
        "value" = 2,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 9
    })

    config.set_value("Keycode", "removeMuzzleKeyCode", {
        "name" = "Remove Muzzle Keycode",
        "tooltip" = "A key to Remove Muzzle.",
        "default" = KEY_F,
        "default_type" = "Key",
        "value" = KEY_F,
        "type" = "Key",
        "menu_pos" = 10
    })

    config.set_value("Dropdown", "splitDropdown", {
        "name" = "Spite item Modifier Key",
        "tooltip" = "Hold this key while pressing the split key to trigger the split. None to trigger with only split key.",
        "default" = 1,
        "value" = 1,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 11
    })

    config.set_value("Keycode", "splitKeyCode", {
        "name" = "Split Keycode",
        "tooltip" = "A key to split stackable items.",
        "default" = KEY_S,
        "default_type" = "Key",
        "value" = KEY_S,
        "type" = "Key",
        "menu_pos" = 12
    })

    config.set_value("Dropdown", "takeDropdown", {
        "name" = "Take Modifier Key",
        "tooltip" = "Hold this key while pressing the take key to trigger Take x amount. None to trigger with only take key.",
        "default" = 2,
        "value" = 2,
        "options" = ["NONE", "SHIFT", "ALT", "CTRL"],
        "menu_pos" = 13
    })

    config.set_value("Keycode", "takeKeyCode", {
        "name" = "Take x Amount Keycode",
        "tooltip" = "A key to take x amount from stackable items.",
        "default" = KEY_S,
        "default_type" = "Key",
        "value" = KEY_S,
        "type" = "Key",
        "menu_pos" = 14
    })

    return config

func RegisterToMCM() -> void:
    var cfg := BuildMCMConfig()

    if !FileAccess.file_exists(MCM_FILE_PATH + "/config.ini"):
        DirAccess.open("user://").make_dir_recursive(MCM_FILE_PATH)
        cfg.save(MCM_FILE_PATH + "/config.ini")
    else:
        if McmHelpers:
            McmHelpers.CheckConfigurationHasUpdated(MCM_MOD_ID, cfg, MCM_FILE_PATH + "/config.ini")
        cfg.load(MCM_FILE_PATH + "/config.ini")
        ApplyToGame(cfg)

    if McmHelpers:
        McmHelpers.RegisterConfiguration(
            MCM_MOD_ID,
            "Inventory Hot Keys",
            MCM_FILE_PATH,
            "Hot Keys for Inventory Remove mag, Unload, Split and Take(x) options.",
            {"config.ini": OnMCMSave}
        )

func OnMCMSave(config: ConfigFile) -> void:
    ApplyToGame(config)

func ApplyToGame(config: ConfigFile) -> void:
    inventoryHotKeys.unloadModifierKey = config.get_value("Dropdown", "unloadDropdown")["value"]
    inventoryHotKeys.unloadKey = int(config.get_value("Keycode", "unloadKeyCode")["value"])
    inventoryHotKeys.RemoveMagModifierKey = config.get_value("Dropdown", "removeMagDropdown")["value"]
    inventoryHotKeys.removeMagKeyKey = int(config.get_value("Keycode", "removeMagKeyCode")["value"])
    inventoryHotKeys.unloadModifierKey = config.get_value("Dropdown", "splitDropdown")["value"]
    inventoryHotKeys.unloadKey = int(config.get_value("Keycode", "splitKeyCode")["value"])
    inventoryHotKeys.unloadModifierKey = config.get_value("Dropdown", "takeDropdown")["value"]
    inventoryHotKeys.unloadKey = int(config.get_value("Keycode", "takeKeyCode")["value"])

    AddInputActions()

func AddInputActions() -> void:
    DefineInputActions(inventoryHotKeys.UNLOAD_MAG_ACTION, inventoryHotKeys.unloadKey as Key)
    DefineInputActions(inventoryHotKeys.REMOVE_MAG_ACTION, inventoryHotKeys.removeMagKey as Key)
    DefineInputActions(inventoryHotKeys.REMOVE_OPTIC_ACTION, inventoryHotKeys.removeOpticKey as Key)
    DefineInputActions(inventoryHotKeys.REMOVE_LASER_ACTION, inventoryHotKeys.removeLaserKey as Key)
    DefineInputActions(inventoryHotKeys.REMOVE_MUZZLE_ACTION, inventoryHotKeys.removeMuzzleKey as Key)
    DefineInputActions(inventoryHotKeys.SPLIT_ACTION, inventoryHotKeys.splitKey as Key)
    DefineInputActions(inventoryHotKeys.TAKE_ACTION, inventoryHotKeys.takeKey as Key)

func DefineInputActions(actionName: String, actionKey: Key) -> void:
    if InputMap.has_action(actionName):
        InputMap.erase_action(actionName)

    InputMap.add_action(actionName)
    print("Action added: %s, on Key: %s" % [actionName, actionKey])

    var event = InputEventKey.new()
    event.keycode = actionKey
    InputMap.action_add_event(actionName, event)
