class_name ChunkEventBus extends Node

## Central signal communication hub for chunk systems.

@warning_ignore("unused_signal")
signal chunk_load_requested(request: ChunkLoadRequest)

@warning_ignore("unused_signal")
signal chunk_unload_requested(request: ChunkUnloadRequest)

@warning_ignore("unused_signal")
signal chunk_loaded(event: ChunkLoadedEvent)

@warning_ignore("unused_signal")
signal chunk_unloaded(event: ChunkUnloadedEvent)
