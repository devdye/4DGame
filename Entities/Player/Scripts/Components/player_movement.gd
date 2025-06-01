extends MoveComponent


# ----------------- #
#     FUNCTIONS     #
# ----------------- #

func get_movement_direction() -> Vector3:
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	return (parent.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func wants_jump() -> bool:
	return false
