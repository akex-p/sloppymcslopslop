extends CharacterBody3D

@export var speed: float = 0.2
@export var stop_distance: float = 0.05
@export var rotate_speed: float = 8.0

@export var targets: Array[Node3D] = []

var current_target_index: int = 0


func _physics_process(delta: float) -> void:
	if targets.is_empty():
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var target := targets[current_target_index]

	if target == null:
		_go_to_next_target()
		return

	var to_target: Vector3 = target.global_position - global_position
	var distance := to_target.length()

	if distance <= stop_distance:
		_go_to_next_target()
		velocity = Vector3.ZERO
		move_and_slide()
		return

	var direction := to_target.normalized()

	# Floating fish movement: move in X, Y, and Z.
	velocity = direction * speed

	_rotate_toward(direction, delta)

	move_and_slide()


func _go_to_next_target() -> void:
	current_target_index += 1

	if current_target_index >= targets.size():
		current_target_index = 0


func _rotate_toward(direction: Vector3, delta: float) -> void:
	if direction.length_squared() == 0.0:
		return

	# Godot models usually face -Z by default.
	var target_basis := Basis.looking_at(-direction, Vector3.UP)

	global_basis = global_basis.slerp(target_basis, rotate_speed * delta)
