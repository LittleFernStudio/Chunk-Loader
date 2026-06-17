extends Node

@export var chunk_manager: ChunkManager


func _ready() -> void:
	chunk_manager.viewer_chunk_changed.connect(_on_viewer_chunk_changed)
	chunk_manager.viewer_chunk_initialized.connect(_on_viewer_chunk_initialized)


func _on_viewer_chunk_changed(old_coord: Vector2i, new_coord: Vector2i) -> void:
	print("Viewer moved from ", old_coord, " -> ", new_coord)
	chunk_manager.debug_print_visible_chunks()


func _on_viewer_chunk_initialized(coord: Vector2i) -> void:
	print("Viewer initialized at: ", coord)
	chunk_manager.debug_print_visible_chunks()
