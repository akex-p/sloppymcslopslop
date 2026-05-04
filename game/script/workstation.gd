extends Interactable

@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	super()
	prompt_text = "Do Work"
	GameManager.register(GameManager.Step.WORKSTATION, self)

func interact() -> void:
	animation_player.play("press")
	timer.start()
	Dialogic.VAR.work_count += 1

func _on_timer_timeout() -> void:
	GameManager.advance_step()
