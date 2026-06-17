class_name ChunkDatabase extends Node

## Provides a runtime access to baked chunks

@export var manifest: ChunkManifest

var _entry_lookup: Dictionary = {}


func _ready() -> void:
	if manifest == null:
		push_error("ChunkDatabase: Manifest is null.")
		return

	_build_lookup()


## Creates a lookup table for faster coordinate lookups
func _build_lookup() -> void:
	_entry_lookup.clear()

	for entry: ChunkManifestEntry in manifest.entries:
		_entry_lookup[entry.coord] = entry


## Exposes whether there are any entries that match a coordinate
func has_chunk(coord: Vector2i) -> bool:
	return _entry_lookup.has(coord)


## Get chunk data given a coordinate
func load_chunk(coord: Vector2i) -> ChunkData:
	var path: String = get_chunk_path(coord)

	if path.is_empty():
		return null

	return load(path) as ChunkData


## Get a chunk resource path given a coordinate. Returns empty string if not found
func get_chunk_path(coord: Vector2i) -> String:
	var entry: ChunkManifestEntry = _entry_lookup.get(coord)

	if entry == null:
		return ""

	return entry.path
