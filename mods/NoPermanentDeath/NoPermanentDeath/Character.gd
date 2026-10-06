extends "res://Scripts/Character.gd"

func Death():
    PlayDeath()
    audio.breathing.stop()
    audio.heartbeat.stop()
    gameData.health = 0
    gameData.isDead = true
    gameData.freeze = true
    rigManager.ClearRig()

    if !gameData.shelter && !gameData.tutorial:
        Loader.SaveWorld()
        Loader.ResetCharacter()
        Loader.LoadScene("Death")

    elif gameData.shelter && !gameData.tutorial:
        var map = get_tree().current_scene.get_node("/root/Map")
        Loader.SaveWorld()
        Loader.SaveShelter(map.mapName)
        Loader.ResetCharacter()
        Loader.LoadScene("Death")

    elif gameData.tutorial:
        Loader.LoadScene("Menu")
