extends Node

@onready var animation_player_overlay: AnimationPlayer = $Overlay/AnimationPlayer
@onready var player: Player = $Objects/Player
@onready var audio_player_wakeup: AudioStreamPlayer = $Node/AudioPlayerWakeup
@onready var container_skip: PanelContainer = $Commercial/SkipContainer
@onready var timer_skip: Timer = $Commercial/Timer

var ad_played: bool = false

func _ready() -> void:
	player.wake_up.connect(wake_up)
	animation_player_overlay.play("fade_label")

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		if container_skip.visible:
			$Commercial/VideoStreamPlayer.stop()
			_on_video_stream_player_finished()
		else:
			container_skip.visible = true
			timer_skip.start()

func wake_up():
	if not ad_played: return
	audio_player_wakeup.play()
	player.awake = true
	animation_player_overlay.play("fade")
	await get_tree().create_timer(2.6).timeout
	$Objects/Player/HUD/Misc.visible = true

func go_to_sleep():
	player.awake = false
	animation_player_overlay.play_backwards("fade")
	get_tree().reload_current_scene()

func _on_video_stream_player_finished() -> void:
	ad_played = true
	$Commercial.visible = false

func _on_timer_timeout() -> void:
	container_skip.visible = false
