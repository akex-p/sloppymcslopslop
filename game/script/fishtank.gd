extends Interactable

func _ready():
	super()
	prompt_text = "Feed Fish"
	GameManager.register(GameManager.Step.FISHTANK, self)

func interact() -> void:
	GameManager.advance_step()
