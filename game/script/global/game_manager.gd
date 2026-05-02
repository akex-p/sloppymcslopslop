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
		interactables[step].enabled = (step == current_step)
