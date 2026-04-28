extends Node

const MCM_HELPERS_PATH := "res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres"
const MCM_MOD_ID = "ContainerJokerChance"
const MCM_MOD_NAME = "Container Joker Chance"
const MCM_MOD_DESC = "Customizable special crate spawn chance and container joker chance."
const MCM_FILE_PATH = "user://MCM/ContainerJokerChance"
const CONTAINER_JOKER_CHANCE_DATA_PATH = "ContainerJokerChanceData.tres"

var McmHelpers = null
var containerJokerChanceData = null

func _ready() -> void:
    containerJokerChanceData = load(get_script().resource_path.get_base_dir().path_join(CONTAINER_JOKER_CHANCE_DATA_PATH))
    OverrideScript("LootContainer.gd")
    McmHelpers = TryToLoadMCM()
    if McmHelpers:
        RegisterToMCM()

func OverrideScript(modScriptName: String) -> void:
    var script = load(get_script().resource_path.get_base_dir().path_join(modScriptName))
    script.reload()
    var parentScript = script.get_base_script()
    script.take_over_path(parentScript.resource_path)

func TryToLoadMCM() -> Object:
    if ResourceLoader.exists(MCM_HELPERS_PATH):
        return load(MCM_HELPERS_PATH)
    return null

func BuildMCMConfig() -> ConfigFile:
    var config = ConfigFile.new()
    config.set_value("Int", "jokerChance", {
        "name" = "Joker Chance",
        "tooltip" = "Chance a Container rolls Joker.",
        "default" = 1,
        "value" = 1,
        "step" = 1,
        "minRange" = 1,
        "maxRange" = 100
    })
    config.set_value("Int", "specialCrateChance", {
        "name" = "Special Crate Spawn Chance",
        "tooltip" = "Chance a Special Crate spawns.",
        "default" = 10,
        "value" = 10,
        "step" = 1,
        "minRange" = 0,
        "maxRange" = 100
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
        OnMCMSave(cfg)

    if McmHelpers:
        McmHelpers.RegisterConfiguration(
            MCM_MOD_ID,
            MCM_MOD_NAME,
            MCM_FILE_PATH,
            MCM_MOD_DESC,
            {"config.ini": OnMCMSave}
        )

func OnMCMSave(config: ConfigFile) -> void:
    containerJokerChanceData.jokerChance = config.get_value("Int", "jokerChance")["value"]
    containerJokerChanceData.specialCrateChance = config.get_value("Int", "specialCrateChance")["value"]
