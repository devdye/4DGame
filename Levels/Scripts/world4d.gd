@tool
class_name World4D
extends Node3D


# ------------ #
#     VARS     #
# ------------ #

# EXPORTS
@export var sensibility: float = 1.0
@export var movement_hardness: float = 5.0

# OBJECTS
var subspace3D: Subspace3D = Subspace3D.new()

# VARS
var cur_rot: Vector3 = Vector3.ZERO
var old_rot: Vector3 = Vector3.ZERO
var target_rot: Vector3 = Vector3.ZERO

# SIGNALS
signal subspace_change


# ------------- #
#     UTILS     #
# ------------- #

# Interpolates between two rotation vectors by smoothing each component
func lerp_angles(from: Vector3, to: Vector3, weight: float):
	return Vector3(
		lerp_angle(from.x, to.x, weight),
		lerp_angle(from.y, to.y, weight),
		lerp_angle(from.z, to.z, weight)
	)

# Checks if two vectors differ by more than a specified margin
func is_different(vector1: Vector3, vector2: Vector3, margin: float = 0.0009):
	return abs(vector1.x - vector2.x + vector1.y - vector2.y + vector1.z - vector2.z) > margin

# Wraps each component of a rotation vector into the range [0, 2π)
func wrap_angles(v: Vector3) -> Vector3:
	return Vector3(
		fmod(v.x, TAU),
		fmod(v.y, TAU),
		fmod(v.z, TAU)
	)


# ------------- #
#     UTILS     #
# ------------- #

# Updates current rotation toward target and emits a signal if it changes
func _process(delta: float) -> void:
	# Wrap rotations to maintain valid angle range
	cur_rot = wrap_angles(cur_rot)
	target_rot = wrap_angles(target_rot)
	
	# Smoothly interpolate current rotation toward target using hardness
	cur_rot = lerp_angles(cur_rot, target_rot, 1.0 - exp(-movement_hardness * get_physics_process_delta_time()))
	
	# If the new rotation differs from the previous one beyond threshold
	if is_different(cur_rot, old_rot):
		# Update rotations
		old_rot = cur_rot
		subspace3D.set_angles(cur_rot.x, 0, cur_rot.y)
		
		# Notify any listeners that the subspace has changed
		emit_signal("subspace_change")

# Adjusts target rotation based on mouse movement when 4D control is active
func _unhandled_input(ev: InputEvent) -> void:
	# Ignore input unless 4D control key is held
	if not Input.is_action_pressed("4d_control"): return
	
	if ev is InputEventMouseMotion:
		# Compute horizontal and vertical adjustments scaled by sensitivity
		var dx = -ev.relative.x * sensibility / 800
		var dy = -ev.relative.y * sensibility / 800
		
		# Update target rotation
		target_rot.y += dx
		target_rot.x += dy
