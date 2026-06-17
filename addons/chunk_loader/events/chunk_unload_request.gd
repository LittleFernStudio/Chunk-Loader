class_name ChunkUnloadRequest extends RefCounted

## Request to unload a chunk.

var coord: Vector2i


func _init(chunk_coord: Vector2i = Vector2i.ZERO) -> void:
	coord = chunk_coord
