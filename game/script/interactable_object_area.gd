extends Area3D

var player_nearby = false

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	print("body entered: ", body)
	if body is CharacterBody3D:
		player_nearby = true

func _on_body_exited(body):
	if body is CharacterBody3D:
		player_nearby = false

func is_player_nearby():
	return player_nearby
