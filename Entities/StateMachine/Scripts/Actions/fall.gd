extends State

@export var idle_state: State
@export var move_state: State

func enter() -> void:
	assert_import([idle_state, move_state])
	
	super()

func process_physics(delta: float) -> State:
	if parent.is_on_floor():
		if wants_move():
			return move_state
		return idle_state
	
	move_component.change_velocity_y(-move_component.gravity * move_component.fall_multiplicator * delta)
	
	var movement = move_component.get_movement_direction() * move_component.air_control
	move_component.set_velocity_xz(movement)
	
	print(movement)
	
	return null
