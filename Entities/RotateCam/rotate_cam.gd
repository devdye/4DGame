@tool
extends Node3D

@onready var pivot: Node3D = $Pivot
@onready var camera: Camera3D = $Pivot/Camera

@export var rotation_time: float = 1.0

@export var camera_height: float = 5.0
@export var distance: float = 25.0

func _process(delta: float) -> void:
	var camera_back = sqrt(distance ** 2 - camera_height ** 2) if camera_height < distance else 0
	
	camera.position = Vector3.BACK * camera_back + Vector3.UP * camera_height
	
	if camera_back > 0: camera.look_at(Vector3.ZERO)
	else: camera.rotation = Vector3(-PI / 2, 0, 0)
	
	if abs(rotation_time) > 0.0:
		pivot.rotate_y(delta / rotation_time)
