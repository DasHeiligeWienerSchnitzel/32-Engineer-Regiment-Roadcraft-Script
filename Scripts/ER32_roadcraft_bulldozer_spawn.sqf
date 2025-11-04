ER32_bulldozer_spawner setObjectTextureGlobal [0,""];

_ER32_bulldozer_spawner = [
	"ER32_bulldozer_spawner",
	"Spawn Bulldozer",
	"",
	{
		params ["_target","_player","_params"];
		_tractor = createVehicle ["C_Tractor_01_F", position ER32_bulldozer_spawnpoint, [], 0, "CAN_COLLIDE"];
		_tractor enableSimulationGlobal false;
		_tractor setObjectTextureGlobal [0,""];
		_tractor setDir ((getDir ER32_bulldozer_spawnpoint) - 180);
		
		_bulldozer = createVehicle ["Land_Bulldozer_01_wreck_F", position ER32_bulldozer_spawnpoint, [], 0, "CAN_COLLIDE"];
		_bulldozer enableSimulationGlobal false;
		
		_bulldozer attachTo [_tractor, [0, 0.7, -0.5]];
		_bulldozer setVectorDirAndUp [[0,-1,0],[0,0,1]];
		
		_tractor enableSimulationGlobal true;
		
		_ER32_bulldozer_demolition_activ = [
			"ER32_bulldozer_demolition_aktiv",
			"Start Demolishment",
			"",
			{
				params ["_target","_player","_params"];
				[_target] execVM "ER32_roadcraft_bulldozer_demolishment.sqf"
			},
			{true}
		] call ace_interact_menu_fnc_createAction;
		[_tractor, 1, ["ACE_SelfActions"], _ER32_bulldozer_demolition_activ] call ace_interact_menu_fnc_addActionToObject;
		
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
		[_tractor, 1, ["ACE_SelfActions"], _ER32_bulldozer_flatten_active] call ace_interact_menu_fnc_addActionToObject;
		
	},
	{true}
] call ace_interact_menu_fnc_createAction;
[ER32_bulldozer_spawner, 0, ["ACE_MainActions"], _ER32_bulldozer_spawner] call ace_interact_menu_fnc_addActionToObject;
