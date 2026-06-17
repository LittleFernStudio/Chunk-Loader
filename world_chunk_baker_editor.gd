@tool
extends EditorInspectorPlugin


func _can_handle(object: Object) -> bool:
	return object is WorldChunkBaker


func _parse_begin(object: Object) -> void:
	var button: Button = Button.new()

	button.text = "Bake World"
	button.pressed.connect(func() -> void: object.bake_world())

	add_custom_control(button)
