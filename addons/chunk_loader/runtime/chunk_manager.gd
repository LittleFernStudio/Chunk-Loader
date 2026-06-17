class_name ChunkManager extends Node

## Updates visible chunks based on visible radius around the viewer

signal viewer_chunk_changed(old_coord: Vector2i, new_coord: Vector2i)
signal viewer_chunk_initialized(chunk_coord: Vector2i)

@export var chunk_settings: ChunkSettings
@export var chunk_event_bus: ChunkEventBus

## Usually set to the player, but could be anything
@export var viewer: Node2D

## Number of chunks around the viewer that should be loaded in a radius
@export_range(0, 100) var visible_radius: int = 2

var _current_chunk: Vector2i
var _visible_chunks: Dictionary = {}
var _initialized: bool = false


func _ready() -> void:
	if viewer == null:
		push_error("ChunkManager: Viewer is not assigned")
		return

	call_deferred("_initialize")


func _initialize() -> void:
	_update_viewer_chunk(true)


func _process(_delta: float) -> void:
	_update_viewer_chunk()


func _update_viewer_chunk(force_initialize: bool = false) -> void:
	var new_chunk: Vector2i = ChunkCoord.world_to_chunk(viewer.global_position, chunk_settings.chunk_size)

	if force_initialize:
		_current_chunk = new_chunk
		_initialized = true

		viewer_chunk_initialized.emit(new_chunk)
		_update_visible_chunks()
		return

	if not _initialized:
		_current_chunk = new_chunk
		_initialized = true

		viewer_chunk_initialized.emit(new_chunk)
		return

	if new_chunk == _current_chunk:
		return

	var old_chunk: Vector2i = _current_chunk

	_current_chunk = new_chunk

	viewer_chunk_changed.emit(old_chunk, new_chunk)
	_update_visible_chunks()


## Returns all chunks that should currently be visible.
func get_visible_chunks() -> Array[Vector2i]:
	var visible_chunks: Array[Vector2i]

	for x in range(-visible_radius, visible_radius + 1):
		for y in range(-visible_radius, visible_radius + 1):
			var coord: Vector2i = _current_chunk + Vector2i(x, y)

			if (coord - _current_chunk).length_squared() <= (visible_radius * visible_radius):
				visible_chunks.append(coord)

	return visible_chunks


## Updates all visible chunks that should be visible
func _update_visible_chunks() -> void:
	var new_visible: Dictionary = {}

	for coord in get_visible_chunks():
		new_visible[coord] = true

		if not _visible_chunks.has(coord):
			var request: ChunkLoadRequest = ChunkLoadRequest.new(coord)
			chunk_event_bus.chunk_load_requested.emit(request)

	for coord in _visible_chunks.keys():
		if not new_visible.has(coord):
			var request: ChunkUnloadRequest = ChunkUnloadRequest.new(coord)
			chunk_event_bus.chunk_unload_requested.emit(request)

	_visible_chunks = new_visible


func debug_print_visible_chunks() -> void:
	for coord in _visible_chunks.keys():
		print("-- Visible Chunk: ", coord)
