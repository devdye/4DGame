# This script allows for free movement and rotation in a 3D space, similar to a first-person camera.

extends CharacterBody3D


# ------------ #
#     VARS     #
# ------------ #

# EXPORTS
@export var speed = 20.0

@onready var movement_hardness: float = 10.0
@onready var sensibility_hardness: float = 10.0

@export var target_rotation: Vector3
@export var sensibility: float = 1.0

# VARS
var target_velocity: Vector3 = Vector3.ZERO
var _is_captured: bool = true



# ------------- #
#     UTILS     #
# ------------- #

# Interpolates each component of a rotation vector using angle lerp
func lerp_angles(from: Vector3, to: Vector3, weight: float):
	var v := from
	return Vector3(lerp_angle(from.x, to.x, weight), lerp_angle(from.y, to.y, weight), lerp_angle(from.z, to.z, weight))

# Capture or release the mouse pointer
func _capture_mouse(capture: bool) -> void:
	_is_captured = capture
	if capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# ------------ #
#     MAIN     #
# ------------ #

# Called on node initialization
func _ready() -> void:
	_capture_mouse(true)

# Called each physics frame
func _physics_process(delta: float) -> void:
	# Get horizontal input vector (left/right and forward/backward)
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	
	# Get vertical input axis (sneak/jump)
	var input_up_dir := Input.get_axis("sneak", "jump")
	
	# Compute movement direction in world space
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Compute target velocity including vertical movement
	target_velocity = speed * (direction + input_up_dir * Vector3.UP)
	
	# Smooth velocity and rotation interpolation using exponential decay
	velocity = lerp(velocity, target_velocity, 1.0 - exp(-movement_hardness * get_physics_process_delta_time()))
	rotation = lerp_angles(rotation, target_rotation, 1.0 - exp(-sensibility_hardness * get_physics_process_delta_time()))
	
	# Apply movement
	move_and_slide()

# Handles mouse and input events not consumed by UI
func _unhandled_input(ev: InputEvent) -> void:
	# Toggle mouse capture on Escape
	if ev.is_action_released("ui_cancel"):
		_capture_mouse(not _is_captured)
		return 

	# Ignore input if mouse is not captured
	if not _is_captured: return
	
	# Skip input if in 4D control mode
	if Input.is_action_pressed("4d_control"): return
	
	# Process mouse movement for rotation
	if ev is InputEventMouseMotion:
		var dx = -ev.relative.x * sensibility / 200
		var dy = -ev.relative.y * sensibility / 200
		
		# Update target rotation
		target_rotation.y += dx
		target_rotation.x += dy
		
		# Clamp vertical angle to avoid flipping
		target_rotation.x = clamp(target_rotation.x, deg_to_rad(-89), deg_to_rad(89))
