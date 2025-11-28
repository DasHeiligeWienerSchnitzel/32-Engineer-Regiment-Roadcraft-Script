/*
Add here the classnames for the switches and zones for the bulldozer spawners and sandFillers.
*/

private _fillTruckZones = [filler_zone];
private _fillTruckSwitches = [filler_switch];

private _bulldozer_spawners = [bulldozer_spawner];
private _bulldozer_spawnpoints = [bulldozer_spawnpoint];


//-------------------------------------------------------------------------------------------------


[_fillTruckZones,_fillTruckSwitches,_bulldozer_spawners,_bulldozer_spawnpoints] execVM "Scripts\ER32_roadbuilder_interactions.sqf";
