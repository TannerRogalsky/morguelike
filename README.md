# Codename: Morguelike
A roguelike.

## Class Overview
* **Map**: Encapsulates a grid of a given width and height. Also has an x and y position and a width and height for the tiles of the grid. The grid is just a 2D data structure. The map has all the actual game info.
* **MapTile**: What the map's grid is actually made of. These know their parent map, their x and y positions on the grid and the contents of that tile, which should be a collection of MapEntities.
* **MapEntity**: An object that lives on the map. It is the main rendering component for the map. It has an x, y, width, and height, all of which are in grid coordinates. It can take up multiple consecutive map tiles. It also has a z-index for rendering.

## TODO
* The replay system needs an overhaul (surprise, surprise). The issue is that I don't think you can just emit the key events and have the game handle it without checking each time if you're in the replay state. Also, having to reimplement all the game logic for rendering and responding to those key events in the replay state might be too much. The easy solution would just be to check on each input and not have a replay state, just a boolean trigger inside the main state. Messy and bad style but so much easier.
* The UI aspect needs a lot of work. This is just in general. Should be modularized for other uses.
