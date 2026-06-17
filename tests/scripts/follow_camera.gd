extends Camera2D

@export var target: Node2D
@export var follow_speed: float = 8.0

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.2
@export var max_zoom: float = 4.0
@export var zoom_lerp_speed: float = 10.0

var _target_zoom: float = 1.0


func _ready() -> void:
	_initialize_zoom()


# Lerps the camera towards a target. (Usually the player)
func _process(delta: float) -> void:
	if target != null:
		global_position = global_position.lerp(target.global_position, follow_speed * delta)

	_handle_zoom_input()

	var current_zoom: float = zoom.x
	var new_zoom: float = lerpf(current_zoom, _target_zoom, zoom_lerp_speed * delta)
	zoom = Vector2.ONE * new_zoom


## Handles zoom input actions.
func _handle_zoom_input() -> void:
	if Input.is_action_just_pressed("zoom_in"):
		_target_zoom = max(min_zoom, _target_zoom - zoom_speed)

	if Input.is_action_just_pressed("zoom_out"):
		_target_zoom = min(max_zoom, _target_zoom + zoom_speed)


func _initialize_zoom() -> void:
	_target_zoom = max(min_zoom, _target_zoom - zoom_speed)
