extends Area3D

# ------------ #
#     VARS     #
# ------------ #

@export var groups: Array[String] = []

@export var new_position := Vector3.ZERO
@export var new_rotation := Vector3.ZERO

@export var start_teleport := true


# --------------- #
#     SIGNALS     #
# --------------- #

# When a body enter into the teleporter
func _on_body_entered(body: Node3D) -> void:
	for group in groups:
		if body.is_in_group(group):
			body.global_position = new_position
