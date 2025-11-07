/*
Add here the classnames for the switches and zones for the bulldozer spawners and sandFillers.
*/

_fillTruckZones = [filler_zone_1,filler_zone_2];
_fillTruckSwitches = [filler_switch_1,filler_switch_2];

_bulldozer_spawners = [bulldozer_spawner_1,bulldozer_spawner_2];
_bulldozer_spawnpoints = [bulldozer_spawnpoint_1,bulldozer_spawnpoint_2];


//-------------------------------------------------------------------------------------------------


_scriptHandler_ER32_buildRoad_interactions = [_fillTruckSwitches,_bulldozer_spawners,_bulldozer_spawnpoints,_fillTruckZones] execVM "ER32_buildRoad_interactions.sqf";
