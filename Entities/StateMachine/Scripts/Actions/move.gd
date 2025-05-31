extends State

@export var fall_state: State
@export var jump_state: State
@export var idle_state: State

func enter() -> void:
	assert_import([fall_state, jump_state, idle_state])
	
	super()
	
func exit() -> void:
	return
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
		
	if not wants_move():
		return idle_state
	
	return null

func process_physics(delta: float) -> State:
	var movement = get_movement_input() * move_component.move_speed
	move_component.set_velocity_xz(movement)
	
	if !parent.is_on_floor():
		return fall_state
		
	return null
