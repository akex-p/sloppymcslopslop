extends Node
class_name Main

@export var day1_scene: PackedScene
@export var day2_scene: PackedScene
@export var day3_scene: PackedScene
@export var day4_scene: PackedScene

@onready var animation_player_overlay: AnimationPlayer = $Overlay/AnimationPlayer
@onready var player: Player = $Player
@onready var audio_player_wakeup: AudioStreamPlayer = $Node/AudioPlayerWakeup
@onready var container_skip: PanelContainer = $Commercial/SkipContainer
@onready var timer_skip: Timer = $Commercial/Timer
@onready var environment: Node3D = $Environment

var ad_played: bool = false
var day_node: Node3D

func _ready() -> void:
	day_node = $Environment/LightmapGI/Day1
	GameManager.main = self
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
	$Player/HUD/Misc.visible = true

func go_to_sleep():
	player.awake = false
	animation_player_overlay.play_backwards("fade")
	await animation_player_overlay.animation_finished
	
	# update game manager and player
	$Player.reset(Vector3(0.551, 0.894, 0.838), 0.0)
	
	# delete stuff
	var old = $Environment/Day
	old.queue_free()
	await old.tree_exited
	
	var new_scene: PackedScene
	match GameManager.current_day:
		1: new_scene = day1_scene
		2: new_scene = day2_scene
		3: new_scene = day3_scene
		4: new_scene = day4_scene
	
	var new_node = new_scene.instantiate()
	new_node.name = "Objects"
	environment.add_child(new_node)
	
	wake_up()

func _on_video_stream_player_finished() -> void:
	ad_played = true
	$Commercial.visible = false

func _on_timer_timeout() -> void:
	container_skip.visible = false
