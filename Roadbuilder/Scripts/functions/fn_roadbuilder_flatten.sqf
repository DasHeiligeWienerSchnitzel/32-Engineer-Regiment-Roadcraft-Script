params ["_vehicle"];

_flattenActive = true;
_vehicle setVariable ["ER32_roadbuilder_bulldozer_flatten",_flattenActive,true];

/*
Starts to scan for "HumpsDirt" Object and will delete and replace it with "Land_DirtPatch_02_F" texture.
*/

while {_flattenActive == true} do {
	
	_flattenActive = _vehicle getVariable ["ER32_roadbuilder_bulldozer_flatten", true];
	
	//Gets relativ forward position to vehicle.

	_posInFrontVehicle = _vehicle getRelPos [5,0];
	
	//Gets nearby HumpsDirt in a 5 meter Radius from the vehicle.
	
	_sandNearby = false;
	if (count ER32_roadbuilder_placedSands >= 0) then {
		{
			if (((_x select 1) distance2D _vehicle) < 5) exitWith {
				_sandNearby = true;
			};
		}forEach ER32_roadbuilder_placedSands;
	};
	
	if (_sandNearby == true) then {
		_dirtPile = [];
		if (count ER32_roadbuilder_placedSands == 1) then {
			_dirtPile = ER32_roadbuilder_placedSands select 0;
		};
		if (count ER32_roadbuilder_placedSands > 1) then {
			_sorted = [ER32_roadbuilder_placedSands, [], {_posInFrontVehicle distance (_x select 1)}, "ASCEND"] call BIS_fnc_sortBy;
			_dirtPile = _sorted select 0;
			
		};
		deleteVehicle (_dirtPile select 0);
		createVehicle ["Land_DirtPatch_02_F", _dirtPile select 1, [], 0, "CAN_COLLIDE"];
		createVehicle ["Land_ClutterCutter_large_F", _dirtPile select 1, [], 0, "CAN_COLLIDE"];
		
		_index = ER32_roadbuilder_placedSands find _dirtPile;
		ER32_roadbuilder_placedSands deleteAt _index;
		publicVariable "ER32_roadbuilder_placedSands";
	};
	
	sleep 0.01;
};
