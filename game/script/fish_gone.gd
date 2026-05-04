extends Node3D

@export var start_scale: Vector3 = Vector3(0.2, 0.2, 0.2)
@export var end_scale: Vector3 = Vector3(1.0, 1.0, 1.0)
@export var scale_duration: float = 3
@export var delete_after_seconds: float = 15.0

func _ready() -> void:
	scale = start_scale

	var tween := create_tween()
	tween.tween_property(self, "scale", end_scale, scale_duration)

	await get_tree().create_timer(delete_after_seconds).timeout
	queue_free()
