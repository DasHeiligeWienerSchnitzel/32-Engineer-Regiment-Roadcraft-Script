params ["_object"];


ER32_bulldozer_demolition_deactive = [
	"ER32_bulldozer_demolition_deactive",
	"Stop Demolishment",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_bulldozer_demolition_deactive"]] call ace_interact_menu_fnc_removeActionFromObject;
		[_target, 1, ["ACE_SelfActions"], ER32_bulldozer_demolition_activ] call ace_interact_menu_fnc_addActionToObject;
		_target setVariable ["ER32_Demolishment_State", false, true];
	},
	{true}
] call ace_interact_menu_fnc_createAction;


ER32_bulldozer_demolition_activ = [
	"ER32_bulldozer_demolition_aktiv",
	"Start Demolishment",
	"",
	{
		params ["_target","_player","_params"];
		[_target, 1, ["ACE_SelfActions","ER32_bulldozer_demolition_aktiv"]] call ace_interact_menu_fnc_removeActionFromObject;
		[_target, 1, ["ACE_SelfActions"], ER32_bulldozer_demolition_deactive] call ace_interact_menu_fnc_addActionToObject;
		[_target] execVM "ER32_roadcraft_bulldozer_demolishment.sqf";
	},
	{true}
] call ace_interact_menu_fnc_createAction;


_pos = [position _object, 5, getDir _object] call BIS_fnc_relPos;
_zoneHelper = createVehicle ["VR_Area_01_square_4x4_yellow_F", _pos, [], 0, "CAN_COLLIDE"];
_object setVariable ["ER32_Demolishment_State", true, true];
_demolishment = _object getVariable ["ER32_Demolishment_State", false];

[_object, 1, ["ACE_SelfActions"], ER32_bulldozer_demolition_deactive] call ace_interact_menu_fnc_addActionToObject;
[_object, 1, ["ACE_SelfActions","ER32_bulldozer_demolition_aktiv"]] call ace_interact_menu_fnc_removeActionFromObject;

while {_demolishment == true} do {
	_demolishment = _object getVariable ["ER32_Demolishment_State", false];
	_pos = [position _object, 5, getDir _object] call BIS_fnc_relPos;
	_zoneHelper setPos _pos;
	_zoneHelper setDir (getDir _object);
	
	_nearbyTerrainObjects = nearestTerrainObjects [_zoneHelper, [], 4, false, true];
	
	_objectsInZone = _nearbyTerrainObjects inAreaArray [_zoneHelper,2.5,2.5,getDir _object,false,5];
	hint format ["%1", count _objectsInZone];
	{
		[_x] spawn {
			params ["_terrainObject"];
			_terrainObject setDamage 1;
			sleep 5;
			_terrainObject hideObjectGlobal true;
		};
	}forEach _objectsInZone;
	
	sleep 0.01;
};

deleteVehicle _zoneHelper;

