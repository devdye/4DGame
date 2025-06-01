extends Area3D

@export var death_teleporter_manager: DeathTeleporterManager


@export var groups: Array[String] = ["player"]


func _ready():
	assert(death_teleporter_manager, "DeathTeleporter needs GameOverManager.")

func _on_body_entered(body: Node3D) -> void:
	for group in groups:
		if body.is_in_group(group):
			body.global_position = death_teleporter_manager.checkpoint_position
			body.global_rotation = death_teleporter_manager.checkpoint_rotation
