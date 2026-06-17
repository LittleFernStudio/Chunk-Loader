class_name ChunkUnloadedEvent extends RefCounted

## Raised when a chunk has completed unloading.

var chunk_data: ChunkData


func _init(data: ChunkData = null) -> void:
	chunk_data = data
