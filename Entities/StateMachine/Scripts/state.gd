class_name State
extends Node3D

var parent: CharacterBody3D
var move_component: MoveComponent

func enter() -> void:
	assert_import([move_component])
	return 
	
func exit() -> void:
	return
	
func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null

# UTILS
func assert_import(objs: Array[Node]):
	for obj in objs:
		assert(obj, str(name) + " - Import Missing")

func get_movement_input() -> Vector3:
	return move_component.get_movement_direction()

func wants_jump() -> bool:
	return move_component.wants_jump()

func wants_move() -> bool:
	return move_component.wants_move()
