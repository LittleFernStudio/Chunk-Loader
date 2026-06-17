class_name ChunkDebugOverlay extends Node2D

## Draws chunk boundaries and labels.

@export var chunk_manager: ChunkManager

@export var chunk_streaming_system: ChunkStreamingSystem

@export var chunk_settings: ChunkSettings

@export var enabled: bool = true


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if not enabled:
		return

	var loaded_chunks: Dictionary = chunk_streaming_system.get_loaded_chunks()

	for coord in loaded_chunks.keys():
		_draw_chunk(coord)


func _draw_chunk(coord: Vector2i) -> void:
	var origin: Vector2 = ChunkCoord.chunk_to_world(coord, chunk_settings.chunk_size)

	var rect: Rect2 = Rect2(origin, Vector2i.ONE * chunk_settings.chunk_size)

	draw_rect(rect, Color.GREEN, false, 2.0)

	var font: Font = ThemeDB.fallback_font

	if font == null:
		return
	var text: String = str(coord)

	var font_size: int = ThemeDB.fallback_font_size

	var text_size: Vector2 = font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size)

	var padding: float = 16.0

	# Top Left
	draw_string(
		font,
		origin + Vector2(padding, padding + text_size.y),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)

	# Top Right
	draw_string(
		font,
		origin + Vector2(rect.size.x - text_size.x - padding, padding + text_size.y),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)

	# Bottom Left
	draw_string(
		font,
		origin + Vector2(padding, rect.size.y - padding),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)

	# Bottom Right
	draw_string(
		font,
		origin + Vector2(rect.size.x - text_size.x - padding, rect.size.y - padding),
		text,
		HORIZONTAL_ALIGNMENT_LEFT,
		-1,
		font_size
	)
