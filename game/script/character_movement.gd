extends CharacterBody3D
class_name Player

@export var SPEED: float = 5.0
@export var MOUSE_SENSITIVITY: float = 0.003
@export var MOVEMENT_SMOOTHING: float = 10.0
@export var CAMERA_SMOOTHING: float = 15.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var head = $Head
@onready var ray = $Head/Camera3D/RayCast3D
@onready var interact_prompt = $HUD/Misc/InteractableContainer/MarginContainer/Label
@onready var interact_container = $HUD/Misc/InteractableContainer
@onready var audio_player_steps: AudioStreamPlayer3D = $AudioPlayerSteps

var focused: bool = true
var awake: bool = false
var _target_yaw: float = 0.0
var _target_pitch: float = 0.0

signal wake_up

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	focused = true
	_target_yaw = rotation.y
	_target_pitch = head.rotation.x
	interact_container.visible = false

func _input(event):
	if event is InputEventMouseMotion and focused and awake:
		_target_yaw -= event.relative.x * MOUSE_SENSITIVITY
		_target_pitch -= event.relative.y * MOUSE_SENSITIVITY
		_target_pitch = clamp(_target_pitch, deg_to_rad(-89), deg_to_rad(89))

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		focused = false
	
	if event.is_action_pressed("interact"):
		if focused:
			_try_interact()
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			focused = true
	
	if event.is_action_pressed("ask_bob"):
		if not awake:
			wake_up.emit()
		else:
			GameManager.ask_bob()
			if $HUD/Bob/BobContainer/MarginContainer/Normal.is_playing():
				$HUD/Bob/BobContainer/MarginContainer/Normal.set_frame_and_progress(0,0.0)
			$HUD/Bob/BobContainer/MarginContainer/Normal.play("talking")
			$AudioStreamPlayer.play()

func make_bob_loading() -> void:
	$HUD/Bob/BobContainer/MarginContainer/Normal.play("loading")
	$HUD/Bob/BobContainer/MarginContainer/AnimationPlayer.play("rotating")

func _physics_process(delta):
	_update_prompt()
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var is_moving = direction.length() > 0 and focused and awake
	
	if is_moving:
		velocity.x = lerp(velocity.x, direction.x * SPEED, MOVEMENT_SMOOTHING * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, MOVEMENT_SMOOTHING * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, MOVEMENT_SMOOTHING * delta)
		velocity.z = lerp(velocity.z, 0.0, MOVEMENT_SMOOTHING * delta)
	
	_handle_headbob(is_moving)
	
	rotation.y = lerp_angle(rotation.y, _target_yaw, CAMERA_SMOOTHING * delta)
	head.rotation.x = lerp_angle(head.rotation.x, _target_pitch, CAMERA_SMOOTHING * delta)
	
	move_and_slide()

func reset(spawn_position: Vector3, spawn_yaw: float) -> void:
	global_position = spawn_position
	velocity = Vector3.ZERO
	awake = false
	focused = true
	_target_yaw = spawn_yaw
	_target_pitch = 0.0
	rotation.y = spawn_yaw
	head.rotation.x = 0.0
	animation_player.stop()

func _handle_headbob(is_moving: bool):
	if is_moving:
		if not animation_player.is_playing():
			animation_player.play("headbop")
			audio_player_steps.play()

func _try_interact() -> void:
	if not ray.is_colliding():
		return
	var hit = ray.get_collider()
	if hit is Interactable and hit.enabled and hit.player_nearby:
		hit.interact()

func _update_prompt() -> void:
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit is Interactable and hit.enabled and hit.player_nearby:
			interact_container.visible = true
			interact_prompt.text = hit.prompt_text
			interact_prompt.visible = true
			return
	interact_prompt.visible = false
	interact_container.visible = false
