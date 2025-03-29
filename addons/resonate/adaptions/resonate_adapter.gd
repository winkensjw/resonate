# =============================================================================
# ResonateAdapter
# =============================================================================
# This script provides an adapter layer between the game and the Resonate audio
# management system. It allows for easier integration and customization of the
# audio functionality within the game.
#
# @author winkensjw
# @version 1.0
# =============================================================================

extends Node

## Logger instance for this class.
## It is initialized with the name of this script's class.
var _log: Log = Log.new("ResonateAdapter")


## Called when the node is initialized.
func _ready() -> void:
	Events.connect("settings_changed", _on_settings_changed)


## Called when the game's settings have changed.
func _on_settings_changed() -> void:
	_log.debug("Settings changed, updating volume")
	update_volume()


## Calculates the music volume in decibels.
## @return The music volume in decibels.
func calc_music_volume_db() -> float:
	return minf(Globals.get_master_volume_db(), Globals.get_music_volume_db())


## Calculates the game volume in decibels.
## @return The game volume in decibels.
func calc_game_volume_db() -> float:
	return minf(Globals.get_master_volume_db(), Globals.get_game_volume_db())


## Updates the volume based on the game's settings.
func update_volume() -> void:
	var volume = calc_music_volume_db()
	MusicManager.set_volume(volume)


## Plays a music track from a specified bank.
## @param bank_name The name of the music bank to play from.
## @param track_name The name of the music track to play.
func play_music(bank_name: String, track_name: String) -> void:
	_log.debug("Playing music track '%s' from bank '%s'" % [track_name, bank_name])
	MusicManager.play(bank_name, track_name)


## Plays a sound effect from a specified bank.
## @param bank_name The name of the sound bank to play from.
## @param track_name The name of the sound effect to play.
func play_sound(bank_name: String, track_name: String) -> void:
	play_sound_at_volume(bank_name, track_name, calc_game_volume_db())


## Plays a sound effect from a specified bank at a specified volume.
## @param bank_name The name of the sound bank to play from.
## @param track_name The name of the sound effect to play.
## @param volume The volume to play the sound effect at.
func play_sound_at_volume(bank_name: String, track_name: String, volume: float) -> void:
	_log.debug("Playing sound effect '%s' from bank '%s' at volume %f dB" % [track_name, bank_name, volume])
	SoundManager.play_varied(bank_name, track_name, 1.0, volume, "")
