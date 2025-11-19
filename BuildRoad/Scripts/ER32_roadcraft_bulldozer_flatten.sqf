params ["_vehicle"];

[_vehicle, 1, ["ACE_SelfActions","ER32_bulldozer_flatten_aktive"]] call ace_interact_menu_fnc_removeActionFromObject;

_ER32_bulldozer_flatten_deactive = [
	"ER32_bulldozer_flatten_deaktive",
	"Stop Flattening",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_bulldozer_flatten_deaktive"]] call ace_interact_menu_fnc_removeActionFromObject;
		_ER32_bulldozer_flatten_active = [
			"ER32_bulldozer_flatten_aktive",
			"Start Flattening",
			"",
			{
				params ["_target","_player","_params"];
				[_target] execVM "ER32_roadcraft_bulldozer_flatten.sqf"
			},
			{true}
		] call ace_interact_menu_fnc_createAction;
		[_target, 1, ["ACE_SelfActions"], _ER32_bulldozer_flatten_active] call ace_interact_menu_fnc_addActionToObject;
	},
	{true}
] call ace_interact_menu_fnc_createAction;
[_vehicle, 1, ["ACE_SelfActions"], _ER32_bulldozer_flatten_deactive] call ace_interact_menu_fnc_addActionToObject;


_flattenActive = _vehicle getVariable ["ER32_roadcraft_bulldozer_flatten",true];

while {_flattenActive == true} do {
	_posInFrontVehicle = _vehicle getRelPos [5,0];
	
	_nearbyDirtPiles = _vehicle nearObjects ["HumpsDirt",5];
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
