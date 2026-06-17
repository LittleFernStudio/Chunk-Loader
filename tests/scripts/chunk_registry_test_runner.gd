extends Node

@export var chunk_registry: ChunkRegistry


func _ready() -> void:
	_run_chunk_registry_tests()
	_run_chunk_coordinate_tests()


func _run_chunk_registry_tests() -> void:
	print("")
	print("Chunk Registry Tests")

	var chunk_a: ChunkData = ChunkData.new()
	chunk_a.coord = Vector2i(0, 0)

	var chunk_b: ChunkData = ChunkData.new()
	chunk_b.coord = Vector2i(1, 0)

	var chunk_c: ChunkData = ChunkData.new()
	chunk_c.coord = Vector2i(5, 3)

	chunk_registry.register_chunk(chunk_a)
	chunk_registry.register_chunk(chunk_b)
	chunk_registry.register_chunk(chunk_c)

	assert(chunk_registry.get_chunk_count() == 3)

	assert(chunk_registry.has_chunk(Vector2i(0, 0)))
	assert(chunk_registry.has_chunk(Vector2i(1, 0)))
	assert(chunk_registry.has_chunk(Vector2i(5, 3)))

	assert(chunk_registry.get_chunk(Vector2i(1, 0)).coord == Vector2i(1, 0))

	print("Chunk count: ", chunk_registry.get_chunk_count())
	print("All registry tests passed.")


func _run_chunk_coordinate_tests() -> void:
	print("")
	print("Coordinate conversion tests.")

	var chunk_size: Vector2i = Vector2i(30, 30)

	assert(ChunkCoord.world_to_chunk(Vector2(0, 0), chunk_size) == Vector2i(0, 0))

	assert(ChunkCoord.world_to_chunk(Vector2(29.9, 29.9), chunk_size) == Vector2i(0, 0))

	assert(ChunkCoord.world_to_chunk(Vector2(30, 30), chunk_size) == Vector2i(1, 1))

	assert(ChunkCoord.world_to_chunk(Vector2(60, 0), chunk_size) == Vector2i(2, 0))

	assert(ChunkCoord.world_to_chunk(Vector2(-1, 0), chunk_size) == Vector2i(-1, 0))
	assert(ChunkCoord.world_to_chunk(Vector2(-30, 0), chunk_size) == Vector2i(-1, 0))
	assert(ChunkCoord.world_to_chunk(Vector2(-31, 0), chunk_size) == Vector2i(-2, 0))

	assert(ChunkCoord.world_to_chunk(Vector2(0, -1), chunk_size) == Vector2i(0, -1))
	assert(ChunkCoord.world_to_chunk(Vector2(0, -30), chunk_size) == Vector2i(0, -1))
	assert(ChunkCoord.world_to_chunk(Vector2(0, -31), chunk_size) == Vector2i(0, -2))

	print("Coordinate conversion tests passed.")
