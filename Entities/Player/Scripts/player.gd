class_name Player
extends CharacterBody3D

# ------------ #
#     VARS     #
# ------------ #

@onready var move_machine: StateMachine = $MoveMachine


# ----------------- #
#     PROCESSES     #
# ----------------- #

func _ready() -> void:
	move_machine.init(self)

func _process(delta: float) -> void:
	move_machine.process_frame(delta)

func _unhandled_input(event: InputEvent) -> void:
	move_machine.process_input(event)
	
func _physics_process(delta: float) -> void:
	move_machine.process_physics(delta)
