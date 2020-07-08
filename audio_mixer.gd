extends Node2D

var next_song = null
var fading_out = false
var fading_in = false
var hard_switch = false

var vol_off = -60.0
var vol_std = -15.0

export var seconds_btw_songs = 2.5
export var fade_range = 3.0
export var fade_interval = 15.0
export var fade_hard_interval = 100.0

signal fadeout_finished

func _ready():
	$bgm_timer.wait_time = seconds_btw_songs
	$bgm_streamer.volume_db = vol_off

func _process(delta):
	check_for_fadeout()
	if fading_out:
		fadeout_song(delta)
	if fading_in:
		fadein_song(delta)

func play_song(song):
	print("audio_mixer.gd: received new song")
	next_song = song
	if not $bgm_streamer.playing:
		fading_in = true
	else:
		hard_switch = true
		fading_out = true
	
func check_for_fadeout():
	if $bgm_streamer.stream != null and $bgm_streamer.playing:
		if($bgm_streamer.stream.get_length() - $bgm_streamer.get_playback_position()) <= fade_range:
			fading_out = true
	
func fadein_song(delta):
	if not $bgm_streamer.playing:
		$bgm_streamer.stream = next_song
		$bgm_streamer.play()
	$bgm_streamer.volume_db += fade_interval * delta
	if $bgm_streamer.volume_db >= vol_std:
		$bgm_streamer.volume_db = vol_std
		fading_in = false

func fadeout_song(delta):
	if hard_switch:
		$bgm_streamer.volume_db -= fade_hard_interval * delta
	else:
		$bgm_streamer.volume_db -= fade_interval * delta
	if $bgm_streamer.volume_db <= vol_off:
		$bgm_streamer.volume_db = vol_off
		fading_out = false
		hard_switch = false
		emit_signal("fadeout_finished")

func _on_audio_mixer_fadeout_finished():
	print("audio_mixer.gd: fadeout completed, starting bgm_timer")
	$bgm_streamer.stop()
	$bgm_timer.start()
	
func _on_bgm_timer_timeout():
	print("audio_mixer.gd: bgm_timer completed")
	$bgm_timer.stop()
	fading_in = true
	
