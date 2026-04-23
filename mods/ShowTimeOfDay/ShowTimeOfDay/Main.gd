extends Node

const MCM_HELPERS_PATH := "res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres"
const MCM_MOD_ID = "ShowTimeOfDay"
const MCM_FILE_PATH = "user://MCM/ShowTimeOfDay"
const TIME_FORMAT_PATH = "TimeFormat.tres"

var McmHelpers = null
var timeFormat

func _ready() -> void:
    timeFormat = load(get_script().resource_path.get_base_dir().path_join(TIME_FORMAT_PATH))
    var hudScript = load(get_script().resource_path.get_base_dir().path_join("HUD.gd"))
    hudScript.reload()
    var parentScript = hudScript.get_base_script()
    hudScript.take_over_path(parentScript.resource_path)
    McmHelpers = TryToLoadMCM()
    if McmHelpers:
        RegisterToMCM()

func TryToLoadMCM() -> Object:
    if ResourceLoader.exists(MCM_HELPERS_PATH):
        return load(MCM_HELPERS_PATH)
    return null

func BuildMCMConfig() -> ConfigFile:
    var config = ConfigFile.new()
    config.set_value("Bool", "twelveHourFormat", {
        "name" = "12-Hour Format",
        "tooltip" = "Whether you wish to display time in 12-Hour format.",
        "default" = true,
        "value" = true
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
            "Show Time of the Day",
            MCM_FILE_PATH,
            "Displays in-game time besides the area name, when alarm clock is equipped.",
            {"config.ini": OnMCMSave}
        )

func OnMCMSave(config: ConfigFile) -> void:
    ApplyToGame(config)

func ApplyToGame(config: ConfigFile) -> void:
    timeFormat.twelveHour = config.get_value("Bool", "twelveHourFormat")["value"]
