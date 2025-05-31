extends CharacterBody3D

@export var speed = 20.0

@onready var movement_hardness: float = 20.0
@onready var sensibility_hardness: float = 20.0

@export var target_rotation: Vector3
 
@export var sensibility: float = 1.0


# VARS
var target_velocity: Vector3 = Vector3.ZERO
var _is_captured: bool = true


func _capture_mouse(capture: bool) -> void:
	_is_captured = capture
	if capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready() -> void:
	_capture_mouse(true)


func lerp_angles(from: Vector3, to: Vector3, weight: float):
	var v := from
	return Vector3(lerp_angle(from.x, to.x, weight), lerp_angle(from.y, to.y, weight), lerp_angle(from.z, to.z, weight))

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var input_up_dir := Input.get_axis("sneak", "jump")
	
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	target_velocity = speed * (direction + input_up_dir * Vector3.UP)
	
	velocity = lerp(velocity, target_velocity, 1.0 - exp(-movement_hardness * get_physics_process_delta_time()))
	rotation = lerp_angles(rotation, target_rotation, 1.0 - exp(-sensibility_hardness * get_physics_process_delta_time()))
	
	move_and_slide()

func _unhandled_input(ev: InputEvent) -> void:
	if ev.is_action_released("ui_cancel"):
		_capture_mouse(not _is_captured)
		return 

	if not _is_captured: return
	
	if Input.is_action_pressed("4d_control"): return
	
	if ev is InputEventMouseMotion:
		var dx = -ev.relative.x * sensibility / 200
		var dy = -ev.relative.y * sensibility / 200
		
		target_rotation.y += dx
		target_rotation.x += dy
		
		target_rotation.x = clamp(target_rotation.x, deg_to_rad(-89), deg_to_rad(89))
	
