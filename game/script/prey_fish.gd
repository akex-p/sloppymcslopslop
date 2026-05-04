extends Node3D

@export var blood_scene := preload("res://scene/fishes/fish_gone.tscn")
@export var new_texture: CompressedTexture2D

func _ready() -> void:
	if new_texture != null:
		$Plane.get_surface_override_material(0).set_shader_parameter("texture_albedo", new_texture)

func _on_area_3d_area_entered(area: Area3D) -> void:
	if(area.is_in_group("predator_fish")):
		var blood = blood_scene.instantiate()
		get_tree().current_scene.add_child(blood)
		blood.global_position = global_position
		queue_free()
	#area_owner.has_method()
