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

var current_step: int = Step.RADIO

func _ready() -> void:
	player.wake_up.connect(wake_up)
	animation_player_overlay.play("fade_label")

func register(step: int, node: Interactable) -> void:
	interactables[step] = node

func advance_step() -> void:
	current_step += 1
	_enable_current()

func _enable_current() -> void:
	for step in interactables:
		interactables[step].enabled = (step == current_step)

func wake_up():
	audio_player_wakeup.play()
	player.awake = true
	animation_player_overlay.play("fade")
	await get_tree().create_timer(2.6).timeout
	$Objects/Player/HUD.visible = true

func go_to_sleep():
	player.awake = false
	animation_player_overlay.play_backwards("fade")
