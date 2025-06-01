extends State


# ------------ #
#     VARS     #
# ------------ #

@export_group("States")
@export var fall_state: State
@export var idle_state: State
@export var move_state: State


# ------------------------ #
#     STATE MANAGEMENT     #
# ------------------------ #

# Function executed when entering the State
func enter() -> void:
	assert_import([fall_state, idle_state, move_state])
	
	super()
	
	move_component.jump()


# ----------------- #
#     PROCESSES     #
# ----------------- #

# Process Physics
func process_physics(delta: float) -> State:
	# Apply gravity
	move_component.change_velocity_y(-move_component.gravity * delta)
	
	# Change state if the entity is no longer falling
	if move_component.velocity.y <= -0.1:
		return fall_state
	
	# Move the entity
	var movement = get_movement_input() * move_component.move_speed * move_component.air_control
	move_component.set_velocity_xz(movement)
	
	# Change state if the entity is no longer jumping but not falling
	if move_component.velocity.y < 0.1 and parent.is_on_floor():
		if wants_move():
			return move_state
		return idle_state
	
	return null
