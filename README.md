Maplinks (v 1.0)
===

A common question among RMXP beginners is "how do you connect maps?" or "why are so many teleports needed?". The typical response is one of the following:

* Block off most spaces with terrain and use a few teleport events
* Make the map larger
* Do some event scripting (using a parallel process event to set variables[/list]

These solutions aren't optimal -- causing lag and/or inconvenience for the mapper.

This script is designed to help. Maplinks simplify linking maps together: a single event sets up an entire edge of the map as a teleport to another map. Players trying to leave that edge of the current map are automatically teleported.

All it takes is one event per edge of the map:

![Maplinks screenshot](maplinks.jpg)

Features
---

* easy to setup and use
* save time, and possibly reduce lag
* handles move events (jumping, speed changes, etc)
* doesn't interfere with "normal" teleports


Demo
---
See `demo` directory. Requires RMXP, of course.


Installation
---
Copy the script in `src`, and open the Script Editor within RMXP. At the bottom of the list of classes on the left side of the new window, you'll see one called "Main". Right click on it and select "Insert". In the newly created entry in the list, paste this script.

Note that this script uses the [SDK](http://www.hbgames.org/forums/viewtopic.php?t=1802.0), which must be above this script. When it was developed, SDK 1.5 was the latest version.

To avoid this dependency, remove or comment out the 3 SDK-related lines, including the `end` at the bottom.

Usage
---

To link a map with another on a specific edge (north, east, south or west), create an event with `<maplink>` included in its name on the appropriate edge of the map. (To avoid confusion, maplink events on corners of the map are not valid.) Then, add a teleport ("Transfer Player") command to the event to specify the destination map and other details (e.g. player direction,  fading on/off). If the destination is an east or west edge, then the Y  coordinate is calculated based on the player's Y coordinate when  teleporting; likewise, the X coordinate is calculated automatically when the destination is a north or south edge.
 
Note: unlike normal teleport events, maplinks are activated when the player tries to leave the screen instead of when stepping on the last tile. This  behaviour could be changed, but I feel that it's more natural this way: it leaves the whole map open for actual exploration, instead of "wasting" the outer tiles of a map.
