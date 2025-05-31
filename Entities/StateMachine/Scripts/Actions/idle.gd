extends State

@export var fall_state: State
@export var jump_state: State
@export var move_state: State

func enter() -> void:
	assert_import([fall_state, jump_state, move_state])
	
	super()
	move_component.set_velocity_xz(Vector3.ZERO)
	
func exit() -> void:
	return
	
func process_input(event: InputEvent) -> State:
	if wants_jump() and parent.is_on_floor():
		return jump_state
	if wants_move():
		return move_state
	
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	
	if not parent.is_on_floor():
		return fall_state
		
	return null
