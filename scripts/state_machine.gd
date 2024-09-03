class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State;
var states: Dictionary = {};

func init(parent: Player) -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child;
			child.Transitioned.connect(on_child_transition);
			child.parent = parent;
			
	if initial_state:
		initial_state.enter();
		current_state = initial_state;

func update(_delta: float) -> void:
	if current_state:
		current_state.update(_delta);

func physics_update(_delta: float) -> void:
	if current_state:
		current_state.physics_update(_delta);
		
func input_update(_event: InputEvent) -> void:
	if current_state:
		current_state.input_update(_event);

func force_child_transition(new_state_name) -> void:
	if(current_state):
		on_child_transition(current_state, new_state_name);
	else:
		printerr("no current state")

func on_child_transition(state, new_state_name) -> void:
	print(var_to_str(Time.get_ticks_msec()) + ": " + state.name + " -> " + new_state_name)
	if (state != current_state) or (current_state.name.to_lower() == new_state_name.to_lower()):
		return;
	
	var new_state: State = states.get(new_state_name.to_lower());
	if !new_state:
		return;
		
	if current_state:
		current_state.exit();
	
	new_state.enter();
	current_state = new_state;

