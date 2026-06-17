class_name TileStreamingSystem extends Node

## Streams baked tile data into runtime TileMapLayers.
##
## For each layer type there exists ONE TileMapLayer. NOT one per chunk

@export var chunk_event_bus: ChunkEventBus

## Parent for all tile layers
@export var tile_layers_root: Node

@export var chunk_settings: ChunkSettings

## Keeps track of which cells belong to which chunk
var _loaded_tiles: Dictionary[Vector2i, Array] = {}


func _ready() -> void:
	if tile_layers_root == null:
		push_error("TileStreamingSystem: TileLayersRoot is null.")
		return

	if chunk_event_bus == null:
		push_error("TileStreamingSystem: ChunkEventBus is null")
		return

	chunk_event_bus.chunk_loaded.connect(_on_chunk_loaded)
	chunk_event_bus.chunk_unloaded.connect(_on_chunk_unloaded)


## Applies all baked tiles for a chunk
func _on_chunk_loaded(event: ChunkLoadedEvent) -> void:
	var chunk_data: ChunkData = event.chunk_data

	var loaded_chunk_cells: Array = []

	for layer_data: ChunkTileLayerData in chunk_data.tile_layers:
		var runtime_layer: Node = tile_layers_root.get_node_or_null(String(layer_data.layer_name))

		if runtime_layer == null:
			push_warning(
				"TileStreamingSystem: Missing runtime TileMapLayer: %s" % layer_data.layer_name
			)
			continue

		var chunk_origin_world: Vector2 = ChunkCoord.chunk_to_world(
			chunk_data.coord, chunk_settings.chunk_size
		)

		var chunk_origin_cell: Vector2i = runtime_layer.local_to_map(
			runtime_layer.to_local(chunk_origin_world)
		)

		for cell_data: ChunkTileCellData in layer_data.cells:
			var world_cell: Vector2i = chunk_origin_cell + cell_data.local_cell

			runtime_layer.set_cell(
				world_cell, cell_data.source_id, cell_data.atlas_coords, cell_data.alternative_tile
			)

			loaded_chunk_cells.append({"layer": runtime_layer, "cell": world_cell})

	_loaded_tiles[chunk_data.coord] = loaded_chunk_cells


## Removes all streamed tiles belonging to a chunk.
func _on_chunk_unloaded(event: ChunkUnloadedEvent) -> void:
	var chunk_data: ChunkData = event.chunk_data

	if not _loaded_tiles.has(chunk_data.coord):
		return

	for entry in _loaded_tiles[chunk_data.coord]:
		var layer: TileMapLayer = entry["layer"]
		var cell: Vector2i = entry["cell"]

		layer.erase_cell(cell)

	_loaded_tiles.erase(chunk_data.coord)
