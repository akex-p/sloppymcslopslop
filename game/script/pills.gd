extends Interactable

func _ready():
	super()
	prompt_text = "Take pill"
	GameManager.register(GameManager.Step.PILL, self)

func interact() -> void:
	$AudioStreamPlayer.play()
	GameManager.advance_step()
	visible = false
