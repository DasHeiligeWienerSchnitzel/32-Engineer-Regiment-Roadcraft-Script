/*
Add here the classnames for the switches and zones for the bulldozer spawners and sandFillers.
*/

_fillTruckZones = [filler_zone];
_fillTruckSwitches = [filler_switch];

_bulldozer_spawners = [bulldozer_spawner];
_bulldozer_spawnpoints = [bulldozer_spawnpoint];


//-------------------------------------------------------------------------------------------------


[_fillTruckZones,_fillTruckSwitches,_bulldozer_spawners,_bulldozer_spawnpoints] execVM "ER32_buildRoad_interactions.sqf";
