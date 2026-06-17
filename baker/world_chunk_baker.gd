@tool
class_name WorldChunkBaker extends Node

## Used to bake world chunks into chunk resources

@export var bake_settings: ChunkBakeSettings


## Invoked from the inspector button.
func bake_world() -> void:
	if not Engine.is_editor_hint():
		return

	if bake_settings == null:
		push_error("Missing bake settings.")
		return

	var baker: ChunkBaker = ChunkBaker.new()

	var result: ChunkBakeResult = baker.bake_world(self, bake_settings)

	var toaster = EditorInterface.get_editor_toaster()
	toaster.push_toast(
		(
			"Successfully Baked "
			+ str(result.baked_chunk_count)
			+ " Chunks and "
			+ str(result.baked_scene_count)
			+ " Scenes and Saved to folder: "
			+ bake_settings.output_directory
		)
	)
