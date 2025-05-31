extends Node3D

@export var plane: Node3D


func _process(delta: float) -> void:
	if plane and "cur_rot" in plane:
		rotation = plane.cur_rot
