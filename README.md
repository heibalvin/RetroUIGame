# RetroUIGame

Using Swift, SwiftUI and SpriteKit to remake old 80s games (arcade, nes, master system, amstrad cpc, ...)

Highly inspired by [Code In Complete](https://codeincomplete.com/).

## Swift UI

Create a Photo Gallery of best Arcade Games. Images comes from .
We then have resized images as a thumbnail format (120x)using [Image Resizer](https://imageresizer.com/bulk-resize).

## Retro Game Engine

Components:
 * SKTileMap
 * SKTileLayer
 * SKTileSet
 * SKTileNode
 * SKTile
 * SKTileLayout
 * SKTileComponent
 * SKTileSprite

SKTileLayer: returns a Bitmap which is composed of a standard SKTile. Each columns and row refers to a Graphic ID (gid), corresponding to a SKTileSet bitmap (tilewidth, tileheight). 
 * set / get / rem will update the tile gid and bitmap.
 * add will remove tile before setting a new one.
 * toJSON / fromTiled / toTiled / update to read / save to Tiled JSON format.
 * coord2index / coord2position helper functions to transfor (col, row) coord to index or pixel coordinate.
 * setTile / remTile for MetaTile management
 * addMetaTile / moveMetaTile for seamlessly update MetaTile.

All 3 components (SKTileMap)will have multiple functions toJSON(), toTiled() and fromTiled(<TiledObject>).

Tiled Components to Import / Export to Tiled JSON format.
 * TiledMap
 * TiledLayer
 * TiledSet
 
## 9: Frogger

Reference:
 * [Pixelated Arcade](https://www.pixelatedarcade.com/games/frogger/screenshots)
 * [The Spriters Resource](https://www.spriters-resource.com/arcade/frogger/)
 * [Strategy Wiki](https://strategywiki.org/wiki/Frogger)


