extends State


# ------------ #
#     VARS     #
# ------------ #

@export_group("States")
@export var fall_state: State
@export var jump_state: State
@export var move_state: State


# ------------------------ #
#     STATE MANAGEMENT     #
# ------------------------ #

# Function executed when entering the State
func enter() -> void:
	assert_import([fall_state, jump_state, move_state])
	
	super()
	
	move_component.set_velocity_xz(Vector3.ZERO)
	

# ----------------- #
#     PROCESSES     #
# ----------------- #

# Process Inputs
func process_input(event: InputEvent) -> State:
	# Make the entity jump
	if wants_jump() and parent.is_on_floor():
		return jump_state
		
	# Make the entity move
	if wants_move():
		return move_state
	
	return null

# Process Physics
func process_physics(delta: float) -> State:
	# Make the entity fall
	if not parent.is_on_floor():
		return fall_state
		
	return null
