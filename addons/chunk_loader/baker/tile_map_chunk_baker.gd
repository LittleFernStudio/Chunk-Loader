@tool
class_name TileMapChunkBaker extends RefCounted

## Converts TileMapLayer data into chunked tile resources used by the runtime streaming system


## Bakes TileMapLayers into chunk resources.
func bake_tile_layers(root: Node, settings: ChunkBakeSettings, chunks: Dictionary) -> void:
	for child: Node in root.get_children():
		if child is TileMapLayer:
			_bake_layer(child, settings, chunks)


## Bake every used cell within a layer
func _bake_layer(layer: TileMapLayer, settings: ChunkBakeSettings, chunks: Dictionary) -> void:
	var used_cells: Array = layer.get_used_cells()

	for world_cell: Vector2i in used_cells:
		_process_tile(layer, world_cell, settings, chunks)


## Convert a tile into chunk relative data
func _process_tile(
	layer: TileMapLayer, world_cell: Vector2i, settings: ChunkBakeSettings, chunks: Dictionary
) -> void:
	var tile_world_position: Vector2 = layer.to_global(layer.map_to_local(world_cell))

	var chunk_coord: Vector2i = ChunkCoord.world_to_chunk(
		tile_world_position, settings.chunk_settings.chunk_size
	)

	var chunk_data: ChunkData = _get_or_create_chunk(chunk_coord, chunks)
	var chunk_layer: ChunkTileLayerData = _get_or_create_layer(layer.name, chunk_data)
	var tile_data: ChunkTileCellData = ChunkTileCellData.new()

	tile_data.source_id = layer.get_cell_source_id(world_cell)
	tile_data.atlas_coords = layer.get_cell_atlas_coords(world_cell)
	tile_data.alternative_tile = layer.get_cell_alternative_tile(world_cell)

	var chunk_origin_world: Vector2 = ChunkCoord.chunk_to_world(
		chunk_coord, settings.chunk_settings.chunk_size
	)

	var chunk_origin_cell: Vector2i = layer.local_to_map(layer.to_local(chunk_origin_world))

	tile_data.local_cell = (world_cell - chunk_origin_cell)

	chunk_layer.cells.append(tile_data)


## Retrieves an existing chunk or creates one.
func _get_or_create_chunk(chunk_coord: Vector2i, chunks: Dictionary) -> ChunkData:
	if chunks.has(chunk_coord):
		return chunks[chunk_coord]

	var chunk_data: ChunkData = ChunkData.new()
	chunk_data.coord = chunk_coord

	chunks[chunk_coord] = chunk_data
	return chunk_data


## Retrieves an existing chunk tile layer or creates one.
func _get_or_create_layer(layer_name: StringName, chunk_data: ChunkData) -> ChunkTileLayerData:
	for layer: ChunkTileLayerData in chunk_data.tile_layers:
		if layer.layer_name == layer_name:
			return layer

	var new_layer: ChunkTileLayerData = ChunkTileLayerData.new()
	new_layer.layer_name = layer_name

	chunk_data.tile_layers.append(new_layer)
	return new_layer
