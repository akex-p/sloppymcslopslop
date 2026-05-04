extends Node

enum Step {
	RADIO,
	PILL,
	WORKSTATION,
	FISHTANK,
	BED
}

const STEP_NAMES: Dictionary = {
	Step.RADIO: "radio",
	Step.PILL:  "pill",
	Step.WORKSTATION: "workstation",
	Step.FISHTANK: "fishtank",
	Step.BED: "bed",
}

signal step_changed(step: int)

var current_day: int = 1
var current_step: int = 0
var interactables: Dictionary = {}
var main: Main

func _ready():
	Dialogic.timeline_ended.connect(_on_timeline_ended)

func register(step: int, node: Interactable) -> void:
	interactables[step] = node
	print(interactables)

func advance_step() -> void:
	disable_all()
	var step_name = STEP_NAMES.get(current_step, "unknown")
	var timeline = "day%d_%s_%s" % [current_day, step_name, "taskend"]
	current_step += 1
	Dialogic.start(timeline)

func enable_current() -> void:
	for step in interactables:
		interactables[step].enabled = (step == current_step)

func disable_all() -> void:
	for step in interactables:
		if is_instance_valid(interactables[step]):
			interactables[step].enabled = false

func ask_bob() -> void:
	if current_day == 4:
		Dialogic.start("bob_offline")
	var step_name = STEP_NAMES.get(current_step, "unknown")
	var timeline = "day%d_%s_taskstart" % [current_day, step_name]
	Dialogic.start(timeline)

func next_day() -> void:
	current_day += 1
	current_step = 0
	interactables.clear()
	main.go_to_sleep()

func _on_timeline_ended() -> void:
	# taskstart ended → world is now interactive
	# taskend ended → next step's taskstart will be triggered by ask_bob
	pass

func reset() -> void:
	interactables.clear()
	current_day = 1
	current_step = 0
