extends Node3D

@export var mouse_sensitivity := 0.002

@export var player: Player

var yaw := 0.0   # rotation around Y (player)
var pitch := 0.0 # rotation around X (head)

func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-89), deg_to_rad(89))
		apply_rotation()

func apply_rotation():
	# Yaw: rotate player around Y
	var yaw_quat = Quaternion(Vector3.UP, yaw)
	player.global_transform.basis = Basis(yaw_quat)

	# Pitch: rotate head around X (local to player)
	var pitch_quat = Quaternion(Vector3.RIGHT, pitch)
	rotation = pitch_quat.get_euler()
