extends CharacterBody3D

@export var SPEED: float = 5.0
@export var MOUSE_SENSITIVITY: float = 0.003

@onready var head = $Head

@onready var ray = $Head/Camera3D/RayCast3D
@onready var interact_prompt = $"/root/Main/HUD/interactable prompt"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	print("ray: ", ray)
	print("interact_prompt: ", interact_prompt)

func _unhandled_input(event):
	# Mouse look
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		head.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
	# Release mouse with Escape
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Movement
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func _process(_delta):
	check_interaction()

func check_interaction():
	if ray.is_colliding():
		var hit = ray.get_collider()
		if hit.has_node("Area3D"):
			var area = hit.get_node("Area3D")
			if area.player_nearby:
				interact_prompt.visible = true
				return
	interact_prompt.visible = false
