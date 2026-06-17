class_name ChunkBakeSettings extends Resource

## Settings used for baking

@export var chunk_settings: ChunkSettings

## Root containing TileMapLayers
@export var tile_layers_root: NodePath

## Root containing scene instances
@export var world_objects_root: NodePath

## Where you want the individual chunks to saved at.
## Along with the chunk manifest file
@export_dir var output_directory: String = "res://addons/chunk_loader/chunks"
