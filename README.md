# Godot Chunk Loader
To support large game worlds without sacrificing performance, I developed a chunk loading system for my game and I want to share that technology with you.

As the player moves through the world, the system continuously determines which chunks should exist based on a configurable loading radius.

## TileMapLayer Streaming

The chunk loader supports dynamic streaming of TileMapLayer tile data. When a chunk enters the active range, its tile data is loaded into the appropriate TileMapLayers. When a chunk leaves the active range, its tiles are removed from memory.

This allows the game to render only the terrain surrounding the player instead of loading the entire world at once. The result is significantly lower memory usage and improved performance, even with large open worlds

## Scene-Based Object Streaming

In addition to terrain streaming, the system supports loading and unloading scenes as resources.

Each chunk contains references to scene resources representing world objects such as:

* Trees
* Mushrooms
* Rocks
* Decorations
* Buildings
* Interactable objects

When a chunk becomes active, the associated scene resources are instantiated and added to the world. When the chunk is unloaded, those instances are automatically removed.

Because objects are stored as resource references rather than permanently existing in the scene tree, thousands of potential world objects can be managed while only a small subset remains active at any given time.
