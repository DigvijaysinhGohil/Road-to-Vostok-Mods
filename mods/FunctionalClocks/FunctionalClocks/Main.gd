extends Node

const ALARM_CLOCK_ORIGINAL_MAT_PATH = "res://Items/Electronics/Alarm_Clock/Files/MT_Alarm_Clock.tres"
const SCHOOL_CLOCK_ORIGINAL_MAT_PATH = "res://Assets/Clock_School/Files/MT_Clock_School.tres"

const ALARM_CLOCK_MODDED_SHADER_PATH = "Clock.gdshader"
const ALARM_CLOCK_MODDED_TEX_PATH = "AlarmClock/Tex_AClock_AL.jpg"
const SCHOOL_CLOCK_MODDED_TEX_PATH = "SchoolClock/Tex_Clock_School_AL.jpg"

var alarmClockMat: ShaderMaterial
var schoolClockMat: ShaderMaterial

func _ready() -> void:
    alarmClockMat = load(ALARM_CLOCK_ORIGINAL_MAT_PATH)
    schoolClockMat = load(SCHOOL_CLOCK_ORIGINAL_MAT_PATH)

    var shader: Shader = load(get_script().resource_path.get_base_dir().path_join(ALARM_CLOCK_MODDED_SHADER_PATH))
    alarmClockMat.shader = shader
    schoolClockMat.shader = shader

    var aClockImage = Image.load_from_file(get_script().resource_path.get_base_dir().path_join(ALARM_CLOCK_MODDED_TEX_PATH))
    var aClockTex = ImageTexture.create_from_image(aClockImage)
    var schoolClockImage = Image.load_from_file(get_script().resource_path.get_base_dir().path_join(SCHOOL_CLOCK_MODDED_TEX_PATH))
    var schoolClockTex = ImageTexture.create_from_image(schoolClockImage)

    alarmClockMat.set_shader_parameter("pivot", Vector2(.267, .272))
    alarmClockMat.set_shader_parameter("handThickness", .004)
    alarmClockMat.set_shader_parameter("albedo", aClockTex)

    schoolClockMat.set_shader_parameter("pivot", Vector2(.281, .3))
    schoolClockMat.set_shader_parameter("handLength", .12)
    schoolClockMat.set_shader_parameter("albedo", schoolClockTex)

func _physics_process(_delta: float) -> void:
    if Engine.get_physics_frames() % 300 == 0:
        var minutes = GetGameTimeInMinutes()
        alarmClockMat.set_shader_parameter("minutes", minutes)
        schoolClockMat.set_shader_parameter("minutes", minutes)

func GetGameTimeInMinutes() -> int:
    var time: float = int(Simulation.time) * 0.01
    var hours: int = floori(time)
    var minutesRaw = int(Simulation.time) % 100
    var minutes = int(floor(float(minutesRaw) / 5.0) * 5)

    if minutes >= 60:
        minutes = 0
        hours += 1

    hours = hours % 24
    return (hours * 60) + minutes
