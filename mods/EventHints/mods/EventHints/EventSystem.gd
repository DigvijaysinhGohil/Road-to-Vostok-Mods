# mods/EventHints/EventSystem.gd
extends "res://Scripts/EventSystem.gd"

var EHUI = preload("res://mods/EventHints/EventHintsUI.tscn")
var eh_settings = preload("res://mods/EventHints/EH_Settings.tres")

func _ready() -> void:
    super()

func ShowEventHint(s : String):
    print("EventHints: " + s)
    var ui = EHUI.instantiate()
    ui.SetText(s)
    add_child(ui)

func ActivateDynamicEvent():
    if dynamicEvents.size() != 0:
        var event = dynamicEvents.pick_random()
        var eventRoll = randi_range(0, 100)
        var chance : int = 0
        var fixGamePercent: bool = eh_settings.fix_game_percent

        if fixGamePercent:
            dynamicEvents.shuffle()
            event = null
            for singleEvent in dynamicEvents:
                chance += singleEvent.possibility
                if eventRoll < chance:
                    event = singleEvent
                    break

            if !event: return

            match event.function:
                "Police": if eh_settings.show_police: ShowEventHint("You can hear distant police sirens...")
                "Airdrop": if eh_settings.show_airdrop: ShowEventHint("[RADIO] ... .. -..- SUPPLIES INBOUND ... . ...- . -.")
                "CrashSite": if eh_settings.show_crashsite: ShowEventHint("There's a smell of burnt electronics and rubber in the air...")
                "BTR": if eh_settings.show_btr: ShowEventHint("[RADIO] ALL MOBILE UNITS ... *STATIC* ... SECURE PERIMETER.")
                "FighterJet": if eh_settings.show_fighterjet: ShowEventHint("You can hear the rumbling of jet engines...")
                "Helicopter": if eh_settings.show_helicopter: ShowEventHint("[RADIO] ALL AERIAL UNITS ... *STATIC* SECURE THE AREA ...")

            if event.instant:
                var eventFunction = Callable(self, event.function)
                eventFunction.call()

            else:
                var eventDelay = randi_range(eh_settings.min_wait, eh_settings.max_wait)
                await get_tree().create_timer(eventDelay, false).timeout;
                var eventFunction = Callable(self, event.function)
                eventFunction.call()

        else:
            match event.function:
                "Police": chance = eh_settings.chance_police
                "Airdrop": chance = eh_settings.chance_airdrop
                "CrashSite": chance = eh_settings.chance_crashsite
                "BTR": chance = eh_settings.chance_btr
                "FighterJet": chance = eh_settings.chance_fighterjet
                "Helicopter": chance = eh_settings.chance_helicopter

            if eventRoll <= chance:

                match event.function:
                    "Police": if eh_settings.show_police: ShowEventHint("You can hear distant police sirens...")
                    "Airdrop": if eh_settings.show_airdrop: ShowEventHint("[RADIO] ... .. -..- SUPPLIES INBOUND ... . ...- . -.")
                    "CrashSite": if eh_settings.show_crashsite: ShowEventHint("There's a smell of burnt electronics and rubber in the air...")
                    "BTR": if eh_settings.show_btr: ShowEventHint("[RADIO] ALL MOBILE UNITS ... *STATIC* ... SECURE PERIMETER.")
                    "FighterJet": if eh_settings.show_fighterjet: ShowEventHint("You can hear the rumbling of jet engines...")
                    "Helicopter": if eh_settings.show_helicopter: ShowEventHint("[RADIO] ALL AERIAL UNITS ... *STATIC* SECURE THE AREA ...")

                if event.instant:
                    print("Event Activated (Dynamic): " + event.name)
                    var eventFunction = Callable(self, event.function)
                    eventFunction.call()

                else:
                    var eventDelay = randi_range(0, eh_settings.max_wait)
                    var minutes = floor(eventDelay / 60.0)
                    var seconds = eventDelay % 60
                    print("Event Activated (Dynamic): " + event.name + " | " + "Delay: " + "%02d:%02d" % [minutes, seconds])
                    await get_tree().create_timer(eventDelay, false).timeout;
                    var eventFunction = Callable(self, event.function)
                    eventFunction.call()
