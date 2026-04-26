extends Node

var SNIPER_RIFLES: Array[String] = [
    "res://Items/Weapons/M78/M78.tres",
    "res://Items/Weapons/Mosin/Mosin.tres",
    "res://Items/Weapons/SVD/SVD.tres",
    "res://Items/Weapons/VSS/VSS.tres"
]

func _ready() -> void:
    UpdateSniperRifleStats()
    queue_free()

func UpdateSniperRifleStats() -> void:
    for sniperPath in SNIPER_RIFLES:
        var sniper = load(sniperPath)
        var rifleName: String = sniper.file
        match rifleName:
            "M78":
                sniper.damage = 60
                sniper.penetration = 4
            "Mosin":
                sniper.damage = 80
                sniper.penetration = 4
            "SVD":
                sniper.damage = 100
                sniper.penetration = 5
            "VSS":
                sniper.damage = 40
                sniper.penetration = 3
