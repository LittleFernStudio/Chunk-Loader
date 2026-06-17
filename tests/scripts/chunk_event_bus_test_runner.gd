extends Node

@export var chunk_event_bus: ChunkEventBus

@export var chunk_streaming_system: ChunkStreamingSystem


func _ready() -> void:
	chunk_event_bus.chunk_load_requested.connect(_on_load_requested)
	chunk_event_bus.chunk_unload_requested.connect(_on_unload_requested)

	chunk_event_bus.chunk_loaded.connect(_on_chunk_loaded)
	chunk_event_bus.chunk_unloaded.connect(_on_chunk_unloaded)


func _on_load_requested(request: ChunkLoadRequest) -> void:
	print("LOAD REQUEST: ", request.coord)


func _on_unload_requested(request: ChunkUnloadRequest) -> void:
	print("UNLOAD REQUEST: ", request.coord)


func _on_chunk_loaded(event: ChunkLoadedEvent) -> void:
	print("LOADED: ", event.chunk_data.coord)

	print("Loaded Count: ", chunk_streaming_system.get_loaded_chunk_count())


func _on_chunk_unloaded(event: ChunkUnloadedEvent) -> void:
	print("UNLOADED: ", event.chunk_data.coord)

	print("Loaded Count: ", chunk_streaming_system.get_loaded_chunk_count())
