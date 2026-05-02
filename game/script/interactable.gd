class_name Interactable
extends StaticBody3D

@export var prompt_text: String = "Interact"
@export var area_interact: Area3D
@export var enabled: bool = false
var player_nearby = false

signal cleared

func _ready() -> void:
	area_interact.body_entered.connect(_on_body_entered)
	area_interact.body_exited.connect(_on_body_exited)

func interact() -> void:
	push_error(name + " must implement interact()")

func _on_body_entered(body):
	if body is CharacterBody3D:
		player_nearby = true

func _on_body_exited(body):
	if body is CharacterBody3D:
		player_nearby = false

func is_player_nearby():
	return player_nearby
