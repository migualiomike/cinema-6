class_name CsmState
extends Node

@export var state_name := ""
@export var debug := false
var enter_state_time: float
var parent : Node


# Virtual methods to be overridden by specific states
func _process_state(delta: float) -> void:
	pass

func _process_transition(delta: float) -> Array:
	return [false, ""]  # [should_transition, next_state_name]

func _on_enter() -> void:
	pass

func _on_exit() -> void:
	pass

# Timer utilities
func mark_enter_state() -> void:
	enter_state_time = Time.get_unix_time_from_system()

func get_state_duration() -> float:
	return Time.get_unix_time_from_system() - enter_state_time

func has_been_in_state_longer_than(time: float) -> bool:
	return get_state_duration() >= time

func has_been_in_state_less_than(time: float) -> bool:
	return get_state_duration() < time

func has_been_in_state_between(start: float, finish: float) -> bool:
	var duration := get_state_duration()
	return duration >= start and duration <= finish
