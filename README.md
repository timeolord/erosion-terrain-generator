# Erosion Terrain Generator

A procedural terrain generation and visualization system built with Rust and Bevy, featuring GPU-accelerated hydraulic erosion simulation and level-of-detail rendering.

## Overview

Erosion Terrain Generator is a focused project for procedural terrain creation and realistic erosion simulation. It combines Perlin noise-based terrain generation with GPU-accelerated hydraulic erosion to create natural-looking landscapes with valleys and realistic weathering patterns. The system uses Bevy 0.13 for rendering and handles rendering optimization through dynamic level-of-detail systems.

## Features

Terrain Generation

The application generates large-scale terrains using multiple layers of Perlin noise. The terrain system divides the world into a 16x16 grid of chunks, each containing 128x128 tiles, creating a total world size of 2048x2048 tiles. Terrain generation is parallelized across multiple CPU threads with progress tracking.

Heightmap Erosion

GPU-accelerated hydraulic erosion simulation applies realistic weathering to terrain. The erosion system uses compute shaders to simulate water droplet behavior, calculating sediment transport and terrain modification. Multiple erosion passes can be applied with configurable intensity (0-100).

Level-of-Detail Rendering

The mesh generation system creates 5 levels of detail for each terrain chunk. The renderer dynamically selects the appropriate LOD based on camera distance, reducing polygon count and improving performance. LOD levels range from full detail (LOD 0) to highly simplified geometry (LOD 5).

Dynamic Terrain Features

Terrain type is determined by height and slope angle:

- Grass dominates gentle slopes below certain altitudes
- Dirt appears on steeper terrain
- Stone forms on very steep slopes
- Sand covers remaining high-angle surfaces
- Snow caps high elevations above 150 world units

Water simulation includes a global water level that can be adjusted (0-150 units). The system renders a flat water plane that interacts with the terrain mesh.

Camera System

An orbit camera with custom input handling allows exploration of the generated terrain. Keyboard controls (WASD) navigate the world, middle mouse button orbits the camera, and mouse wheel zooms. The camera automatically maintains terrain clearance and world boundaries.

Save and Load System

Generated terrains can be saved to disk as RON files containing heightmap data and world generation settings. Loading previously saved terrains preserves all generation parameters, allowing iteration on specific seeds and settings.

## Architecture

The codebase is organized into several functional modules:

world_gen - Core terrain generation pipeline including noise generation, heightmap management, mesh generation, and erosion simulation

world - Runtime world state and entity management

camera - Orbit camera controller and raycasting systems

assets - Asset loading pipeline and texture atlas generation for terrain materials

menu - Main menu interface for starting new terrains or loading saves

save - Save file serialization and loading logic

utils - Mathematical utilities and helper functions

debug - Development debugging tools

The application uses a state machine with four main states: AssetLoading, MainMenu, WorldGeneration, and World. Transitions between states manage resource loading and entity spawning.

## Noise Generation

The terrain uses a customizable noise system combining Fbm (fractional Brownian motion) for base terrain with RidgedMulti noise for mountain peaks. A circle-based mask system controls mountain distribution by placing Gaussian circles across the world. Parameters include:

- Seed: Reproducible terrain generation
- Hilliness: 0.0-1.0 blend between flat and hilly terrain
- Mountain Amount: Number of mountain centers (0-10)
- Mountain Size: Radius of mountain clusters (50-200 units)

## Mesh Generation

Mesh vertices are computed from the heightmap with position-dependent terrain texturing. Each tile generates 4 vertices and 2 triangles. Normals are calculated per-quad for smooth lighting. UV coordinates are indexed into a texture atlas containing grass, dirt, stone, and sand materials. Edge meshes connect terrain chunks at world boundaries to prevent gaps.

## GPU Compute

The erosion system uses compute shaders to process the heightmap. A WGSL shader simulates multiple water droplet iterations per dispatch. The shader tracks droplet properties (position, velocity, sediment, water content) and modifies the heightmap based on erosion and deposition logic. Results are staged back to CPU memory for integration into the main heightmap.

## Dependencies

Key dependencies include:

- bevy 0.13 - Game engine and rendering framework
- bevy_app_compute - Compute shader integration
- bevy_egui - UI framework for menus and debug panels
- noise - Perlin and other noise function implementations
- rand/rand_distr - Random number generation
- image - Heightmap and texture processing
- serde/ron - Save file serialization

The project uses Nix for development environment management, providing consistent builds across platforms.

## Building and Running

Install dependencies using the Nix flake or manually with Cargo:

```
cargo run --release
```

Development builds can be run with:

```
cargo run
```

The dev profile enables optimization level 3 for reasonable compile times with faster execution.

## License

This project does not currently specify a license.
