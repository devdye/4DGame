extends SubViewportContainer

# EXPORTS
@export var world_4d: World4D

# NODES
@onready var rotation_sphere: Node3D = $SubViewport/Camera3D/RotationSphere

func _ready() -> void:
	# Check required nodes and properties
	assert(rotation_sphere, "Sphere is missing inside 4DRotationViewer, even though it is a already imported node.")
	assert(world_4d, "Instance of World4D is missing inside 4DRotationViewer. You need to import it.")
	assert("cur_rot" in world_4d, "cur_rot is missing inside world_4D. This variable is needed to run correctly the 4DRotationViewer.")

func _process(delta: float) -> void:
	# Sync sphere rotation with current 4D rotation if valid
	if rotation_sphere and world_4d and "cur_rot" in world_4d:
		rotation_sphere.rotation = world_4d.cur_rot
