class_name ChunkTileCellData extends Resource

## Data for a single baked tile in a chunk

## Cell coordinates relative to the chunk
@export var local_cell: Vector2i

## Tile source ID of the cell at coords
@export var source_id: int = -1

## Tile atlas coordinates
@export var atlas_coords: Vector2i = Vector2i.ZERO

## Alternative ID of the tile
@export var alternative_tile: int = 0
