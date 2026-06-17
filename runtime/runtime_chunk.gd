class_name RuntimeChunk extends RefCounted

## Runtime-only state for a loaded chunk. Never saved, only runtime
##
## Keeps runtime data separate from baked data

enum State { UNLOADED, LOADING, LOADED, UNLOADING }

## World coordinate of chunk
var coord: Vector2i

var chunk_data: ChunkData

var spawned_nodes: Array[Node] = []

var state: State = State.LOADING

var load_frame: int = -1

var unload_frame: int = -1

## Last loaded time in the current Unix timestamp in seconds based on the system time in UTC
var last_loaded_time: float = 0.0

## Last unloaded time in the current Unix timestamp in seconds based on the system time in UTC
var last_unloaded_time: float = 0.0


func is_loaded() -> bool:
	return state == State.LOADED


func is_loading() -> bool:
	return state == State.LOADING


func is_unloading() -> bool:
	return state == State.UNLOADING
