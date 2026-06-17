class_name ChunkLoadedEvent extends RefCounted

## Raised when a chunk has completed loading.

var chunk_data: ChunkData


func _init(data: ChunkData = null) -> void:
	chunk_data = data
