extends Interactable

@onready var timer: Timer = $Timer

func _ready():
	super()
	prompt_text = "Do Wrrk"
	GameManager.register(GameManager.Step.WORKSTATION, self)

func interact() -> void:
	timer.start()
	Dialogic.VAR.work_count += 1

func _on_timer_timeout() -> void:
	GameManager.advance_step()
