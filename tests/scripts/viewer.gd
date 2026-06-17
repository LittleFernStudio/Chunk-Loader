class_name Viewer extends CharacterBody2D

@export var speed: float = 100.0

var _input_vector: Vector2 = Vector2.ZERO
var _current_movement: String = "idle"
var _current_direction: String = "down"


func _process(_delta):
	_input_vector = Input.get_vector("left", "right", "up", "down")


func _physics_process(_delta):
	velocity = _input_vector.normalized() * speed
	move_and_slide()


func _get_movement() -> String:
	return "walk" if _input_vector.length() > 0 else "idle"


func _get_direction() -> String:
	if _input_vector.length() == 0:
		return _current_direction

	if abs(_input_vector.x) > abs(_input_vector.y):
		return "side"

	return "up" if _input_vector.y < 0 else "down"
