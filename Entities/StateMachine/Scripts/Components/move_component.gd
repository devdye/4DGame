class_name MoveComponent
extends Node3D

# ------------ #
#     VARS     #
# ------------ #

# EXPORTS
@export var parent: CharacterBody3D

@export var move_speed: float = 10.0
@export var movement_smoothness: float = 20.0

@export var jump_height: float = 1.05
@export var air_control: float = 0.7
@export var fall_multiplicator: float = 1.8

# Jump force when jumping
@onready var jump_force: float = sqrt(jump_height * 2.0 * gravity)

# VARS
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var target_velocity_xz = Vector2.ZERO
var velocity = Vector3.ZERO


# ---------------- #
#    PROCESSES     #
# ---------------- #

func _ready():
	assert(parent, "MoveComponent's parent is missing.")

func _physics_process(delta: float) -> void:
	# Make velocity smoother
	velocity.x = lerp(velocity.x, target_velocity_xz.x, 1.0 - exp(-movement_smoothness * get_physics_process_delta_time()))
	velocity.z = lerp(velocity.z, target_velocity_xz.y, 1.0 - exp(-movement_smoothness * get_physics_process_delta_time()))
	
	# Set Velocity
	parent.velocity = velocity
	
	# Make the parent move
	parent.move_and_slide()


# -------------- #
#     INPUTS     #
# -------------- #

func get_movement_direction() -> Vector3:
	return Vector3.ZERO

func wants_jump() -> bool:
	return Input.is_action_just_pressed('jump')

func wants_move() -> bool:
	return get_movement_direction().length() > 0.05 


# --------------- #
#     SETTERS     #
# --------------- #

func set_velocity_xz(vel: Vector3): 
	target_velocity_xz.x = vel.x
	target_velocity_xz.y = vel.z

func set_velocity_x(vel_x: float): target_velocity_xz.x = vel_x
func set_velocity_y(vel_y: float): velocity.y = vel_y
func set_velocity_z(vel_z: float): target_velocity_xz.y = vel_z

func change_velocity_x(vel_x: float): target_velocity_xz.x += vel_x
func change_velocity_y(vel_y: float): velocity.y += vel_y
func change_velocity_z(vel_z: float): target_velocity_xz.y += vel_z

func jump(): set_velocity_y(jump_force)


# --------------- #
#     GETTERS     #
# --------------- #

func get_velocity_xz() -> Vector2: return Vector2(target_velocity_xz.x, target_velocity_xz.z)
func get_velocity_x() -> Vector2: return target_velocity_xz.x
func get_velocity_y() -> Vector2: return velocity.y
func get_velocity_z() -> Vector2: return target_velocity_xz.z
