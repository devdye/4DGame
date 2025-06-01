@tool
extends Node3D


# ------------ #
#     VARS     #
# ------------ #

@export var rotation_time: float = 1.0

@export_range(-90, 90, 5.0) var camera_angle: float = 0.0
@export var distance: float = 25.0

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera


# ----------------- #
#     PROCESSES     #
# ----------------- #

func _process(delta: float) -> void:
	if camera_angle == -90 or camera_angle == 90: camera_angle -= 10e-1
	
	camera.position = Vector3.BACK * cos(deg_to_rad(camera_angle)) * distance + Vector3.UP * sin(deg_to_rad(camera_angle)) * distance
	camera.look_at(Vector3.ZERO)
	
	if abs(rotation_time) > 0.0:
		pivot.rotate_y(delta / rotation_time)
