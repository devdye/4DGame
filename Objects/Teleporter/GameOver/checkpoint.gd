extends Area3D

@export var death_teleporter_manager: DeathTeleporterManager

@export var checkpoint_position := Vector3.ZERO
@export var checkpoint_rotation := Vector3.ZERO

@export var groups: Array[String] = ["player"]

func _ready():
	assert(death_teleporter_manager, "Checkpoint needs GameOverManager.")

func _on_body_entered(body: Node3D) -> void:
	for group in groups:
		if body.is_in_group(group):
			death_teleporter_manager.set_checkpoint(checkpoint_position, checkpoint_rotation)
	
