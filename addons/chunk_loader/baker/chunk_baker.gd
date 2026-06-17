@tool
class_name ChunkBaker extends RefCounted

## Converts editor placed scenes and tiles into chunk resources for runtime streaming

var _tile_baker: TileMapChunkBaker = TileMapChunkBaker.new()


func bake_world(world_root: Node, settings: ChunkBakeSettings) -> ChunkBakeResult:
	var result: ChunkBakeResult = ChunkBakeResult.new()

	if world_root == null:
		push_error("ChunkBaker: World Root is null")
		return result

	if settings == null:
		push_error("ChunkBaker: Settings are null")
		return result

	var tile_root: Node = world_root.get_node_or_null(settings.tile_layers_root)
	var object_root: Node = world_root.get_node_or_null(settings.world_objects_root)

	if object_root == null:
		push_error("ChunkBaker: Settings - World Objects Root is null")
		return result

	if tile_root == null:
		push_error("ChunkBaker: Settings - Tile Layers Root is null")
		return result

	var chunks: Dictionary = {}

	_collect_scene_nodes(object_root, settings, chunks, result)
	_tile_baker.bake_tile_layers(tile_root, settings, chunks)
	_save_chunks(chunks, settings, result)

	return result


## Recursively goes through scene tree and assigns Node2D instances to chunks
func _collect_scene_nodes(
	node: Node, settings: ChunkBakeSettings, chunks: Dictionary, result: ChunkBakeResult
) -> void:
	if node is Node2D:
		_process_scene_node(node, settings, chunks, result)

	for child: Node in node.get_children():
		_collect_scene_nodes(child, settings, chunks, result)


## Converts a scene into ChunkSceneData
func _process_scene_node(
	node: Node2D, settings: ChunkBakeSettings, chunks: Dictionary, result: ChunkBakeResult
) -> void:
	# Ignore nodes that are not scenes
	if node.scene_file_path.is_empty():
		return

	var chunk_coord: Vector2i = ChunkCoord.world_to_chunk(
		node.global_position, settings.chunk_settings.chunk_size
	)
	var chunk_data: ChunkData = _get_or_create_chunk(chunk_coord, chunks)
	var scene_resource: PackedScene = load(node.scene_file_path) as PackedScene

	if scene_resource == null:
		push_error("ChunkBaker: Failed to process node at path: %s", node.scene_file_path)
		return

	var scene_data: ChunkSceneData = ChunkSceneData.new()
	scene_data.scene = scene_resource

	var chunk_origin: Vector2 = ChunkCoord.chunk_to_world(
		chunk_coord, settings.chunk_settings.chunk_size
	)

	scene_data.local_position = (node.global_position - chunk_origin)
	scene_data.id = StringName(node.name)

	chunk_data.scenes.append(scene_data)

	result.baked_scene_count += 1


## Returns an existing chunk or creates a new one
func _get_or_create_chunk(chunk_coord: Vector2i, chunks: Dictionary) -> ChunkData:
	if chunks.has(chunk_coord):
		return chunks[chunk_coord]

	var chunk: ChunkData = ChunkData.new()
	chunk.coord = chunk_coord

	chunks[chunk_coord] = chunk
	return chunk


## Saves all generated chunk resources and creates a manifest of all chunks
func _save_chunks(
	chunks: Dictionary, settings: ChunkBakeSettings, result: ChunkBakeResult
) -> void:
	# Create chunk output folder if does not exist
	if not DirAccess.dir_exists_absolute(settings.output_directory):
		DirAccess.make_dir_absolute(settings.output_directory)

	var manifest: ChunkManifest = ChunkManifest.new()
	for chunk: ChunkData in chunks.values():
		var file_path: String = (
			(settings.output_directory + "/%s_%s.tres") % [chunk.coord.x, chunk.coord.y]
		)

		var save_result := ResourceSaver.save(chunk, file_path)

		if save_result != OK:
			push_error("ChunkBaker: Failed to save chunk at path: %s" % file_path)
			continue

		var entry: ChunkManifestEntry = ChunkManifestEntry.new()
		entry.coord = chunk.coord
		entry.path = file_path
		manifest.entries.append(entry)

		result.baked_chunk_count += 1

	var manifest_path: String = settings.output_directory + "/chunk_manifest.tres"
	var manifest_save_result := ResourceSaver.save(manifest, manifest_path)

	if manifest_save_result != OK:
		push_error("ChunkBaker: Failed to save chunk manifest file at path: %s" % manifest_path)
		return
