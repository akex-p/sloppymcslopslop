extends Interactable

@export var piranha_scene : PackedScene
@export var piranha_spawnpoint : Node3D
@export var piranha_food: Array[Node3D] = []

var piranha

func _ready():
	super()
	prompt_text = "Care for Fish"
	GameManager.register(GameManager.Step.FISHTANK, self)

func interact() -> void:
	GameManager.advance_step()

func _release_the_piranha() -> void:
	piranha = piranha_scene.instantiate()
	piranha.targets = piranha_food
	get_tree().current_scene.add_child(piranha)
	piranha.global_position = piranha_spawnpoint.global_position
