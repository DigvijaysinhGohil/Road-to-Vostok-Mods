extends Control

func SetText(s_ : String):
    %Label.text = s_
    
func _ready() -> void:
    %Label.visible_ratio = 0.0
    var tween = get_tree().create_tween()
    tween.tween_property(%Label, "visible_ratio", 1.0, 1.0)
    tween.tween_interval(3)
    tween.tween_property(%Label, "visible_ratio", 0.0, 1.0)
    await tween.finished
    queue_free()
    
