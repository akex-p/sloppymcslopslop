extends Interactable

@onready var timer: Timer = $Timer

func _ready():
	super()
	prompt_text = "Do Wrrk"
	GameManager.register(GameManager.Step.WORKSTATION, self)

func interact() -> void:
	timer.start()
	Dialogic.VAR.work_count += 1
	if Dialogic.paused:
		Dialogic.paused = false

func _on_timer_timeout() -> void:
	GameManager.advance_step()
