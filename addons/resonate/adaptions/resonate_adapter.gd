# Resonate Adapter
extends Node


func _ready() -> void:
	Events.connect("settings_changed", _on_settings_changed)


func _on_settings_changed() -> void:
	Log.debug("Settings changed, updating volume")
	update_volume()


func calc_music_volume_db() -> float:
	return minf(Globals.master_volume_db, Globals.music_volume_db)


func calc_game_volume_db() -> float:
	return minf(Globals.master_volume_db, Globals.game_volume_db)


func update_volume() -> void:
	var volume = calc_music_volume_db()
	MusicManager.set_volume(volume)
