class_name ChunkStreamingSystem extends Node

## Listens for chunk visibility changes and loads/unloads chunk data.

@export var chunk_event_bus: ChunkEventBus
@export var chunk_registry: ChunkRegistry
@export var chunk_database: ChunkDatabase

## Dictionary lookup for runtime chunks
var _runtime_chunks: Dictionary[Vector2i, RuntimeChunk] = {}

## Stores the coordinates of a chunk to load
var _load_queue: Array[Vector2i] = []

## Stores the coordinates of a chunk to unload
var _unload_queue: Array[Vector2i] = []


func _process(_delta: float) -> void:
	_process_load_queue()
	_process_unload_queue()


func _ready() -> void:
	if chunk_event_bus == null:
		push_error("ChunkStreamingSystem: ChunkEventBus is null")
		return

	if chunk_registry == null:
		push_error("ChunkStreamingSystem: ChunkRegistry is null")
		return

	if chunk_database == null:
		push_error("ChunkStreamingSystem: ChunkDatabase is null")
		return

	chunk_event_bus.chunk_load_requested.connect(_on_chunk_load_requested)
	chunk_event_bus.chunk_unload_requested.connect(_on_chunk_unload_requested)


## Adds requested coordinate to teh load queue to be processed
func _on_chunk_load_requested(request: ChunkLoadRequest) -> void:
	if _runtime_chunks.has(request.coord):
		return

	if request.coord in _load_queue:
		return

	_load_queue.append(request.coord)


## Adds requested coordinate to the unload queue to be processed
func _on_chunk_unload_requested(request: ChunkUnloadRequest) -> void:
	if request.coord in _unload_queue:
		return

	_unload_queue.append(request.coord)


## Returns the runtime chunk if loaded.
func get_runtime_chunk(coord: Vector2i) -> RuntimeChunk:
	return _runtime_chunks.get(coord)


func _process_load_queue() -> void:
	if _load_queue.is_empty():
		return

	var coord: Vector2i = _load_queue.pop_front()

	_load_chunk_from_coord(coord)


func _process_unload_queue() -> void:
	if _unload_queue.is_empty():
		return

	var coord: Vector2i = _unload_queue.pop_front()

	_unload_chunk_from_coord(coord)


## Load chunk at given coordinate
func _load_chunk_from_coord(coord: Vector2i) -> void:
	if not chunk_registry.has_chunk(coord):
		var db_chunk_data: ChunkData = chunk_database.load_chunk(coord)

		if db_chunk_data == null:
			return

		chunk_registry.register_chunk(db_chunk_data)

	var chunk_data: ChunkData = chunk_registry.get_chunk(coord)

	var runtime_chunk := RuntimeChunk.new()

	runtime_chunk.coord = coord
	runtime_chunk.chunk_data = chunk_data
	runtime_chunk.state = RuntimeChunk.State.LOADING

	_runtime_chunks[coord] = runtime_chunk

	runtime_chunk.state = RuntimeChunk.State.LOADED
	runtime_chunk.load_frame = Engine.get_process_frames()
	runtime_chunk.last_loaded_time = Time.get_unix_time_from_system()

	var event := ChunkLoadedEvent.new(chunk_data)

	chunk_event_bus.chunk_loaded.emit(event)


## Unloads a chunk at given world coordinate
func _unload_chunk_from_coord(coord: Vector2i) -> void:
	if not _runtime_chunks.has(coord):
		return

	var runtime_chunk: RuntimeChunk = _runtime_chunks[coord]

	runtime_chunk.state = RuntimeChunk.State.UNLOADING
	runtime_chunk.unload_frame = Engine.get_process_frames()
	runtime_chunk.last_unloaded_time = Time.get_unix_time_from_system()

	var event := ChunkUnloadedEvent.new(runtime_chunk.chunk_data)

	chunk_event_bus.chunk_unloaded.emit(event)

	chunk_registry.remove_chunk(coord)

	_runtime_chunks.erase(coord)


## Used by debug overlay to show what is currently visible
func get_loaded_chunks() -> Dictionary[Vector2i, RuntimeChunk]:
	return _runtime_chunks


## Used by tests only
func get_loaded_chunk_count() -> int:
	return _runtime_chunks.size()
