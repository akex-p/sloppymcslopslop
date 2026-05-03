extends Node

enum Step {
	
	RADIO,
	PILL,
	WINDOW, 
	FISH_TANK, 
	BED 
}

@export var interactables: Dictionary[int, Interactable]

@onready var animation_player_overlay: AnimationPlayer = $Overlay/AnimationPlayer
@onready var player: Player = $Objects/Player
@onready var audio_player_wakeup: AudioStreamPlayer = $Node/AudioPlayerWakeup

var ad_played: bool = false
var current_step: int = Step.RADIO

func _ready() -> void:
	player.wake_up.connect(wake_up)
	animation_player_overlay.play("fade_label")

func _unhandled_input(event):
	if event.is_action_pressed("interact"):
		$Commercial/VideoStreamPlayer.stop()
		_on_video_stream_player_finished()

func register(step: int, node: Interactable) -> void:
	interactables[step] = node

func advance_step() -> void:
	current_step += 1
	_enable_current()

func _enable_current() -> void:
	for step in interactables:
		interactables[step].enabled = (step == current_step)

func wake_up():
	if not ad_played: return
	audio_player_wakeup.play()
	player.awake = true
	animation_player_overlay.play("fade")
	await get_tree().create_timer(2.6).timeout
	$Objects/Player/HUD.visible = true
	Dialogic.start("first_day") 

func go_to_sleep():
	player.awake = false
	animation_player_overlay.play_backwards("fade")

func _on_video_stream_player_finished() -> void:
	ad_played = true
	$Commercial.visible = false
