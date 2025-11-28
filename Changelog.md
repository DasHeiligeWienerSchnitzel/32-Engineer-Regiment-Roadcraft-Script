# Version 1.1
###### Fixes
- Fixed a problem, where on a dedicated server, the ace self interaction for dropping sand would not show.
- Fixed a problem, where the truck would stay unsimulated if trying to refill, when already full.

# Version 1.0
Release Version with main functions and mp compatibility.

###### Changed
* Rewritten script to enable multiplayer compatiblity.
* Rewritten script to use functions properly.

---

# Version 0.9

###### Added
* New file "ER32_buildRoad_interactions.sqf". Holds all the ace interactions.
###### Changed
* Renamed script from **roadcraft** to **buildRoad**.
* Rewrote the code to make it support multiple classnames for spawning bulldozers and filling Trucks.
* "Init.sqf" now holds the parameters and initialises the other scripts.
###### Removed
* Removed the "ER32_buildRoad_bulldozer_spawn.sqf" file, as its functionality was moved to the "ER32_buildRoad_interactions.sqf" file.
