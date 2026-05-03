extends Interactable

func _ready():
	super()
	prompt_text = "Take pill"
	GameManager.register(GameManager.Step.PILL, self)

func interact() -> void:
	GameManager.advance_step()
	visible = false
