extends Node3D

@onready var animation_player_overlay: AnimationPlayer = $Overlay/AnimationPlayer


func _ready() -> void:
	animation_player_overlay.play("fade")
