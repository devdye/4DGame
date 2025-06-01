extends Node3D


# ------------ #
#     VARS     #
# ------------ #

@export var mouse_sensitivity := 0.002
@export var hardness_factor := 30.0

@onready var player = $".."

var target_yaw := 0.0
var target_pitch := 0.0

var yaw := 0.0
var pitch := 0.0


# ----------------- #
#     PROCESSES     #
# ----------------- #

func _ready():
	if not player: return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize yaw and pitch to current rotations
	target_yaw = player.rotation.y
	target_pitch = rotation.x
	yaw = target_yaw
	pitch = target_pitch

func _unhandled_input(event):
	if not player: return
	
	# Verify if mouse is captured
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	if event is InputEventMouseMotion:
		target_yaw -= event.relative.x * mouse_sensitivity
		target_pitch -= event.relative.y * mouse_sensitivity
		target_pitch = clamp(target_pitch, deg_to_rad(-89), deg_to_rad(89))

func _process(delta):
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
