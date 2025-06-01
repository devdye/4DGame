class_name State
extends Node3D


# ------------ #
#     VARS     #
# ------------ #

var parent: CharacterBody3D
var move_component: MoveComponent

var is_active: bool = false


# ------------------------ #
#     STATE MANAGEMENT     #
# ------------------------ #

# Function executed when entering the State
func enter() -> void:
	assert_import([move_component])
	is_active = true
	return 

# Function executed when exiting the State
func exit() -> void:
	is_active = false
	return


# ----------------- #
#     PROCESSES     #
# ----------------- #

# Process Physics
func process_physics(delta: float) -> State:
	return null

# Process Inputs
func process_input(event: InputEvent) -> State:
	return null

# Process Frames
func process_frame(delta: float) -> State:
	return null


# ------------- #
#     UTILS     #
# ------------- #

# Verify if objs are imported correctly
func assert_import(objs: Array[Node]):
	for obj in objs:
		assert(obj, str(name) + " - Import Missing")

# Get Inputs
func get_movement_input() -> Vector3: return move_component.get_movement_direction()
func wants_jump() -> bool: return move_component.wants_jump()
func wants_move() -> bool: return move_component.wants_move()
func wants_sprint() -> bool: return move_component.wants_sprint()
