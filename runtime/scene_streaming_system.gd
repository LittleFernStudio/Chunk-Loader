class_name SceneStreamingSystem extends Node

## Instantiates and destroys scene content when chunks load and unload

@export var chunk_streaming_system: ChunkStreamingSystem

@export var chunk_event_bus: ChunkEventBus

@export var chunk_settings: ChunkSettings

## Parent for all streamed content
@export var streamed_content_root: Node

## Key: ChunkCoord, Value: Array[Node]
var _spawned_scene_nodes: Dictionary = {}


func _ready() -> void:
	if chunk_streaming_system == null:
		push_error("SceneStreamingSystem: ChunkStreamingSystem is null.")
		return

	if streamed_content_root == null:
		push_error("SceneStreamingSystem: StreamedContentRoot is null.")
		return

	if chunk_event_bus == null:
		push_error("SceneStreamingSystem: ChunkEventBus is null")
		return

	chunk_event_bus.chunk_loaded.connect(_on_chunk_loaded)
	chunk_event_bus.chunk_unloaded.connect(_on_chunk_unloaded)


## Instantiate PackedScene for all scenes in the chunk
func _on_chunk_loaded(event: ChunkLoadedEvent) -> void:
	var chunk_data: ChunkData = event.chunk_data

	var nodes: Array[Node] = []

	var chunk_origin: Vector2 = ChunkCoord.chunk_to_world(
		chunk_data.coord, chunk_settings.chunk_size
	)

	for scene_data in chunk_data.scenes:
		if scene_data.scene == null:
			continue

		var instance := scene_data.scene.instantiate()

		if instance is Node2D:
			instance.global_position = (chunk_origin + scene_data.local_position)

		streamed_content_root.add_child(instance)

		nodes.append(instance)

	_spawned_scene_nodes[chunk_data.coord] = nodes


## Destroy scene when unloaded
func _on_chunk_unloaded(event: ChunkUnloadedEvent) -> void:
	var chunk_data: ChunkData = event.chunk_data

	if not _spawned_scene_nodes.has(chunk_data.coord):
		return

	for node in _spawned_scene_nodes[chunk_data.coord]:
		if is_instance_valid(node):
			node.queue_free()

	_spawned_scene_nodes.erase(chunk_data.coord)
