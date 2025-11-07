params ["_vehicle"];

_flattenActive = _vehicle getVariable ["ER32_roadcraft_bulldozer_flatten",true];

/*
Starts to scan for "HumpsDirt" Object and will delete and replace it with "Land_DirtPatch_02_F" texture.
*/

while {_flattenActive == true} do {

	//Gets relativ forward position to vehicle.

	_posInFrontVehicle = _vehicle getRelPos [5,0];
	
	//Gets nearby HumpsDirt in a 5 meter Radius from the vehicle.
	
	_nearbyDirtPiles = _vehicle nearObjects ["HumpsDirt",5];
	
	/*
	Now will delete the collected objects and replace it with the dirt texture.
	If only one object detected it will just take that, but
	if more than one object was detected, it will delete the closest one.
	*/
	
	if (count _nearbyDirtPiles == 1) then {
		_dirtPile = _nearbyDirtPiles select 0;
		_posDirtPile = getPosATL _dirtPile;
		deleteVehicle _dirtPile;
		createVehicle ["Land_DirtPatch_02_F", _posDirtPile, [], 0, "CAN_COLLIDE"];
		createVehicle ["Land_ClutterCutter_large_F", _posDirtPile, [], 0, "CAN_COLLIDE"];
	};
	if (count _nearbyDirtPiles > 1) then {
		_sorted = [[_nearbyDirtPiles], [], {_posInFrontVehicle distance _x}, "ASCEND"] call BIS_fnc_sortBy;
		_dirtPile = _sorted select 0;
		_posDirtPile = getPosATL _dirtPile;
		deleteVehicle _dirtPile;
		createVehicle ["Land_DirtPatch_02_F", _posDirtPile, [], 0, "CAN_COLLIDE"];
		createVehicle ["Land_ClutterCutter_large_F", _posDirtPile, [], 0, "CAN_COLLIDE"];
	};
	sleep 0.01;
};
