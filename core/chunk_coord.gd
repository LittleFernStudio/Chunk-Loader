class_name ChunkCoord extends RefCounted

## Static utility for coordinate maths


## Convert world position to chunk coordinates
static func world_to_chunk(world_position: Vector2, chunk_size: Vector2i) -> Vector2i:
	return Vector2i(
		floori(world_position.x / chunk_size.x), floor(world_position.y / chunk_size.y)
	)


## Convert a chunk coordinate into chunk's bottom-left world position
static func chunk_to_world(chunk_coord: Vector2i, chunk_size: Vector2i) -> Vector2:
	return Vector2(chunk_coord.x * chunk_size.x, chunk_coord.y * chunk_size.y)


## Convert a chunk coordinate into it's world center position
static func chunk_to_world_center(chunk_coord: Vector2i, chunk_size: Vector2i) -> Vector2:
	var world_position: Vector2 = chunk_to_world(chunk_coord, chunk_size)
	return world_position + Vector2(chunk_size) * 0.5


## Returns squared chunk distance used for radius checks
static func distance_squared(a: Vector2i, b: Vector2i) -> int:
	return (a - b).length_squared()
