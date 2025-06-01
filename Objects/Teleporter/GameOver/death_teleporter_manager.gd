class_name DeathTeleporterManager
extends Node3D


@export var checkpoint_position = Vector3.ZERO
@export var checkpoint_rotation = Vector3.ZERO

func set_checkpoint(new_position: Vector3, new_rotation: Vector3):
	if checkpoint_position != new_position: 
		checkpoint_position = new_position
		checkpoint_rotation = new_rotation
