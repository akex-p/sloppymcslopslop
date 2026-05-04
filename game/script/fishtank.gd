extends Interactable

@export var piranha_scene : PackedScene
@export var piranha_spawnpoint : Node3D
@export var piranha_food: Array[Node3D] = []

var piranha
var day: int = 1

func _ready():
	super()
	prompt_text = "Care for Fish"
	GameManager.register(GameManager.Step.FISHTANK, self)

func interact() -> void:
	match day:
		1:
			$AudioStreamPlayer.play()
			$AudioStreamPlayer3D2.play()
			$CPUParticles3D.emitting = true
			GameManager.advance_step()
		2:
			put_fish_out()
			$AudioStreamPlayer3D.play()
			$AudioStreamPlayer3D2.play()
			GameManager.advance_step()
		3:
			_release_the_piranha()
			GameManager.advance_step()

func put_fish_out() -> void:
	$FishesOutofTank.visible = true
	$Fishes.visible = false

func _release_the_piranha() -> void:
	piranha = piranha_scene.instantiate()
	piranha.targets = piranha_food
	get_tree().current_scene.add_child(piranha)
	piranha.global_position = piranha_spawnpoint.global_position
