class_name ChunkSceneData extends Resource

## Scenes that belong to a chunk.
##
## Sotred by the chunk baker and instantiated by SceneStreamingSystem

## Scene to be loaded/unloaded
@export var scene: PackedScene

## Position relative to the chunk origin
@export var local_position: Vector2

## Unique identifier for save system
@export var id: StringName
