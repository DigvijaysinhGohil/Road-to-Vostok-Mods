extends Node

var ASSAULT_RIFLES: Array[String] = [
    "res://Items/Weapons/AK-12/AK-12.tres",
    "res://Items/Weapons/AKM/AKM.tres",
    "res://Items/Weapons/AKS-74U/AKS-74U.tres",
    "res://Items/Weapons/HK416/HK416.tres",
    "res://Items/Weapons/M4A1/M4A1.tres",
    "res://Items/Weapons/MK18/MK18.tres",
    "res://Items/Weapons/KAR-21/KAR-21_223.tres",
    "res://Items/Weapons/KAR-21/KAR-21_308.tres",
    "res://Items/Weapons/Remington_870/Remington_870.tres",
    "res://Items/Weapons/RK-62/RK-62.tres",
    "res://Items/Weapons/RK-62/RK-62M.tres",
    "res://Items/Weapons/RK-95/RK-95.tres"
]

func _ready() -> void:
    update_rifles()

func update_rifles() -> void:
    for ar_path in ASSAULT_RIFLES:
        var ar = load(ar_path)
        if ar:
            if "slots" in ar:
                ar.slots = ["Primary", "Secondary"] as Array[String]
