extends Interactable

func _ready():
	super()
	prompt_text = "Do Work"
	enabled = true

func interact() -> void:
	Dialogic.VAR.work_count += 1
	print("work count: ", Dialogic.VAR.work_count)
	if Dialogic.paused:
		Dialogic.paused = false
	
	
	
