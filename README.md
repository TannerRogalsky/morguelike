# Codename: Morguelike
A roguelike.

## Class Overview
* **Map**: Encapsulates a grid of a given width and height. Also has an x and y position and a width and height for the tiles of the grid. The grid is just a 2D data structure. The map has all the actual game info.
* **MapTile**: What the map's grid is actually made of. These know their parent map, their x and y positions on the grid and the contents of that tile, which should be a collection of MapEntities.
* **MapEntity**: An object that lives on the map. It is the main rendering component for the map. It has an x, y, width, and height, all of which are in grid coordinates. It can take up multiple consecutive map tiles. It also has a z-index for rendering.
