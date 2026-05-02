extends Interactable

func _ready():
	super()
	prompt_text = "Take pill"

func interact() -> void:
	cleared.emit()
	queue_free()
