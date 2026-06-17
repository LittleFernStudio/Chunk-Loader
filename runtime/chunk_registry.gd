class_name ChunkRegistry extends Node

## Stores all chunk data resources.
##
## Does not perform loading/unloading

var _chunks: Dictionary = {}


## Registers a chunk
func register_chunk(chunk_data: ChunkData) -> void:
	_chunks[chunk_data.coord] = chunk_data


## Removes a chunk
func remove_chunk(coord: Vector2i) -> void:
	_chunks.erase(coord)


## Returns true if a chunk exists
func has_chunk(coord: Vector2i) -> bool:
	return _chunks.has(coord)


## Retrieves a chunk.
func get_chunk(coord: Vector2i) -> ChunkData:
	return _chunks.get(coord)


## Number of registered chunks
func get_chunk_count() -> int:
	return _chunks.size()


## Returns all registered chunks
func get_all_chunks() -> Array[ChunkData]:
	var chunks: Array[ChunkData]

	for chunk: ChunkData in _chunks.values():
		chunks.append(chunk)

	return chunks
