class_name ChunkData extends Resource

## Contains chunk data including tile and scene data

## World coordinate this chunk exists at
@export var coord: Vector2i

## All scenes in this chunk
@export var scenes: Array[ChunkSceneData] = []

## TileMap data grouped by layer.
@export var tile_layers: Array[ChunkTileLayerData] = []

## Can be used to update only parts of your world based on chunk versions
@export var version: int = 1
