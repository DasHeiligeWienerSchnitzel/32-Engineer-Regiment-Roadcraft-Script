params ["_zone","_player"];

//Collects trucks near the zone.

_nearbyObjects = _zone nearObjects ["B_Truck_01_cargo_F",5];
_nearestTruck = objNull;

//Checks if even one truck was found, otherwise script will end here.

if (count _nearbyObjects == 0) exitWith {
	["No trucks nearby"] remoteExec ["hint",owner _player];
};

//If atleast one or more trucks were found, the closest one will be selected.

if (count _nearbyObjects == 1) then {
	_nearestTruck = _nearbyObjects select 0;
}else{
	_sorted = [[_nearbyObjects], [], {_zone distance _x}, "ASCEND"] call BIS_fnc_sortBy;
	_nearestTruck = _sorted select 0;
};

_status = _nearestTruck getVariable ["ER32_roadbuilder_sandFiller_status",false];
if (_status == true) exitWith {
	//["Filling already in progress!"] remoteExec ["hint",owner _player];
};
_nearestTruck setVariable ["ER32_roadbuilder_sandFiller_status",true,true];

//Now checks again, if the truck is really in the zone.

_truckInArea = _nearestTruck inArea [_zone, 2, 3, getDir _zone, true]; 

//Pre-selected positions for sands. 

_height = _nearestTruck getVariable ["ER32_roadbuilder_sandHeight", -0.5];
_sandPositions = [[0, 0.5, _height],[0, -1.5, _height],[0, -3.1, _height]];

//Disables the simulation of the truck (so it does not blow up).

_nearestTruck enableSimulationGlobal false;

//Spawns the sand objects onto the truck.

_sandFilled = _nearestTruck getVariable ["ER32_roadbuilder_sandFilled",0];

if (_sandFilled >= 1500) exitWith {
	["Truck already filled to the maximum."] remoteExec ["hint",owner _player];
};

if (_sandFilled <= 0) then {
	for "_i" from 0 to 2 do {
		_sand = createVehicle ["EFM_ground_surface_2x2m_soil", position _nearestTruck, [], 0, "CAN_COLLIDE"];
		_sand enableSimulationGlobal false;
		_sand attachTo [_nearestTruck, _sandPositions select _i];
	};	
};

//Collects the just created sand objects.

_sands = _nearestTruck nearObjects ["EFM_ground_surface_2x2m_soil",5];

/*
Now the truck will be slowly "filled" with sand.
This is done by setting the sand objects incremently higher.
Sand will be "filled" till either the truck was removed from the zone (Not likely).
Or the position of the sands reached 0.0 (or higher), which is the top of the truck.
*/

_filled = false;

while {_truckInArea == true and _filled == false} do {
	_truckInArea = _nearestTruck inArea [_zone, 2, 3, getDir _zone, true];
	_height = _height + 0.001;
	//hintSilent format ["Sand Filled: %1/1500",_sandFilled];
	format ["Sand Filled: %1/1500",_sandFilled] remoteExec ["hintSilent",owner _player];
	_sandFilled = _sandFilled + 3;
	_sandPositions = [[0, 0.5, _height],[0, -1.5, _height],[0, -3.1, _height]];
	{
		//_x attachTo [_nearestTruck, _sandPositions select _forEachIndex];
		[_x,[_nearestTruck, _sandPositions select _forEachIndex]] remoteExec ["attachTo",0];
	}forEach _sands;
	if (_height >= 0.0) then {
		_filled = true;
	};
	sleep 0.1;
};

//There is 3 exess sand, I am too lazy to compute it again. Its just 3 too much so it just gets removed in the end...

_sandFilled = _sandFilled - 3;
_nearestTruck setVariable ["ER32_roadbuilder_sandFilled", _sandFilled, true];

//Enables the simulation of the truck again. Can be driven again now.

_nearestTruck enableSimulationGlobal true;

/*
Two new actions will be added to the truck, aslong as the truck has sand inside it. 
One allows for a singular sand drop, and the other will just repeatedly dump the sand out the back.
*/

[_nearestTruck] remoteExecCall ["ER32_fnc_roadbuilder_addSandDropperAction",-2];

ER32_roadbuilder_sandTrucks pushBack _nearestTruck;
publicVariable "ER32_roadbuilder_sandTrucks";

_nearestTruck setVariable ["ER32_roadbuilder_sandFiller_status",false,true];