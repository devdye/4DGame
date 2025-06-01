extends SpringArm3D


# ------------ #
#     VARS     #
# ------------ #

@export_group("Nodes")
@export var player: Player

@export_group("Camera")
@export_range(0.0, 360.0, 45.0) var spring_arm_angle: float = 270.0
@export var mouse_sensitivity := 0.002
@export var hardness_factor := 8.0
@export_range(30.0, 95.0) var fov := 75.0

@onready var camera: Camera3D = $Camera

var target_yaw := 0.0
var target_pitch := 0.0

var yaw := 0.0
var pitch := 0.0


# ----------------- #
#     PROCESSES     #
# ----------------- #

func _ready():
	assert(player, "Third Person Camera needs a player.")
	
	# Set mouse mode to captured
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Initialize yaw and pitch to current rotations
	target_yaw = rotation.y
	target_pitch = rotation.x
	yaw = target_yaw
	pitch = target_pitch
	
	# Set FOV
	camera.fov = fov
	
	# Set Spring Arm Angle
	rotation.y = spring_arm_angle
	
	# Ensure SpringArm follows player
	global_position = player.global_position

func _unhandled_input(event):
	if not player: return
	
	# Verify if mouse is captured
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	# Verify if you are not in 4D mode
	if Input.is_action_pressed("4d_control"): return
	
	if event is InputEventMouseMotion:
		target_yaw -= event.relative.x * mouse_sensitivity
		target_pitch -= event.relative.y * mouse_sensitivity
		target_pitch = clamp(target_pitch, deg_to_rad(-60), deg_to_rad(60))

func _process(delta):
	if not player: return
	
	# Toggle mouse capture
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
	
	# Keep SpringArm positioned at player
	global_position = player.global_position
	
	# Set fov
	camera.fov = fov


# ----------------- #
#     FUNCTIONS     #
# ----------------- #

# Apply rotation using the provided yaw and pitch
func apply_rotation(yaw, pitch):
	if not player: return
	
	# Rotate SpringArm for yaw and pitch
	player.rotation.y = yaw
	rotation.x = pitch
