extends Node

var eh_settings = preload("res://mods/EventHints/EH_Settings.tres")
var McmHelpers = load("res://ModConfigurationMenu/Scripts/Doink Oink/MCM_Helpers.tres")
var MCMNotInstalledUI = preload("res://ModConfigurationMenu/UI/mcm_not_installed.tscn")

const MOD_ID = "EventHints"
const FILE_PATH = "user://MCM/EventHints"

func _ready():
    var _config = ConfigFile.new()
    _config.set_value("Bool", "eh_show_police", {
        "name" = "Show Punisher Hint",
        "tooltip" = "Show hint when punisher event is active on map. (delayed)",
        "default" = true,
        "value" = true
    })
    _config.set_value("Bool", "eh_show_airdrop", {
        "name" = "Show Airdrop Hint",
        "tooltip" = "Show hint when airdrop event is active on map. (delayed)",
        "default" = true,
        "value" = true
    })
    _config.set_value("Bool", "eh_show_crashsite", {
        "name" = "Show Crash Sites Hint",
        "tooltip" = "Show hint when crash sites event is active on map. (instant)",
        "default" = true,
        "value" = true
    })
    _config.set_value("Bool", "eh_show_btr", {
        "name" = "Show BTR Hint",
        "tooltip" = "Show hints when BTR event is active on map. (delayed)",
        "default" = true,
        "value" = true
    })
    _config.set_value("Bool", "eh_show_fighterjet", {
        "name" = "Show Fighter Jet Hint",
        "tooltip" = "Show hints when Fighter Jets event is active on map. (delayed)",
        "default" = false,
        "value" = false
    })
    _config.set_value("Bool", "eh_show_helicopter", {
        "name" = "Show Attack Helicopter Hint",
        "tooltip" = "Show hints when Attack Helicopter event is active on map. (delayed)",
        "default" = false,
        "value" = false
    })
    _config.set_value("Int", "eh_chance_police", {
        "name" = "% Chance Punisher",
        "tooltip" = "Chance of punisher event \"succeding\"",
        "default" = 10,
        "value" = 10,
        "minRange" = 0,
        "maxRange" = 100
    })
    _config.set_value("Int", "eh_chance_airdrop", {
        "name" = "% Chance Airdrop",
        "tooltip" = "Chance of airdrop event \"succeding\"",
        "default" = 10,
        "value" = 10,
        "minRange" = 0,
        "maxRange" = 100
    })
    _config.set_value("Int", "eh_chance_crashsite", {
        "name" = "% Chance Crash Sites",
        "tooltip" = "Chance of crash site event \"succeding\"",
        "default" = 10,
        "value" = 10,
        "minRange" = 0,
        "maxRange" = 100
    })
    _config.set_value("Int", "eh_chance_btr", {
        "name" = "% Chance BTR",
        "tooltip" = "Chance of BTR event \"succeding\"",
        "default" = 25,
        "value" = 25,
        "minRange" = 0,
        "maxRange" = 100
    })
    _config.set_value("Int", "eh_chance_fighterjet", {
        "name" = "% Chance Fighter Jet",
        "tooltip" = "Chance of fighter jet event \"succeding\"",
        "default" = 25,
        "value" = 25,
        "minRange" = 0,
        "maxRange" = 100
    })
    _config.set_value("Int", "eh_chance_helicopter", {
        "name" = "% Chance Attack Helicopter",
        "tooltip" = "Chance of attack helicopter event \"succeding\"",
        "default" = 25,
        "value" = 25,
        "minRange" = 0,
        "maxRange" = 100
    })
    _config.set_value("Int", "eh_max_wait", {
        "name" = "Max wait time (seconds, non-instant events)",
        "tooltip" = "Max wait time in seconds before non-instant events occur.",
        "default" = 300,
        "value" = 300,
        "minRange" = 60,
        "maxRange" = 600
    })
    _config.set_value("Bool", "fix_game_percent", {
        "name" = "Fix in-game percentage chance",
        "tooltip" = "Overrides this settings and fixes percentage chance with in-game description.",
        "default" = false,
        "value" = false
    })

    if McmHelpers:
        if !FileAccess.file_exists(FILE_PATH + "/config.ini"):
            DirAccess.open("user://").make_dir(FILE_PATH)
            _config.save(FILE_PATH + "/config.ini")
        else:
            McmHelpers.CheckConfigurationHasUpdated(MOD_ID, _config, FILE_PATH + "/config.ini")
            _config.load(FILE_PATH + "/config.ini")

        McmHelpers.RegisterConfiguration(
            MOD_ID,
            "Event Hints",
            FILE_PATH,
            "Event Hints displays short hints at area load-in that indicates what events are active for that session.",
            {
                "config.ini" = UpdateConfigProperties
            }
        )

func UpdateConfigProperties(_config : ConfigFile):
    eh_settings.show_police = _config.get_value("Bool", "eh_show_police")["value"]
    eh_settings.show_airdrop = _config.get_value("Bool", "eh_show_airdrop")["value"]
    eh_settings.show_crashsite = _config.get_value("Bool", "eh_show_crashsite")["value"]
    eh_settings.show_btr = _config.get_value("Bool", "eh_show_btr")["value"]
    eh_settings.show_fighterjet = _config.get_value("Bool", "eh_show_fighterjet")["value"]
    eh_settings.show_helicopter = _config.get_value("Bool", "eh_show_helicopter")["value"]
    eh_settings.chance_police = _config.get_value("Int", "eh_chance_police")["value"]
    eh_settings.chance_airdrop = _config.get_value("Int", "eh_chance_airdrop")["value"]
    eh_settings.chance_crashsite = _config.get_value("Int", "eh_chance_crashsite")["value"]
    eh_settings.chance_btr = _config.get_value("Int", "eh_chance_btr")["value"]
    eh_settings.chance_fighterjet = _config.get_value("Int", "eh_chance_fighterjet")["value"]
    eh_settings.chance_helicopter = _config.get_value("Int", "eh_chance_helicopter")["value"]
    eh_settings.max_wait = _config.get_value("Int", "eh_max_wait")["value"]
    eh_settings.fix_game_percent = _config.get_value("Bool", "fix_game_percent")["value"]
