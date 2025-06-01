extends State


# ------------ #
#     VARS     #
# ------------ #

# Linked States
@export var idle_state: State
@export var move_state: State


# ------------------------ #
#     STATE MANAGEMENT     #
# ------------------------ #

# Function executed when entering the State
func enter() -> void:
	assert_import([idle_state, move_state])
	
	super()


# ----------------- #
#     PROCESSES     #
# ----------------- #

# Process Physics
func process_physics(delta: float) -> State:
	# Change state if the entity is on floor
	if parent.is_on_floor():
		if wants_move():
			return move_state
		return idle_state
	
	# Apply gravity + fall_multiplicator
	move_component.change_velocity_y(-move_component.gravity * move_component.fall_multiplicator * delta)
	
	# Make the entity move and apply air control
	var movement = get_movement_input() * move_component.move_speed * move_component.air_control
	move_component.set_velocity_xz(movement)
	
	return null
