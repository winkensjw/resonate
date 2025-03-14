# Resonate Adapter
extends Node

const SAVE_ID: String = "019595c4-7e50-79d7-99d1-22c1c3c631c9"
const VERSION_ID: String = "1"

var m_master_volume_db: float = 0.0
var m_music_volume_db: float = 0.0
var m_game_volume_db: float = 0.0


func _ready() -> void:
	Events.volume_changed.connect(_on_volume_changed)
	add_to_group("persistable")
	load_data()


func get_master_volume_db() -> float:
	return m_master_volume_db


func set_master_volume_db(master_volume_db: float) -> void:
	m_master_volume_db = master_volume_db
	MusicManager.set_volume(calc_music_volume_db())
	Log.debug("Master volume adjusted to: " + str(master_volume_db))


func get_music_volume_db() -> float:
	return m_music_volume_db


func set_music_volume_db(music_volume_db: float) -> void:
	m_music_volume_db = music_volume_db
	MusicManager.set_volume(calc_music_volume_db())
	Log.debug("Music volume adjusted to: " + str(m_music_volume_db))


func calc_music_volume_db() -> float:
	return minf(m_master_volume_db, m_music_volume_db)


func get_game_volume_db() -> float:
	return m_game_volume_db


func set_game_volume_db(game_volume_db: float) -> void:
	m_game_volume_db = game_volume_db
	Log.debug("Game volume adjusted to: " + str(m_game_volume_db))


func calc_game_volume_db() -> float:
	return minf(m_master_volume_db, m_game_volume_db)


func _on_volume_changed(property_name: String, value: float) -> void:
	match property_name:
		"master":
			set_master_volume_db(value)
		"music":
			set_music_volume_db(value)
		"game":
			set_game_volume_db(value)


func get_volume_db(property_name: String) -> float:
	match property_name:
		"master":
			return get_master_volume_db()
		"music":
			return get_music_volume_db()
		"game":
			return get_game_volume_db()
	return 0.0


######################
# Saving and Loading #
######################


func get_save_id() -> String:
	return SAVE_ID


func save_data() -> Dictionary:
	return {"version_id": VERSION_ID, "master_volume_db": m_master_volume_db, "music_volume_db": m_music_volume_db, "game_volume_db": m_game_volume_db}


func load_data() -> void:
	var data: Dictionary = SaveManager.get_data(get_save_id())
	set_master_volume_db(data.get("master_volume_db", 1.0))
	set_music_volume_db(data.get("music_volume_db", 1.0))
	set_game_volume_db(data.get("game_volume_db", 1.0))
