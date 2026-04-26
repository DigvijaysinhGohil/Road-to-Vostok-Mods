extends Node

func _ready() -> void:
    var interfaceScript = load(get_script().resource_path.get_base_dir().path_join("Interface.gd"))
    interfaceScript.reload()
    var parentScript = interfaceScript.get_base_script()
    interfaceScript.take_over_path(parentScript.resource_path)
	queue_free()
