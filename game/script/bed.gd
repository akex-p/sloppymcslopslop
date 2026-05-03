extends Interactable

func _ready():
	super()
	prompt_text = "Go to bed"
	GameManager.register(GameManager.Step.BED, self)

func interact() -> void:
	GameManager.advance_step()
	GameManager.next_day()
