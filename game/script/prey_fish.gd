extends Node3D

@export var blood_scene := preload("res://scene/fishes/fish_gone.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_area_entered(area: Area3D) -> void:
	if(area.is_in_group("predator_fish")):
		var blood = blood_scene.instantiate()
		get_tree().current_scene.add_child(blood)
		blood.global_position = global_position
		queue_free()
	#area_owner.has_method()
