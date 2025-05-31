class_name World4D
extends Node3D

var subspace3D: Subspace3D = Subspace3D.new()

var cur_rot: Vector3 = Vector3.ZERO
var old_rot: Vector3 = Vector3.ZERO

var target_rot: Vector3 = Vector3.ZERO

var sensibility: float = 1.0

var movement_hardness: float = 0.1

signal subspace_change

func lerp_angles(from: Vector3, to: Vector3, weight: float):
	var v := from
	return Vector3(lerp_angle(from.x, to.x, weight), lerp_angle(from.y, to.y, weight), lerp_angle(from.z, to.z, weight))

func is_different(vector1: Vector3, vector2: Vector3, margin: float = 10e-4):
	return abs(vector1.x - vector2.x + vector1.y - vector2.y + vector1.z - vector2.z) > margin

func wrap_angles(v: Vector3) -> Vector3:
	return Vector3(fmod(v.x, TAU), fmod(v.y, TAU), fmod(v.z, TAU))

func _process(delta: float) -> void:
	cur_rot = wrap_angles(cur_rot)
	cur_rot = wrap_angles(target_rot)
	
	cur_rot = lerp_angles(cur_rot, target_rot, 1.0 - exp(-movement_hardness * get_physics_process_delta_time()))
	
	if is_different(cur_rot, old_rot):
		old_rot = cur_rot
		subspace3D.set_angles(cur_rot.x, 0, cur_rot.y)
		emit_signal("subspace_change")
	
func _unhandled_input(ev: InputEvent) -> void:
	if not Input.is_action_pressed("4d_control"): return
	
	if ev is InputEventMouseMotion:
		var dx = -ev.relative.x * sensibility / 800
		var dy = -ev.relative.y * sensibility / 800
		
		target_rot.y += dx
		target_rot.x += dy
		
