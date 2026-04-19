extends "res://Scripts/HUD.gd"

@onready var equipmentUI = $"../Interface/Equipment"

#const TIME_FORMAT_PATH = "./TimeFormat.tres" # For Testing
const TIME_FORMAT_PATH = "res://ShowTimeOfDay/TimeFormat.tres"

var mapInfo: Node
var timeLabel: Label
var timeFormat

func _ready() -> void:
    timeFormat = load(TIME_FORMAT_PATH)
    super()
    mapInfo = get_tree().current_scene.get_node("/root/Map")
    CreateTimeLabel()

func _physics_process(_delta: float):
    super(_delta)

    if Engine.get_physics_frames() % 300 == 0 && !gameData.isTransitioning:
        if IsClockEquipped():
            timeLabel.text = GetTimeOfDay()
        else:
            timeLabel.text = ""

func CreateTimeLabel() -> void:
    timeLabel = map.duplicate()
    map.get_parent().add_child(timeLabel)


func IsClockEquipped() -> bool:
    var timeSlot = equipmentUI.get_child(18)
    return timeSlot.get_child_count() != 0

func GetTimeOfDay() -> String:
    var meridiem: String = " AM"
    var time: float = int(Simulation.time) * 0.01
    var hours: int = floori(time)
    var minutesRaw = int(Simulation.time) % 100
    var minutes = int(floor(float(minutesRaw) / 5.0) * 5)

    if minutes >= 60:
        minutes = 0
        hours += 1

    hours = hours % 24

    if !timeFormat.twelveHour:
        return "%02d:%02d" % [hours, minutes]

    if hours < 1:
        hours = 12
    elif hours == 12:
        meridiem = " PM"
    elif hours > 12:
        hours -= 12
        meridiem = " PM"

    return "%02d:%02d" % [hours, minutes] + meridiem
