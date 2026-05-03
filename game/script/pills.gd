extends Interactable

func _ready():
	super()
	prompt_text = "Take pill"
	GameManager.register(GameManager.Step.PILL, self)  # THIS goes here


func interact() -> void:
	cleared.emit()
	Dialogic.paused = false
	GameManager.advance_step()
	queue_free()
	
