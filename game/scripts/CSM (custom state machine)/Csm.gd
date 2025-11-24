class_name CSM
extends Node

@export var starting_state : String
@export var master : Node
@export var debug := false

var states: Dictionary = {}  # { String : State }
var current_state: CsmState
var is_active: bool = true

func _ready() -> void:
	_initialize_states()
	if states.has(starting_state):
		switch_state(starting_state)
	elif states.size() > 0:
		switch_state(states.keys()[0])
	

func _physics_process(delta: float) -> void:
	if not is_active or not current_state:
		return
	
	var transition_result : Array = current_state._process_transition(delta)
	if transition_result[0]:  # [should_transition, next_state_name]
		switch_state(transition_result[1])
	
	current_state._process_state(delta)

func switch_state(next_state_name: String) -> void:
	if not states.has(next_state_name):
		push_error("State '%s' not found in FSM" % next_state_name)
		return
	
	if current_state:
		if debug: print(current_state.state_name + " -> " + next_state_name)
		current_state._on_exit()
	
	current_state = states[next_state_name]
	current_state.mark_enter_state()
	current_state._on_enter()

func _initialize_states() -> void:
	for child in get_children():
		if child is CsmState:
			states[child.state_name] = child
			child.parent = self
	
	if states.is_empty():
		push_warning("FSM has no State children")

func set_active(active: bool) -> void:
	is_active = active

func get_current_state_name() -> String:
	return current_state.state_name if current_state else ""
