class_name ChunkManifestEntry extends Resource

## Maps a chunk coordinate to a chunk resource

## World chunk coordinate
@export var coord: Vector2i

## Chunk file path to save resource under
@export_file("*.tres") var path: String
