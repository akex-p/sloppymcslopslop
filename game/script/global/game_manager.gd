extends Node

signal step_changed(step: int)

enum Step { WAKE_UP, RADIO, PILL, WINDOW, FISH_TANK, BED }

var current_step: int = Step.WAKE_UP
var interactables: Dictionary = {}

func register(step: int, node: Interactable) -> void:
	interactables[step] = node

func advance_step() -> void:
	current_step += 1
	emit_signal("step_changed", current_step)
	_enable_current()

func _enable_current() -> void:
	for step in interactables:
		if is_instance_valid(interactables[step]):
			interactables[step].enabled = (step == current_step)

func _ready():
	Dialogic.signal_event.connect(_on_dialogic_signal)

func _on_dialogic_signal(argument):
	if argument == "start_radio":
		var radio = interactables.get(Step.RADIO)
		if is_instance_valid(radio):
			Dialogic.paused = true
			current_step = Step.RADIO
			_enable_current()
	
	if argument == "take_pills":
		var pill = interactables.get(Step.PILL)
		if is_instance_valid(pill):
			# pills still exist, pause and wait for player
			Dialogic.paused = true
			current_step = Step.PILL
			_enable_current()
		# if pill is gone (already taken), dialog just continues
	
	
