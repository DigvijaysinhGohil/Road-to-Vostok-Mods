# mods/EventHints/Main.gd
extends Node

func _ready():
    overrideScript("res://mods/EventHints/EventSystem.gd")
    queue_free()

func overrideScript(path: String):
    var script: Script = load(path)
    script.reload()
    var parent = script.get_base_script()
    script.take_over_path(parent.resource_path)
