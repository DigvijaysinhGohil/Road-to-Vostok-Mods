extends Node

func _ready() -> void:
    OverrideScript("Character.gd")
    queue_free()

func OverrideScript(modScriptName: String) -> void:
    var script = load(get_script().resource_path.get_base_dir().path_join(modScriptName))
    script.reload()
    var parentScript = script.get_base_script()
    script.take_over_path(parentScript.resource_path)
