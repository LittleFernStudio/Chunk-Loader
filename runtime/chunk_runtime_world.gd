@tool
class_name ChunkRuntimeWorld extends Node

## Composition root for all chunk systems related to running the game after it has been baked.
##
## Be sure to use the WorldCunkBaker before attempting to run the world

@export var chunk_event_bus: ChunkEventBus

@export var chunk_database: ChunkDatabase

@export var chunk_registry: ChunkRegistry

@export var chunk_manager: ChunkManager

@export var chunk_streaming_system: ChunkStreamingSystem

@export var scene_streaming_system: SceneStreamingSystem

@export var tile_streaming_system: TileStreamingSystem

@export var chunk_debug_overlay: ChunkDebugOverlay
