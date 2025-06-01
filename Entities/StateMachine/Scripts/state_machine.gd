class_name StateMachine
extends Node3D


# ------------ #
#     VARS     #
# ------------ #

@export var parent: CharacterBody3D
@export var starting_state: State

@export var move_component: MoveComponent

var current_state: State


# ------------ #
#     INIT     #
# ------------ #

# Init the character
func init(entity: CharacterBody3D) -> void:
	assert(parent, "Parent is needed in order to use the StateMachine.")
	assert(starting_state, "Starting_state is needed in order to use the StateMachine.")
	assert(move_component, "Move_component is needed in order to use the StateMachine.")
	
	parent = entity
	move_component.parent = parent
	
	for child in get_children(): 
		child.parent = entity
		child.move_component = move_component
	
	change_state(starting_state)


# ------------------------ #
#     STATE MANAGEMENT     #
# ------------------------ #

# Change the current state
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()


# ----------------- #
#     PROCESSES     #
# ----------------- #

# Process Physics
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

# Process Inputs
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

# Process Frames
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
