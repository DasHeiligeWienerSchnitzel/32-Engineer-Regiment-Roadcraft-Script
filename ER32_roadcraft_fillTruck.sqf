ER32_fnc_startFilling = {
	_zone = ER32_roadcraft_sandFiller_zone;
	_nearbyObjects = _zone nearObjects ["B_Truck_01_cargo_F",5];
	_nearestTruck = objNull;

	if (count _nearbyObjects == 0) exitWith {
		hint "No trucks nearby";
	};

	if (count _nearbyObjects == 1) then {
		_nearestTruck = _nearbyObjects select 0;
	}else{
		_sorted = [[_nearbyObjects], [], {_zone distance _x}, "ASCEND"] call BIS_fnc_sortBy;
		_nearestTruck = _sorted select 0;
	};

	_truckInArea = _nearestTruck inArea [_zone, 2, 3, getDir _zone, true]; 

	_height = -0.5;
	_sandPositions = [[0, 0.5, _height],[0, -1.5, _height],[0, -3.1, _height]];

	_nearestTruck enableSimulationGlobal false;
	
	_sandFilled = _nearestTruck getVariable ["ER32_roadcraft_sandFilled",0];
	if (_sandFilled == 0) then {
		for "_i" from 0 to 2 do {
			_sand = createVehicle ["EFM_ground_surface_2x2m_soil", position _nearestTruck, [], 0, "CAN_COLLIDE"];
			_sand enableSimulationGlobal false;
			_sand attachTo [_nearestTruck, _sandPositions select _i];
		};	
	};
	
	_filled = false;
	_sands = _nearestTruck nearObjects ["EFM_ground_surface_2x2m_soil",5];
	while {_truckInArea == true and _filled == false} do {
		_truckInArea = _nearestTruck inArea [_zone, 2, 3, getDir _zone, true];
		_height = _height + 0.001;
		_sandFilled = _sandFilled + 3;
		_sandPositions = [[0, 0.5, _height],[0, -1.5, _height],[0, -3.1, _height]];
		{
			_x attachTo [_nearestTruck, _sandPositions select _forEachIndex];
		}forEach _sands;
		if (_height >= 0.0) then {
			_filled = true;
		};
		hint format ["%1",_sandFilled];
		sleep 0.1;
	};
	
	_sandFilled = _sandFilled - 3;
	_nearestTruck setVariable ["ER32_roadcraft_sandFilled", _sandFilled, true];

	_nearestTruck enableSimulationGlobal true;
	
	_ER32_roadcraft_sandDropper = [
		"ER32_roadcraft_sandDropper",
		"Drop Sand",
		"",
		{
			params ["_target","_player","_params"];
			[_target,false] execVM "ER32_roadcraft_sandDropper.sqf";
		},
		{
			params ["_target","_player","_params"];
			(_target getVariable ["ER32_roadcraft_sandFilled",1]) > 0;
		}
	] call ace_interact_menu_fnc_createAction;
	[_nearestTruck, 1, ["ACE_SelfActions"], _ER32_roadcraft_sandDropper] call ace_interact_menu_fnc_addActionToObject;
	
	_ER32_roadcraft_sandDropper_loopActive = [
		"ER32_roadcraft_sandDropper_loopActive",
		"Drop Sand (Activate Loop)",
		"",
		{
			params ["_target","_player","_params"];
			[_target,true] execVM "ER32_roadcraft_sandDropper.sqf";
		},
		{
			params ["_target","_player","_params"];
			(_target getVariable ["ER32_roadcraft_sandFilled",1]) > 0;
		}
	] call ace_interact_menu_fnc_createAction;
	[_nearestTruck, 1, ["ACE_SelfActions"], _ER32_roadcraft_sandDropper_loopActive] call ace_interact_menu_fnc_addActionToObject;
};


_ER32_roadcraft_sandFiller = [
	"ER32_roadcraft_sandFiller",
	"Start Filling Truck with Sand",
	"",
	{
		params ["_target","_player","_params"];
		0 spawn ER32_fnc_startFilling;
	},
	{true}
] call ace_interact_menu_fnc_createAction;
[ER32_roadcraft_switch_sandFiller, 0, ["ACE_MainActions"], _ER32_roadcraft_sandFiller] call ace_interact_menu_fnc_addActionToObject;


