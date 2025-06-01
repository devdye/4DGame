extends Node3D


# ------------ #
#     VARS     #
# ------------ #


@export var player: Player



@export var mouse_sensitivity := 0.002
@export var hardness_factor := 30.0
@export_range(30.0, 95.0) var fov := 80.0

@onready var camera: Camera3D = $Camera

var target_yaw := 0.0
var target_pitch := 0.0

var yaw := 0.0
var pitch := 0.0


# ----------------- #
#     PROCESSES     #
# ----------------- #

func _ready():
	assert(player, "FPS Camera needs a player.")
	
	# Set mouse mode to captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize yaw and pitch to current rotations
	target_yaw = player.rotation.y
	target_pitch = rotation.x
	yaw = target_yaw
	pitch = target_pitch
	
	# Set FOV
	camera.fov = fov

func _unhandled_input(event):
	if not player: return
	
	# Verify if mouse is captured
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event is InputEventMouseMotion:
		target_yaw -= event.relative.x * mouse_sensitivity
		target_pitch -= event.relative.y * mouse_sensitivity
		target_pitch = clamp(target_pitch, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
	if not player: return
	
	# Toogle mouse capture
	if Input.is_action_just_pressed("exit") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	elif Input.is_action_just_pressed("exit"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	# Verify if mouse is captured
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	# Smoothly interpolate towards the target yaw and pitch
	yaw = lerp(yaw, target_yaw, hardness_factor * delta)
	pitch = lerp(pitch, target_pitch, hardness_factor * delta)
	
	# Apply the smoothed rotation
	apply_rotation(yaw, pitch)
	
	# Set fov
	camera.fov = fov


# ----------------- #
#     FUNCTIONS     #
# ----------------- #

# Apply rotation using the provided yaw and pitch
func apply_rotation(yaw, pitch):
	if not player: return
	
	# Rotate player yaw with quaternion
	var yaw_quat = Quaternion(Vector3.UP, yaw)
	player.global_transform.basis = Basis(yaw_quat)

	# Rotate camera pitch with quaternion
	var pitch_quat = Quaternion(Vector3.RIGHT, pitch)
	rotation = pitch_quat.get_euler()
